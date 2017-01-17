package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl

import com.google.inject.Inject
import org.eclipse.m2m.atl.common.OCL.IteratorExp
import org.eclipse.m2m.atl.common.OCL.OclModelElement
import org.eclipse.m2m.atl.common.OCL.OperationCallExp
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.NotImplementedException

/**
 * The OclOperationTransformerImpl Class.
 */
class OclOperationTransformerImpl implements OclOperationTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper) {
		this.atl2NmfSHelper = atl2NmfSHelper;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperationTransformer#transform
	 */
	override String transform(OperationCallExp expression, String transformedSource,
		String transformedArguments) {
		// TODO: use c# extension methods for some cases to improve the readability of the created c# code
		var String transformedExpression;
		switch (expression.operationName) {
			case "oclIsKindOf":
				// oclIsKindOf(t : oclType) returns a boolean value stating whether self is either an instance of t or of one of its subtypes	
				transformedExpression = '''«transformedSource» is «transformedArguments»'''
			case "oclIsTypeOf":
				// oclIsTypeOf(t : oclType) returns a boolean value stating whether self is an instance of t. It returns false if self is a subtype of t
				// therefore the c# "is" operation can't be used here!
				transformedExpression = '''«transformedSource».GetType() == typeof(«transformedArguments»)'''
			case "oclIsUndefined":
				// oclIsUndefined() is an operation on OclAny that results in True if its argument is null or invalid and false otherwise.
				transformedExpression = '''«transformedSource» == null'''
			case "oclType":
				transformedExpression = '''«transformedSource».GetType(«transformedArguments»)'''
			case "implies":
				transformedExpression = '''!(«transformedSource») || («transformedArguments»)'''
			case "max":
				transformedExpression = '''Math.Max(«transformedSource», «transformedArguments»)'''
			case "min":
				transformedExpression = '''Math.Min(«transformedSource», «transformedArguments»)'''
			case "abs":
				transformedExpression = '''Math.Abs(«transformedSource»)'''
			case "sum":
				transformedExpression = '''«transformedSource».Sum(«transformedArguments»)'''
			case "toInteger":
				transformedExpression = '''Int32.Parse(«transformedSource»)'''
			case "toReal":
				// we have to use the invariant culture info or the "." are ignored in the number
				transformedExpression = '''Double.Parse(«transformedSource», CultureInfo.InvariantCulture)'''
			case "first":
				// if the collection is empty oclUndefined (null, the default value) should be returned
				transformedExpression = '''«transformedSource».FirstOrDefault(«transformedArguments»)'''
			case "last":
				// if the collection is empty oclUndefined (null, the default value) should be returned
				transformedExpression = '''«transformedSource».LastOrDefault(«transformedArguments»)'''
			case "indexOf":
				transformedExpression = '''«transformedSource».IndexOf(«transformedArguments»)'''
			case "at":
				transformedExpression = '''«transformedSource».ElementAt(«transformedArguments»)'''
			case "insertAt":
				transformedExpression = '''«transformedSource».Insert(«transformedArguments»)'''
			case "includes":
				transformedExpression = '''«transformedSource».Contains(«transformedArguments»)'''
			case "excludes":
				// opposite of includes
				transformedExpression = '''!«transformedSource».Contains(«transformedArguments»)'''
			case "includesAll":
				transformedExpression = '''!(«transformedArguments».Except(«transformedSource»).Any())'''
			case "excludesAll":
				// TODO: is there a better solution?
				transformedExpression = '''(«transformedArguments».Except(«transformedSource»).Count() == «transformedArguments».Count())'''
			case "flatten":
				transformedExpression = transformFlattenOperation(expression, transformedSource)
			case "isEmpty":
				transformedExpression = '''!«transformedSource».Any()'''
			case "notEmpty":
				transformedExpression = '''«transformedSource».Any(«transformedArguments»)'''
			case "count":
				// count(o : oclAny) returns the number of times the object o occurs in the collection self;
				transformedExpression = '''«transformedSource».Count(element => element.Equals(«transformedArguments»))'''
			case "size":
				transformedExpression = '''«transformedSource».Count(«transformedArguments»)'''
			case "trim":
				transformedExpression = '''«transformedSource».Trim(«transformedArguments»)'''
			case "union":
				transformedExpression = transformUnionOperation(expression, transformedSource, transformedArguments)
			case "allInstances":
				transformedExpression = transformAllInstancesOperation(expression, transformedSource)
			case "refImmediateComposite":
				transformedExpression = transformRefImmediateCompositeOperation(expression, transformedSource)
			default: {
				transformedExpression = transformDefaultOperation(expression, transformedSource, transformedArguments)
			}
		}

		return transformedExpression;
	}

	/**
	 * Transforms a flatten operation call expression.
	 * 
	 * @param expression
	 *            the flatten operation call expression
	 * @param transformedSource
	 *            the transformed source expression of the operation call expression
	 * @return the transformed string
	 */
	def private String transformFlattenOperation(OperationCallExp expression, String transformedSource) {
		// we have to check if flatten is used after collect and if the return type of collect is a collection or not.
		// If it is no collection the flatten operation must not be transformed
		if (expression.source instanceof IteratorExp) {
			var iteratorExp = expression.source as IteratorExp;

			// get the return type of the body expression of the iterator expression
			var bodyReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(iteratorExp.body);

			if (iteratorExp.name.equals("collect") && !bodyReturnTypeInfo.getIsTypeCollection) {
				// when the body is no collection the return value of collect is already a collection of metamodel types
				// and not a collection with collections of a metamodel type
				// so we don't have to transform flatten to SelectMany and just return the source
				// the flatten operation is not needed in this case
				return transformedSource;
			}
		}

		return '''«transformedSource».SelectMany(x => x)'''
	}

	/**
	 * Transforms an union operation call expression.
	 * 
	 * @param expression
	 *            the union operation call expression
	 * @param transformedSource
	 *            the transformed source expression of the operation call expression
	 * @param transformedArguments
	 *            the transformed arguments expression of the operation call expression
	 * @return the transformed string
	 */
	def private String transformUnionOperation(OperationCallExp expression, String transformedSource,
		String transformedArguments) {
		var String transformedExpression;
		// TODO: Distinguish between concat and Union. It depends on the collection type if it allows duplicates or not
		// When using Union: duplicates are automatically removed
		// When using concat: duplicates are not removed! The elements of the two collections are only put into a new collection
		// we have to compare the return type of the source and the argument
		// union expects two collections with the same type 
		// if they are different we have to use the OfType operation
		var sourceReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(expression.source);
		var argumentReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(expression.arguments.get(0));

		if (sourceReturnTypeInfo.getTypeName.equals(argumentReturnTypeInfo.getTypeName)) {
			transformedExpression = '''«transformedSource».Union(«transformedArguments»)''';
		} 
		else {
			// we have to find the lowest common super type which we have to use in the union operation
			var lowestCommonSuperTypeInfo = atl2NmfSHelper.findLowestCommonSuperTypeInfoInInputMetamodel(
				sourceReturnTypeInfo.metamodelName, sourceReturnTypeInfo.getTypeName,
				argumentReturnTypeInfo.metamodelName, argumentReturnTypeInfo.getTypeName);

			transformedExpression = '''«transformedSource».Union<«lowestCommonSuperTypeInfo.getTransformedName»>(«transformedArguments»)''';
		}

		return transformedExpression;
	}

	/**
	 * Transforms an all instances operation call expression.
	 * 
	 * @param expression
	 *            the all instances operation call expression
	 * @param transformedSource
	 *            the transformed source expression of the operation call expression
	 * @param transformedArguments
	 *            the transformed arguments expression of the operation call expression
	 * @return the transformed string
	 */
	def private String transformAllInstancesOperation(OperationCallExp expression, String transformedSource) {
		// we have to use the static property InputModel of the synchronization class to access the elements of the input model
		// the name of the synchronization class is the transformation name
		var synchronizationClassName = atl2NmfSHelper.transformationName;

		// the class name is also used as property name
		var inputModelContainerPropertyName = atl2NmfSHelper.inputModelContainerClassName;

		// the source contains the name of the type (OCL: "MMName!TypeName.allInstances()")
		var oclModelElement = expression.source as OclModelElement;
		val metamodelName = oclModelElement.model.name;

		var inputModelInfos = atl2NmfSHelper.inputModelInfos;
		var filteredInputModelInfos = inputModelInfos.filter[it.metamodelName.equals(metamodelName)];

		if (filteredInputModelInfos.size != 1) {
			throw new NotImplementedException(
				"Multiple possible input models for the 'allInstances' OCL Operations are not supported yet")
		}

		var inputModelInfo = filteredInputModelInfos.get(0);

		// we use the explicit call of the static property to avoid name conflicts
		return '''«synchronizationClassName».«inputModelContainerPropertyName».«inputModelInfo.name».Descendants().OfType<«transformedSource»>()'''
	}

	/**
	 * Transforms a ref immediate composite operation call expression.
	 * 
	 * @param expression
	 *            the ref immediate composite operation call expression
	 * @param transformedSource
	 *            the transformed source expression of the operation call expression
	 * @return the transformed string
	 */
	def private String transformRefImmediateCompositeOperation(OperationCallExp expression,
		String transformedSource) {
		// since the operation returns the parent element we have to determine the type of the
		// parent element to be able to cast the IModelElement that is returned by the
		// Parent property (OCL allows access to its properties without a cast which is 
		// not allowed in C#)
		var sourceReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(expression.source);
		if (sourceReturnTypeInfo.isAmbiguous && sourceReturnTypeInfo.typePrimitive) {
			throw new NotImplementedException(
				"A simple return type or an ambiguous return type for the source expression is not supported for a refImmediateComposite operation");
		}

		var possibleTypeInfos = atl2NmfSHelper.
			getAllPossibleInputMMTypeInfosThatContainFeatureWithType(sourceReturnTypeInfo);
		if (possibleTypeInfos.size == 0) {
			throw new IllegalArgumentException(
				"No possible type was found while transforming a refImmediateComposite operation.");
		} 
		else if (possibleTypeInfos.size > 1) {
			// TODO: The possibilities could be narrowed down if after the refImmediateComposite call a property is used
			throw new NotImplementedException(
				"The cast that is required to transform the refImmediateComposite operation is not distinct. Further analysis is not supported yet.");
		}

		var type = possibleTypeInfos.get(0);
		return '''((«type.getTransformedName»)«transformedSource».Parent)'''
	}

	/**
	 * Transforms a default operation call expression.
	 * 
	 * @param expression
	 *            the default operation call expression
	 * @param transformedSource
	 *            the transformed source expression of the operation call expression
	 * @param transformedArguments
	 *            the transformed arguments expression of the operation call expression
	 * @return the transformed string
	 */
	def private String transformDefaultOperation(OperationCallExp expression, String transformedSource,
		String transformedArguments) {
		var String transformedExpression;
		// we don't have to check if the called operation is a lazy rule because it was already checked in the OCL Transformer class
		if (atl2NmfSHelper.isFunctionalHelper(expression.operationName)) {
			// the operation is an operation helper
			var operationHelperInfo = atl2NmfSHelper.getFunctionalHelperInfo(expression.operationName);
			var operationHelperName = operationHelperInfo.getTransformedName;

			if (transformedSource.equals("thisModule")) {
				// if the operation helper has no context it is called with "thisModule" 
				// We transform such a helper to a normal static method in the HelperExtensionMethods class
				transformedExpression = '''«atl2NmfSHelper.getHelperClassName».«operationHelperName»(«transformedArguments»)''';
			} 
			else {
				transformedExpression = '''«transformedSource».«operationHelperName»(«transformedArguments»)''';
			}
		} 
		else {
			throw new NotImplementedException(expression.operationName + " Operation is not supported yet")
		}

		return transformedExpression;
	}
}
		