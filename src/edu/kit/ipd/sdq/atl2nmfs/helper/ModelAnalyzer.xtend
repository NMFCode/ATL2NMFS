package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ModelInfo
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The ModelAnalyzer Interface.
 */
interface ModelAnalyzer {

	/**
	 * Analyze models.
	 * 
	 * @param atlModule
	 *            the ATL module
	 */
	def void analyzeModels(Module atlModule);

	/**
	 * Gets the input model infos.
	 * 
	 * @return the input model infos
	 */
	def List<ModelInfo> getInputModelInfos();

	/**
	 * Gets the output model infos.
	 * 
	 * @return the output model infos
	 */
	def List<ModelInfo> getOutputModelInfos();

}
