package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.List

/**
 * The EcoreAnalyzer Interface.
 */
interface EcoreAnalyzer {

	/**
	 * Gets the type info.
	 * 
	 * @param typeName
	 *            the type name
	 * @return the type info
	 */
	def TypeInfo getTypeInfo(String typeName);

	/**
	 * Gets the ns uri.
	 * 
	 * @return the ns uri
	 */
	def String getNsUri();

	/**
	 * Gets the return type info of the feature.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the return type info of the feature
	 */
	def ReturnTypeInfo getReturnTypeInfoOfFeature(String classifierName, String featureName);

	/**
	 * Gets all the type infos that contain feature with the passed type.
	 * 
	 * @param containingFeatureType
	 *            the containing feature type
	 * @return all the type infos that contain feature with the passed type
	 */
	def List<TypeInfo> getAllTypeInfosThatContainFeatureWithType(String containingFeatureType);

	/**
	 * Checks if the features type is complex.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the boolean indicating if the feature type is complex
	 */
	def Boolean isFeaturesTypeComplex(String classifierName, String featureName);

	/**
	 * Checks if the features type is a collection.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the boolean indicating if the features type is a collection
	 */
	def Boolean isFeaturesTypeACollection(String classifierName, String featureName);

}
