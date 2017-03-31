package edu.kit.ipd.sdq.atl2nmfs;

import java.util.List;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.ParameterException;

import edu.kit.ipd.sdq.atl2nmfs.Atl2NmfSynchronizations;

public class ATL2NMFSynchronizationsMain {
	
	@Parameter(names = { "-transformation" }, description = "The path to the ATL transformation to be transformed", required = true)
	private String transformationPath;
	
	@Parameter(names = { "-name" }, description = "The name for the generated solution", required = true)
	private String transformationName;
	
	@Parameter(names = { "-output" }, description = "The output path for the transformation", required = true)
	private String outputPath;
	
	@Parameter(names = { "-sourceMM" }, description = "The path to the source metamodel. This option can be specified multiple times", required = true)
	private List<String> inputMetamodelPaths;

	@Parameter(names = { "-targetMM" }, description = "The path to the target metamodel. This option can be specified multiple times", required = true)
	private List<String> outputMetamodelPaths;
	
	@Parameter(names = { "-cacheAttributeHelpers" }, description = "If specified, the transformation makes sure that attribute helpers are cached")
	private boolean cacheHelpers;
	
	@Parameter(names = { "-transformationOnly" }, description = "If specified, only transform the transformation itself, not the metamodels")
	private boolean transformationOnly;

	public static void main(String[] args) {
		
		ATL2NMFSynchronizationsMain app = new ATL2NMFSynchronizationsMain();
		JCommander jc = new JCommander(app);

		try {
			jc.parse(args);
		} catch (ParameterException pe) {
			System.err.println(pe.getMessage());
			jc.usage();
			return;
		}

		app.generate();

	}
	
	public void generate() {
		try {
			Atl2NmfSynchronizations atl2NmfSynchronizations = new Atl2NmfSynchronizations();
			atl2NmfSynchronizations.doGenerate(transformationName, transformationPath, outputPath, inputMetamodelPaths,
					outputMetamodelPaths, cacheHelpers, transformationOnly);
		} catch (Exception exception) {
			System.err.println("Execution of the Atl2NmfS HOT failed. Exception message: " + exception.getMessage());
			exception.printStackTrace();
		}
	}

}
