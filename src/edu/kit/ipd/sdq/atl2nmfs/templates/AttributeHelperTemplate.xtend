package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import org.apache.commons.lang.WordUtils

/**
 * The AttributeHelperTemplate Class.
 */
class AttributeHelperTemplate {

	/**
	 * Creates the code.
	 * 
	 * @param helperInfo
	 *            the helper info
	 * @param useMemorizationForAttributeHelper
	 *            the value indicating if the memorization patter should be used for transformed attribute helper
	 * @return the created code as string
	 */
	def static String createCode(HelperInfo helperInfo, boolean useMemorizationForAttributeHelper) {
		// ATL attribute helper can't have parameters
		// it is important that the parameter has the name self because this name is used in the expression
		var String attributeHelperTemplate;
		if(useMemorizationForAttributeHelper && helperInfo.hasContext) {
			// the memorization pattern should be used which means that for each calling context the computed value
			// and the notify value is stored and they therefore have only be computed once  
			var valuesDictName = helperInfo.getTransformedName + "Values";
			var computationsDictName = helperInfo.getTransformedName + "Computations";
			
			attributeHelperTemplate = '''
				private static readonly Dictionary<«helperInfo.getTransformedContext», «helperInfo.getTransformedReturnTypeName»> «valuesDictName» = new Dictionary<«helperInfo.getTransformedContext», «helperInfo.getTransformedReturnTypeName»>();
				private static readonly Dictionary<«helperInfo.getTransformedContext», INotifyValue<«helperInfo.getTransformedReturnTypeName»>> «computationsDictName» = new Dictionary<«helperInfo.getTransformedContext», INotifyValue<«helperInfo.getTransformedReturnTypeName»>>();
				
				[ObservableProxy(typeof(Proxies), "«helperInfo.getTransformedName»Proxy")]
				public static «helperInfo.getTransformedReturnTypeName» «helperInfo.getTransformedName»(this «helperInfo.getTransformedContext» self)
				{
					//attribute helper
					INotifyValue<«helperInfo.getTransformedReturnTypeName»> computation;
					if (!«computationsDictName».TryGetValue(self, out computation))
					{
					    string value;
					    if (!«valuesDictName».TryGetValue(self, out value))
					    {
					        value = «helperInfo.getTransformedExpression»;
					        «valuesDictName».Add(self, value);
					    }
				
					    return value;
					}
				
					return computation.Value;
				}
			'''
		}
		else if (useMemorizationForAttributeHelper) {
			// since the memorization pattern should be used and the attribute has no context we don't have
			// to create dicts since the calling context is always the same and therefore only one value
			// can be computed
			var valueName = WordUtils.uncapitalize(helperInfo.getTransformedName) + "Value";
			var valueInitializedFlagName = "is" + helperInfo.getTransformedName + "ValueInitialized";
			
			attributeHelperTemplate = '''
				private static «helperInfo.getTransformedReturnTypeName» «valueName»;
				private static bool «valueInitializedFlagName» = false;
				
				public static «helperInfo.getTransformedReturnTypeName» «helperInfo.getTransformedName»()
				{
					//attribute helper
					if (!«valueInitializedFlagName»)
					{
					    «valueName» = «helperInfo.getTransformedExpression»;
					    «valueInitializedFlagName» = true;
					}

					return «valueName»;
				}
			'''
		}
		else {
			attributeHelperTemplate = '''
				«IF helperInfo.hasContext»[ObservableProxy(typeof(Proxies), "«helperInfo.getTransformedName»")]«ENDIF»
				public static «helperInfo.getTransformedReturnTypeName» «helperInfo.getTransformedName»(«IF helperInfo.hasContext»this «helperInfo.getTransformedContext» self«ENDIF»)
				{
					//attribute helper
					return «helperInfo.getTransformedExpression»;
				}
			'''
		}
		
		return attributeHelperTemplate;
	}
}
