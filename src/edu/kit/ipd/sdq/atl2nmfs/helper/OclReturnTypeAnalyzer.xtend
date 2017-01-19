package edu.kit.ipd.sdq.atl2nmfs.helper;

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import java.util.List
import org.eclipse.m2m.atl.common.OCL.OclExpression

/**
 * The OclReturnTypeAnalyzer Interface.
 */
interface OclReturnTypeAnalyzer {

	/**
	 * Initialize the OCL return type analyzer.
	 * 
	 * @param inputMetamodelInfos
	 *            the input metamodel infos
	 */
	def void initialize(List<MetamodelInfo> inputMetamodelInfos);

	/**
	 * Gets the return type info.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the return type info
	 */
	def ReturnTypeInfo getReturnTypeInfo(OclExpression expression);

}
