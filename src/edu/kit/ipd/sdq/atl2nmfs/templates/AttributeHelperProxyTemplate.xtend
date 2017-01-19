package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import org.apache.commons.lang.WordUtils

/**
 * The AttributeHelperProxyTemplate Class.
 */
class AttributeHelperProxyTemplate {

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
		// ATL attribute helpers can't have parameters
		var observingFuncName = WordUtils.uncapitalize(helperInfo.getTransformedName) + "Func";

		// it is important that the parameter name "self" is used because this name is used in the expression
		var String attributeHelperProxyTemplate;
		if(useMemorizationForAttributeHelper) {
			// the memorization pattern should be used which means that for each calling context the computed value
			// and the notify value is stored and they therefore have only be computed once  
			var computationsDictName = helperInfo.getTransformedName + "Computations";	

			attributeHelperProxyTemplate = '''
				public static INotifyValue<string> «helperInfo.getTransformedName»Proxy(«helperInfo.getTransformedContext» parameter)
				{
				    INotifyValue<«helperInfo.getTransformedReturnTypeName»> computation;
				    if (!«computationsDictName».TryGetValue(parameter, out computation))
				    {
				        var «observingFuncName» = new ObservingFunc<«helperInfo.getTransformedContext», «helperInfo.getTransformedReturnTypeName»>(
				        	self => «helperInfo.getTransformedExpression»);
				
				        computation = «observingFuncName».Observe(parameter);
				        «computationsDictName».Add(parameter, computation);
				    }
				
				    return computation;
				}
			'''
		}
		else {
			attributeHelperProxyTemplate = '''
				private static readonly ObservingFunc<«helperInfo.getTransformedContext», «helperInfo.getTransformedReturnTypeName»> «observingFuncName» = 
					new ObservingFunc<«helperInfo.getTransformedContext», «helperInfo.getTransformedReturnTypeName»>(self => «helperInfo.getTransformedExpression»);
				
				public static INotifyValue<«helperInfo.getTransformedReturnTypeName»> «helperInfo.getTransformedName»(INotifyValue<«helperInfo.getTransformedContext»> self)
				{
				    return «observingFuncName».Observe(self);
				}
			'''
		}
			
		return attributeHelperProxyTemplate;
	}
}
		