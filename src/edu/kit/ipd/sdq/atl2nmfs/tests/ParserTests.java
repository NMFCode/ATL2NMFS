package edu.kit.ipd.sdq.atl2nmfs.tests;

import java.io.File;

import org.eclipse.emf.common.util.EList;
import org.eclipse.m2m.atl.common.ATL.Helper;
import org.eclipse.m2m.atl.common.ATL.MatchedRule;
import org.eclipse.m2m.atl.common.ATL.Module;
import org.eclipse.m2m.atl.common.ATL.ModuleElement;
import org.eclipse.m2m.atl.common.OCL.Attribute;
import org.eclipse.m2m.atl.common.OCL.OclFeatureDefinition;
import org.eclipse.m2m.atl.common.OCL.OclModel;
import org.eclipse.m2m.atl.common.OCL.Operation;
import org.junit.Assert;
import org.junit.Test;

import edu.kit.ipd.sdq.atl2nmfs.utils.AtlParserUtils;

/**
 * The ParserTests Class.
 */
public class ParserTests {

	/**
	 * Parser test.
	 */
	@Test
	public void ParserTest() {
		String transformationFilePath = "resources/Families2Persons/Families2Persons.atl";
		File file = new File(transformationFilePath);
		Assert.assertTrue(file.exists());
	
		Module parsedModule = null;
		try {
			parsedModule = AtlParserUtils.parseModule(transformationFilePath);
		}
		catch(Exception exception) {
			Assert.fail("Parsing of the module failed. Exception message: " + exception.getMessage());
		}

		Assert.assertNotNull(parsedModule);		
		Assert.assertEquals(parsedModule.getName(), "Families2Persons");
		
		EList<OclModel> inModels = parsedModule.getInModels();
		Assert.assertEquals(inModels.size(), 1);
		
		OclModel inModel = inModels.get(0);
		Assert.assertEquals(inModel.getName(), "IN");
		
		OclModel inputMetamodel = inModel.getMetamodel();
		Assert.assertEquals(inputMetamodel.getName(), "Families");

		EList<OclModel> outModels = parsedModule.getOutModels();
		
		OclModel outModel = outModels.get(0);
		Assert.assertEquals(outModel.getName(), "OUT");
		
		OclModel outputMetamodel = outModel.getMetamodel();
		Assert.assertEquals(outputMetamodel.getName(), "Persons");
		
		EList<ModuleElement> elements = parsedModule.getElements();
		Assert.assertEquals(elements.size(), 4);
		
		ModuleElement firstModuleElement = elements.get(0);
		Helper firstHelper = firstModuleElement instanceof Helper ? (Helper)firstModuleElement : null;
		Assert.assertNotNull(firstHelper);
		
		OclFeatureDefinition firstFeatureDefinition = firstHelper.getDefinition();
		Attribute attribute = firstFeatureDefinition.getFeature() instanceof Attribute ? (Attribute)firstFeatureDefinition.getFeature() : null;
		Assert.assertNotNull(attribute);
		Assert.assertEquals(attribute.getName(), "familyName");
		
		ModuleElement secondModuleElement = elements.get(1);
		Helper secondHelper = secondModuleElement instanceof Helper ? (Helper)secondModuleElement : null;
		Assert.assertNotNull(secondHelper);
		
		OclFeatureDefinition secondFeatureDefinition = secondHelper.getDefinition();
		Operation operation = secondFeatureDefinition.getFeature() instanceof Operation ? (Operation)secondFeatureDefinition.getFeature() : null;
		Assert.assertNotNull(operation);
		Assert.assertEquals(operation.getName(), "isFemale");
		
		ModuleElement thirdModuleElement = elements.get(2);
		MatchedRule firstMatchedRule = thirdModuleElement instanceof MatchedRule ? (MatchedRule)thirdModuleElement : null;
		Assert.assertNotNull(firstMatchedRule);
		Assert.assertEquals(firstMatchedRule.getName(), "Member2Male");

		ModuleElement fourthModuleElement = elements.get(3);
		MatchedRule secondMatchedRule = fourthModuleElement instanceof MatchedRule ? (MatchedRule)fourthModuleElement : null;
		Assert.assertNotNull(secondMatchedRule);
		Assert.assertEquals(secondMatchedRule.getName(), "Member2Female");
	}
}
