package edu.kit.ipd.sdq.atl2nmfs.transformer.atl

import com.google.inject.Inject
import java.util.ArrayList
import java.util.List
import org.apache.commons.lang.NotImplementedException
import edu.kit.ipd.sdq.atl2nmfs.templates.SynchronizeManyMainRuleTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.SynchronizeManyTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.SynchronizeTemplate
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleType
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ModelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.BindingInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper

/**
 * The BindingTransformerImpl Class.
 */
class BindingTransformerImpl implements BindingTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper) {
		this.atl2NmfSHelper = atl2NmfSHelper;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.BindingTransformer#transformBindings
	 */
	override void transformBindings(RuleInfo ruleInfo, List<String> bindingsCodeList) {
		for (bindingInfo : ruleInfo.bindingInfos) {
			var binding = transformBinding(bindingInfo, ruleInfo);
			bindingsCodeList.addAll(binding);
		}
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.BindingTransformer#createMainRuleBindings
	 */
	override List<String> createMainRuleBindings(List<RuleInfo> ruleInfos) {
		val mainRuleBindingsCodeList = new ArrayList<String>();

		val inputModelInfos = atl2NmfSHelper.inputModelInfos;
		val outputModelInfos = atl2NmfSHelper.outputModelInfos;

		// create a binding for all matched rules. Lazy and unique lazy matched rules are
		// not called from the main rule. They are only referenced directly from other rules	
		for (ruleInfo : ruleInfos) {
			if (ruleInfo.ruleType == RuleType.MATCHED) {
				createMainRuleBindingsForMatchedRule(ruleInfo, inputModelInfos, outputModelInfos,
					mainRuleBindingsCodeList);
			}
		}

		return mainRuleBindingsCodeList;
	}

	/**
	 * Creates the main rule bindings code for matched rule.
	 * 
	 * @param matchedRuleInfo
	 *            the matched rule info
	 * @param inputModelInfos
	 *            the input model infos
	 * @param outputModelInfos
	 *            the output model infos
	 * @param mainRuleBindingsCodeList
	 *            the list where the created code of the main rule bindings is added
	 */
	def private void createMainRuleBindingsForMatchedRule(RuleInfo matchedRuleInfo, List<ModelInfo> inputModelInfos,
		List<ModelInfo> outputModelInfos, List<String> mainRuleBindingsCodeList) {
		// we have to create for each possible input model of this rule a binding which calls the rule with the elements in the possible input model
		var filteredInputModelInfos = inputModelInfos.filter [
			it.metamodelName.equals(matchedRuleInfo.inputTypeMetamodelName)
		].toList;
		for (inputModelInfo : filteredInputModelInfos) {
			// we have to create for each possible output model of this rule a binding where the created output elements are stored in the possible output models
			var filteredOutputModelInfos = outputModelInfos.filter [
				it.metamodelName.equals(matchedRuleInfo.outputTypeMetamodelName)
			].toList;
			for (outputModelInfo : filteredOutputModelInfos) {
				var binding = SynchronizeManyMainRuleTemplate.createCode(matchedRuleInfo, inputModelInfo.name,
					outputModelInfo.name, atl2NmfSHelper.outputModelCollectionClassName);
				mainRuleBindingsCodeList.add(binding);
			}

			// add calls for all additional rules which were created for non default output elements of an ATL rule
			for (additionalRuleInfo : matchedRuleInfo.getAdditionalOutputPatternElementRuleInfos) {
				// we only have to create bindings for the synchronization rules if the corresponding 
				// target pattern element wasn't referenced from a binding of this rule.
				// In case it was referenced it will be created automatically when the corresponding
				// rule of the default target pattern element will be executed.
				if(!additionalRuleInfo.isReferenced) {
					var filteredAdditionalOutputModelInfos = outputModelInfos.filter [
						it.metamodelName.equals(additionalRuleInfo.outputTypeMetamodelName)
					].toList;
					for (outputModelInfo : filteredAdditionalOutputModelInfos) {
						var additionalRuleBinding = SynchronizeManyMainRuleTemplate.createCode(additionalRuleInfo,
							inputModelInfo.name, outputModelInfo.name, atl2NmfSHelper.outputModelCollectionClassName);
						mainRuleBindingsCodeList.add(additionalRuleBinding);
					}
				}
			}
		}
	}

	/**
	 * Transforms a binding.
	 * 
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @return the list where the created code is added
	 */
	def private List<String> transformBinding(BindingInfo bindingInfo, RuleInfo containingRuleInfo) {
		val bindingsCode = new ArrayList<String>();

		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
		val ruleOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;

		if (!ruleInputReturnTypeInfo.isAmbiguous && !ruleOutputReturnTypeInfo.isAmbiguous &&
			ruleInputReturnTypeInfo.typePrimitive != ruleOutputReturnTypeInfo.typePrimitive) {
			throw new IllegalArgumentException(
				"The Binding " + bindingInfo.outputPropertyName + " at location " + bindingInfo.location + " can't be resolved since one side of the Binding has a primitive type and the other a complex type. Rule name: " +
					containingRuleInfo.name + "; Output classifier: " + bindingInfo.outputTypeName +
					"; Output element: " + bindingInfo.getOutputPropertyName);
		}
		
		if (ruleOutputReturnTypeInfo.isAmbiguous) {
			throw new Exception("The binding  " + bindingInfo.outputPropertyName + " at location " + bindingInfo.location + " is ambiguous.");
		}

		if (ruleOutputReturnTypeInfo.typePrimitive) {
			// the type is a primitive type (like string, double, ...) so we don't have to call another rule here
			transformBindingPrimitiveType(bindingsCode, bindingInfo, containingRuleInfo);
		} 
		else {
			// the type is a reference to another metamodel element so we have to call another rule or rules
			if (ruleOutputReturnTypeInfo.isAmbiguous) {
				throw new NotImplementedException(
					"Ambiguous rule output types are not supported yet. Rule name: " + containingRuleInfo.name +
						"; Output classifier: " + bindingInfo.outputTypeName + "; Output element: " +
						bindingInfo.getOutputPropertyName);
			}

			if (ruleInputReturnTypeInfo.getUsageOfAnotherOutputPatternElement) {
				transformBindingReferenceTypeWhereAnotherOutputPatternElementIsReferenced(bindingsCode,
					bindingInfo, containingRuleInfo);
			} 
			else if (ruleInputReturnTypeInfo.isAmbiguous) {
				transformBindingReferenceTypeWhereInputTypeIsAmbiguous(bindingsCode, bindingInfo,
					containingRuleInfo);
			} 
			else if (ruleInputReturnTypeInfo.isCallToLazyRule) {
				transformBindingReferenceTypeWhereLazyRuleIsCalled(bindingsCode, bindingInfo,
					containingRuleInfo);
			} 
			else {
				transformBindingReferenceTypeDefaultCase(bindingsCode, bindingInfo, containingRuleInfo);
			}
		}

		return bindingsCode;
	}

	/**
	 * Transform binding where the output is a reference type and another output pattern element is referenced on the input side.
	 * 
	 * @param bindingCode
	 *            the list where the created code of the binding is added
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 */
	def private void transformBindingReferenceTypeWhereAnotherOutputPatternElementIsReferenced(
		List<String> bindingCode, BindingInfo bindingInfo, RuleInfo containingRuleInfo) {
		// if another output pattern element was referenced in the expression the rule which was created for 
		// this output pattern element has to be called (and no other rule)
		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;

		// the variable name of the referenced output pattern element is the output variable name of the rule of the output pattern element
		var RuleInfo requiredRuleInfo;
		if (containingRuleInfo.isDefaultRule) {
			// If it is the default rule info it contains all the rule infos which are created for the different ATL output pattern elements
			requiredRuleInfo = containingRuleInfo.getAdditionalOutputPatternElementRuleInfos.findFirst [ additionalOutputPatternElementRuleInfo |
				additionalOutputPatternElementRuleInfo.outputVariableName.equals(
					ruleInputReturnTypeInfo.getNameOfTheReferencedOutputPatternElement)
			];
		} 
		else {
			var parentRule = containingRuleInfo.parentRuleInfo;
			if (ruleInputReturnTypeInfo.nameOfTheReferencedOutputPatternElement.equals(parentRule.outputVariableName)) {
				requiredRuleInfo = parentRule;
			} else {
				// if it is not the default rule it contains no additional output element rule because itself is one. So we have to 
				// use the parent rule which contains all the rule infos which are created for the different atl output elements 
				requiredRuleInfo = containingRuleInfo.getParentRuleInfo.getAdditionalOutputPatternElementRuleInfos.
					findFirst [ additionalOutputPatternElementRuleInfo |
						additionalOutputPatternElementRuleInfo.outputVariableName.equals(
							ruleInputReturnTypeInfo.getNameOfTheReferencedOutputPatternElement)
					];
			}
		}

		if (requiredRuleInfo == null) {
			throw new IllegalArgumentException(
				"The ruleInfo with the output variable name " +
					ruleInputReturnTypeInfo.getNameOfTheReferencedOutputPatternElement + " was not found")
		}

		// in case of a reference to another output pattern element:
		// we have to use the inPatternElement variable name as expression (the input lambda expression must be e => e)
		// we have to use the input type of the containing rule and not the name of the ruleInputType 
		//(this would be the output type of the referenced output pattern element and would be false)
		var code = transformBindingForCallingRules(requiredRuleInfo, containingRuleInfo, bindingInfo,
			containingRuleInfo.inputVariableName, containingRuleInfo.getInputTypeName);
		bindingCode.add(code);
	}

	/**
	 * Transform binding where the output is a reference type and the input type is ambiguous.
	 * 
	 * @param bindingCode
	 *            the list where the created code of the binding is added
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 */
	def private void transformBindingReferenceTypeWhereInputTypeIsAmbiguous(List<String> bindingCode,
		BindingInfo bindingInfo, RuleInfo containingRuleInfo) {
		// it is possible that the input type of the expression is ambiguous
		// in such a case multiple input types are possible and have to be considered
		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
		val ruleOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;

		for (possibleType : ruleInputReturnTypeInfo.getPossibleReturnTypeInfos) {
			// we can't use the default transformed expression in the binding info. We have to consider the possible type during
			// the transformation of the OCL expression to solve ambiguous property navigations with a cast to the possible type
			val transformedExpression = atl2NmfSHelper.
				transformExpressionWithAmbiguousCall(bindingInfo.oclExpression, null, possibleType);

			var requiredRules = atl2NmfSHelper.getRequiredRuleInfos(possibleType.metamodelName,
				possibleType.typeName, containingRuleInfo.outputTypeMetamodelName,
				ruleOutputReturnTypeInfo.typeName);
			for (requiredRule : requiredRules) {
				var code = transformBindingForCallingRules(requiredRule, containingRuleInfo, bindingInfo,
					transformedExpression, possibleType.typeName);
				bindingCode.add(code);
			}
		}
	}

	/**
	 * Transform binding where the output is a reference type and a lazy rule is called on the input side.
	 * 
	 * @param bindingCode
	 *            the list where the created code of the binding is added
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 */
	def private void transformBindingReferenceTypeWhereLazyRuleIsCalled(List<String> bindingCode,
		BindingInfo bindingInfo, RuleInfo containingRuleInfo) {
		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;

		// TODO: Distinguish between a call to a lazy rule and an unique lazy rule
		// the call to a unique lazy rule is correct since by using the trace links in the NMF S. engine an already created output model element is used
		// the call to a lazy rule is not correct yet since it isn't always a new output model model element created
		
		// this is the corresponding rule info for the default target pattern of the lazy rule
		var lazyRuleInfo = ruleInputReturnTypeInfo.lazyRuleInfo
		var code = transformBindingForCallingRules(lazyRuleInfo, containingRuleInfo,
			bindingInfo, bindingInfo.transformedDefaultExpression, ruleInputReturnTypeInfo.getTypeName);
		bindingCode.add(code);
		
		// for each non default target pattern element that is not referenced in one of the lazy rules
		// target pattern element we have to create a synchronization block which calls the
		// corresponding synchronization rule of the target pattern element
		for(addtionalTargetPatternElementRuleInfo : lazyRuleInfo.additionalOutputPatternElementRuleInfos) {
			if(!addtionalTargetPatternElementRuleInfo.isReferenced) {
				// we have to create for each possible output model of this rule a binding where the created output elements are stored 
				// in the possible output models as root elements			
				val outputModelInfos = atl2NmfSHelper.outputModelInfos;
				var filteredOutputModelInfos = outputModelInfos.filter [
					it.metamodelName.equals(addtionalTargetPatternElementRuleInfo.outputTypeMetamodelName)
				].toList;
				
				for (outputModelInfo : filteredOutputModelInfos) {
					val bindingInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
					val bindingOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;

					var String additionalCode;
					if (bindingInputReturnTypeInfo.getIsTypeCollection &&
						bindingOutputReturnTypeInfo.getIsTypeCollection) {
						// it is a collection so we have to call SynchronizeMany
						additionalCode = SynchronizeManyTemplate.createCode(addtionalTargetPatternElementRuleInfo, containingRuleInfo, 
							bindingInfo, bindingInfo.transformedDefaultExpression, outputModelInfo.name, atl2NmfSHelper.outputModelContainerClassName);
					} 
					else {
						// it is no collection so we have to call Synchronize
						additionalCode = SynchronizeTemplate.createCode(addtionalTargetPatternElementRuleInfo, containingRuleInfo, 
							bindingInfo, bindingInfo.transformedDefaultExpression, outputModelInfo.name, atl2NmfSHelper.outputModelContainerClassName);
					}
					
					bindingCode.add(additionalCode);
				}
			}
		}
	}

	/**
	 * Transform binding where the output is a reference type.
	 * 
	 * @param bindingCode
	 *            the list where the created code of the binding is added
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 */
	def private void transformBindingReferenceTypeDefaultCase(List<String> bindingCode,
		BindingInfo bindingInfo, RuleInfo containingRuleInfo) {
		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
		val ruleOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;
		
		if (ruleInputReturnTypeInfo.metamodelName == ruleOutputReturnTypeInfo.metamodelName &&
			ruleInputReturnTypeInfo.typeName == ruleOutputReturnTypeInfo.typeName) {
			transformBindingPrimitiveType(bindingCode, bindingInfo, containingRuleInfo);
			return;
		}

		var requiredRules = atl2NmfSHelper.getRequiredRuleInfos(ruleInputReturnTypeInfo.metamodelName,
			ruleInputReturnTypeInfo.getTypeName, containingRuleInfo.outputTypeMetamodelName,
			ruleOutputReturnTypeInfo.typeName);
		for (requiredRule : requiredRules) {
			var code = transformBindingForCallingRules(requiredRule, containingRuleInfo, bindingInfo,
				bindingInfo.transformedDefaultExpression, ruleInputReturnTypeInfo.getTypeName);
			bindingCode.add(code);
		}
	}

	/**
	 * Transform binding where a rule has to be called.
	 * 
	 * @param callingRuleInfo
	 *            the calling rule info
	 * @param containingRuleInfo
	 *            the containing rule info
	 * @param bindingInfo
	 *            the binding info
	 * @param expression
	 *            the transformed expression as string
	 * @param inputTypeName
	 *            the input type name
	 * @return the created code as string
	 */
	def private String transformBindingForCallingRules(RuleInfo callingRuleInfo,
		RuleInfo containingRuleInfo, BindingInfo bindingInfo, String expression, String inputTypeName) {
		val bindingInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
		val bindingOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;

		// we have to check if we have to cast to the correct type	
		var inputCast = callingRuleInfo.castForInputRequired(inputTypeName);
		var outputCast = callingRuleInfo.castForOutputRequired(bindingOutputReturnTypeInfo.typeName);

		if (bindingInputReturnTypeInfo.getIsTypeCollection &&
			bindingOutputReturnTypeInfo.getIsTypeCollection) {
			// it is a collection so we have to call SynchronizeMany
			var code = SynchronizeManyTemplate.createCode(callingRuleInfo, containingRuleInfo, bindingInfo,
				expression, inputCast, outputCast);

			return code;
		} 
		else {
			// it is no collection so we have to call Synchronize
			var code = SynchronizeTemplate.createCode(callingRuleInfo, containingRuleInfo, bindingInfo,
				expression, inputCast, outputCast);

			return code;
		}
	}

	/**
	 * Transform binding where the types are primitive.
	 * 
	 * @param bindingCode
	 *            the list where the created code of the binding is added
	 * @param bindingInfo
	 *            the binding info
	 * @param containingRuleInfo
	 *            the containing rule info
	 */
	def private void transformBindingPrimitiveType(List<String> bindingCode, BindingInfo bindingInfo,
		RuleInfo containingRuleInfo) {
		// the type is a simple type like e.g. string so we don't have to call another rule
		val ruleInputReturnTypeInfo = bindingInfo.inputReturnTypeInfo;
		val ruleOutputReturnTypeInfo = bindingInfo.outputReturnTypeInfo;

		if (ruleInputReturnTypeInfo.getIsTypeCollection && ruleOutputReturnTypeInfo.getIsTypeCollection) {
			// it is a collection so we have to call SynchronizeMany
			var code = SynchronizeManyTemplate.createCode(
				containingRuleInfo,
				bindingInfo);
			bindingCode.add(code);
		} 
		else {
			// it is no collection so we have to call Synchronize
			var code = SynchronizeTemplate.createCode(containingRuleInfo, bindingInfo);
			bindingCode.add(code);
		}
	}
}
			