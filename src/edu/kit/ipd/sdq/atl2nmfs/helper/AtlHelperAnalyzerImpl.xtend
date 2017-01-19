package edu.kit.ipd.sdq.atl2nmfs.helper

import com.google.inject.Inject
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperType
import java.util.ArrayList
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Helper
import org.eclipse.m2m.atl.common.ATL.Library
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The AtlHelperAnalyzerImpl Class.
 */
class AtlHelperAnalyzerImpl implements AtlHelperAnalyzer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	private ArrayList<HelperInfo> helperInfos;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper) {
		this.atl2NmfSHelper = atl2NmfSHelper;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#analyzeHelpers
	 */
	override void analyzeHelpers(Module atlModule, List<Library> atlLibraries) {
		// The helpers must be extracted and registered. Both types of helpers are mapped to
		// C# extension methods. Hence they must be used as an operation in the C# code.
		// Through registering the helpers they can be identified as helper and their calls can be transformed into a operation call	
		helperInfos = new ArrayList<HelperInfo>();

		analyzeAtlModule(atlModule);
		analyzeAtlLibraries(atlLibraries);
	}

	/**
	 * Analyze atl module.
	 * 
	 * @param atlModule
	 *            the atl module
	 */
	def private void analyzeAtlModule(Module atlModule) {
		// retrieve the helpers
		for (element : atlModule.elements) {
			if (element instanceof Helper) {
				createHelperInfo(element);
			}
		}
	}

	/**
	 * Analyze atl libraries.
	 * 
	 * @param atlLibraries
	 *            the atl libraries
	 */
	def private void analyzeAtlLibraries(List<Library> atlLibraries) {
		// retrieve the helpers
		for (library : atlLibraries) {
			for (helper : library.helpers) {
				createHelperInfo(helper);
			}
		}
	}

	/**
	 * Creates helper info for the passed helper.
	 * 
	 * @param helper
	 *            the helper
	 */
	def private void createHelperInfo(Helper helper) {
		var definition = helper.definition;
		helperInfos.add(new HelperInfo(atl2NmfSHelper, definition))
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#isAttributeHelper
	 */
	override public Boolean isAttributeHelper(String helperName) {
		return helperInfos.exists[it.helperType == HelperType.ATTRIBUTE && it.name == helperName];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#isFunctionalHelper
	 */
	override public Boolean isFunctionalHelper(String helperName) {
		return helperInfos.exists[it.helperType == HelperType.FUNCTIONAL && it.name == helperName];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#getFunctionalHelperInfo
	 */
	override public HelperInfo getFunctionalHelperInfo(String helperName) {
		return helperInfos.findFirst[it.helperType == HelperType.FUNCTIONAL && it.name == helperName];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#getAttributeHelperInfog)
	 */
	override public HelperInfo getAttributeHelperInfo(String helperName) {
		return helperInfos.findFirst[it.helperType == HelperType.ATTRIBUTE && it.name == helperName];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer#getAllHelperInfos
	 */
	override public List<HelperInfo> getAllHelperInfos() {
		return helperInfos;
	}
}
