package edu.kit.ipd.sdq.atl2nmfs.helper.infos

/**
 * The ModelInfo Class.
 */
class ModelInfo {
	private final String name;
	private final Boolean isInputModel;
	private final String metamodelName;

	/**
	 * Class constructor.
	 * 
	 * @param name
	 *            the name
	 * @param metamodelName
	 *            the metamodel name
	 * @param isInputModel
	 *            the value indicating if this is an input model
	 */
	new(String name, String metamodelName, Boolean isInputModel) {
		this.name = name;
		this.metamodelName = metamodelName;
		this.isInputModel = isInputModel;
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
	 * Gets the value indicating if this is an input model.
	 * 
	 * @return the value indicating if this is an input model
	 */
	def Boolean isInputModel() {
		return isInputModel;
	}

	/**
	 * Gets the metamodel name.
	 * 
	 * @return the metamodel name
	 */
	def String getMetamodelName() {
		return metamodelName;
	}
}
