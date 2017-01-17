package edu.kit.ipd.sdq.atl2nmfs.helper

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo

/**
 * The TargetPatternElementAnalyzer Interface.
 */
interface TargetPatternElementAnalyzer {
	
	/**
	 * Check and initialize target pattern elements references.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 */
	def void checkAndInitializeTargetPatternElementReferences(RuleInfo ruleInfo);

}