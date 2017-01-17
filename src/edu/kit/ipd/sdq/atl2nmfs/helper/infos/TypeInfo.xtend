package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import java.util.List
import java.util.ArrayList
import org.apache.commons.lang.StringUtils

/**
 * The TypeInfo Class.
 */
class TypeInfo {
	private final String metamodelName
	private final String name;
	private final List<TypeInfo> superTypeInfos;
	private final List<TypeInfo> subTypeInfos;

	/**
	 * Class constructor.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param name
	 *            the name
	 */
	new(String metamodelName, String name) {
		this.metamodelName = StringUtils.capitalize(metamodelName);
		this.name = StringUtils.capitalize(name);
		this.superTypeInfos = new ArrayList<TypeInfo>();
		this.subTypeInfos = new ArrayList<TypeInfo>();
	}

	/**
	 * Gets the metamodel name.
	 * 
	 * @return the metamodel name
	 */
	def String getMetamodelName() {
		return metamodelName;
	}

	/**
	 * Gets the name.
	 * 
	 * @return the name
	 */
	def String getName() {
		return name;
	}

	/**
	 * Gets the super type infos.
	 * 
	 * @return the super type infos
	 */
	def List<TypeInfo> getSuperTypeInfos() {
		return superTypeInfos;
	}

	/**
	 * Gets the sub type infos.
	 * 
	 * @return the sub type infos
	 */
	def List<TypeInfo> getSubTypeInfos() {
		return subTypeInfos;
	}

	/**
	 * Gets the transformed name.
	 * 
	 * @return the transformed name
	 */
	def String getTransformedName() {
		return '''«metamodelName».I«name»''';
	}
}
