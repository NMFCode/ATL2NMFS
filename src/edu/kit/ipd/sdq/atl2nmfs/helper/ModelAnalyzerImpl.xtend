package edu.kit.ipd.sdq.atl2nmfs.helper

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ModelInfo
import java.util.ArrayList
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The ModelAnalyzerImpl Class.
 */
class ModelAnalyzerImpl implements ModelAnalyzer {
	private List<ModelInfo> inputModelInfos;
	private List<ModelInfo> outputModelInfos;

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.ModelAnalyzer#analyzeModels
	 */
	override void analyzeModels(Module atlModule) {
		// initialize input model infos
		inputModelInfos = new ArrayList<ModelInfo>();
		atlModule.inModels.forEach [ atlInputModel, index |
			val inputModelName = atlInputModel.name;
			val inputMetamodelName = atlInputModel.metamodel.name;

			var modelInfo = new ModelInfo(inputModelName, inputMetamodelName, true)
			inputModelInfos.add(modelInfo);
		]

		// initialize output model infos
		outputModelInfos = new ArrayList<ModelInfo>();
		atlModule.outModels.forEach [ atlOutputModel, index |
			val outputModelName = atlOutputModel.name;
			val outputMetamodelName = atlOutputModel.metamodel.name;

			var modelInfo = new ModelInfo(outputModelName, outputMetamodelName, false)
			outputModelInfos.add(modelInfo);
		]
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.ModelAnalyzer#getInputModelInfos
	 */
	override List<ModelInfo> getInputModelInfos() {
		return inputModelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.ModelAnalyzer#getOutputModelInfos
	 */
	override List<ModelInfo> getOutputModelInfos() {
		return outputModelInfos;
	}
}
