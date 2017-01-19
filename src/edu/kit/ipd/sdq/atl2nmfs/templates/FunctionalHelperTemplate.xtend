package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo

/**
 * The FunctionalHelperTemplate Class.
 */
class FunctionalHelperTemplate {

	/**
	 * Creates the code.
	 * 
	 * @param helperInfo
	 *            the helper info
	 * @return the created code as string
	 */
	def static String createCode(HelperInfo helperInfo) {
		// ATL functional helper can have parameters
		// combine the parameter information
		var String parameters;
		if (helperInfo.hasContext && helperInfo.hasParameters) {
			parameters = '''«FOR paramInfo : helperInfo.parameterInfos BEFORE '''this «helperInfo.getTransformedContext» self, ''' SEPARATOR ", "»«paramInfo.getTransformedType» «paramInfo.name»«ENDFOR»''';
		} 
		else if (helperInfo.hasContext) {
			parameters = '''this «helperInfo.getTransformedContext» self''';
		} 
		else {
			parameters = '''«FOR paramInfo : helperInfo.parameterInfos SEPARATOR ", "»«paramInfo.getTransformedType» «paramInfo.name»«ENDFOR»''';
		}

		// it is important that the first parameter has the name self because it is used in the expression
		var functionalHelperTemplate = '''
			«IF helperInfo.hasContext || helperInfo.hasParameters»[ObservableProxy(typeof(Proxies), "«helperInfo.getTransformedName»")]«ENDIF»
			public static «helperInfo.getTransformedReturnTypeName» «helperInfo.getTransformedName»(«parameters»)
			{
				//functional helper
				return «helperInfo.getTransformedExpression»;
			}
		'''

		return functionalHelperTemplate;
	}
}
		