package edu.kit.ipd.sdq.atl2nmfs.utils

import java.io.File
import java.io.FileNotFoundException
import java.util.List
import java.util.ArrayList

/**
 * The ExecutionUtils Class.
 */
class ExecutionUtils {
	
	/**
	 * Private Class constructor.
	 */
	private new() {}

	/**
	 * Executes the executable file which path is passed.
	 *
	 * @param executableFilePath
	 *            the path of the executable file which should be executed
	 * @param inputModelPaths
	 *            the input model paths
	 * @param outputModelPaths
	 *            the output model paths
	 * @throws Exception
	 *             the exception
	 */
	public def static void execute(String executableFilePath, String outputPath, List<String> inputModelPaths,
			List<String> outputModelPaths) throws Exception {
		// check if the executable file exists
		var executableFile = new File(executableFilePath);
		if (!executableFile.isFile()) {
			throw new FileNotFoundException("The file " + executableFilePath + " was not found");
		}

		//prepare the parameters
		var absoluteModelPaths = new ArrayList<String>();
		for (String inputModelPath : inputModelPaths) {
			var inputModel = new File(inputModelPath);
			absoluteModelPaths.add(inputModel.absolutePath);
		}
		for (String outputModelPath : outputModelPaths) {
			var outputModel = new File(outputModelPath);
			absoluteModelPaths.add(outputModel.absolutePath);
		}
		var parameters = '''«FOR absoluteModelPath : absoluteModelPaths SEPARATOR " "»"«absoluteModelPath»"«ENDFOR»''';

		// start the compiled program
		var processBuilder = new ProcessBuilder(executableFilePath, parameters);
		processBuilder.inheritIO();
		var process = processBuilder.start();
		var returnValue = process.waitFor();
		if (returnValue != 0) {
			throw new IllegalArgumentException("Execution of program failed");
		}

		System.out.println("Execution of program finished successfully");
	}
}