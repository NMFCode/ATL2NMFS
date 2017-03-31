package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import org.eclipse.m2m.atl.common.ATL.Binding
import org.eclipse.m2m.atl.common.OCL.OclExpression
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.WordUtils
import org.eclipse.m2m.atl.common.OCL.OCLFactory
import org.eclipse.m2m.atl.common.OCL.OclModelElement

/**
 * The BindingInfo Class.
 */
class BindingInfo {
	private final Atl2NmfSHelper atl2NmfSHelper;

	private final String outputTypeMetamodelName;
	private final String outputTypeName;

	private final String outputPropertyName;
	private final String transfromedOutputPropertyName;

	private final OclExpression expression;
	private final String location;
	private String transformedExpression;

	private ReturnTypeInfo ruleInputReturnTypeInfo;
	private ReturnTypeInfo ruleOutputReturnTypeInfo;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param binding
	 *            the binding
	 * @param outputTypeMetamodelName
	 *            the output type metamodel name
	 * @param outputTypeName
	 *            the output type name
	 */
	new(Atl2NmfSHelper atl2NmfSHelper, Binding binding, String outputTypeMetamodelName, String outputTypeName) {
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.outputTypeMetamodelName = outputTypeMetamodelName;
		this.outputTypeName = outputTypeName;
		this.outputPropertyName = binding.propertyName;
		this.transfromedOutputPropertyName = WordUtils.capitalize(binding.propertyName);
		this.location = binding.location;

		// we have to delay the transformation since not all ATL rules and helpers are analyzed and registered yet
		this.expression = binding.value;
	}

	/**
	 * Gets the output type metamodel name.
	 * 
	 * @return the output type metamodel name
	 */
	def String getOutputTypeMetamodelName() {
		return outputTypeMetamodelName;
	}

	/**
	 * Gets the output type name.
	 * 
	 * @return the output type name
	 */
	def String getOutputTypeName() {
		return outputTypeName;
	}

	/**
	 * Gets the output property name.
	 * 
	 * @return the output property name
	 */
	def String getOutputPropertyName() {
		return outputPropertyName;
	}
	
	def String getLocation() {
		return location;
	}

	/**
	 * Gets the transformed output property name.
	 * 
	 * @return the transformed output property name
	 */
	def String getTransformedOutputPropertyName() {
		return transfromedOutputPropertyName;
	}

	/**
	 * Gets the input return type info.
	 * 
	 * @return the input return type info
	 */
	def ReturnTypeInfo getInputReturnTypeInfo() {
		if (ruleInputReturnTypeInfo == null) {
			ruleInputReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoOfOclExpression(expression);
		}

		return ruleInputReturnTypeInfo;
	}

	/**
	 * Gets the output return type info.
	 * 
	 * @return the output return type info
	 */
	def ReturnTypeInfo getOutputReturnTypeInfo() {
		if (ruleOutputReturnTypeInfo == null) {
			this.ruleOutputReturnTypeInfo = atl2NmfSHelper.getReturnTypeInfoFromOutputMetamodel(outputTypeMetamodelName,
				outputTypeName, outputPropertyName);
		}

		return ruleOutputReturnTypeInfo;
	}

	/**
	 * Gets the transformed default expression.
	 * 
	 * @return the transformed default expression
	 */
	def String getTransformedDefaultExpression() {
		if (transformedExpression == null) {
			var returnType = this.getOutputReturnTypeInfo();
			var typeInfo = null as OclModelElement;
			if (returnType != null) {
				typeInfo = OCLFactory.eINSTANCE.createOclModelElement();
				typeInfo.name = returnType.typeName;
			}
			transformedExpression = atl2NmfSHelper.transformExpression(expression, typeInfo);
		}

		return transformedExpression;
	}

	/**
	 * Gets the OCL expression.
	 * 
	 * @return the OCL expression
	 */
	def OclExpression getOclExpression() {
		// in some special cases we have to transform the OCL expression with the consideration
		// of a type to solve ambiguous property navigations with a cast to the possible type
		// therefore the default transformation of the expression can't be used in this case
		return expression;
	}
}
