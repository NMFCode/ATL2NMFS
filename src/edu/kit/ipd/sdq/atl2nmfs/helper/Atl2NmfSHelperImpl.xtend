package edu.kit.ipd.sdq.atl2nmfs.helper

import com.google.inject.Inject
import java.util.List
import org.eclipse.m2m.atl.common.ATL.Library
import org.eclipse.m2m.atl.common.ATL.Module
import org.eclipse.m2m.atl.common.OCL.OclExpression
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclTransformer
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ModelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.PossibleReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.HelperInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo

/**
 * The Atl2NmfSHelperImpl Class.
 */
public class Atl2NmfSHelperImpl implements Atl2NmfSHelper {
	private final MetamodelAnalyzer metamodelAnalyzer;
	private final ModelAnalyzer modelAnalyzer;
	private final AtlHelperAnalyzer atlHelperAnalyzer;
	private final AtlRuleAnalyzer atlRuleAnalyzer;
	private final OclReturnTypeAnalyzer oclReturnTypeAnalyzer;
	private final OclTransformer oclTransformer;
	private final TargetPatternElementAnalyzer targetPatternElementAnalyzer;

	private static final String CSHARPFILENAMEEXTENSION = ".cs";
	private static final String NMFFILENAMEEXTENSION = ".nmf";
	private static final String MAINRULENAME = "Model2ModelMainRule";
	private static final String OUTPUTMODELCOLLECTIONCLASSNAME = "OutputModelCollection";
	private static final String INPUTMODELCONTAINERCLASSNAME = "InputModelContainer";
	private static final String OUTPUTMODELCONTAINERCLASSNAME = "OutputModelContainer";
	private static final String HELPERCLASSNAME = "HelperExtensionMethods";
	private static final String FILTERCLASSNAME = "FilterExtensionMethods";
	private static final String FILTERNAMEEXTENSION = "Filter";
	private static final String MAINCLASSNAME = "Program";
	private static final String NAMESPACEEXTENSION = "Namespace";

	private String transformationName;

	/**
	 * Class constructor.
	 * 
	 * @param metamodelAnalyzer
	 *            the metamodel analyzer
	 * @param modelAnalyzer
	 *            the model analyzer
	 * @param atlHelperAnalyzer
	 *            the ATL helper analyzer
	 * @param atlRuleAnalyzer
	 *            the ATL rule analyzer
	 * @param oclReturnTypeAnalyzer
	 *            the OCL return type analyzer
	 * @param oclTransformer
	 *            the OCL transformer
	 */
	@Inject
	new(MetamodelAnalyzer metamodelAnalyzer, ModelAnalyzer modelAnalyzer, AtlHelperAnalyzer atlHelperAnalyzer,
		AtlRuleAnalyzer atlRuleAnalyzer, OclReturnTypeAnalyzer oclReturnTypeAnalyzer, OclTransformer oclTransformer,
		TargetPatternElementAnalyzer targetPatternElementAnalyzer) {
		this.metamodelAnalyzer = metamodelAnalyzer;
		this.modelAnalyzer = modelAnalyzer;
		this.atlHelperAnalyzer = atlHelperAnalyzer;
		this.atlRuleAnalyzer = atlRuleAnalyzer;
		this.oclReturnTypeAnalyzer = oclReturnTypeAnalyzer;
		this.oclTransformer = oclTransformer;
		this.targetPatternElementAnalyzer = targetPatternElementAnalyzer;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#initializeNewTransformation
	 */
	override void initializeNewTransformation(Module atlModule, List<Library> atlLibraries,
		List<String> inputMetamodelPaths, List<String> outputMetamodelPaths) {
		this.transformationName = atlModule.name;

		metamodelAnalyzer.analyzeMetamodels(atlModule, inputMetamodelPaths, outputMetamodelPaths);
		oclReturnTypeAnalyzer.initialize(metamodelAnalyzer.inputMetamodelInfos);
		modelAnalyzer.analyzeModels(atlModule);
		atlHelperAnalyzer.analyzeHelpers(atlModule, atlLibraries);
		atlRuleAnalyzer.analyzeRules(atlModule);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getTransformationName
	 */
	override String getTransformationName() {
		return transformationName;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getMainRuleName
	 */
	override String getMainRuleName() {
		return MAINRULENAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getCSharpFilenameExtension
	 */
	override String getCSharpFilenameExtension() {
		return CSHARPFILENAMEEXTENSION;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getNmfFilenameExtension
	 */
	override String getNmfFilenameExtension() {
		return NMFFILENAMEEXTENSION;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getOutputModelCollectionClassName
	 */
	override String getOutputModelCollectionClassName() {
		return OUTPUTMODELCOLLECTIONCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getInputModelContainerClassName
	 */
	override String getInputModelContainerClassName() {
		return INPUTMODELCONTAINERCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getOutputModelContainerClassName
	 */
	override String getOutputModelContainerClassName() {
		return OUTPUTMODELCONTAINERCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getHelperClassName
	 */
	override String getHelperClassName() {
		return HELPERCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getFilterClassName
	 */
	override String getFilterClassName() {
		return FILTERCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getFilterNameExtension
	 */
	override String getFilterNameExtension() {
		return FILTERNAMEEXTENSION;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getMainClassName
	 */
	override String getMainClassName() {
		return MAINCLASSNAME;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getProjectNamespace
	 */
	override String getProjectNamespace() {
		return transformationName + NAMESPACEEXTENSION;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getInputModelInfos
	 */
	override List<ModelInfo> getInputModelInfos() {
		return modelAnalyzer.inputModelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getOutputModelInfos
	 */
	override List<ModelInfo> getOutputModelInfos() {
		return modelAnalyzer.outputModelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getReturnTypeInfoFromOutputMetamodel
	 */
	override ReturnTypeInfo getReturnTypeInfoFromOutputMetamodel(String metamodelName, String classifierName,
		String featureName) {
		return metamodelAnalyzer.getReturnTypeInfoFromOutputMetamodel(metamodelName, classifierName, featureName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getAllPossibleInputMMTypeInfosThatContainFeatureWithType
	 */
	override List<TypeInfo> getAllPossibleInputMMTypeInfosThatContainFeatureWithType(
		ReturnTypeInfo sourceReturnTypeInfo) {
		return metamodelAnalyzer.getAllPossibleInputMMTypeInfosThatContainFeatureWithType(sourceReturnTypeInfo);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#findLowestCommonSuperTypeInfoInInputMetamodel
	 */
	override TypeInfo findLowestCommonSuperTypeInfoInInputMetamodel(String firstMetamodelName, String firstTypeName,
		String secondMetamodelName, String secondTypeName) {
		return metamodelAnalyzer.findLowestCommonSuperTypeInfoInInputMetamodel(firstMetamodelName, firstTypeName,
			secondMetamodelName, secondTypeName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getRequiredRuleInfos
	 */
	override List<RuleInfo> getRequiredRuleInfos(String inputMetamodelName, String inputTypeName,
		String outputMetamodelName, String outputTypeName) {
		return metamodelAnalyzer.getRequiredRuleInfos(inputMetamodelName, inputTypeName, outputMetamodelName,
			outputTypeName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getInputMetamodelInfos
	 */
	override List<MetamodelInfo> getInputMetamodelInfos() {
		return metamodelAnalyzer.inputMetamodelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getOutputMetamodelInfos
	 */
	override List<MetamodelInfo> getOutputMetamodelInfos() {
		return metamodelAnalyzer.outputMetamodelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#transformExpression
	 */
	override String transformExpression(OclExpression expression) {
		return oclTransformer.transformExpression(expression);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#transformExpressionWithAmbiguousCall
	 */
	override String transformExpressionWithAmbiguousCall(OclExpression expression,
		PossibleReturnTypeInfo possibleReturnTypeInfo) {
		return oclTransformer.transformExpressionWithAmbiguousCall(expression, possibleReturnTypeInfo);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getAllRuleInfos
	 */
	override List<RuleInfo> getAllRuleInfos() {
		return atlRuleAnalyzer.getAllRuleInfos();
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getRuleInfo
	 */
	override RuleInfo getRuleInfo(String ruleName) {
		return atlRuleAnalyzer.getRuleInfo(ruleName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getPossibleRuleInfosForInputTypeInfo
	 */
	override List<RuleInfo> getPossibleRuleInfosForInputTypeInfo(TypeInfo inputTypeInfo) {
		return atlRuleAnalyzer.getPossibleRuleInfosForInputTypeInfo(inputTypeInfo);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#isLazyRule(java.lang.String)
	 */
	override Boolean isLazyRule(String ruleName) {
		return atlRuleAnalyzer.isLazyRule(ruleName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#checkAndInitializeTargetPatternElementReferences
	 */
	override void checkAndInitializeTargetPatternElementReferences(RuleInfo ruleInfo) {
		targetPatternElementAnalyzer.checkAndInitializeTargetPatternElementReferences(ruleInfo);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getReturnTypeInfoOfOclExpression
	 */
	override ReturnTypeInfo getReturnTypeInfoOfOclExpression(OclExpression expression) {
		return oclReturnTypeAnalyzer.getReturnTypeInfo(expression);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#isAttributeHelper
	 */
	override Boolean isAttributeHelper(String helperName) {
		return atlHelperAnalyzer.isAttributeHelper(helperName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getAttributeHelperInfo
	 */
	override HelperInfo getAttributeHelperInfo(String helperName) {
		return atlHelperAnalyzer.getAttributeHelperInfo(helperName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#isFunctionalHelper
	 */
	override Boolean isFunctionalHelper(String helperName) {
		return atlHelperAnalyzer.isFunctionalHelper(helperName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getFunctionalHelperInfo
	 */
	override HelperInfo getFunctionalHelperInfo(String helperName) {
		return atlHelperAnalyzer.getFunctionalHelperInfo(helperName);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper#getAllHelperInfos
	 */
	override public List<HelperInfo> getAllHelperInfos() {
		return atlHelperAnalyzer.getAllHelperInfos();
	}
	
}
