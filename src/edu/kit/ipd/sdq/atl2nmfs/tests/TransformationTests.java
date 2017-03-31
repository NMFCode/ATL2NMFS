package edu.kit.ipd.sdq.atl2nmfs.tests;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import edu.kit.ipd.sdq.atl2nmfs.Atl2NmfSynchronizations;
import edu.kit.ipd.sdq.atl2nmfs.utils.MsBuildUtils;
import edu.kit.ipd.sdq.atl2nmfs.utils.XmiComparer;
import edu.kit.ipd.sdq.atl2nmfs.utils.ExecutionUtils;

/**
 * The TransformationTests Class.
 */
public class TransformationTests {

	/**
	 * Generate the NMF Synchronization code by executing the Atl2NmfS HOT,
	 * build and execute the created code.
	 *
	 * @param transformationName
	 *            the transformation name
	 * @param transformationPath
	 *            the transformation path
	 * @param outputPath
	 *            the output path
	 * @param inputMetamodelPaths
	 *            the input metamodel paths
	 * @param outputMetamodelPaths
	 *            the output metamodel paths
	 * @param inputModelPaths
	 *            the input model paths
	 * @param outputModelFileNames
	 *            the output model file names
	 */
	private void GenerateBuildExecute(String transformationName, String transformationPath, String outputPath,
			List<String> inputMetamodelPaths, List<String> outputMetamodelPaths, List<String> inputModelPaths,
			List<String> outputModelFileNames) {
		// execute the Atl2NmfS HOT
		try {
			Atl2NmfSynchronizations atl2NmfSynchronizations = new Atl2NmfSynchronizations();
			atl2NmfSynchronizations.doGenerate(transformationName, transformationPath, outputPath, inputMetamodelPaths,
					outputMetamodelPaths, false, false);
		} catch (Exception exception) {
			Assert.fail("Execution of the Atl2NmfS HOT failed. Exception message: " + exception.getMessage());
		}

		// build the created code of the Atl2NmfS HOT
		try {
			//in our test cases the project file path is a combination of the output path and the transformation name
			String projectFilePath = outputPath + "/" + transformationName + ".csproj";	
			MsBuildUtils.build(projectFilePath);
		} catch (Exception exception) {
			Assert.fail("Execution of MsBuild failed. Exception message: " + exception.getMessage());
		}
		
		//in these tests the output models do not exist yet. The synchronization will create them.
		//Therefore we create the paths where they should be created
		ArrayList<String> outputModelPaths = new ArrayList<String>();
		for(String outputModelFileName : outputModelFileNames) {
			outputModelPaths.add(outputPath + "/bin/" + outputModelFileName);
		}
		
		// execute the build code
		try {
			//in our test cases the executable file path is in the bin folder of the output path
			String executableFilePath = outputPath + "/bin/" + transformationName + ".exe";	
			ExecutionUtils.execute(executableFilePath, outputPath, inputModelPaths, outputModelPaths);
		} catch (Exception exception) {
			Assert.fail("Execution of the NMF Synchronizations failed. Exception message: " + exception.getMessage());
		}
		
		//check if all output models are created by the synchronization
		for(String outputModelPath : outputModelPaths) {
			Assert.assertTrue("One of the expected models wasn't created", new File(outputModelPath).exists());
		}
	}
	
	/**
	 * Checks the expected and create model for equality.,
	 *
	 * @param expectedModelPath
	 *            the path of the expected model
	 * @param createdModelPath
	 *            the path of the created model
	 */
	private void CheckModelsForEquality(String expectedModelPath, String createdModelPath) {
		boolean result = false;
		try {
			result = XmiComparer.checkForEquality(expectedModelPath, createdModelPath);
		} catch (Exception exception) {
			Assert.fail("One of the models couldn't be found. Exception message: " + exception.getMessage());
		}
		
		Assert.assertTrue("The created model is not identical with the expected model", result);
	}

	/**
	 * Families 2 persons with library test.
	 */
	@Test
	public void Families2PersonsWithLibraryTest() {
		String transformationName = "Families2PersonsWithLibrary";
		String transformationPath = "resources/Families2PersonsWithLibrary/Families2PersonsWithLibrary.atl";
		String outputPath = "generated/Families2PersonsWithLibrary.NMFSynchronizations";
		String inputMetamodelPath = "resources/Families2PersonsWithLibrary/Families.ecore";
		String outputMetamodelPath = "resources/Families2PersonsWithLibrary/Persons.ecore";
		String inputModelPath = "resources/Families2PersonsWithLibrary/SampleFamilies.xmi";
		String outputModelFileName = "SamplePersonsOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/Families2PersonsWithLibrary/ExpectedPersons.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * Families 2 persons test.
	 */
	@Test
	public void Families2PersonsTest() {
		String transformationName = "Families2Persons";
		String transformationPath = "resources/Families2Persons/Families2Persons.atl";
		String outputPath = "generated/Families2Persons.NMFSynchronizations";
		String inputMetamodelPath = "resources/Families2Persons/Families.ecore";
		String outputMetamodelPath = "resources/Families2Persons/Persons.ecore";
		String inputModelPath = "resources/Families2Persons/SampleFamilies.xmi";
		String outputModelFileName = "SamplePersonsOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/Families2Persons/ExpectedPersons.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * XML 2 DXF test.
	 */
	@Test
	public void XML2DXFTest() {
		String transformationName = "XML2DXF";
		String transformationPath = "resources/XML2DXF/XML2DXF.atl";
		String outputPath = "generated/XML2DXF.NMFSynchronizations";
		String inputMetamodelPath = "resources/XML2DXF/XML.ecore";
		String outputMetamodelPath = "resources/XML2DXF/DXF.ecore";
		String inputModelPath = "resources/XML2DXF/SampleInputXML.xmi";
		String outputModelFileName = "SampleDXFOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		//Could not automatically compare the created models for equality
	}
	
	/**
	 * XML 2 book test.
	 */
	@Test
	public void XML2BookTest() {
		String transformationName = "XML2Book";
		String transformationPath = "resources/XML2Book/XML2Book.atl";
		String outputPath = "generated/XML2Book.NMFSynchronizations";
		String inputMetamodelPath = "resources/XML2Book/XML.ecore";
		String outputMetamodelPath = "resources/XML2Book/Book.ecore";
		String inputModelPath = "resources/XML2Book/SampleInputXML.xmi";
		String outputModelFileName = "SampleBookOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/XML2Book/ExpectedOutputBook.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}
	
	/**
	 * Make 2 ant test.
	 */
	@Test
	public void Make2AntTest() {
		String transformationName = "Make2Ant";
		String transformationPath = "resources/Make2Ant/Make2Ant.atl";
		String outputPath = "generated/Make2Ant.NMFSynchronizations";
		String inputMetamodelPath = "resources/Make2Ant/Make.ecore";
		String outputMetamodelPath = "resources/Make2Ant/Ant.ecore";
		String inputModelPath = "resources/Make2Ant/SampleInputMake.xmi";
		String outputModelFileName = "SampleAntFileOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		//Could not automatically compare the created models for equality
	}

	/**
	 * A2BContainment test.
	 */
	@Test
	public void A2BContainmentTest() {
		String transformationName = "A2BContainment";
		String transformationPath = "resources/A2BContainment/A2BContainment.atl";
		String outputPath = "generated/A2BContainment.NMFSynchronizations";
		String inputMetamodelPath = "resources/A2BContainment/TypeA.ecore";
		String outputMetamodelPath = "resources/A2BContainment/TypeB.ecore";
		String inputModelPath = "resources/A2BContainment/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/A2BContainment/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * Petri net 2 grafcet test.
	 */
	@Test
	public void PetriNet2GrafcetTest() {
		String transformationName = "PetriNet2Grafcet";
		String transformationPath = "resources/PetriNet2Grafcet/PetriNet2Grafcet.atl";
		String outputPath = "generated/PetriNet2Grafcet.NMFSynchronizations";
		String inputMetamodelPath = "resources/PetriNet2Grafcet/PetriNet.ecore";
		String outputMetamodelPath = "resources/PetriNet2Grafcet/Grafcet.ecore";
		String inputModelPath = "resources/PetriNet2Grafcet/SamplePetriNet.xmi";
		String outputModelFileName = "SampleGrafcetOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		//Could not automatically compare the created models for equality
	}

	/**
	 * PetriNet 2 PathExp test.
	 */
	@Test
	public void PetriNet2PathExpTest() {
		String transformationName = "PetriNet2PathExp";
		String transformationPath = "resources/PetriNet2PathExp/PetriNet2PathExp.atl";
		String outputPath = "generated/PetriNet2PathExp.NMFSynchronizations";
		String inputMetamodelPath = "resources/PetriNet2PathExp/PetriNet.ecore";
		String outputMetamodelPath = "resources/PetriNet2PathExp/PathExp.ecore";
		String inputModelPath = "resources/PetriNet2PathExp/SamplePetrinet.xmi";
		String outputModelFileName = "SamplePathExpOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
	
		//Could not automatically compare the created models for equality
	}

	/**
	 * A2BMultInOut test.
	 */
	@Test
	public void A2BMultInOutTest() {
		String transformationName = "A2BMultInOut";
		String transformationPath = "resources/A2BMultInOut/A2BMultInOut.atl";
		String outputPath = "generated/A2BMultInOut.NMFSynchronizations";

		List<String> inputMetamodelPaths = new ArrayList<String>();
		inputMetamodelPaths.add("resources/A2BMultInOut/TypeA.ecore");
		inputMetamodelPaths.add("resources/A2BMultInOut/TypeB.ecore");

		List<String> outputMetamodelPaths = new ArrayList<String>();
		outputMetamodelPaths.add("resources/A2BMultInOut/TypeC.ecore");
		outputMetamodelPaths.add("resources/A2BMultInOut/TypeD.ecore");

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BMultInOut/SampleInputTypeA.xmi");
		inputModelPaths.add("resources/A2BMultInOut/SampleInputTypeB1.xmi");
		inputModelPaths.add("resources/A2BMultInOut/SampleInputTypeB2.xmi");

		List<String> outputModelFileNames = new ArrayList<String>();
		String outputModelFileNameTypeC = "SampleOutputTypeC.xmi";
		String outputModelFileNameTypeD = "SampleOutputTypeD.xmi";
		outputModelFileNames.add(outputModelFileNameTypeC);
		outputModelFileNames.add(outputModelFileNameTypeD);

		GenerateBuildExecute(transformationName, transformationPath, outputPath, inputMetamodelPaths,
				outputMetamodelPaths, inputModelPaths, outputModelFileNames);
		
		//Could not automatically compare the created models for equality
	}

	/**
	 * A2BMultOut test.
	 */
	@Test
	public void A2BMultOutTest() {
		String transformationName = "A2BMultOut";
		String transformationPath = "resources/A2BMultOut/A2BMultOut.atl";
		String outputPath = "generated/A2BMultOut.NMFSynchronizations";

		String inputMetamodelPath = "resources/A2BMultOut/TypeA.ecore";

		List<String> outputMetamodelPaths = new ArrayList<String>();
		outputMetamodelPaths.add("resources/A2BMultOut/TypeB.ecore");
		outputMetamodelPaths.add("resources/A2BMultOut/TypeC.ecore");

		String inputModelPath = "resources/A2BMultOut/SampleInput.xmi";

		List<String> outputModelFileNames = new ArrayList<String>();
		String outputModelFileNameTypeB = "SampleOutputTypeB.xmi";
		String outputModelFileNameTypeC = "SampleOutputTypeC.xmi";
		outputModelFileNames.add(outputModelFileNameTypeB);
		outputModelFileNames.add(outputModelFileNameTypeC);

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				outputMetamodelPaths, Arrays.asList(inputModelPath), outputModelFileNames);
		
		String expectedOutputModelPathTypeB = "resources/A2BMultOut/ExpectedOutputTypeB.xmi";
		String createdOutputModelPathTypeB = outputPath + "/bin/" + outputModelFileNameTypeB;
		CheckModelsForEquality(expectedOutputModelPathTypeB, createdOutputModelPathTypeB);
		
		String expectedOutputModelPathTypeC = "resources/A2BMultOut/ExpectedOutputTypeC.xmi";
		String createdOutputModelPathTypeC = outputPath + "/bin/" + outputModelFileNameTypeC;
		CheckModelsForEquality(expectedOutputModelPathTypeC, createdOutputModelPathTypeC);
	}

	/**
	 * A2BMultDiffIn test.
	 */
	@Test
	public void A2BMultDiffInTypeTest() {
		String transformationName = "A2BMultDiffIn";
		String transformationPath = "resources/A2BMultDiffIn/A2BMultDiffIn.atl";
		String outputPath = "generated/A2BMultDiffIn.NMFSynchronizations";

		List<String> inputMetamodelPaths = new ArrayList<String>();
		inputMetamodelPaths.add("resources/A2BMultDiffIn/TypeA.ecore");
		inputMetamodelPaths.add("resources/A2BMultDiffIn/TypeC.ecore");

		String outputMetamodelPath = "resources/A2BMultDiffIn/TypeB.ecore";

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BMultDiffIn/SampleInputTypeA.xmi");
		inputModelPaths.add("resources/A2BMultDiffIn/SampleInputTypeC.xmi");

		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, inputMetamodelPaths,
				Arrays.asList(outputMetamodelPath), inputModelPaths, Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/A2BMultDiffIn/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * A2BMultIn test.
	 */
	@Test
	public void A2BMultInTest() {
		String transformationName = "A2BMultIn";
		String transformationPath = "resources/A2BMultIn/A2BMultIn.atl";
		String outputPath = "generated/A2BMultIn.NMFSynchronizations";

		String inputMetamodelPath = "resources/A2BMultIn/TypeA.ecore";
		String outputMetamodelPath = "resources/A2BMultIn/TypeB.ecore";

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BMultIn/SampleInput1.xmi");
		inputModelPaths.add("resources/A2BMultIn/SampleInput2.xmi");

		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), inputModelPaths, Arrays.asList(outputModelFileName));	
		
		String expectedOutputModelPath = "resources/A2BMultIn/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * A2BHelper test.
	 */
	@Test
	public void A2BHelperTest() {
		String transformationName = "A2BHelper";
		String transformationPath = "resources/A2BHelper/A2BHelper.atl";
		String outputPath = "generated/A2BHelper.NMFSynchronizations";
		String inputMetamodelPath = "resources/A2BHelper/TypeA.ecore";
		String outputMetamodelPath = "resources/A2BHelper/TypeB.ecore";
		String inputModelPath = "resources/A2BHelper/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
			
		//Could not automatically compare the created models for equality
	}

	/**
	 * Port V 4 ref immediate composite test.
	 */
	@Test
	public void PortV4RefImmediateCompositeTest() {
		String transformationName = "PortV4";
		String transformationPath = "resources/PortV4/PortV4.atl";
		String outputPath = "generated/PortV4.NMFSynchronizations";
		String inputMetamodelPath = "resources/PortV4/TypeA.ecore";
		String outputMetamodelPath = "resources/PortV4/TypeB.ecore";
		String inputModelPath = "resources/PortV4/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/PortV4/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * Port V 3 all instances test.
	 */
	@Test
	public void PortV3AllInstancesTest() {
		String transformationName = "PortV3";
		String transformationPath = "resources/PortV3/PortV3.atl";
		String outputPath = "generated/PortV3.NMFSynchronizations";
		String inputMetamodelPath = "resources/PortV3/TypeA.ecore";
		String outputMetamodelPath = "resources/PortV3/TypeB.ecore";
		String inputModelPath = "resources/PortV3/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/PortV3/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * Port V 2 lazy rules test.
	 */
	@Test
	public void PortV2LazyRulesTest() {
		String transformationName = "PortV2";
		String transformationPath = "resources/PortV2/PortV2.atl";
		String outputPath = "generated/PortV2.NMFSynchronizations";
		String inputMetamodelPath = "resources/PortV2/TypeA.ecore";
		String outputMetamodelPath = "resources/PortV2/TypeB.ecore";
		String inputModelPath = "resources/PortV2/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		String expectedOutputModelPath = "resources/PortV2/ExpectedOutput.xmi";
		String createdOutputModelPath = outputPath + "/bin/" + outputModelFileName;
		CheckModelsForEquality(expectedOutputModelPath, createdOutputModelPath);
	}

	/**
	 * A2BUniqueLazy test.
	 */
	@Test
	public void A2BUniqueLazyTest() {
		String transformationName = "A2BUniqueLazy";
		String transformationPath = "resources/A2BUniqueLazy/A2BUniqueLazy.atl";
		String outputPath = "generated/A2BUniqueLazy.NMFSynchronizations";

		List<String> inputMetamodelPaths = new ArrayList<String>();
		inputMetamodelPaths.add("resources/A2BUniqueLazy/TypeA.ecore");

		List<String> outputMetamodelPaths = new ArrayList<String>();
		outputMetamodelPaths.add("resources/A2BUniqueLazy/TypeB.ecore");
		outputMetamodelPaths.add("resources/A2BUniqueLazy/TypeC.ecore");

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BUniqueLazy/SampleInputTypeA.xmi");

		List<String> outputModelFileNames = new ArrayList<String>();
		String outputModelFileNameTypeB = "SampleOutputTypeB.xmi";
		String outputModelFileNameTypeC = "SampleOutputTypeC.xmi";
		outputModelFileNames.add(outputModelFileNameTypeB);
		outputModelFileNames.add(outputModelFileNameTypeC);

		GenerateBuildExecute(transformationName, transformationPath, outputPath, inputMetamodelPaths,
				outputMetamodelPaths, inputModelPaths, outputModelFileNames);
		
		//Could not automatically compare the created models for equality
	}	
	
	/**
	 * A2BLazy test.
	 */
	@Test
	public void A2BLazyTest() {
		String transformationName = "A2BLazy";
		String transformationPath = "resources/A2BLazy/A2BLazy.atl";
		String outputPath = "generated/A2BLazy.NMFSynchronizations";

		List<String> inputMetamodelPaths = new ArrayList<String>();
		inputMetamodelPaths.add("resources/A2BLazy/TypeA.ecore");

		List<String> outputMetamodelPaths = new ArrayList<String>();
		outputMetamodelPaths.add("resources/A2BLazy/TypeB.ecore");
		outputMetamodelPaths.add("resources/A2BLazy/TypeC.ecore");

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BLazy/SampleInputTypeA.xmi");

		List<String> outputModelFileNames = new ArrayList<String>();
		String outputModelFileNameTypeB = "SampleOutputTypeB.xmi";
		String outputModelFileNameTypeC = "SampleOutputTypeC.xmi";
		outputModelFileNames.add(outputModelFileNameTypeB);
		outputModelFileNames.add(outputModelFileNameTypeC);

		GenerateBuildExecute(transformationName, transformationPath, outputPath, inputMetamodelPaths,
				outputMetamodelPaths, inputModelPaths, outputModelFileNames);
		
		//Could not automatically compare the created models for equality
	}

	/**
	 * A2BMatched test.
	 */
	@Test
	public void A2BMatchedTest() {
		String transformationName = "A2BMatched";
		String transformationPath = "resources/A2BMatched/A2BMatched.atl";
		String outputPath = "generated/A2BMatched.NMFSynchronizations";

		List<String> inputMetamodelPaths = new ArrayList<String>();
		inputMetamodelPaths.add("resources/A2BMatched/TypeA.ecore");

		List<String> outputMetamodelPaths = new ArrayList<String>();
		outputMetamodelPaths.add("resources/A2BMatched/TypeB.ecore");
		outputMetamodelPaths.add("resources/A2BMatched/TypeC.ecore");

		List<String> inputModelPaths = new ArrayList<String>();
		inputModelPaths.add("resources/A2BMatched/SampleInputTypeA.xmi");

		List<String> outputModelFileNames = new ArrayList<String>();
		String outputModelFileNameTypeB = "SampleOutputTypeB.xmi";
		String outputModelFileNameTypeC = "SampleOutputTypeC.xmi";
		outputModelFileNames.add(outputModelFileNameTypeB);
		outputModelFileNames.add(outputModelFileNameTypeC);

		GenerateBuildExecute(transformationName, transformationPath, outputPath, inputMetamodelPaths,
				outputMetamodelPaths, inputModelPaths, outputModelFileNames);

		String expectedOutputModelPathTypeB = "resources/A2BMatched/ExpectedOutputTypeB.xmi";
		String createdOutputModelPathTypeB = outputPath + "/bin/" + outputModelFileNameTypeB;
		CheckModelsForEquality(expectedOutputModelPathTypeB, createdOutputModelPathTypeB);
		
		String expectedOutputModelPathTypeC = "resources/A2BMatched/ExpectedOutputTypeC.xmi";
		String createdOutputModelPathTypeC = outputPath + "/bin/" + outputModelFileNameTypeC;
		CheckModelsForEquality(expectedOutputModelPathTypeC, createdOutputModelPathTypeC);
	}

	
	/**
	 * Petri net 2 PNML test.
	 */
	@Test
	public void PetriNet2PNMLTest() {
		String transformationName = "PetriNet2PNML";
		String transformationPath = "resources/PetriNet2PNML/PetriNet2PNML.atl";
		String outputPath = "generated/PetriNet2PNML.NMFSynchronizations";
		String inputMetamodelPath = "resources/PetriNet2PNML/PetriNet.ecore";
		String outputMetamodelPath = "resources/PetriNet2PNML/PNML.ecore";
		String inputModelPath = "resources/PetriNet2PNML/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		//Could not automatically compare the created models for equality
	}

	/**
	 * A2BInheritance test.
	 */
	@Test
	public void A2BInheritanceTest() {
		String transformationName = "A2BInheritance";
		String transformationPath = "resources/A2BInheritance/A2BInheritance.atl";
		String outputPath = "generated/A2BInheritance.NMFSynchronizations";
		String inputMetamodelPath = "resources/A2BInheritance/TypeA.ecore";
		String outputMetamodelPath = "resources/A2BInheritance/TypeB.ecore";
		String inputModelPath = "resources/A2BInheritance/SampleInput.xmi";
		String outputModelFileName = "SampleOutput.xmi";

		GenerateBuildExecute(transformationName, transformationPath, outputPath, Arrays.asList(inputMetamodelPath),
				Arrays.asList(outputMetamodelPath), Arrays.asList(inputModelPath), Arrays.asList(outputModelFileName));
		
		//Could not automatically compare the created models for equality
	}
}
