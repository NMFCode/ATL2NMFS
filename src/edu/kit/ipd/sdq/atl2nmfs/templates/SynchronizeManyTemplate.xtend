package edu.kit.ipd.sdq.atl2nmfs.templates

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.BindingInfo

/**
 * The SynchronizeManyTemplate Class.
 */
class SynchronizeManyTemplate {

	/**
	 * Creates the code.
	 * 
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @param bindingInfo
	 *            the binding info
	 * @return the created code as string
	 */
	def static String createCode(RuleInfo containingRuleInfo, BindingInfo bindingInfo) {
		return createTemplateCode(null, containingRuleInfo, bindingInfo, bindingInfo.transformedDefaultExpression, false,
			false, false, null, null);
	}

	/**
	 * Creates the code.
	 * 
	 * @param callingRuleInfo
	 *            the calling rule info
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @param bindingInfo
	 *            the binding info
	 * @param bindingExpression
	 *            the transformed binding expression
	 * @param inputCast
	 *            indicating if an input cast is required
	 * @param outputCast
	 *            indicating if an output cast is required
	 * @return the created code as string
	 */
	def static String createCode(RuleInfo callingRuleInfo, RuleInfo containingRuleInfo, BindingInfo bindingInfo,
		String bindingExpression, Boolean inputCast, Boolean outputCast) {
		return createTemplateCode(callingRuleInfo, containingRuleInfo, bindingInfo, bindingExpression, inputCast, 
			outputCast, false, null, null);
	}
	
	/**
	 * Creates the code.
	 * 
	 * @param callingRuleInfo
	 *            the calling rule info
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @param bindingInfo
	 *            the binding info
	 * @param bindingExpression
	 *            the transformed binding expression
	 * @param outputModelName
	 *            the output Model Name
	 * @param outputModelCollectionClassName
	 *            the output model collection class name
	 * @return the created code as string
	 */
	def static String createCode(RuleInfo callingRuleInfo, RuleInfo containingRuleInfo, BindingInfo bindingInfo,
		String bindingExpression, String outputModelName, String outputModelCollectionClassName) {
		return createTemplateCode(callingRuleInfo, containingRuleInfo, bindingInfo, bindingExpression, false, 
			false, true, outputModelName, outputModelCollectionClassName);
	}	

	/**
	 * Creates the template code.
	 * 
	 * @param callingRuleInfo
	 *            the calling rule info
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @param bindingInfo
	 *            the binding info
	 * @param bindingExpression
	 *            the transformed binding expression
	 * @param inputCast
	 *            indicating if an input cast is required
	 * @param outputCast
	 *            indicating if an output cast is required
	 * @param storeAsRootElements
	 *            indicating if an the output element should be stored as RootElements
	 * @param outputModelName
	 *            the output Model Name
	 * @param outputModelCollectionClassName
	 *            the output model collection class name
	 * @return the created code as string
	 */
	def private static String createTemplateCode(RuleInfo callingRuleInfo, RuleInfo containingRuleInfo,
		BindingInfo bindingInfo, String bindingExpression, Boolean inputCast, Boolean outputCast,
		Boolean storeAsRootElements, String outputModelName, String outputModelCollectionClassName) {
		// extracted some information to be able to create a more readable template expression
		var hasRule = callingRuleInfo != null;
		var hasFilter = hasRule && callingRuleInfo.getHasFilter;

		var filterName = if(hasFilter) callingRuleInfo.filterName else "";
		var ruleName = if(hasRule) callingRuleInfo.name else "";
		var expectedInputType = if(inputCast) callingRuleInfo.getTransformedInputTypeName else "";
		var expectedOutputType = if(outputCast) callingRuleInfo.getTransformedOutputTypeName else "";

		var bindingOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;
		var outputType = if(outputCast) bindingOutputReturnTypeInfo.getTransformedName else "";

		var inPatternVariableName = containingRuleInfo.inputVariableName;
		var outPatternVariableName = containingRuleInfo.outputVariableName;

		var outputPropertyName = bindingInfo.transformedOutputPropertyName;

		var String outputExpression;
		if(storeAsRootElements) {
			outputExpression = '''«outputModelCollectionClassName».«outputModelName».RootElements.OfType<IModelElement, «callingRuleInfo.getTransformedOutputTypeName»>()''';
		}
		else {
			outputExpression = '''«outPatternVariableName».«outputPropertyName»«IF outputCast».OfType<«outputType», «expectedOutputType»>()«ENDIF»''';
		}

		var synchronizeManyTemplate = '''
			SynchronizeManyLeftToRightOnly(«IF hasRule»SyncRule<«ruleName»>(),«ENDIF»
				«inPatternVariableName» => «bindingExpression»«IF inputCast».OfType<«expectedInputType»>()«ENDIF»«IF hasFilter».Where(x => x.«filterName»())«ENDIF»,
				«outPatternVariableName» => «outputExpression»);
		'''

		return synchronizeManyTemplate;
	}
}
