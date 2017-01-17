package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import java.io.File
import org.apache.commons.io.FilenameUtils
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer

/**
 * The MetamodelInfo Class.
 */
class MetamodelInfo {
	private final Atl2NmfSHelper atl2NmfSHelper;
	private final EcoreAnalyzer ecoreAnalyzer;

	private final String name;
	private final String path;
	private final String fileNameWithoutExtension;
	private final String nmfFileName

	/**
	 * Class constructor.
	 * 
	 * @param name
	 *            the name
	 * @param path
	 *            the path
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param ecoreAnalyzer
	 *            the ecore analyzer
	 */
	new(String name, String path, Atl2NmfSHelper atl2NmfSHelper, EcoreAnalyzer ecoreAnalyzer) {
		this.name = name;
		this.path = path;
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.ecoreAnalyzer = ecoreAnalyzer;

		var metamodelFile = new File(path);
		this.fileNameWithoutExtension = FilenameUtils.removeExtension(metamodelFile.name);
		this.nmfFileName = fileNameWithoutExtension + atl2NmfSHelper.nmfFilenameExtension;
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
	 * Gets the path.
	 * 
	 * @return the path
	 */
	def String getPath() {
		return path;
	}

	/**
	 * Gets the file name without extension.
	 * 
	 * @return the file name without extension
	 */
	def String getFileNameWithoutExtension() {
		return fileNameWithoutExtension;
	}

	/**
	 * Gets the nmf file name.
	 * 
	 * @return the nmf file name
	 */
	def String getNmfFileName() {
		return nmfFileName;
	}

	/**
	 * Gets the ns uri.
	 * 
	 * @return the ns uri
	 */
	def String getNsUri() {
		return ecoreAnalyzer.nsUri;
	}

	/**
	 * Gets the ecore analyzer.
	 * 
	 * @return the ecore analyzer
	 */
	def EcoreAnalyzer getEcoreAnalyzer() {
		return ecoreAnalyzer;
	}
}
