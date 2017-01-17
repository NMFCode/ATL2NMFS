package edu.kit.ipd.sdq.atl2nmfs;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.eclipse.m2m.atl.common.ATL.Library;
import org.eclipse.m2m.atl.common.ATL.LibraryRef;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;

import com.google.inject.Guice;
import com.google.inject.Injector;

import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.AtlTransformer;
import edu.kit.ipd.sdq.atl2nmfs.utils.AtlParserUtils;

/**
 * The Atl2NmfSynchronizations Class.
 */
class Atl2NmfSynchronizations {

	private final Injector injector;
	private final JavaIoFileSystemAccess fileSystemAccess;
	private final AtlTransformer atlTransformer;

	/**
	 * Class constructor.
	 */
	public new() {
		// initialize file system access
		fileSystemAccess = new JavaIoFileSystemAccess();
		injector = Guice.createInjector(new Atl2NmfSynchronizationsModule(), new EncodingProviderModule());

		injector.injectMembers(fileSystemAccess);
		atlTransformer = injector.getInstance(AtlTransformer);
	}

	/**
	 * Generates the NMF S. code for the passed ATL transformation.
	 *
	 * @param transformationName
	 *            the transformation name
	 * @param transformationFilePath
	 *            the path to the transformation file
	 * @param outputPath
	 *            the output path
	 * @param inputMetamodelPaths
	 *            the paths to the input metamodels
	 * @param outputMetamodelPaths
	 *            the paths to the output metamodels
	 * @param useMemorizationForAttributeHelper
	 *            the value indicating if the memorization patter should be used for transformed attribute helper
	 * @throws Exception
	 */
	public def void doGenerate(String transformationName, String transformationFilePath, String outputPath,
			List<String> inputMetamodelPaths, List<String> outputMetamodelPaths, boolean useMemorizationForAttributeHelper) throws Exception {

		// check if the file exist
		var transformationFile = new File(transformationFilePath);
		if (!transformationFile.isFile()) {
			throw new FileNotFoundException("The transformation file " + transformationFilePath + " was not found");
		}

		// parse the transformation file
		var parsedAtlModule = AtlParserUtils.parseModule(transformationFile.getAbsolutePath());

		// check if libraries exists and parse them if existing
		var parsedAtlLibraries = new ArrayList<Library>();
		var atlLibraries = parsedAtlModule.getLibraries();
		if (atlLibraries.size() > 0) {
			var transformationDirectory = transformationFile.getParentFile();

			for (LibraryRef library : atlLibraries) {
				var libraryFile = new File(transformationDirectory + "/" + library.getName() + ".atl");
				if (!libraryFile.isFile()) {
					throw new FileNotFoundException("The referenced library file '" + library.getName()
							+ ".atl' was not found. Does the file have this name and is in the same directory as the transformation file?");
				}

				var parsedAtlLibrary = AtlParserUtils.parseLibrary(libraryFile.getAbsolutePath());
				parsedAtlLibraries.add(parsedAtlLibrary);
			}
		}

		// TODO: analyze ATL transformation and check if all the used ATL
		// constructs are supported by the Atl2NmfS HOT

		// copy the required files into the output directory
		FileUtils.copyDirectory(new File("resources/Libs"), new File(outputPath + "/Libs"));

		// initialize and run the higher-order transformation
		fileSystemAccess.setOutputPath(outputPath);
		atlTransformer.initialize(fileSystemAccess, parsedAtlModule, parsedAtlLibraries, inputMetamodelPaths,
				outputMetamodelPaths, useMemorizationForAttributeHelper);

		var projectFileName = transformationName + ".csproj";
		atlTransformer.createCSharpCode(outputPath, projectFileName);
	}
}
