package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo

/**
 * The FilterTemplate Class.
 */
class FilterTemplate {

	/**
	 * Creates the code.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 * @return the created code as string
	 */
	def static String createCode(RuleInfo ruleInfo) {
		var filterTemplate = '''
			[ObservableProxy(typeof(Proxies), "«ruleInfo.filterName»")]
			public static bool «ruleInfo.filterName»(this «ruleInfo.getTransformedInputTypeName» «ruleInfo.inputVariableName»)
			{
				return «ruleInfo.getTransformedFilterExpression»;
			}
		'''

		return filterTemplate;
	}
}
