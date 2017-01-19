package edu.kit.ipd.sdq.atl2nmfs.tests;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;

import edu.kit.ipd.sdq.atl2nmfs.utils.MsBuildUtils;

/**
 * The BuildTests Class.
 */
public class BuildTests {

	/**
	 * Executes MsBuild.
	 *
	 * @param path
	 *            the path
	 * @param nameOfProgram
	 *            the name of program
	 */
	private void Build(String path, String nameOfProgram) {
		File projectFile = new File(path + "/" + nameOfProgram + ".csproj");
		Assert.assertTrue(projectFile.exists());

		// clean directory
		File binDirectory = new File(path + "/bin");
		File objDirectory = new File(path + "/obj");
		try {
			FileUtils.deleteDirectory(binDirectory);
			FileUtils.deleteDirectory(objDirectory);
		} catch (IOException e) {
			// cleaning failed
		}

		// check compiled file
		File executable = new File(path + "/bin/" + nameOfProgram + ".exe");
		Assert.assertFalse(executable.exists());

		try {
			MsBuildUtils.build(projectFile.getAbsolutePath());
		} catch (Exception exception) {
			Assert.fail("The MsBuild failed. Exception message: " + exception.getMessage());
		}

		// check compiled file
		Assert.assertTrue(executable.exists());
	}

	/**
	 * Hello world build test.
	 */
	@Test
	public void HelloWorldBuildTest() {
		String path = "resources/HelloWorldCode";
		String nameOfProgram = "program";

		Build(path, nameOfProgram);
	}

	/**
	 * Nmf synchronizations build test.
	 */
	@Test
	public void NmfSynchronizationsBuildTest() {
		String path = "resources/NmfSynchronizationsExampleCode";
		String nameOfProgram = "program";

		Build(path, nameOfProgram);
	}
}
