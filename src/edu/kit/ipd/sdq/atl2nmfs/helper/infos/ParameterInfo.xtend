package edu.kit.ipd.sdq.atl2nmfs.helper.infos

/**
 * The ParameterInfo Class.
 */
class ParameterInfo {
	private final String name;
	private final String transformedType;

	/**
	 * Class constructor.
	 * 
	 * @param name
	 *            the name
	 * @param transformedType
	 *            the transformed type
	 */
	new(String name, String transformedType) {
		this.name = name;
		this.transformedType = transformedType;
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
	 * Gets the transformed type.
	 * 
	 * @return the transformed type
	 */
	def String getTransformedType() {
		return transformedType;
	}
}
