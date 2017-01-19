package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo

/**
 * The FunctionalHelperProxyTemplate Class.
 */
class FunctionalHelperProxyTemplate {

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
		var String combinedParameters;
		var String combinedParameterTypes;
		var String combinedParameterNames;

		if (helperInfo.hasContext && helperInfo.hasParameters) {
			combinedParameters = '''«FOR paramInfo : helperInfo.parameterInfos BEFORE '''INotifyValue<«helperInfo.getTransformedContext»> self, ''' SEPARATOR ", "»INotifyValue<«paramInfo.getTransformedType»> «paramInfo.name»«ENDFOR»''';
			combinedParameterTypes = '''«FOR paramInfo : helperInfo.parameterInfos BEFORE '''«helperInfo.getTransformedContext», ''' SEPARATOR ", "»«paramInfo.getTransformedType»«ENDFOR»''';
			combinedParameterNames = '''«FOR paramInfo : helperInfo.parameterInfos BEFORE '''self, ''' SEPARATOR ", "»«paramInfo.name»«ENDFOR»'''
		} 
		else if (helperInfo.hasContext) {
			combinedParameters = '''INotifyValue<«helperInfo.getTransformedContext»> self''';
			combinedParameterTypes = helperInfo.getTransformedContext;
			combinedParameterNames = "self";
		} else {
			combinedParameters = '''«FOR paramInfo : helperInfo.parameterInfos SEPARATOR ", "»INotifyValue<«paramInfo.getTransformedType»> «paramInfo.name»«ENDFOR»''';
			combinedParameterTypes = '''«FOR paramInfo : helperInfo.parameterInfos SEPARATOR ", "»«paramInfo.getTransformedType»«ENDFOR»''';
			combinedParameterNames = '''«FOR paramInfo : helperInfo.parameterInfos SEPARATOR ", "»«paramInfo.name»«ENDFOR»'''
		}

		var observingFuncName = helperInfo.getTransformedName + "Func";

		// it is important that the parameter name "self" is used because this name is used in the expression
		var functionalHelperProxyTemplate = '''
			private static readonly ObservingFunc<«combinedParameterTypes», «helperInfo.getTransformedReturnTypeName»> «observingFuncName» = 
				new ObservingFunc<«combinedParameterTypes», «helperInfo.getTransformedReturnTypeName»>((«combinedParameterNames») => «helperInfo.getTransformedExpression»);
				
			public static INotifyValue<«helperInfo.getTransformedReturnTypeName»> «helperInfo.getTransformedName»(«combinedParameters»)
			{
			    return «observingFuncName».Observe(«combinedParameterNames»);
			}
		'''

		return functionalHelperProxyTemplate;
	}
}
				