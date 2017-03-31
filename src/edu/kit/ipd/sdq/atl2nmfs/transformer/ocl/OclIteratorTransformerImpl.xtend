package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl

import com.google.inject.Inject
import org.eclipse.m2m.atl.common.OCL.IteratorExp
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.OperationCallExp
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.NotImplementedException

/**
 * The OclIteratorTransformerImpl Class.
 */
class OclIteratorTransformerImpl implements OclIteratorTransformer {
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
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclIteratorTransformer#transform
	 */
	override String transform(IteratorExp expression, String transformedSource, String transformedBody,
		OclExpression bodyExpression, Boolean callToLazyRule) {
		if (expression.iterators.size > 1) {
			throw new NotImplementedException("IteratorExpressions with multiple iterators are not supported yet")
		}

		var iteratorName = expression.iterators.get(0).varName;
		if (callToLazyRule && transformedBody.equals(iteratorName)) {
			// if the body is equal to the name of the iterator we can simplify the expression.
			// the iterator call is not needed so just return the source
			return transformedSource;
		}

		//TODO: support isUnique iterator

		var String transformedExpression;
		switch (expression.name) {
			case "select":
				transformedExpression = transformSelectIterator(transformedSource, transformedBody, bodyExpression,
					iteratorName)
			case "collect":
				// Warning: the ATL collect iterator operation implements the semantics of the collectNested OCL operation (this is the C# behavior)
				transformedExpression = '''«transformedSource».Select(«iteratorName» => «transformedBody»)'''
			case "exists":
				transformedExpression = '''«transformedSource».Any(«iteratorName» => «transformedBody»)'''
			case "forAll":
				transformedExpression = '''«transformedSource».All(«iteratorName» => «transformedBody»)'''
			case "any":
				transformedExpression = '''«transformedSource».FirstOrDefault(«iteratorName» => «transformedBody»)'''
			case "one":
				transformedExpression = '''«transformedSource».Single(«iteratorName» => «transformedBody»)'''
			case "reject":
				// equivalent to OCL "select (not body)"
				transformedExpression = '''«transformedSource».Where(«iteratorName» => !(«transformedBody»))'''
			case "sortedBy":
				// the return type of OrderBy is "IOrderedEnumerable"
				transformedExpression = '''«transformedSource».OrderBy(«iteratorName» => «transformedBody»)'''
			default:
				throw new NotImplementedException(expression.name + " Iterator is not supported yet")
		}

		return transformedExpression;
	}

	/**
	 * Transforms a select iterator expression..
	 * 
	 * @param transformedSource
	 *            the transformed source expression of the iterator expression
	 * @param transformedBody
	 *            the transformed body expression of the iterator expression
	 * @param bodyExpression
	 *            the body OCL expression
	 * @param iteratorName
	 *            the iterator name
	 * @return the transformed string
	 */
	def private String transformSelectIterator(String transformedSource, String transformedBody,
		OclExpression bodyExpression, String iteratorName) {
		var String transformedExpression;
		var OperationCallExp operationBodyExpression;
		if (bodyExpression instanceof OperationCallExp)
			operationBodyExpression = bodyExpression as OperationCallExp;

		// we have to detect "select(c | c.oclIsKindOf(X!Y))" and transform it into "OfType<X.Y>()" instead of "Where(e => e is X.Y)" without an cast
		// we would have to cast it afterwards ("Where(c => c is X.Y).OfType<X.Y>()") what could result in runtime errors (null argument exceptions)
		if (operationBodyExpression != null && operationBodyExpression.operationName.equals("oclIsKindOf")) {
			var argument = atl2NmfSHelper.transformExpression(operationBodyExpression.arguments.get(0), null);
			transformedExpression = '''«transformedSource».OfType<«argument»>()'''
		} 
		else {
			transformedExpression = '''«transformedSource».Where(«iteratorName» => «transformedBody»)''';
		}

		return transformedExpression;
	}
}
