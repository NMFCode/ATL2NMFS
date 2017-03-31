package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The MetamodelAnalyzer Interface.
 */
interface MetamodelAnalyzer {

	/**
	 * Analyze the used metamodels in the ATL transformation.
	 * 
	 * @param atlModule
	 *            the atl module
	 * @param inputMetamodelPaths
	 *            the paths to the input metamodes
	 * @param outputMetamodelPaths
	 *            the paths to the output metamodels
	 */
	def void analyzeMetamodels(Module atlModule, List<String> inputMetamodelPaths, List<String> outputMetamodelPaths);

	/**
	 * Find lowest common super type info in input metamodel.
	 * 
	 * @param firstMetamodelName
	 *            the first metamodel name
	 * @param firstTypeName
	 *            the first type name
	 * @param secondMetamodelName
	 *            the second metamodel name
	 * @param secondTypeName
	 *            the second type name
	 * @return the type info of the lowest common super type
	 */
	def TypeInfo findLowestCommonSuperTypeInfoInInputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName);
		
		
	/**
	 * Find lowest common super type info in output metamodel.
	 * 
	 * @param firstMetamodelName
	 *            the first metamodel name
	 * @param firstTypeName
	 *            the first type name
	 * @param secondMetamodelName
	 *            the second metamodel name
	 * @param secondTypeName
	 *            the second type name
	 * @return the type info of the lowest common super type
	 */
	def TypeInfo findLowestCommonSuperTypeInfoInOutputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName);

	/**
	 * Get the required rule infos.
	 * 
	 * @param inputMetamodeName
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
	 * Get the input metamodel infos.
	 * 
	 * @return the input metamodel infos
	 */
	def List<MetamodelInfo> getInputMetamodelInfos();

	/**
	 * Get the output metamodel infos.
	 * 
	 * @return the output metamodel infos
	 */
	def List<MetamodelInfo> getOutputMetamodelInfos();

	/**
	 * Get the type info from the input metamodel.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param typeName
	 *            the type name
	 * @return the type info from the input metamodel
	 */
	def TypeInfo getTypeInfoFromInputMetamodel(String metamodelName, String typeName);

	/**
	 * Get the type info from the output metamodel.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param typeName
	 *            the type name
	 * @return the type info from the output metamodel
	 */
	def TypeInfo getTypeInfoFromOutputMetamodel(String metamodelName, String typeName);

	/**
	 * Get the return type info from the output metamodel.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the return type info from the output metamodel
	 */
	def ReturnTypeInfo getReturnTypeInfoFromOutputMetamodel(String metamodelName, String classifierName,
		String featureName);

	/**
	 * Get all the possible input MM type infos that contain feature with the passed type.
	 * 
	 * @param sourceReturnTypeInfo
	 *            the return type info from the source
	 * @return all the possible input MM type infos that contain feature with the passed type
	 */
	def List<TypeInfo> getAllPossibleInputMMTypeInfosThatContainFeatureWithType(ReturnTypeInfo sourceReturnTypeInfo);

}
