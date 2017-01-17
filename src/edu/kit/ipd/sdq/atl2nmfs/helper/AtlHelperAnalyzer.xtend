package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Library
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The AtlHelperAnalyzer Interface.
 */
interface AtlHelperAnalyzer {

	/**
	 * Analyze the helpers of the ATL module and ATL libraries.
	 * 
	 * @param atlModule
	 *            the ATL module
	 * @param atlLibraries
	 *            the ATL libraries
	 */
	def void analyzeHelpers(Module atlModule, List<Library> atlLibraries);

	/**
	 * Checks if an attribute helper with the passed name exists.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the boolean indicating if an attribute helper with the passed name exists
	 */
	def Boolean isAttributeHelper(String helperName);

	/**
	 * Checks if a functional helper with the passed name exists.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the boolean indicating if a functional helper with the passed name exists
	 */
	def Boolean isFunctionalHelper(String helperName);

	/**
	 * Gets the functional helper info for the passed helper name.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the functional helper info
	 */
	def HelperInfo getFunctionalHelperInfo(String helperName);

	/**
	 * Gets the attribute helper info for the passes helper name.
	 * 
	 * @param helperName
	 *            the helper name
	 * @return the attribute helper info
	 */
	def HelperInfo getAttributeHelperInfo(String helperName);

	/**
	 * Gets the all the helper infos.
	 * 
	 * @return all the helper infos
	 */
	def List<HelperInfo> getAllHelperInfos();

}
