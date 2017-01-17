package edu.kit.ipd.sdq.atl2nmfs.utils;

import java.io.File
import java.io.FileNotFoundException

/**
 * The MsBuildUtils Class.
 */
class MsBuildUtils {

	/**
	 * Private Class constructor.
	 */
	private new() {}

	/**
	 * Builds the project with msbuild which path is passed.
	 *
	 * @param projectFilePath
	 *            the path to the project file which should be build
	 * @throws Exception
	 */
	public def static void build(String projectFilePath) throws Exception {
		// check if the file exists
		var projectfile = new File(projectFilePath);
		if (!projectfile.isFile()) {
			throw new FileNotFoundException("The project file " + projectFilePath + " was not found");
		}

		// create and start the msbuild process
		var msBuildProcessBuilder = new ProcessBuilder("msbuild", projectFilePath);

		// redirect the outputs to the default output of the current java
		// process (console in this case)
		msBuildProcessBuilder.inheritIO();
		var msBuildProcess = msBuildProcessBuilder.start();
		var returnValueMsBuild = msBuildProcess.waitFor();

		if (returnValueMsBuild != 0) {
			throw new IllegalArgumentException("MSBuild failed");
		}

		System.out.println("MSBuild finished successfully");
	}
}
