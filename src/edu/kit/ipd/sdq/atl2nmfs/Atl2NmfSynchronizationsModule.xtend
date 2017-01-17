package edu.kit.ipd.sdq.atl2nmfs;

import com.google.inject.AbstractModule
import com.google.inject.Singleton

import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelperImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzer
import edu.kit.ipd.sdq.atl2nmfs.helper.AtlHelperAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer
import edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzerFactory
import edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzerFactoryImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzer
import edu.kit.ipd.sdq.atl2nmfs.helper.MetamodelAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.ModelAnalyzer
import edu.kit.ipd.sdq.atl2nmfs.helper.ModelAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.OclReturnTypeAnalyzer
import edu.kit.ipd.sdq.atl2nmfs.helper.OclReturnTypeAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.AtlTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.AtlTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.BindingTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.BindingTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.FilterTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.FilterTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.HelperTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.HelperTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.RuleTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.atl.RuleTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclIteratorTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclIteratorTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperationTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperationTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperatorTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclOperatorTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclTransformer
import edu.kit.ipd.sdq.atl2nmfs.transformer.ocl.OclTransformerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.TargetPatternElementAnalyzerImpl
import edu.kit.ipd.sdq.atl2nmfs.helper.TargetPatternElementAnalyzer

/**
 * The Atl2NmfSynchronizationsModule Class.
 */
class Atl2NmfSynchronizationsModule extends AbstractModule {

	/* (non-Javadoc)
	 * @see com.google.inject.AbstractModule#configure
	 */
	@Override
	protected override void configure() {
		bind(Atl2NmfSHelper).to(Atl2NmfSHelperImpl).in(Singleton);
		bind(AtlHelperAnalyzer).to(AtlHelperAnalyzerImpl).in(Singleton);
		bind(AtlRuleAnalyzer).to(AtlRuleAnalyzerImpl).in(Singleton);
		bind(MetamodelAnalyzer).to(MetamodelAnalyzerImpl).in(Singleton);
		bind(ModelAnalyzer).to(ModelAnalyzerImpl).in(Singleton);
		bind(OclReturnTypeAnalyzer).to(OclReturnTypeAnalyzerImpl).in(Singleton);
		bind(EcoreAnalyzerFactory).to(EcoreAnalyzerFactoryImpl).in(Singleton);
		bind(TargetPatternElementAnalyzer).to(TargetPatternElementAnalyzerImpl).in(Singleton);	

		bind(AtlTransformer).to(AtlTransformerImpl).in(Singleton);
		bind(BindingTransformer).to(BindingTransformerImpl).in(Singleton);
		bind(FilterTransformer).to(FilterTransformerImpl).in(Singleton);
		bind(HelperTransformer).to(HelperTransformerImpl).in(Singleton);
		bind(RuleTransformer).to(RuleTransformerImpl).in(Singleton);

		bind(OclTransformer).to(OclTransformerImpl).in(Singleton);
		bind(OclIteratorTransformer).to(OclIteratorTransformerImpl).in(Singleton);
		bind(OclOperationTransformer).to(OclOperationTransformerImpl).in(Singleton);
		bind(OclOperatorTransformer).to(OclOperatorTransformerImpl).in(Singleton);
	}
}