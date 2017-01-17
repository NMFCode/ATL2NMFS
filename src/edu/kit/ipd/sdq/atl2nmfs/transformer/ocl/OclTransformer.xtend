package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl;

import org.eclipse.m2m.atl.common.OCL.OclExpression;
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.PossibleReturnTypeInfo

/**
 * The OclTransformer Interface.
 */
interface OclTransformer {

	/**
	 * Transforms an OCL expression into a LINQ expression.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the created LINQ expression as string
	 */
	def String transformExpression(OclExpression expression);

	/**
	 * Transforms an OCL expression with ambiguous calls into a LINQ expression.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @param possibleReturnTypeInfo
	 *            the possible return type info which should be used to solve ambiguous calls
	 * @return the created LINQ expression as string
	 */
	def String transformExpressionWithAmbiguousCall(OclExpression expression,
		PossibleReturnTypeInfo possibleReturnTypeInfo);

}
