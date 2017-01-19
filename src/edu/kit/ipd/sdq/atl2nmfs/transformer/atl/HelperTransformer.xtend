package edu.kit.ipd.sdq.atl2nmfs.transformer.atl;

import java.util.List;

/**
 * The HelperTransformer Interface.
 */
interface HelperTransformer {

	/**
	 * Transforms ATL helpers.
	 * 
	 * @param helperCodeList
	 * 			  the list where the created helper code is added
	 * @param helperProxiesCodeList
	 * 			  the list where the created helper proxy code is added
	 * @param useMemorizationForAttributeHelper
	 *            the value indicating if the memorization patter should be used for transformed attribute helper
	 */
	def void transformHelpers(List<String> helperCodeList, List<String> helperProxiesCodeList, boolean useMemorizationForAttributeHelper);

}
