package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import java.util.ArrayList
import java.util.List
import org.eclipse.m2m.atl.common.ATL.MatchedRule
import org.eclipse.m2m.atl.common.ATL.OutPatternElement
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.OclModelElement
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.StringUtils

/**
 * The RuleType Enum.
 */
public enum RuleType {
	MATCHED,
	LAZYMATCHED,
	UNIQUELAZYMATCHED
}

/**
 * The RuleInfo Class.
 */
class RuleInfo {
	private final Atl2NmfSHelper atl2NmfSHelper;

	private final String name;
	private final RuleType ruleType;
	private final Boolean isDefaultRule;
	private final RuleInfo parentRuleInfo;

	private final Boolean hasFilter;
	private final String filterName;
	private final OclExpression filterExpression;
	private String transformedFilterExpression;
	private boolean isReferenced;

	private final String inputTypeName;
	private final String inputTypeMetamodelName;
	private final String transformedInputTypeName;
	private final String inputVariableName;

	private final String outputTypeName;
	private final String outputTypeMetamodelName;
	private final String transformedOutputTypeName;
	private final String outputVariableName;

	private final List<BindingInfo> bindingInfos;
	private final List<RuleInfo> additionalOutputPatternElementRuleInfos;

	/**
	 * Class constructor to create a rule info object for a default output pattern element.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param matchedRule
	 *            the matched rule
	 * @param ruleType
	 *            the rule type
	 */
	new(Atl2NmfSHelper atl2NmfSHelper, MatchedRule matchedRule, RuleType ruleType) {
		this.atl2NmfSHelper = atl2NmfSHelper;

		this.isDefaultRule = true;
		this.parentRuleInfo = null;
		this.ruleType = ruleType;
		this.name = matchedRule.name;

		var inputPatternElement = matchedRule.inPattern.elements.get(0);
		var inputOclModelElement = inputPatternElement.type as OclModelElement;

		this.inputTypeName = inputPatternElement.type.name;
		this.inputTypeMetamodelName = inputOclModelElement.model.name;
		this.transformedInputTypeName = atl2NmfSHelper.transformExpression(inputPatternElement.type, null);
		this.inputVariableName = inputPatternElement.varName;

		// create the rule info for the default output pattern element (the first output pattern element)
		var outputPatternElement = matchedRule.outPattern.elements.get(0);
		var outputOclModelElement = outputPatternElement.type as OclModelElement;

		this.outputTypeName = outputPatternElement.type.name;
		this.outputTypeMetamodelName = outputOclModelElement.model.name;
		this.transformedOutputTypeName = atl2NmfSHelper.transformExpression(outputPatternElement.type, null);
		this.outputVariableName = outputPatternElement.varName;

		// check if the rule has a filter
		if (inputPatternElement.inPattern.filter != null) {
			this.hasFilter = true;
			this.filterName = name + atl2NmfSHelper.filterNameExtension;

			// we have to delay the transformation since not all ATL rules and helpers are analyzed and registered yet
			this.filterExpression = inputPatternElement.inPattern.filter;
		} else {
			this.hasFilter = false;
			this.filterName = null;
			this.filterExpression = null;
		}

		this.bindingInfos = new ArrayList<BindingInfo>();
		for (binding : outputPatternElement.bindings) {
			var bindingInfo = new BindingInfo(atl2NmfSHelper, binding, outputTypeMetamodelName, outputTypeName);
			bindingInfos.add(bindingInfo);
		}

		// check if the rule has multiple output pattern elements
		// if the rule has more than one output pattern element we have to create for each additional output pattern element a rule info
		// remark: in NMF Synchronization each output pattern element is represented by a synchronization rule
		this.additionalOutputPatternElementRuleInfos = new ArrayList<RuleInfo>();
		if (matchedRule.outPattern.elements.size > 1) {
			for (var i = 1; i < matchedRule.outPattern.elements.size; i++) {
				var additionalOutputPatternElement = matchedRule.outPattern.elements.get(i);
				var additionalRuleInfo = new RuleInfo(atl2NmfSHelper, this, additionalOutputPatternElement);

				// we have to register the additionalRuleInfo as an additional rule for the default output pattern element of this atl rule
				// we can not add the additional rule as a normal rule to the rule list (rules). Because in such a case the rule would be used 
				// as a default rule and would be called when resolving a binding for the input type of the rule. This would be false because at
				// such a point only the default rule for this input type must be called
				this.additionalOutputPatternElementRuleInfos.add(additionalRuleInfo);
			}
		}
		
		atl2NmfSHelper.checkAndInitializeTargetPatternElementReferences(this);
	}

	/**
	 * Class constructor to create a additional rule info object for a non default output pattern element.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param parentRuleInfo
	 *            the parent rule info
	 * @param additionalOutputPatternElement
	 *            the additional output pattern element
	 */
	new(Atl2NmfSHelper atl2NmfSHelper, RuleInfo parentRuleInfo, OutPatternElement additionalOutputPatternElement) {
		this.atl2NmfSHelper = atl2NmfSHelper;

		this.isDefaultRule = false;
		this.additionalOutputPatternElementRuleInfos = null;

		// the parent rule info is the rule info of the corresponding default output pattern element
		this.parentRuleInfo = parentRuleInfo
		this.ruleType = parentRuleInfo.ruleType;

		this.inputTypeName = parentRuleInfo.inputTypeName;
		this.inputTypeMetamodelName = parentRuleInfo.inputTypeMetamodelName;
		this.transformedInputTypeName = parentRuleInfo.transformedInputTypeName;
		this.inputVariableName = parentRuleInfo.inputVariableName;

		var additionalOutputOclModelElement = additionalOutputPatternElement.type as OclModelElement;
		this.outputTypeMetamodelName = additionalOutputOclModelElement.model.name;
		this.outputTypeName = additionalOutputPatternElement.type.name;
		this.transformedOutputTypeName = atl2NmfSHelper.transformExpression(additionalOutputPatternElement.type, null);
		this.outputVariableName = additionalOutputPatternElement.varName;

		this.bindingInfos = new ArrayList<BindingInfo>();
		for (binding : additionalOutputPatternElement.bindings) {
			var bindingInfo = new BindingInfo(atl2NmfSHelper, binding, outputTypeMetamodelName, outputTypeName);
			bindingInfos.add(bindingInfo);
		}

		// if the rule name is e.g. mainRule the additional rule name is MainRuleLabel if the variable name is e.g. label
		this.name = parentRuleInfo.name + StringUtils.capitalize(outputVariableName);
		if (parentRuleInfo.hasFilter) {
			this.hasFilter = true;
			this.filterName = parentRuleInfo.filterName;

			// we have to delay the transformation since not all ATL rules and helpers are analyzed and registered yet
			this.filterExpression = parentRuleInfo.filterExpression;
		} else {
			this.hasFilter = false;
			this.filterName = null;
			this.filterExpression = null;
		}
	}

	/**
	 * Gets the rule type.
	 * 
	 * @return the rule type
	 */
	def RuleType getRuleType() {
		return ruleType;
	}

	/**
	 * Gets the name.
	 * 
	 * @return the name
	 */
	def String getName() {
		return name;
	}

	/**
	 * Gets value indicating if a filter exists.
	 * 
	 * @return the value indicating if a filter exists
	 */
	def Boolean getHasFilter() {
		return hasFilter;
	}

	/**
	 * Gets the filter name.
	 * 
	 * @return the filter name
	 */
	def String getFilterName() {
		return filterName;
	}

	/**
	 * Gets the transformed filter expression.
	 * 
	 * @return the transformed filter expression
	 */
	def String getTransformedFilterExpression() {
		if (transformedFilterExpression == null) {
			if (!isDefaultRule) {
				transformedFilterExpression = parentRuleInfo.transformedFilterExpression;
			} else {
				transformedFilterExpression = atl2NmfSHelper.transformExpression(filterExpression, null);
			}
		}

		return transformedFilterExpression;
	}
	
	/**
	 * Gets the value indicating if the target pattern element is referenced in a binding.
	 * 
	 * @return the value indicating if the target pattern element is referenced in a binding
	 */
	def boolean getIsReferenced() {
		return isReferenced;
	}	
	
	/**
	 * Sets the value indicating if the target pattern element is referenced in a binding.
	 * 
	 * @param isReferenced
	 *            the value indicating if the target pattern element is referenced in a binding
	 */
	def void setIsReferenced(boolean isReferenced) {
		this.isReferenced = isReferenced;
	}		

	/**
	 * Gets the input type name.
	 * 
	 * @return the input type name
	 */
	def String getInputTypeName() {
		return inputTypeName;
	}

	/**
	 * Gets the input type metamodel name.
	 * 
	 * @return the input type metamodel name
	 */
	def String getInputTypeMetamodelName() {
		return inputTypeMetamodelName;
	}

	/**
	 * Gets the transformed input type name.
	 * 
	 * @return the transformed input type name
	 */
	def String getTransformedInputTypeName() {
		return transformedInputTypeName;
	}

	/**
	 * Gets the input variable name.
	 * 
	 * @return the input variable name
	 */
	def String getInputVariableName() {
		return inputVariableName;
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
	 * Gets the output type metamodel name.
	 * 
	 * @return the output type metamodel name
	 */
	def String getOutputTypeMetamodelName() {
		return outputTypeMetamodelName;
	}

	/**
	 * Gets the transformed output type name.
	 * 
	 * @return the transformed output type name
	 */
	def String getTransformedOutputTypeName() {
		return transformedOutputTypeName;
	}

	/**
	 * Gets the output variable name.
	 * 
	 * @return the output variable name
	 */
	def String getOutputVariableName() {
		return outputVariableName;
	}

	/**
	 * Gets the binding infos.
	 * 
	 * @return the binding infos
	 */
	def List<BindingInfo> getBindingInfos() {
		return bindingInfos;
	}

	/**
	 * Checks if a cast for the input type is required.
	 * 
	 * @param typeName
	 *            the type name
	 * @return the boolean value indicating if a cast is required
	 */
	def Boolean castForInputRequired(String typeName) {
		if (inputTypeName.equals(typeName)) {
			return false;
		}
		return true;
	}

	/**
	 * Checks if a cast for the output type is required.
	 * 
	 * @param typeName
	 *            the type name
	 * @return the boolean value indicating if a cast is required
	 */
	def Boolean castForOutputRequired(String typeName) {
		if (outputTypeName.equals(typeName)) {
			return false;
		}
		return true;
	}

	/**
	 * Gets the additional output pattern element rule infos.
	 * 
	 * @return the additional output pattern element rule infos
	 */
	def List<RuleInfo> getAdditionalOutputPatternElementRuleInfos() {
		return additionalOutputPatternElementRuleInfos;
	}

	/**
	 * Gets a value indicating if this is a default rule.
	 * 
	 * @return the value indicating if this is a default rule
	 */
	def Boolean getIsDefaultRule() {
		return isDefaultRule;
	}

	/**
	 * Gets the parent rule info.
	 * 
	 * @return the parent rule info
	 */
	def RuleInfo getParentRuleInfo() {
		return parentRuleInfo;
	}
}
