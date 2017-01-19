package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl;

import org.eclipse.m2m.atl.common.OCL.IteratorExp;
import org.eclipse.m2m.atl.common.OCL.OclExpression;

/**
 * The OclIteratorTransformer Interface.
 */
interface OclIteratorTransformer {

	/**
	 * Transforms an OCL iterator expression into a LINQ expression.
	 * 
	 * @param expression
	 *            the iterator expression
	 * @param transformedSource
	 *            the transformed source expression of the iterator expression as string
	 * @param transformedBody
	 *            the transformed body expression of the iterator expression as string
	 * @param bodyExpression
	 *            the body OCL expression 
	 * @param callToLazyRule
	 *            indicating if a call to lazy rule is made
	 * @return the transformed string
	 */
	def String transform(IteratorExp expression, String transformedSource, String transformedBody,
		OclExpression bodyExpression, Boolean callToLazyRule);

}
