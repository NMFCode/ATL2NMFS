package edu.kit.ipd.sdq.atl2nmfs.helper

/**
 * A factory for creating EcoreAnalyzer objects.
 */
interface EcoreAnalyzerFactory {

	/**
	 * Creates a EcoreAnalyzer.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param metamodelPath
	 *            the metamodel path
	 * @return the created ecore analyzer
	 */
	def EcoreAnalyzer create(String metamodelName, String metamodelPath);

}
