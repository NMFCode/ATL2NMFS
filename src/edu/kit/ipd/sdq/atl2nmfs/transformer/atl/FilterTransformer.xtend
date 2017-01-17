package edu.kit.ipd.sdq.atl2nmfs.transformer.atl;

import java.util.List;

/**
 * The FilterTransformer Interface.
 */
interface FilterTransformer {

	/**
	 * Transforms ATL filters.
	 * 
	 * @param filterCodeList
	 *            the list where the created filter code is added
	 * @param filterProxiesCodeList
	 *            the list where the created filter proxy code is added
	 */
	def void transformFilters(List<String> filterCodeList, List<String> filterProxiesCodeList);

}
