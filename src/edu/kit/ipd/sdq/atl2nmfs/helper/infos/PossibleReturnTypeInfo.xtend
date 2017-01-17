package edu.kit.ipd.sdq.atl2nmfs.helper.infos

/**
 * The PossibleReturnTypeInfo Class.
 * This class holds all information which is needed to solve ambiguous return type conflicts
 * which can happen since ATL allows access to features of sub types which are not
 * declared in the static type of the element
 */
class PossibleReturnTypeInfo {

	private final String metamodelName;

	// the name of the possible return type
	private final String typeName;

	// the name of the classifier which contains a property with the name of the ambiguous property that is called 
	private final String ambiguousClassifierName;

	/**
	 * Class constructor.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param typeName
	 *            the type name
	 * @param ambiguousClassifierName
	 *            the ambiguous classifier name
	 */
	new(String metamodelName, String typeName, String ambiguousClassifierName) {
		this.metamodelName = metamodelName;
		this.typeName = typeName;
		this.ambiguousClassifierName = ambiguousClassifierName;
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
	 * Gets the metamodel name.
	 * 
	 * @return the metamodel name
	 */
	def String getMetamodelName() {
		return metamodelName;
	}

	/**
	 * Gets the ambiguous classifier name.
	 * 
	 * @return the ambiguous classifier name
	 */
	def String getAmbiguousClassifierName() {
		return ambiguousClassifierName;
	}
}
