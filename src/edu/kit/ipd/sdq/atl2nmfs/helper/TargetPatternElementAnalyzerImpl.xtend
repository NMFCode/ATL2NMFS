package edu.kit.ipd.sdq.atl2nmfs.helper

import org.eclipse.m2m.atl.common.ATL.SimpleOutPatternElement
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.VariableExp
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.BindingInfo

/**
 * The TargetPatternElementAnalyzerImpl Class.
 */
class TargetPatternElementAnalyzerImpl implements TargetPatternElementAnalyzer {
	
	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.TargetPatternElementAnalyzer#checkAndInitializeTargetPatternElementReferences
	 */
	override checkAndInitializeTargetPatternElementReferences(RuleInfo ruleInfo) {
		//check the bindings of the default target pattern element of the rule
		for (bindingInfo : ruleInfo.bindingInfos) {
			checkBindingAndInitializeValue(ruleInfo, bindingInfo);
		}
		
		//check the bindings of the non default target pattern elements if existing
		for (additionaltargetPatternElementRuleInfo : ruleInfo.additionalOutputPatternElementRuleInfos)	 {
			for (bindingInfo : additionaltargetPatternElementRuleInfo.bindingInfos) {
				checkBindingAndInitializeValue(ruleInfo, bindingInfo);
			}
		}
	}
	
	/**
	 * Checks the binding info if a target pattern element is referenced and initializes the value
	 * 
	 * @param ruleInfo
	 *            the rule Info
	 * @param bindingInfo
	 *            the binding Info
	 */
	def private void checkBindingAndInitializeValue(RuleInfo ruleInfo, BindingInfo bindingInfo) {		
		val result = getReferencedTargetPatternElementNameIfExisting(bindingInfo.oclExpression);
			
		if(result != null) {
			//mark the specific target pattern element as referenced
			var referencedTargetPatternElement = ruleInfo.additionalOutputPatternElementRuleInfos.findFirst[
				it.outputVariableName.equals(result) ]
					
			if(referencedTargetPatternElement != null)
				referencedTargetPatternElement.isReferenced = true;
		}
	}
	
	/**
	 * Gets the referenced target pattern element name if one is referenced.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the referenced target pattern element name
	 */
	def private String getReferencedTargetPatternElementNameIfExisting(OclExpression expression) {		
		// TODO: Support special cases		
		// Remark: At the moment only referenced target pattern elements are 
		// supported where the name is defined alone in source side of the binding
		if (expression instanceof VariableExp) {			
			if(expression.referredVariable instanceof SimpleOutPatternElement) {
				return expression.referredVariable.varName;
			}					
		}
		
		return null;
	}
}