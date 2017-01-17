package edu.kit.ipd.sdq.atl2nmfs.transformer.atl

import com.google.inject.Inject
import java.io.File
import java.util.ArrayList
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Library
import org.eclipse.m2m.atl.common.ATL.Module
import org.eclipse.xtext.generator.IFileSystemAccess
import edu.kit.ipd.sdq.atl2nmfs.templates.AssemblyInfoTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.OutputModelCollectionClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.InputModelContainerClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.OutputModelContainerClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.ExtensionMethodClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.ReflectiveSynchronizationClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.MainClassTemplate
import edu.kit.ipd.sdq.atl2nmfs.templates.ProjectTemplate
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper

/**
 * The AtlTransformerImpl Class.
 */
class AtlTransformerImpl implements AtlTransformer {
	private final Atl2NmfSHelper atl2NmfSHelper;
	private final HelperTransformer helperTransformer;
	private final FilterTransformer filterTransformer;
	private final RuleTransformer ruleTransformer;

	private boolean useMemorizationForAttributeHelper;

	private List<String> fileList;
	private List<String> embeddedFileList;
	private IFileSystemAccess fsa;

	private Module atlModule;
	private List<Library> atlLibraries;
	private List<String> inputMetamodelPaths;
	private List<String> outputMetamodelPaths;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param helperTransformer
	 *            the helper transformer
	 * @param filterTransformer
	 *            the filter transformer
	 * @param ruleTransformer
	 *            the rule transformer
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper, HelperTransformer helperTransformer, FilterTransformer filterTransformer,
		RuleTransformer ruleTransformer) {
		this.atl2NmfSHelper = atl2NmfSHelper;
		this.helperTransformer = helperTransformer;
		this.filterTransformer = filterTransformer;
		this.ruleTransformer = ruleTransformer;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.AtlTransformer#initialize
	 */
	public override void initialize(IFileSystemAccess fsa, Module atlModule, List<Library> atlLibraries,
		List<String> inputMetamodelPaths, List<String> outputMetamodelPaths, boolean useMemorizationForAttributeHelper) {
		this.fsa = fsa;
		this.atlModule = atlModule;
		this.atlLibraries = atlLibraries;
		this.inputMetamodelPaths = inputMetamodelPaths;
		this.outputMetamodelPaths = outputMetamodelPaths;
		this.useMemorizationForAttributeHelper = useMemorizationForAttributeHelper;

		fileList = new ArrayList();
		embeddedFileList = new ArrayList();

		// initialize the helper class with the current transformation data
		atl2NmfSHelper.initializeNewTransformation(atlModule, atlLibraries, inputMetamodelPaths, outputMetamodelPaths);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.transformer.atl.AtlTransformer#createCSharpCode
	 */
	public override void createCSharpCode(String outputPath, String projectFileName) {
		// start the transformation
		transformEcoreMetamodels(outputPath);

		createAssemblyInfoFile();
		createOutputModelCollectionFile();
		createMainClass();
		createTransformationFiles();
		createProjectFile(projectFileName);
	}

	/**
	 * Transforms the ecore metamodels.
	 * 
	 * @param outputPath
	 *            the output path where the transformed ecore metamodels are saved
	 */
	private def void transformEcoreMetamodels(String outputPath) {
		val inputMetamodelInfos = atl2NmfSHelper.getInputMetamodelInfos();
		val outputMetamodelInfos = atl2NmfSHelper.getOutputMetamodelInfos()

		for (inputMetamodelInfo : inputMetamodelInfos) {
			transformEcoreMetamodel(inputMetamodelInfo, outputPath);
		}

		for (outputMetamodelInfo : outputMetamodelInfos) {
			// if one of the output metamodels was also used as input metamodel 
			// we don't have to transform it again since we can reuse it.
			if (!inputMetamodelInfos.exists[it.path.equals(outputMetamodelInfo.path)]) {
				transformEcoreMetamodel(outputMetamodelInfo, outputPath);
			}
		}
	}

	/**
	 * Transforms an ecore metamodel.
	 * 
	 * @param metamodelInfo
	 *            the metamodel info
	 * @param outputPath
	 *            the output path where the transformed ecore metamodel is saved
	 */
	private def void transformEcoreMetamodel(MetamodelInfo metamodelInfo, String outputPath) {
		var nmfMetamodelCodePath = outputPath + "/" + metamodelInfo.fileNameWithoutExtension +
			atl2NmfSHelper.getCSharpFilenameExtension;
		var nmfMetamodelPath = outputPath + "/" + metamodelInfo.fileNameWithoutExtension +
			atl2NmfSHelper.nmfFilenameExtension;

		// create and start the ecore2code process
		var ecore2CodeProcessBuilder = new ProcessBuilder("resources/Ecore2Code/Ecore2Code", "-n",
			atl2NmfSHelper.projectNamespace, "-o", nmfMetamodelCodePath, "-m", nmfMetamodelPath, metamodelInfo.path);

		// redirect the outputs to the default output of the current java process (console in this case)
		ecore2CodeProcessBuilder.inheritIO();

		var ecore2CodeProcess = ecore2CodeProcessBuilder.start();
		var returnValueEcore2Code = ecore2CodeProcess.waitFor();
		if (returnValueEcore2Code != 0) {
			throw new IllegalArgumentException("Ecore2Code failed while transforming " +
				metamodelInfo.fileNameWithoutExtension);
		}

		// register the created files
		fileList.add(metamodelInfo.fileNameWithoutExtension + atl2NmfSHelper.getCSharpFilenameExtension);
		embeddedFileList.add(metamodelInfo.fileNameWithoutExtension + atl2NmfSHelper.nmfFilenameExtension);
	}

	/**
	 * Creates the assembly info file.
	 */
	private def void createAssemblyInfoFile() {
		val inputMetamodelInfos = atl2NmfSHelper.getInputMetamodelInfos();
		var outputMetamodelInfos = atl2NmfSHelper.getOutputMetamodelInfos()

		// if one of the outputMetamodel paths is equal to one of the inputMetamodel paths 
		// both MM are equal and hence we must register the MM only once
		var combinedMetamodelInfos = new ArrayList<MetamodelInfo>(inputMetamodelInfos);
		combinedMetamodelInfos.addAll(outputMetamodelInfos.filter [ output |
			!inputMetamodelInfos.exists [ input |
				input.path.equals(output.path)
			]
		])

		var assemblyInfoFileCode = AssemblyInfoTemplate.createCode(atl2NmfSHelper.transformationName,
			combinedMetamodelInfos, atl2NmfSHelper.projectNamespace);

		var assemblyInfoFileName = new File("Properties/AssemblyInfo" + atl2NmfSHelper.getCSharpFilenameExtension);
		fsa.generateFile(assemblyInfoFileName.path, assemblyInfoFileCode);
		fileList.add(assemblyInfoFileName.path);
	}

	/**
	 * Creates the output model collection file.
	 */
	private def void createOutputModelCollectionFile() {
		var outputModelCollectionFileCode = OutputModelCollectionClassTemplate.createCode(
			atl2NmfSHelper.projectNamespace, atl2NmfSHelper.outputModelCollectionClassName);

		var outputModelCollectionFileName = atl2NmfSHelper.outputModelCollectionClassName +
			atl2NmfSHelper.getCSharpFilenameExtension;
		fsa.generateFile(outputModelCollectionFileName, outputModelCollectionFileCode);
		fileList.add(outputModelCollectionFileName);
	}

	/**
	 * Creates the transformation files.
	 */
	private def void createTransformationFiles() {
		// create the input model container
		var inputModelInfos = atl2NmfSHelper.inputModelInfos;
		var inputModelContainerCode = InputModelContainerClassTemplate.createCode(atl2NmfSHelper.projectNamespace,
			atl2NmfSHelper.inputModelContainerClassName,
			inputModelInfos);
		var inputModelContainerFileName = atl2NmfSHelper.inputModelContainerClassName +
			atl2NmfSHelper.getCSharpFilenameExtension;
		fsa.generateFile(inputModelContainerFileName, inputModelContainerCode);
		fileList.add(inputModelContainerFileName);

		// create the output model container
		var outputModelInfos = atl2NmfSHelper.outputModelInfos;
		var outputModelContainerCode = OutputModelContainerClassTemplate.createCode(atl2NmfSHelper.projectNamespace,
			atl2NmfSHelper.outputModelContainerClassName,
			outputModelInfos);
		var outputModelContainerFileName = atl2NmfSHelper.outputModelContainerClassName +
			atl2NmfSHelper.getCSharpFilenameExtension;
		fsa.generateFile(outputModelContainerFileName, outputModelContainerCode);
		fileList.add(outputModelContainerFileName);

		// transform helpers
		var helperClassName = atl2NmfSHelper.helperClassName;
		var helperCodeList = new ArrayList<String>();
		var helperProxiesCodeList = new ArrayList<String>();
		helperTransformer.transformHelpers(helperCodeList, helperProxiesCodeList, useMemorizationForAttributeHelper);

		if (helperCodeList.size != 0) {
			var helperClassCode = ExtensionMethodClassTemplate.createCode(atl2NmfSHelper.projectNamespace,
				helperClassName, helperCodeList, helperProxiesCodeList);
			var helperFileName = helperClassName + atl2NmfSHelper.getCSharpFilenameExtension;
			fsa.generateFile(helperFileName, helperClassCode);
			fileList.add(helperFileName);
		}

		// transform filters
		var filterClassName = atl2NmfSHelper.filterClassName;
		var filterCodeList = new ArrayList<String>();
		var filterProxiesCodeList = new ArrayList<String>();
		filterTransformer.transformFilters(filterCodeList, filterProxiesCodeList)

		if (filterCodeList.size != 0) {
			var filterClassCode = ExtensionMethodClassTemplate.createCode(atl2NmfSHelper.projectNamespace,
				filterClassName, filterCodeList, filterProxiesCodeList);
			var filterFileName = filterClassName + atl2NmfSHelper.getCSharpFilenameExtension;
			fsa.generateFile(filterFileName, filterClassCode);
			fileList.add(filterFileName);
		}

		// transform matched rules
		var ruleCodeList = new ArrayList<String>();
		ruleTransformer.transformMatchedRules(ruleCodeList);
		var transformationFileCode = ReflectiveSynchronizationClassTemplate.createCode(
			atl2NmfSHelper.transformationName, atl2NmfSHelper.inputModelContainerClassName,
			atl2NmfSHelper.outputModelContainerClassName, atl2NmfSHelper.projectNamespace, ruleCodeList);
		var transformationFileName = atl2NmfSHelper.transformationName + atl2NmfSHelper.getCSharpFilenameExtension;
		fsa.generateFile(transformationFileName, transformationFileCode);
		fileList.add(transformationFileName);
	}

	/**
	 * Creates the main class.
	 */
	private def void createMainClass() {
		var inputModelInfos = atl2NmfSHelper.inputModelInfos;
		var outputModelInfos = atl2NmfSHelper.outputModelInfos;

		var mainClassCode = MainClassTemplate.createCode(atl2NmfSHelper.transformationName,
			atl2NmfSHelper.mainClassName, atl2NmfSHelper.mainRuleName, atl2NmfSHelper.inputModelContainerClassName,
			atl2NmfSHelper.outputModelContainerClassName, atl2NmfSHelper.projectNamespace, inputModelInfos,
			outputModelInfos);
			var mainClassFileName = atl2NmfSHelper.mainClassName + atl2NmfSHelper.getCSharpFilenameExtension;
			fsa.generateFile(mainClassFileName, mainClassCode);
			fileList.add(mainClassFileName);
		}

	/**
	 * Creates the project file.
	 * 
	 * @param projectFileName
	 *            the name of the project file
	 */
	private def void createProjectFile(String projectFileName) {
		var projectFileCode = ProjectTemplate.createCode(fileList, embeddedFileList,
			atl2NmfSHelper.projectNamespace, atl2NmfSHelper.transformationName);
		fsa.generateFile(projectFileName, projectFileCode);
	}
}
	