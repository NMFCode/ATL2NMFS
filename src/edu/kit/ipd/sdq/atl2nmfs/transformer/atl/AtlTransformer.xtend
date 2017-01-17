package edu.kit.ipd.sdq.atl2nmfs.transformer.atl;

import java.util.List;
import org.eclipse.m2m.atl.common.ATL.Library;
import org.eclipse.m2m.atl.common.ATL.Module;
import org.eclipse.xtext.generator.IFileSystemAccess;

/**
 * The AtlTransformer Interface.
 */
interface AtlTransformer {

	/**
	 * Initialize the ATL transformer.
	 * 
	 * @param fsa
	 *            the file system access
	 * @param atlModule
	 *            the ATL module
	 * @param atlLibraries
	 *            the ATL libraries
	 * @param inputMetamodelPaths
	 *            the input metamodel paths
	 * @param outputMetamodelPaths
	 *            the output metamodel paths
	 * @param useMemorizationForAttributeHelper
	 *            the value indicating if the memorization patter should be used for transformed attribute helper
	 */
	def void initialize(IFileSystemAccess fsa, Module atlModule, List<Library> atlLibraries,
		List<String> inputMetamodelPaths, List<String> outputMetamodelPaths, boolean useMemorizationForAttributeHelper);

	/**
	 * Creates the C sharp code.
	 * 
	 * @param outputPath
	 *            the output path
	 * @param projectFileName
	 *            the project file name
	 */
	def void createCSharpCode(String outputPath, String projectFileName);

}
