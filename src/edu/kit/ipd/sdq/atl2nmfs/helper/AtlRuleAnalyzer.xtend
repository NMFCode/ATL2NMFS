package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The AtlRuleAnalyzer Interface.
 */
interface AtlRuleAnalyzer {

	/**
	 * Analyze the rules of the ATL module.
	 * 
	 * @param atlModule
	 *            the ATL module
	 */
	def void analyzeRules(Module atlModule);

	/**
	 * Checks if a lazy rule with the passed name exists.
	 * 
	 * @param ruleName
	 *            the rule name
	 * @return the boolean indicating if a lazy rule with this name exists
	 */
	def Boolean isLazyRule(String ruleName);

	/**
	 * Gets all the rule infos.
	 * 
	 * @return all the rule infos
	 */
	def List<RuleInfo> getAllRuleInfos();

	/**
	 * Gets the rule info.
	 * 
	 * @param ruleName
	 *            the rule name
	 * @return the rule info
	 */
	def RuleInfo getRuleInfo(String ruleName);

	/**
	 * Gets the possible rule infos for the passed input type info.
	 * 
	 * @param inputTypeInfo
	 *            the input type info
	 * @return the possible rule infos for the input type info
	 */
	def List<RuleInfo> getPossibleRuleInfosForInputTypeInfo(TypeInfo inputTypeInfo);

}
