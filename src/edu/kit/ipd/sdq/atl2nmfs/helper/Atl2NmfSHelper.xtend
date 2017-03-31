package edu.kit.ipd.sdq.atl2nmfs.helper;

import java.util.List;
import org.eclipse.m2m.atl.common.ATL.Library;
import org.eclipse.m2m.atl.common.ATL.Module;
import org.eclipse.m2m.atl.common.OCL.OclExpression;
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ModelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.PossibleReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import org.eclipse.m2m.atl.common.OCL.OclType

/**
 * The Atl2NmfSHelper Interface.
 */
interface Atl2NmfSHelper {

	/**
	 * Initialize the Atl2NmfSHelper for a new transformation.
	 * 
	 * @param atlModule
	 *            the ATL module
	 * @param atlLibraries
	 *            the ATL libraries
	 * @param inputMetamodelPaths
	 *            the input metamodel paths
	 * @param outputMetamodelPaths
	 *            the output metamodel paths
	 */
	def void initializeNewTransformation(Module atlModule, List<Library> atlLibraries, List<String> inputMetamodelPaths,
		List<String> outputMetamodelPaths);
		
	def TypeInfo findClassifier(String metamodel, String classifierName);

	/**
	 * Gets the transformation name.
	 * 
	 * @return the transformation name
	 */
	def String getTransformationName();

	/**
	 * Gets the main rule name.
	 * 
	 * @return the main rule name
	 */
	def String getMainRuleName();

	/**
	 * Gets the c sharp filename extension.
	 * 
	 * @return the c sharp filename extension
	 */
	def String getCSharpFilenameExtension();

	/**
	 * Gets the nmf filename extension.
	 * 
	 * @return the nmf filename extension
	 */
	def String getNmfFilenameExtension();

	/**
	 * Gets the output model collection class name.
	 * 
	 * @return the output model collection class name
	 */
	def String getOutputModelCollectionClassName();

	/**
	 * Gets the input model container class name.
	 * 
	 * @return the input model container class name
	 */
	def String getInputModelContainerClassName();

	/**
	 * Gets the output model container class name.
	 * 
	 * @return the output model container class name
	 */
	def String getOutputModelContainerClassName();

	/**
	 * Gets the helper class name.
	 * 
	 * @return the helper class name
	 */
	def String getHelperClassName();

	/**
	 * Gets the filter class name.
	 * 
	 * @return the filter class name
	 */
	def String getFilterClassName();

	/**
	 * Gets the filter name extension.
	 * 
	 * @return the filter name extension
	 */
	def String getFilterNameExtension();

	/**
	 * Gets the main class name.
	 * 
	 * @return the main class name
	 */
	def String getMainClassName();

	/**
	 * Gets the project namespace.
	 * 
	 * @return the project namespace
	 */
	def String getProjectNamespace();

	/**
	 * Gets the input model infos.
	 * 
	 * @return the input model infos
	 */
	def List<ModelInfo> getInputModelInfos();

	/**
	 * Gets the output model infos.
	 * 
	 * @return the output model infos
	 */
	def List<ModelInfo> getOutputModelInfos();

	/**
	 * Gets the return type info from an output metamodel for the passed values.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the return type info from an output metamodel for the passed values
	 */
	def ReturnTypeInfo getReturnTypeInfoFromOutputMetamodel(String metamodelName, String classifierName,
		String featureName);

	/**
	 * Gets all the possible input MM type infos that contain feature with the passed type.
	 * 
	 * @param sourceReturnTypeInfo
	 *            the source return type info
	 * @return all the possible input MM type infos that contain feature with the passed type
	 */
	def List<TypeInfo> getAllPossibleInputMMTypeInfosThatContainFeatureWithType(ReturnTypeInfo sourceReturnTypeInfo);

	/**
	 * Find the lowest common super type info in input metamodel for the passed values.
	 * 
	 * @param firstMetamodelName
	 *            the first metamodel name
	 * @param firstTypeName
	 *            the first type name
	 * @param secondMetamodelName
	 *            the second metamodel name
	 * @param secondTypeName
	 *            the second type name
	 * @return the lowest common super type info for the passed values
	 */
	def TypeInfo findLowestCommonSuperTypeInfoInInputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName);
		
		
	def TypeInfo findLowestCommonSuperTypeInfoInOutputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName);

	/**
	 * Transform OCL expression.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the transformed OCL expression as string
	 */
	def String transformExpression(OclExpression expression, OclType type);

	/**
	 * Transform OLC expression with ambiguous calls.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @param possibleReturnType
	 *            the possible return type
	 * @return the transformed OCL expression as string
	 */
	def String transformExpressionWithAmbiguousCall(OclExpression expression, OclType type,
		PossibleReturnTypeInfo possibleReturnType);

	/**
	 * Gets all the rule infos.
	 * 
	 * @return all the rule infos
	 */
	def List<RuleInfo> getAllRuleInfos();

	/**
	 * Gets the rule info for the passed rule name.
	 * 
	 * @param ruleName
	 *            the rule name
	 * @return the rule info
	 */
	def RuleInfo getRuleInfo(String ruleName);

	/**
	 * Gets the possible rule infos for the passed input type info.
	 * 
	 * @param inputTypeInfo
	 *            the input type info
	 * @return the possible rule infos for the passed input type info
	 */
	def List<RuleInfo> getPossibleRuleInfosForInputTypeInfo(TypeInfo inputTypeInfo);

	/**
	 * Gets the required rule infos for the passed values.
	 * 
	 * @param inputMetamodelName
	 *            the input metamodel name
	 * @param inputTypeName
	 *            the input type name
	 * @param outputMetamodelName
	 *            the output metamodel name
	 * @param outputTypeName
	 *            the output type name
	 * @return the required rule infos
	 */
	def List<RuleInfo> getRequiredRuleInfos(String inputMetamodelName, String inputTypeName, String outputMetamodelName,
		String outputTypeName);

	/**
	 * Check and initialize target pattern elements references.
	 * 
	 * @param ruleInfo
	 *            the rule info
	 */
	def void checkAndInitializeTargetPatternElementReferences(RuleInfo ruleInfo);

	/**
	 * Gets the return type info of the passed OCL expression.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the return type info of the passed OCL expression
	 */
	def ReturnTypeInfo getReturnTypeInfoOfOclExpression(OclExpression expression);

	/**
	 * Checks if an attribute helper with the passed name exists.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the boolean indicating if an attribute helper with the passed name exists
	 */
	def Boolean isAttributeHelper(String helperName);

	/**
	 * Gets the attribute helper info for the passed helper name.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the attribute helper info for the passed helper name
	 */
	def HelperInfo getAttributeHelperInfo(String helperName);

	/**
	 * Checks if a functional helper with the passed name exists.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the boolean indicating if a functional helper with the passed name exists
	 */
	def Boolean isFunctionalHelper(String helperName);

	/**
	 * Gets the functional helper info for the passed helper name.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the functional helper info for the passed helper name
	 */
	def HelperInfo getFunctionalHelperInfo(String helperName);

	/**
	 * Gets all the helper infos.
	 * 
	 * @return all the helper infos
	 */
	def List<HelperInfo> getAllHelperInfos();

	/**
	 * Checks if a lazy rule with the passed rule name exists.
	 * 
	 * @param ruleName
	 *            the rule name
	 * @return the boolean indicating if a lazy rule with the passed rule name exists
	 */
	def Boolean isLazyRule(String ruleName);

	/**
	 * Gets the input metamodel infos.
	 * 
	 * @return the input metamodel infos
	 */
	def List<MetamodelInfo> getInputMetamodelInfos();

	/**
	 * Gets the output metamodel infos.
	 * 
	 * @return the output metamodel infos
	 */
	def List<MetamodelInfo> getOutputMetamodelInfos();

}
