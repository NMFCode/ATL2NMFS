package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl;

import org.eclipse.m2m.atl.common.OCL.OperationCallExp;

/**
 * The OclOperationTransformer Interface.
 */
interface OclOperationTransformer {

	/**
	 * Transforms an OCL operation call expression into a LINQ expression.
	 * 
	 * @param expression
	 *            the operation call expression
	 * @param transformedSource
	 *            the transformed source of the expression as string
	 * @param transformedArguments
	 *            the transformed arguments of the expression as string
	 * @return the created LINQ expression as string
	 */
	def String transform(OperationCallExp expression, String transformedSource, String transformedArguments);

}
