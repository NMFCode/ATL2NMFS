package edu.kit.ipd.sdq.atl2nmfs.utils

import org.xmlunit.builder.Input
import org.xmlunit.builder.DiffBuilder
import java.io.FileNotFoundException
import java.io.File

/**
 * The XmiComparer Class.
 */
class XmiComparer {
	
	/**
	 * Private Class constructor.
	 */
	private new() {}
	
	/**
	 * Compares to xmi models to determine if they are equal or not.
	 *
	 * @param path1
	 *            the path to the first xmi file
	 * @param path2
	 *            the path to the second xmi file
	 * @return the value indicating if the two xmi models are equal or not
	 * @throws Exception
	 */
	public def static boolean checkForEquality(String firstPath, String secondPath) throws Exception {
		// check if the file exists
		var firstXmi = new File(firstPath);
		var secondXmi = new File(secondPath);
		if (!firstXmi.isFile()) {
			throw new FileNotFoundException("The first xmi file " + firstPath + " was not found");
		}	
		if (!secondXmi.isFile()) {
			throw new FileNotFoundException("The second xmi file " + secondPath + " was not found");
		}		
		
		// Remark: the attribute order is always ignored
		var diff = DiffBuilder.compare(Input.fromFile(firstPath))
	              .withTest(Input.fromFile(secondPath))
			      .withDifferenceEvaluator(new AttributeIgnorer())
			      .ignoreWhitespace()
			      .ignoreComments()
			      .checkForIdentical()
			      .build();

		var result = diff.hasDifferences();
		return !result;
	}
}