package edu.kit.ipd.sdq.atl2nmfs.helper.infos

import java.util.ArrayList
import java.util.List
import org.eclipse.m2m.atl.common.OCL.Attribute
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.OclFeatureDefinition
import org.eclipse.m2m.atl.common.OCL.OclModelElement
import org.eclipse.m2m.atl.common.OCL.Operation
import edu.kit.ipd.sdq.atl2nmfs.helper.Atl2NmfSHelper
import org.apache.commons.lang.WordUtils
import org.eclipse.m2m.atl.common.OCL.OclType
import org.eclipse.m2m.atl.common.OCL.SequenceType

/**
 * The HelperType Enum.
 */
public enum HelperType {
	ATTRIBUTE,
	FUNCTIONAL
}

/**
 * The HelperInfo Class.
 */
class HelperInfo {
	private final Atl2NmfSHelper atl2NmfSHelper;

	private final String name;
	private final String transformedName;
	private final HelperType helperType;
	private final Boolean hasContext;
	private final String transformedContext;

	private final String transformedReturnTypeName;
	private final String returnTypeName;
	private final String returnTypeMetamodelName;
	private final Boolean isReturnTypePrimitive;
	private final Boolean isReturnTypeSequence;
	private final OclExpression expression;
	private final OclType type;
	private String transformedExpression;

	private final ArrayList<ParameterInfo> parameterInfos;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 * @param featureDefinition
	 *            the feature definition
	 */
	new(Atl2NmfSHelper atl2NmfSHelper, OclFeatureDefinition featureDefinition) {
		this.atl2NmfSHelper = atl2NmfSHelper;

		// TODO: support helpers with a collection as return type
		// analyze helper definition and initialize the variables
		var feature = featureDefinition.feature;
		var contextDefinition = featureDefinition.context_;

		this.hasContext = contextDefinition != null;
		if (hasContext) {
			this.transformedContext = atl2NmfSHelper.transformExpression(contextDefinition.context_, null);
		} 
		else {
			// if the helper has no context declared then it has a global context and must be called with 'thisModule'
			this.transformedContext = null;
		}

		this.parameterInfos = new ArrayList<ParameterInfo>();

		if (feature instanceof Attribute) {
			this.helperType = HelperType.ATTRIBUTE;
			this.name = feature.name;
			this.transformedName = WordUtils.capitalize(name);
			
			var type = feature.type;
			var isCollection = false;
			if (type instanceof SequenceType) {
				type = (type as SequenceType).elementType;
				isCollection = true;
			}
			
			this.isReturnTypeSequence = isCollection;

			if (type instanceof OclModelElement) {
				var oclModelElement = type as OclModelElement;

				this.returnTypeMetamodelName = oclModelElement.model.name;
				this.returnTypeName = oclModelElement.name;
				this.isReturnTypePrimitive = false;
			} 
			else {
				this.returnTypeMetamodelName = null;
				this.returnTypeName = atl2NmfSHelper.transformExpression(feature.type, null);
				this.isReturnTypePrimitive = true;
			}

			this.transformedReturnTypeName = atl2NmfSHelper.transformExpression(feature.type, null);

			// we have to delay the transformation since not all ATL rules and helpers are analyzed and registered yet
			this.expression = feature.initExpression;
			this.type = feature.type;
		} 
		else {
			var operation = feature as Operation
			this.helperType = HelperType.FUNCTIONAL;
			this.name = operation.name;
			this.transformedName = WordUtils.capitalize(name);
			
			var type = operation.returnType;
			var isCollection = false;
			if (type instanceof SequenceType) {
				type = (type as SequenceType).elementType;
				isCollection = true;
			}
			
			this.isReturnTypeSequence = isCollection;

			if (type instanceof OclModelElement) {
				var oclModelElement = type as OclModelElement;

				this.returnTypeMetamodelName = oclModelElement.model.name;
				this.returnTypeName = oclModelElement.name;
				this.isReturnTypePrimitive = false;
			} 
			else {
				this.returnTypeMetamodelName = null;
				this.returnTypeName = atl2NmfSHelper.transformExpression(operation.returnType, null);
				this.isReturnTypePrimitive = true;
			}

			this.transformedReturnTypeName = atl2NmfSHelper.transformExpression(operation.returnType, null);

			// we have to delay the transformation since not all ATL rules and helpers are analyzed and registered yet
			this.expression = operation.body;
			this.type = operation.returnType;

			for (parameter : operation.parameters) {
				var transformedTypeName = atl2NmfSHelper.transformExpression(parameter.type, null);
				var parameterInfo = new ParameterInfo(parameter.varName, transformedTypeName);
				parameterInfos.add(parameterInfo)
			}
		}
	}

	/**
	 * Gets the name.
	 * 
	 * @return the name
	 */
	def String getName() {
		return name;
	}

	/**
	 * Gets the transformed name.
	 * 
	 * @return the transformed name
	 */
	def String getTransformedName() {
		return transformedName;
	}

	/**
	 * Gets the transformed return type name.
	 * 
	 * @return the transformed return type name
	 */
	def String getTransformedReturnTypeName() {
		return transformedReturnTypeName;
	}

	/**
	 * Gets the transformed expression.
	 * 
	 * @return the transformed expression
	 */
	def String getTransformedExpression() {
		if (transformedExpression == null) {
			transformedExpression = atl2NmfSHelper.transformExpression(expression, type);
		}

		return transformedExpression;
	}

	/**
	 * Gets the helper type.
	 * 
	 * @return the helper type
	 */
	def HelperType getHelperType() {
		return helperType;
	}

	/**
	 * Checks for parameters.
	 * 
	 * @return the boolean
	 */
	def Boolean hasParameters() {
		return parameterInfos.size > 0;
	}

	/**
	 * Gets the parameter infos.
	 * 
	 * @return the parameter infos
	 */
	def List<ParameterInfo> getParameterInfos() {
		return parameterInfos;
	}

	/**
	 * Checks for context.
	 * 
	 * @return the boolean
	 */
	def Boolean hasContext() {
		return hasContext;
	}

	/**
	 * Gets the transformed context.
	 * 
	 * @return the transformed context
	 */
	def String getTransformedContext() {
		return transformedContext;
	}

	/**
	 * Checks if the return type is primitive.
	 * 
	 * @return the boolean
	 */
	def Boolean isReturnTypePrimitive() {
		return isReturnTypePrimitive;
	}

	/**
	 * Gets the return type name.
	 * 
	 * @return the return type name
	 */
	def String getReturnTypeName() {
		return returnTypeName;
	}

	/**
	 * Gets the return type metamodel name.
	 * 
	 * @return the return type metamodel name
	 */
	def String getReturnTypeMetamodelName() {
		return returnTypeMetamodelName;
	}
}
