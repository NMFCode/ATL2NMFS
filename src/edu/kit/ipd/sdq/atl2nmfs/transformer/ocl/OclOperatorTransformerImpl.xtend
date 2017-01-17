package edu.kit.ipd.sdq.atl2nmfs.transformer.ocl

import org.eclipse.m2m.atl.common.OCL.OperatorCallExp
import org.apache.commons.lang.NotImplementedException

/**
 * The OclOperatorTransformerImpl Class.
 */
class OclOperatorTransformerImpl implements OclOperatorTransformer {

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperatorTransformer#transform
	 */
	override String transform(OperatorCallExp expression, String transformedSource, String transformedArgument) {
		var String transformedExpression;

		switch (expression.operationName) {
			case "+":
				transformedExpression = transformPlusOperator(transformedSource, transformedArgument)
			case "-":
				transformedExpression = transformMinusOperator(transformedSource, transformedArgument)
			case ">":
				transformedExpression = '''«transformedSource» > «transformedArgument»'''
			case ">=":
				transformedExpression = '''«transformedSource» >= «transformedArgument»'''
			case "<":
				transformedExpression = '''«transformedSource» < «transformedArgument»'''
			case "<=":
				transformedExpression = '''«transformedSource» <= «transformedArgument»'''
			case "<>":
				transformedExpression = '''«transformedSource» != «transformedArgument»'''
			case "=":
				// TODO: distinguish between assignment and comparison
				transformedExpression = '''«transformedSource» == «transformedArgument»'''
			case "and":
				transformedExpression = '''«transformedSource» && «transformedArgument»'''
			case "or":
				transformedExpression = '''«transformedSource» || «transformedArgument»'''
			case "xor":
				transformedExpression = '''«transformedSource» ^ «transformedArgument»'''
			case "not":
				transformedExpression = '''!(«transformedSource»)'''
			case "/":
				transformedExpression = '''«transformedSource» / «transformedArgument»'''
			case "*":
				transformedExpression = '''«transformedSource» * «transformedArgument»'''
			default:
				throw new NotImplementedException(expression.operationName + " Operator not supported yet")
		}

		return transformedExpression;
	}

	/**
	 * Transforms a minus operator expression.
	 * 
	 * @param transformedSource
	 *            the transformed source expression of the operator expression as string
	 * @param transformedArgument
	 *            the transformed argument expression of the operator expression as string
	 * @return the transformed string
	 */
	def private String transformMinusOperator(String transformedSource, String transformedArgument) {
		var String transformedExpression;
		if (transformedArgument.nullOrEmpty) {
			// it must be used as unary operator
			transformedExpression = '''-«transformedSource»'''
		} else {
			transformedExpression = '''«transformedSource» - «transformedArgument»''';
		}

		return transformedExpression;
	}

	/**
	 * Transforms a plus operator expression.
	 * 
	 * @param transformedSource
	 *            the transformed source expression of the operator expression as string
	 * @param transformedArgument
	 *            the transformed argument expression of the operator expression as string
	 * @return the transformed string
	 */
	def private String transformPlusOperator(String transformedSource, String transformedArgument) {
		var String transformedExpression;
		if (transformedArgument.nullOrEmpty) {
			// it must be used as unary operator
			transformedExpression = '''+«transformedSource»'''
		} else {
			transformedExpression = '''«transformedSource» + «transformedArgument»''';
		}

		return transformedExpression;
	}
}
