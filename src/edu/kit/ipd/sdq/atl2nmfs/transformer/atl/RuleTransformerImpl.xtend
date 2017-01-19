package edu.kit.ipd.sdq.atl2nmfs.transformer.atl

import com.google.inject.Inject
import java.util.ArrayList
import java.util.List
import edu.kit.ipd.sdq.atl2nmfs.templates.SynchronizationRuleClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper

/**
 * The RuleTransformerImpl Class.
 */
class RuleTransformerImpl implements RuleTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;
	private final BindingTransformer bindingTransformer;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param bindingTransformer
	 *            the binding transformer
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper, BindingTransformer bindingTransformer) {
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.bindingTransformer = bindingTransformer;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.RuleTransformer#transformMatchedRules
	 */
	override void transformMatchedRules(List<String> ruleCodeList) {
		var ruleInfos = atl2NmfSHelper.getAllRuleInfos();
		var mainRuleCode = createMainRule(ruleInfos);
		ruleCodeList.add(mainRuleCode);

		// transform the matched rules
		for (ruleInfo : ruleInfos) {
			var synchronizationRuleCodes = transformMatchedRule(ruleInfo);
			ruleCodeList.addAll(synchronizationRuleCodes);
		}
	}

	/**
	 * Creates the main synchronization rule of the NMF S. synchronization.
	 * 
	 * @param ruleInfos
	 *            the rule infos
	 * @return the created code of the main rule as string
	 */
	def private String createMainRule(List<RuleInfo> ruleInfos) {
		// to simulate the ATL behavior we have to create for each matched rule
		// a binding that calls the rule for each matching element
		var mainRuleBindings = bindingTransformer.createMainRuleBindings(ruleInfos);
		var mainRuleCode = SynchronizationRuleClassTemplate.createMainRuleCode(
			atl2NmfSHelper.mainRuleName,
			atl2NmfSHelper.inputModelContainerClassName,
			atl2NmfSHelper.outputModelContainerClassName,
			mainRuleBindings
		);

		return mainRuleCode;
	}

	/**
	 * Transforms an ATL matched rule.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 * @return the created list with the code of the created NMF S. synchronization rules
	 */
	def private List<String> transformMatchedRule(RuleInfo ruleInfo) {
		val synchronizationRulesCode = new ArrayList<String>();
		var bindingsCodeList = new ArrayList<String>();

		bindingTransformer.transformBindings(ruleInfo, bindingsCodeList)
		var synchronizationRuleCode = SynchronizationRuleClassTemplate.createCode(
			ruleInfo,
			bindingsCodeList
		);

		synchronizationRulesCode.add(synchronizationRuleCode);

		// create also the synchronization rule code for each additional output pattern element of the ATL rule
		for (additionalOutputPatternElementRuleInfo : ruleInfo.getAdditionalOutputPatternElementRuleInfos) {
			var additionalBindingsCodeList = new ArrayList<String>();
			bindingTransformer.transformBindings(additionalOutputPatternElementRuleInfo, additionalBindingsCodeList);

			var additionalSynchronizationRuleCode = SynchronizationRuleClassTemplate.createCode(
				additionalOutputPatternElementRuleInfo,
				additionalBindingsCodeList
			);

			synchronizationRulesCode.add(additionalSynchronizationRuleCode);
		}

		return synchronizationRulesCode;
	}
}
