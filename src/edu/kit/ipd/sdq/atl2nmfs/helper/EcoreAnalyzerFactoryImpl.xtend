package edu.kit.ipd.sdq.atl2nmfs.helper

/**
 * The EcoreAnalyzerFactoryImpl Class.
 */
class EcoreAnalyzerFactoryImpl implements EcoreAnalyzerFactory {

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzerFactory#create
	 */
	override EcoreAnalyzer create(String metamodelName, String metamodelPath) {
		return new EcoreAnalyzerImpl(metamodelName, metamodelPath);
	}
}
