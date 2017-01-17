package edu.kit.ipd.sdq.atl2nmfs.transformer.atl;

import java.util.List;

/**
 * The RuleTransformer Interface.
 */
interface RuleTransformer {

	/**
	 * Transforms ATL matched rules.
	 * 
	 * @param ruleCodeList
	 * 			  the list where the created code of the transformed matched rules is added
	 */
	def void transformMatchedRules(List<String> ruleCodeList);

}
