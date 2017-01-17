package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo

/**
 * The SynchronizeManyMainRuleTemplate Class.
 */
class SynchronizeManyMainRuleTemplate {

	/**
	 * Creates the code.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 * @param inputModelName
	 *            the input model name
	 * @param outputModelName
	 *            the output model name
	 * @param outputModelCollectionClassName
	 *            the output model collection class name
	 * @return the created code as string
	 */
	def static String createCode(RuleInfo ruleInfo, String inputModelName, String outputModelName,
		String outputModelCollectionClassName) {
		var synchronizeManyMainRuleTemplate = '''
			SynchronizeManyLeftToRightOnly(SyncRule<«ruleInfo.name»>(),
				input => input.«inputModelName».Descendants().OfType<«ruleInfo.getTransformedInputTypeName»>()«IF ruleInfo.getHasFilter».Where(x => x.«ruleInfo.filterName»())«ENDIF»,
				output => new «outputModelCollectionClassName»<«ruleInfo.getTransformedOutputTypeName»>(output.«outputModelName».RootElements.OfType<IModelElement, «ruleInfo.getTransformedOutputTypeName»>()));
		'''

		return synchronizeManyMainRuleTemplate;
	}
}
