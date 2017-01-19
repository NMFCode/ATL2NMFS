package edu.kit.ipd.sdq.atl2nmfs.transformer.atl

import com.google.inject.Inject
import java.util.List
import edu.kit.ipd.sdq.atl2nmfs.templates.AttributeHelperProxyTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.FunctionalHelperTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.FunctionalHelperProxyTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.AttributeHelperTemplate
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperType
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper

/**
 * The HelperTransformerImpl Class.
 */
class HelperTransformerImpl implements HelperTransformer {
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
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.HelperTransformer#transformHelpers
	 */
	override void transformHelpers(List<String> helperCodeList, List<String> helperProxiesCodeList, 
		boolean useMemorizationForAttributeHelper) {
		var helperInfos = atl2NmfSHelper.getAllHelperInfos();
		for (helperInfo : helperInfos) {
			if (helperInfo.helperType == HelperType.ATTRIBUTE) {
				createAttributeHelperCode(helperInfo, helperCodeList, helperProxiesCodeList, useMemorizationForAttributeHelper)
			} else {
				createFunctionalHelperCode(helperInfo, helperCodeList, helperProxiesCodeList)
			}
		}
	}

	/**
	 * Creates the code of an attribute helper.
	 * 
	 * @param helperInfo
	 *            the helper info
	 * @param helperCodeList
	 * 			  the list where the created helper code is added
	 * @param helperProxiesCodeList
	 * 			  the list where the created helper proxy code is added
	 * @param useMemorizationForAttributeHelper
	 *            the value indicating if the memorization patter should be used for transformed attribute helper
	 */
	def private void createAttributeHelperCode(HelperInfo helperInfo, List<String> helperCodeList,
		List<String> helperProxiesCodeList, boolean useMemorizationForAttributeHelper) {
		// attribute helper: no parameters, only executed once for each calling context
		var attributeHelperCode = AttributeHelperTemplate.createCode(helperInfo, useMemorizationForAttributeHelper);
		helperCodeList.add(attributeHelperCode);

		// we don't have to create an observable proxy for this attribute helper if it has no context		
		if (helperInfo.hasContext) {
			var attributeHelperProxyCode = AttributeHelperProxyTemplate.createCode(helperInfo, useMemorizationForAttributeHelper);
			helperProxiesCodeList.add(attributeHelperProxyCode);
		}
	}

	/**
	 * Creates the code of a functional helper.
	 * 
	 * @param helperInfo
	 *            the helper info
	 * @param helperCodeList
	 * 			  the list where the created helper code is added
	 * @param helperProxiesCodeList
	 * 			  the list where the created helper proxy code is added
	 */
	def private void createFunctionalHelperCode(HelperInfo helperInfo, List<String> helperCodeList,
		List<String> helperProxiesCodeList) {
		// functional helper (operation helper): can have parameters
		// self is the first parameter in the extension methods
		var functionalHelperCode = FunctionalHelperTemplate.createCode(helperInfo);
		helperCodeList.add(functionalHelperCode);

		// we don't have to create an observable proxy for this functional helper if it has no context and no parameters 		
		if (helperInfo.hasContext || helperInfo.hasParameters) {
			var functionalHelperProxyCode = FunctionalHelperProxyTemplate.createCode(helperInfo);
			helperProxiesCodeList.add(functionalHelperProxyCode);
		}
	}
}
