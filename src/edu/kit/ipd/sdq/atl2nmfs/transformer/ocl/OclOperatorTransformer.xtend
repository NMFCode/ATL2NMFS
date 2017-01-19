package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl;

import org.eclipse.m2m.atl.common.OCL.OperatorCallExp;

/**
 * The OclOperatorTransformer Interface.
 */
public interface OclOperatorTransformer {

	/**
	 * Transforms an OCL operator call expression into a LINQ expression.
	 * 
	 * @param expression
	 *            the operator call expression
	 * @param transformedSource
	 *            the transformed source of the expression as string
	 * @param transformedArgument
	 *            the transformed argument of the exoression as string
	 * @return the created LINQ expression as string
	 */
	def String transform(OperatorCallExp expression, String transformedSource, String transformedArgument);

}
