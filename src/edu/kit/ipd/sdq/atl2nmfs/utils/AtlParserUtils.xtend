package edu.kit.ipd.sdq.atl2nmfs.utils;

import java.io.File
import java.io.FileInputStream

import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EFactory
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.m2m.atl.common.ATL.ATLFactory
import org.eclipse.m2m.atl.common.ATL.ATLPackage
import org.eclipse.m2m.atl.common.ATL.Library
import org.eclipse.m2m.atl.common.ATL.Module
import org.eclipse.m2m.atl.common.OCL.OCLFactory
import org.eclipse.m2m.atl.common.OCL.OCLPackage
import org.eclipse.m2m.atl.common.PrimitiveTypes.PrimitiveTypesFactory
import org.eclipse.m2m.atl.common.PrimitiveTypes.PrimitiveTypesPackage

/**
 * The AtlParserUtils Class.
 */
class AtlParserUtils {

	private static org.eclipse.m2m.atl.engine.parser.AtlParser atlParser;

	/**
	 * Private Class constructor.
	 */
	private new() {}

	/**
	 * Parses the ATL module which path is passed.
	 *
	 * @param transformationFilePath
	 *            the path to the transformation file which should be parsed
	 * @return the parsed module
	 * @throws Exception
	 */
	public def static Module parseModule(String transformationFilePath) throws Exception {
		if (atlParser == null)
			initialize();

		// load the ATL transformation
		var FileInputStream atlTransformationInputStream = null;
		var Module atlModule = null;

		var atlTransformationFile = new File(transformationFilePath);
		atlTransformationInputStream = new FileInputStream(atlTransformationFile);

		var parseResult = atlParser.parseWithProblems(atlTransformationInputStream);
		var parsedModule = parseResult.get(0);

		if (parsedModule == null) {
			printParsingProblems(parseResult);
			throw new IllegalArgumentException("Parsing of the ATL transformation file failed");
		}

		if (!(parsedModule instanceof Module)) {
			throw new IllegalArgumentException("The parsed atl file can't be casted to the Module type");
		}

		atlModule = parsedModule as Module;
		return atlModule;
	}

	/**
	 * Parses the ATL library which path is passed.
	 *
	 * @param libraryFilePath
	 *            the path to the library file which should be parsed
	 * @return the parsed library
	 * @throws Exception
	 */
	public def static Library parseLibrary(String libraryFilePath) throws Exception {
		if (atlParser == null)
			initialize();

		// load the ATL library
		var FileInputStream atlLibraryInputStream = null;
		var Library atlLibrary = null;

		var atlLibraryFile = new File(libraryFilePath);
		atlLibraryInputStream = new FileInputStream(atlLibraryFile);

		var parseResult = atlParser.parseWithProblems(atlLibraryInputStream);
		var parsedLibrary = parseResult.get(0);

		if (parsedLibrary == null) {
			printParsingProblems(parseResult);
			throw new IllegalArgumentException("Parsing the ATL library file failed");
		}

		if (!(parsedLibrary instanceof Library)) {
			throw new IllegalArgumentException("The parsed atl file can't be casted to the Library type");
		}

		atlLibrary = parsedLibrary as Library;
		return atlLibrary;
	}

	/**
	 * Initializes the resourceSets with the ATL metamodels and loads the
	 * default ATL parser.
	 */
	private def static void initialize() {
		var atlResourceSet = new ResourceSetImpl();
		var EPackage.Registry reg = atlResourceSet.getPackageRegistry();

		var EFactory atlFactory = ATLFactory.eINSTANCE;
		var EFactory oclFactory = OCLFactory.eINSTANCE;
		var EFactory primitiveTypesFactory = PrimitiveTypesFactory.eINSTANCE;
		reg.put(ATLPackage.eNS_URI, atlFactory);
		reg.put(OCLPackage.eNS_URI, oclFactory);
		reg.put(PrimitiveTypesPackage.eNS_URI, primitiveTypesFactory);

		atlResourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put("*", new XMIResourceFactoryImpl());
		atlParser = org.eclipse.m2m.atl.engine.parser.AtlParser.getDefault();
	}

	/**
	 * Prints the problems which occurred during the parsing process.
	 *
	 * @param parseResult
	 *            the parsed results
	 */
	private def static void printParsingProblems(EObject[] parseResult) {
		for(problem : parseResult) {
			var problemClass = problem.eClass();

			var severity = problem.eGet(problemClass.getEStructuralFeature("severity")) as EEnumLiteral;
			var location = problem.eGet(problemClass.getEStructuralFeature("location")) as String;
			var description = problem.eGet(problemClass.getEStructuralFeature("description")) as String;

			System.out.println("Severity: " + severity);
			System.out.println("Location: " + location);
			System.out.println("Description: " + description);
		}
	}
}
