package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import java.util.List
import org.apache.commons.lang.StringUtils

/**
 * The ReturnTypeInfo Class.
 */
class ReturnTypeInfo {
	private final String metamodelName;
	private final String typeName;
	private final Boolean isTypePrimitive;
	private final RuleInfo lazyRuleInfo;
	private final boolean isAmbiguous;
	private final List<PossibleReturnTypeInfo> possibleReturnTypeInfos;

	private boolean isTypeCollection;
	private boolean usageOfAnotherOutputPatternElement;
	private String nameOfTheReferencedOutputPatternElement;

	/**
	 * Class constructor to create an instance for a complex type.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param typeName
	 *            the type name
	 */
	new(String metamodelName, String typeName, boolean isClass) {
		this.metamodelName = StringUtils.capitalize(metamodelName);
		this.typeName = StringUtils.capitalize(typeName);

		this.isTypeCollection = false;
		this.isTypePrimitive = !isClass;
		this.isAmbiguous = false;
		this.lazyRuleInfo = null;
		this.possibleReturnTypeInfos = null;
	}

	/**
	 * Class constructor to create an instance where a lazy rule is called in the OCL expression.
	 * 
	 * @param lazyRuleInfo
	 *            the lazy rule info
	 * @param argumentsReturnTypeInfo
	 *            the arguments return type info
	 */
	new(RuleInfo lazyRuleInfo, ReturnTypeInfo argumentsReturnTypeInfo) {
		this.lazyRuleInfo = lazyRuleInfo;

		this.metamodelName = lazyRuleInfo.outputTypeMetamodelName;
		this.typeName = lazyRuleInfo.outputTypeName;
		this.isTypeCollection = false;

		this.isTypePrimitive = false;
		this.isAmbiguous = false;
		this.possibleReturnTypeInfos = null;
	}

	/**
	 * Class constructor to create an instance when the type is complex but not definitely decidable (there are more possible candidates).
	 * 
	 * @param possibleReturnTypeInfos
	 *            the possible return type infos
	 */
	new(List<PossibleReturnTypeInfo> possibleReturnTypeInfos) {
		this.possibleReturnTypeInfos = possibleReturnTypeInfos;
		this.isAmbiguous = true;

		this.isTypePrimitive = null;
		this.metamodelName = null;
		this.typeName = null;
		this.lazyRuleInfo = null;
	}

	/**
	 * Class constructor to create an instance when the return type is a primitive type.
	 */
	new() {
		this.isTypePrimitive = true;

		this.isTypeCollection = false;
		this.metamodelName = null;
		this.typeName = null;
		this.lazyRuleInfo = null;
		this.isAmbiguous = false;
		this.possibleReturnTypeInfos = null;
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
	 * Gets the type name.
	 * 
	 * @return the type name
	 */
	def String getTypeName() {
		return typeName;
	}

	/**
	 * Gets the transformed name.
	 * 
	 * @return the transformed name
	 */
	def String getTransformedName() {
		return '''«metamodelName».I«typeName»''';
	}

	/**
	 * Gets the value indicating if the type is a collection.
	 * 
	 * @return the value indicating if the type is a collection
	 */
	def Boolean getIsTypeCollection() {
		return isTypeCollection;
	}

	/**
	 * Sets the value indicating if the type is a collection.
	 * 
	 * @param isCollection
	 *            the new value indicating if the type is a collection
	 */
	def void setIsTypeCollection(boolean isCollection) {
		this.isTypeCollection = isCollection;
	}

	/**
	 * Gets the value indicating if the type is ambiguous.
	 * 
	 * @return the value indicating if the type is ambiguous
	 */
	def Boolean getIsAmbiguous() {
		return isAmbiguous;
	}

	/**
	 * Gets the value indicating if a lazy rule is called in the OCL expression.
	 * 
	 * @return the value indicating if a lazy rule is called in the OCL expression
	 */
	def Boolean getIsCallToLazyRule() {
		return lazyRuleInfo != null;
	}

	/**
	 * Gets the lazy rule info.
	 * 
	 * @return the lazy rule info
	 */
	def RuleInfo getLazyRuleInfo() {
		return lazyRuleInfo;
	}

	/**
	 * Gets the possible return type infos.
	 * 
	 * @return the possible return type infos
	 */
	def List<PossibleReturnTypeInfo> getPossibleReturnTypeInfos() {
		return possibleReturnTypeInfos;
	}

	/**
	 * Gets the value indicating if another output pattern element is used.
	 * 
	 * @return the value indicating if another output pattern element is used
	 */
	def Boolean getUsageOfAnotherOutputPatternElement() {
		return usageOfAnotherOutputPatternElement;
	}

	/**
	 * Sets the value indicating if another output pattern element is used.
	 * 
	 * @param isUsageOfAnotherOutputPatternElement
	 *            the new value indicating if another output pattern element is used
	 */
	def void setUsageOfAnotherOutputPatternElement(boolean isUsageOfAnotherOutputPatternElement) {
		this.usageOfAnotherOutputPatternElement = isUsageOfAnotherOutputPatternElement;
	}

	/**
	 * Gets the name of the referenced output pattern element.
	 * 
	 * @return the name of the referenced output pattern element
	 */
	def String getNameOfTheReferencedOutputPatternElement() {
		return nameOfTheReferencedOutputPatternElement;
	}

	/**
	 * Sets the name of the referenced output pattern element.
	 * 
	 * @param nameOfTheReferencedOutputPatternElement
	 *            the new name of the referenced output pattern element
	 */
	def void setNameOfTheReferencedOutputPatternElement(String nameOfTheReferencedOutputPatternElement) {
		this.nameOfTheReferencedOutputPatternElement = nameOfTheReferencedOutputPatternElement;
	}

	/**
	 * Gets the value indicating if the type is primitive.
	 * 
	 * @return the value indicating if the type is primitive
	 */
	def Boolean isTypePrimitive() {
		// primitive types are e.g. int, string, ...
		return isTypePrimitive;
	}
}
