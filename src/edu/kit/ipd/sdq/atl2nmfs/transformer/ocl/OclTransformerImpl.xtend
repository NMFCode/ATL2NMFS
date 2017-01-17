package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl

import com.google.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.m2m.atl.common.OCL.BooleanExp
import org.eclipse.m2m.atl.common.OCL.BooleanType
import org.eclipse.m2m.atl.common.OCL.EnumLiteralExp
import org.eclipse.m2m.atl.common.OCL.IfExp
import org.eclipse.m2m.atl.common.OCL.IntegerExp
import org.eclipse.m2m.atl.common.OCL.IntegerType
import org.eclipse.m2m.atl.common.OCL.IteratorExp
import org.eclipse.m2m.atl.common.OCL.NavigationOrAttributeCallExp
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.OclModel
import org.eclipse.m2m.atl.common.OCL.OclModelElement
import org.eclipse.m2m.atl.common.OCL.OperationCallExp
import org.eclipse.m2m.atl.common.OCL.OperatorCallExp
import org.eclipse.m2m.atl.common.OCL.RealExp
import org.eclipse.m2m.atl.common.OCL.RealType
import org.eclipse.m2m.atl.common.OCL.StringExp
import org.eclipse.m2m.atl.common.OCL.StringType
import org.eclipse.m2m.atl.common.OCL.VariableExp
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.PossibleReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.NotImplementedException
import org.apache.commons.lang.WordUtils

/**
 * The OclTransformerImpl Class.
 */
class OclTransformerImpl implements OclTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;
	private final OclIteratorTransformer oclIteratorTransformer;
	private final OclOperationTransformer oclOperationTransformer;
	private final OclOperatorTransformer oclOperatorTransformer;

	var PossibleReturnTypeInfo possibleReturnTypeInfo = null;
	var Boolean handleCallToLazyRule = false;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param oclIteratorTransformer
	 *            the OCL iterator transformer
	 * @param oclOperationTransformer
	 *            the OCL operation transformer
	 * @param oclOperatorTransformer
	 *            the OCL operator transformer
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper, OclIteratorTransformer oclIteratorTransformer,
		OclOperationTransformer oclOperationTransformer, OclOperatorTransformer oclOperatorTransformer) {
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.oclIteratorTransformer = oclIteratorTransformer;
		this.oclOperationTransformer = oclOperationTransformer;
		this.oclOperatorTransformer = oclOperatorTransformer;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclTransformer#transformExpression
	 */
	override String transformExpression(OclExpression expression) {
		// in this expression are no ambiguous calls so we don't need the possible type to solve ambiguity
		this.possibleReturnTypeInfo = null;
		this.handleCallToLazyRule = false;

		return transform(expression);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclTransformer#transformExpressionWithAmbiguousCall
	 */
	override String transformExpressionWithAmbiguousCall(OclExpression expression,
		PossibleReturnTypeInfo possibleReturnTypeInfo) {
		// we need this function to cast a part of the expression to allow access to a property
		// which is only availably from a sub type. Since there could be multiple possible types
		// we have to transform the expression for each possible type separately
		this.possibleReturnTypeInfo = possibleReturnTypeInfo;
		this.handleCallToLazyRule = false;

		return transform(expression);
	}

	/**
	 * The double dispatch function to transform an OCLExpression.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the transformed string
	 */
	def private dispatch String transform(OclExpression expression) {
		// is called when no specific dispatch function for the expression type is implemented
		throw new NotImplementedException("No dispatch function for the type " + expression.class.name +
			" implemented");
	}

	/**
	 * The double dispatch function to transform Void expression.
	 * 
	 * @param v
	 *            the void expression
	 * @return the transformed string
	 */
	def private dispatch String transform(Void v) {
		// called if the parameter is null
		return "";
	}

	/**
	 * The double dispatch function to transform an EList<OclExpression>.
	 * 
	 * @param expressions
	 *            the OCL expressions
	 * @return the transformed string
	 */
	def private dispatch String transform(EList<OclExpression> expressions) {
		return '''«FOR expression : expressions SEPARATOR ", "»«transform(expression)»«ENDFOR»'''
	}

	/**
	 * The double dispatch function to transform an OperatorCallExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the transformed string
	 */
	def private dispatch String transform(OperatorCallExp expression) {
		var transformedSource = transform(expression.source);
		var transformedArgument = transform(expression.arguments);

		return oclOperatorTransformer.transform(expression, transformedSource, transformedArgument);
	}

	/**
	 * The double dispatch function to transform an OperationCallExp.
	 * 
	 * @param expression
	 *            the operation call expression
	 * @return the transformed string
	 */
	def private dispatch String transform(OperationCallExp expression) {
		// this function can also be used for the CollectionOperationCallExp type which is a subtype of the OperationCallExp type
		var transformedSource = transform(expression.source);
		var transformedArgument = transform(expression.arguments);

		if (atl2NmfSHelper.isLazyRule(expression.operationName)) {
			// we set this flag to signalize that iterator expressions can be simplified
			handleCallToLazyRule = true;

			// since the source of a lazy rule call is always "thisModule." we can just return the argument here
			return transformedArgument;
		}

		return oclOperationTransformer.transform(expression, transformedSource, transformedArgument);
	}

	/**
	 * The double dispatch function to transform an IfExp.
	 * 
	 * @param expression
	 *            the if expression
	 * @return the transformed string
	 */
	def private dispatch String transform(IfExp expression) {
		var transformedCondition = transform(expression.condition);
		var transformedThenExpression = transform(expression.thenExpression);
		var transformedElseExpression = transform(expression.elseExpression);

		return '''
		(«transformedCondition») ? 
			(«transformedThenExpression») : («transformedElseExpression»)''';
	}

	/**
	 * The double dispatch function to transform an IteratorExp.
	 * 
	 * @param expression
	 *            the iterator expression
	 * @return the transformed string
	 */
	def private dispatch String transform(IteratorExp expression) {
		var transformedSource = transform(expression.source);
		var transformedBody = transform(expression.body);

		var transformedExpression = oclIteratorTransformer.transform(expression, transformedSource, transformedBody,
			expression.body, handleCallToLazyRule);

		if (handleCallToLazyRule) {
			// we have to reset this flag in case there are two IteratorExp in this expression
			// we can only simplify the IteratorExp where the lazy rule call was made in the body 
			handleCallToLazyRule = false;
		}

		return transformedExpression;
	}

	/**
	 * The double dispatch function to transform an NavigationOrAttributeCallExp.
	 * 
	 * @param expression
	 *            the navigation or attribute call expression
	 * @return the transformed string
	 */
	def private dispatch String transform(NavigationOrAttributeCallExp expression) {
		var transformedPropertyName = WordUtils.capitalize(expression.name);
		var transformedSource = transform(expression.source);

		if (atl2NmfSHelper.isAttributeHelper(expression.name)) {
			var attributeHelperInfo = atl2NmfSHelper.getAttributeHelperInfo(expression.name);
			var attributeHelperName = attributeHelperInfo.getTransformedName;

			if (transformedSource.equals("thisModule")) {
				// if the attribute helper has no context it is called with "thisModule" 
				// We transform such a helper to a normal static method in the HelperExtensionMethods class
				return '''«atl2NmfSHelper.getHelperClassName».«attributeHelperName»()''';
			} else {
				return '''«transformedSource».«attributeHelperName»()''';
			}
		}

		// check if the property call is ambiguous and try to solve it if a possible return type info was passed
		if (possibleReturnTypeInfo != null) {
			var returnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(expression);
			if (returnTypeInfo.isAmbiguous) {
				var targetType = '''«possibleReturnTypeInfo.metamodelName».I«possibleReturnTypeInfo.ambiguousClassifierName»''';

				// to solve the ambiguous property call a possibleReturnTypeInfo was passed as a parameter when starting
				// the transformation of the OCL expression. Therefore we can use this possible type info to cast
				// the source to make the desired property available for the c# type system.
				// since it it possible that the source is not of the passed possible type we have to check first 
				// to avoid null reference exceptions
				// Remark: the OCL expression is transformed for each possible type
				return '''((«transformedSource» is «targetType») ? ((«targetType»)«transformedSource»).«transformedPropertyName» : null)''';
			}
		}

		return '''«transformedSource».«transformedPropertyName»''';
	}

	/**
	 * The double dispatch function to transform an VariableExp.
	 * 
	 * @param expression
	 *            the variable expression
	 * @return the transformed string
	 */
	def private dispatch String transform(VariableExp expression) {
		return expression.referredVariable.varName;
	}

	/**
	 * The double dispatch function to transform an BooleanExp.
	 * 
	 * @param expression
	 *            the boolean expression
	 * @return the transformed string
	 */
	def private dispatch String transform(BooleanExp expression) {
		return expression.isBooleanSymbol.toString;
	}

	/**
	 * The double dispatch function to transform an StringExp.
	 * 
	 * @param expression
	 *            the string expression
	 * @return the transformed string
	 */
	def private dispatch String transform(StringExp expression) {
		return '''"«expression.stringSymbol»"''';
	}

	/**
	 * The double dispatch function to transform an EnumLiteralExp.
	 * 
	 * @param expression
	 *            the enum literal expression
	 * @return the transformed string
	 */
	def private dispatch String transform(EnumLiteralExp expression) {
		return expression.name;
	}

	/**
	 * The double dispatch function to transform an IntegerExp.
	 * 
	 * @param expression
	 *            the integer expression
	 * @return the transformed string
	 */
	def private dispatch String transform(IntegerExp expression) {
		return expression.integerSymbol.toString;
	}

	/**
	 * The double dispatch function to transform an RealExp.
	 * 
	 * @param expression
	 *            the real expression
	 * @return the transformed string
	 */
	def private dispatch String transform(RealExp expression) {
		return expression.realSymbol.toString;
	}

	/**
	 * The double dispatch function to transform an OclModelElement.
	 * 
	 * @param expression
	 *            the OCL model element expression
	 * @return the transformed string
	 */
	def private dispatch String transform(OclModelElement expression) {
		// the name of the metamodel is used by Ecore2Code as inner namespace name for the code of the metamodel
		var metamodel = transform(expression.model);

		// we use the generated interface type of the model element
		return '''«metamodel».I«expression.name»''';
	}

	/**
	 * The double dispatch function to transform an OclModel.
	 * 
	 * @param expression
	 *            the OCL model expression
	 * @return the transformed string
	 */
	def private dispatch String transform(OclModel expression) {
		return expression.name;
	}

	/**
	 * The double dispatch function to transform an BooleanType.
	 * 
	 * @param expression
	 *            the boolean type expression
	 * @return the transformed string
	 */
	def private dispatch String transform(BooleanType expression) {
		return "bool";
	}

	/**
	 * The double dispatch function to transform an IntegerType.
	 * 
	 * @param expression
	 *            the integer type expression
	 * @return the transformed string
	 */
	def private dispatch String transform(IntegerType expression) {
		return "int";
	}

	/**
	 * The double dispatch function to transform an RealType.
	 * 
	 * @param expression
	 *            the real type expression
	 * @return the transformed string
	 */
	def private dispatch String transform(RealType expression) {
		return "double";
	}

	/**
	 * The double dispatch function to transform an StringType.
	 * 
	 * @param expression
	 *            the string type expression
	 * @return the transformed string
	 */
	def private dispatch String transform(StringType expression) {
		return "string";
	}
}
