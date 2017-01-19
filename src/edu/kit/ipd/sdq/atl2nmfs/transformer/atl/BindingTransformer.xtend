package edu.kit.ipd.sdq.atl2nmfs.transformer.atl;

import java.util.List;
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo

/**
 * The BindingTransformer Interface.
 */
interface BindingTransformer {

	/**
	 * Transforms the bindings of an ATL rules.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 * @param bindingsCodeList
	 *            the list where the created code of the bindings is added
	 */
	def void transformBindings(RuleInfo ruleInfo, List<String> bindingsCodeList);

	/**
	 * Creates the bindings for the main synchronization rule.
	 * 
	 * @param ruleInfos
	 *            the rule infos
	 * @return the list with the created code of the bindings
	 */
	def List<String> createMainRuleBindings(List<RuleInfo> ruleInfos);

}
