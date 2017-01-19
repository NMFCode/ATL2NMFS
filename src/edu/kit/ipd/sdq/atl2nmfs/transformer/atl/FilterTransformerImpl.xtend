package edu.kit.ipd.sdq.atl2nmfs.transformer.atl

import com.google.inject.Inject
import java.util.List
import edu.kit.ipd.sdq.atl2nmfs.templates.FilterTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.FilterProxyTemplate
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper

/**
 * The FilterTransformerImpl Class.
 */
class FilterTransformerImpl implements FilterTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper) {
		this.atl2NmfSHelper = atl2NmfSHelper;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.FilterTransformer#transformFilters
	 */
	override void transformFilters(List<String> filterCodeList, List<String> filterProxiesCodeList) {
		var ruleInfos = atl2NmfSHelper.getAllRuleInfos();

		for (ruleInfo : ruleInfos) {
			if (ruleInfo.getHasFilter) {
				createFilterCode(ruleInfo, filterCodeList, filterProxiesCodeList);
			}
		}
	}

	/**
	 * Creates the filter code of an ATL rule.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 * @param filterCodeList
	 *            the list where the created filter code is added
	 * @param filterProxiesCodeList
	 *            the list where the created filter proxy code is added
	 */
	def private void createFilterCode(RuleInfo ruleInfo, List<String> filterCodeList,
		List<String> filterProxiesCodeList) {
		var filterCode = FilterTemplate.createCode(ruleInfo);
		var filterProxyCode = FilterProxyTemplate.createCode(ruleInfo);

		filterCodeList.add(filterCode);
		filterProxiesCodeList.add(filterProxyCode);
	}
}
