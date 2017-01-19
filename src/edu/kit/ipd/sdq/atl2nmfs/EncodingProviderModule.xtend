package edu.kit.ipd.sdq.atl2nmfs

import org.eclipse.xtext.parser.IEncodingProvider;
import org.eclipse.xtext.service.AbstractGenericModule;

/**
 * The Class EncodingProviderModule.
 */
class EncodingProviderModule extends AbstractGenericModule {
	
	/**
	 * Bind the IEncoding provider.
	 *
	 * @return the class<? extends IEncoding provider>
	 */
	public def Class<? extends IEncodingProvider> bindIEncodingProvider() {
		return IEncodingProvider.Runtime;
	}
}
