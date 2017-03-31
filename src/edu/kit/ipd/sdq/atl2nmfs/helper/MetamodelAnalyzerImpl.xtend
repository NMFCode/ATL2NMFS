package edu.kit.ipd.sdq.atl2nmfs.helper

import com.google.inject.Inject
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.ArrayList
import java.util.Collections
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The MetamodelAnalyzerImpl Class.
 */
class MetamodelAnalyzerImpl implements MetamodelAnalyzer {
	private final EcoreAnalyzerFactory ecoreAnalyzerFactory;
	private final Atl2NmfSHelper atl2NmfSHelper;

	private List<MetamodelInfo> inputMetamodelInfos;
	private List<MetamodelInfo> outputMetamodelInfos;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param ecoreAnalyzerFactory
	 *            the ecore analyzer factory
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper, EcoreAnalyzerFactory ecoreAnalyzerFactory) {
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.ecoreAnalyzerFactory = ecoreAnalyzerFactory;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#analyzeMetamodels
	 */
	override void analyzeMetamodels(Module atlModule, List<String> inputMetamodelPaths,
		List<String> outputMetamodelPaths) {
		// initialize input metamodel infos
		inputMetamodelInfos = new ArrayList<MetamodelInfo>();
		var inputIndex = 0;
		for (atlInputModel : atlModule.inModels) {
			val inputMetamodelName = atlInputModel.metamodel.name;

			// the passed order of the metamodel paths must be the same as the defined order of the metamodels in the ATL transformation
			// if the same metamodel is used multiple times the path must be passed only once
			if (!inputMetamodelInfos.exists[it.getName.equals(inputMetamodelName)]) {
				if (inputIndex >= inputMetamodelPaths.size) {
					throw new IllegalArgumentException(
						"There are to less input metamodel paths passed to the HOT. Please make sure all metamodel paths are passed.");
				}

				// TODO: Check if the user has kept the order of the metamodels as defined in the ATL transformation
				var ecoreAnalyzer = ecoreAnalyzerFactory.create(inputMetamodelName,
					inputMetamodelPaths.get(inputIndex));
				var metamodelInfo = new MetamodelInfo(inputMetamodelName, inputMetamodelPaths.get(inputIndex),
					atl2NmfSHelper, ecoreAnalyzer);
				inputMetamodelInfos.add(metamodelInfo);
				inputIndex++;
			}
		}

		// initialize output metamodel infos
		outputMetamodelInfos = new ArrayList<MetamodelInfo>();
		var outputIndex = 0;
		for (atlOutputModel : atlModule.outModels) {
			val outputMetamodelName = atlOutputModel.metamodel.name;

			// the passed order of the metamodel paths must be the same as the defined order of the metamodels in the ATL transformation
			// if the same metamodel is used multiple times the path must be passed only once
			if (!outputMetamodelInfos.exists[it.getName.equals(outputMetamodelName)]) {
				if (outputIndex >= outputMetamodelPaths.size) {
					throw new IllegalArgumentException(
						"There are to less output metamodel paths passed to the HOT. Please make sure all metamodel paths are passed.");
				}

				// TODO: Check if the user has kept the order of the metamodels as defined in the ATL transformation
				var ecoreAnalyzer = ecoreAnalyzerFactory.create(outputMetamodelName,
					outputMetamodelPaths.get(outputIndex));
				var metamodelInfo = new MetamodelInfo(outputMetamodelName, outputMetamodelPaths.get(outputIndex),
					atl2NmfSHelper, ecoreAnalyzer);
				outputMetamodelInfos.add(metamodelInfo);
				outputIndex++;
			}
		}
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#findLowestCommonSuperTypeInfoInInputMetamodel
	 */
	override TypeInfo findLowestCommonSuperTypeInfoInInputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName) {
		val firstTypeInfo = getTypeInfoFromInputMetamodel(firstMetamodelName, firstTypeName);
		val secondTypeInfo = getTypeInfoFromInputMetamodel(secondMetamodelName, secondTypeName);

		return findLowest(firstTypeInfo, secondTypeInfo, firstTypeName, secondTypeName);
	}
	
	override TypeInfo findLowestCommonSuperTypeInfoInOutputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName) {
		val firstTypeInfo = getTypeInfoFromOutputMetamodel(firstMetamodelName, firstTypeName);
		val secondTypeInfo = getTypeInfoFromOutputMetamodel(secondMetamodelName, secondTypeName);

		return findLowest(firstTypeInfo, secondTypeInfo, firstTypeName, secondTypeName);
	}
	
	def TypeInfo findLowest(TypeInfo firstTypeInfo, TypeInfo secondTypeInfo, String firstTypeName, String secondTypeName) {
		if (firstTypeInfo == null) {
			throw new IllegalArgumentException(
				"The lowest common super type could not be determined because the first type '" + firstTypeName +
					"' was not found in the input metamodel.")
		}
		if (secondTypeInfo == null) {
			throw new IllegalArgumentException(
				"The required rules could not be determined because the second type '" + secondTypeName +
					"' was not found in the input metamodel.")
		}

		var firstPossibileTypeInfo = firstTypeInfo.superTypeInfos.findFirst [
			it.name == secondTypeInfo.name
		];
		var secondPossibileTypeInfo = secondTypeInfo.superTypeInfos.findFirst [
			it.name == firstTypeInfo.name
		];

		if (firstPossibileTypeInfo != null) {
			// the second type is a super type of the first one
			return firstPossibileTypeInfo;
		} 
		else if (secondPossibileTypeInfo != null) {
			// the first type is a super type of the second one
			return secondPossibileTypeInfo;
		} 
		else {
			// find common super types of both types
			val commonTypeInfos = new ArrayList<TypeInfo>(firstTypeInfo.superTypeInfos);
			commonTypeInfos.retainAll(secondTypeInfo.superTypeInfos);

			if (commonTypeInfos.size > 1) {
				// find the lowest super type
				// it is the type which has no sub type which is in the commonTypes collection 
				var lowestCommonTypeInfo = commonTypeInfos.findFirst [
					Collections.disjoint(it.subTypeInfos, commonTypeInfos)
				]
				return lowestCommonTypeInfo;
			} 
			else if (commonTypeInfos.size == 1) {
				return commonTypeInfos.get(0);
			} 
			else {
				// no common super type was found
				throw new IllegalArgumentException(
					"No common super type was found for the types: " + firstTypeInfo.name + ", " +
						secondTypeInfo.name);
			}
		}
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getRequiredRuleInfos
	 */
	override List<RuleInfo> getRequiredRuleInfos(String inputMetamodelName, String inputTypeName,
		String outputMetamodelName, String outputTypeName) {
		// we have to return all the rules which input type matches the the type of the input ocl binding expression or one of its subtypes		
		val inputTypeInfo = getTypeInfoFromInputMetamodel(inputMetamodelName, inputTypeName);
		val outputTypeInfo = getTypeInfoFromOutputMetamodel(outputMetamodelName, outputTypeName);

		if (inputTypeInfo == null) {
			throw new IllegalArgumentException(
				"The required rules could not be determined because the input type '" + inputTypeName +
					"' was not found in the input metamodel.")
		}
		if (outputTypeInfo == null) {
			throw new IllegalArgumentException(
				"The required rules could not be determined because the output type '" +
					outputTypeName + "' was not found in the output metamodel.")
		}

		var possibleRuleInfos = atl2NmfSHelper.getPossibleRuleInfosForInputTypeInfo(inputTypeInfo);
		val allowedRuleInfos = new ArrayList<RuleInfo>();
		val forbiddenRuleInfos = new ArrayList<RuleInfo>();

		// check if the output types for the possible rules are in a relationship to the expected output type of the binding
		// Remark: ATL does not care if the output types are in a relationship or not. That way it is possible that an element is created at a place
		// where the type of the element is not allowed and thus makes the model invalid (We prevent that by only allowing rules where the output types are correct)
		for (possibleRuleInfo : possibleRuleInfos) {
			var possibleRuleOutputTypeInfo = getTypeInfoFromOutputMetamodel(
				possibleRuleInfo.outputTypeMetamodelName, possibleRuleInfo.getOutputTypeName);

			if (outputTypeInfo == possibleRuleOutputTypeInfo ||
				outputTypeInfo.subTypeInfos.contains(possibleRuleOutputTypeInfo)) {
				// if the output type of the rule is the expected output type or one of its sub types the rule is allowed at this point
				allowedRuleInfos.add(possibleRuleInfo);
			} 
			else {
				// if the output type of the rule is in no relationship with the expected output type the rule is not allowed at this point
				// because it would result in a type error
				// Warning: ATL still allows such a rule at this point even if it results in an error. The user is responsible to create only valid rules
				forbiddenRuleInfos.add(possibleRuleInfo);
			}
		}

		if (allowedRuleInfos.size == 0) {
			throw new IllegalArgumentException(
				"Could not resolve binding. No possible rule was found for this expression");
		}

		if (forbiddenRuleInfos.size > 0) {
			for (forbiddenRuleInfo : forbiddenRuleInfos) {
				// TODO: print also the binding in the warning
				println(
					"Warning: A call to a possible rule is not declared while transforming a binding. The rule with the name " +
						forbiddenRuleInfo.name + " has a not suitable output type");
			}
		}

		return allowedRuleInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getInputMetamodelInfos
	 */
	override List<MetamodelInfo> getInputMetamodelInfos() {
		return inputMetamodelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getOutputMetamodelInfos
	 */
	override List<MetamodelInfo> getOutputMetamodelInfos() {
		return outputMetamodelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getTypeInfoFromInputMetamodel
	 */
	override TypeInfo getTypeInfoFromInputMetamodel(String metamodelName, String typeName) {
		var metamodelInfo = inputMetamodelInfos.findFirst[it.name.equals(metamodelName)];
		if (metamodelInfo == null) metamodelInfo = outputMetamodelInfos.findFirst[it.name.equals(metamodelName)];
		if (metamodelInfo == null) return null;
		return metamodelInfo.ecoreAnalyzer.getTypeInfo(typeName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getTypeInfoFromOutputMetamodel
	 */
	override TypeInfo getTypeInfoFromOutputMetamodel(String metamodelName, String typeName) {
		var metamodelInfo = outputMetamodelInfos.findFirst[it.name.equals(metamodelName)];
		if (metamodelInfo == null) metamodelInfo = inputMetamodelInfos.findFirst[it.name.equals(metamodelName)];
		if (metamodelInfo == null) return null;
		return metamodelInfo.ecoreAnalyzer.getTypeInfo(typeName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getReturnTypeInfoFromOutputMetamodel
	 */
	override ReturnTypeInfo getReturnTypeInfoFromOutputMetamodel(String metamodelName,
		String classifierName, String featureName) {
		var metamodelInfo = outputMetamodelInfos.findFirst[it.name.equals(metamodelName)];
		return metamodelInfo.ecoreAnalyzer.getReturnTypeInfoOfFeature(classifierName,
			featureName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer#getAllPossibleInputMMTypeInfosThatContainFeatureWithType
	 */
	override List<TypeInfo> getAllPossibleInputMMTypeInfosThatContainFeatureWithType(
		ReturnTypeInfo sourceReturnTypeInfo) {
		// find all classifiers in the input MM that contain a structural feature with the type of the source return type
		var metamodelInfo = inputMetamodelInfos.findFirst [
			it.name.equals(sourceReturnTypeInfo.metamodelName)
		];
		return metamodelInfo.ecoreAnalyzer.
			getAllTypeInfosThatContainFeatureWithType(sourceReturnTypeInfo.getTypeName);
	}
}
						