package edu.kit.ipd.sdq.atl2nmfs.helper

import edu.kit.ipd.sdq.atl2nmfs.helper.infos.PossibleReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.ArrayList
import java.util.List
import org.apache.commons.lang.NotImplementedException
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.impl.EClassImpl
import org.eclipse.emf.ecore.impl.EReferenceImpl
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

/**
 * The EcoreAnalyzerImpl Class.
 */
class EcoreAnalyzerImpl implements EcoreAnalyzer {
	private final String metamodelName;
	private final Resource resource;
	private final EPackage mainPackage;
	private final List<TypeInfo> typeInfos;

	/**
	 * Class constructor.
	 * 
	 * @param metamodelName
	 *            the metamodel name
	 * @param metamodelPath
	 *            the metamodel path
	 */
	new(String metamodelName, String metamodelPath) {
		this.metamodelName = metamodelName;

		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("*", new XMIResourceFactoryImpl());
		var resourceSet = new ResourceSetImpl();
		resource = resourceSet.getResource(URI.createURI(metamodelPath), true);

		var packages = resource.getContents();
		if (packages.size > 1) {
			throw new NotImplementedException("Ecore metamodels with multiple packages are not supported yet.");
		}

		var untypedPackage = packages.get(0);
		mainPackage = untypedPackage as EPackage

		// the name of the metamodel used in the atl transformation must be the same name of the main ePackage used in the metamodel
		if (!mainPackage.name.equals(metamodelName))
			throw new IllegalArgumentException("No Package with the name " + metamodelName +
				" found. Please make sure that the package name in the Ecore metamodel is the same name as the metamodel name in the ATL Transformation.");

		// analyze ecore metamodel and initialize type hierarchy
		typeInfos = new ArrayList<TypeInfo>();
		initializeTypeHierarchy();
	}

	/**
	 * Initialize the type hierarchy.
	 */
	def private void initializeTypeHierarchy() {
		// iterate over each classifier and create the type hierarchy
		for (eClassifier : mainPackage.getEClassifiers) {
			if (eClassifier instanceof EClass) {
				var eClass = eClassifier as EClass;

				// a type info can already be created for the classifier if it was a super type of a classifier which was already handled
				var typeInfo = getOrCreateTypeInfo(eClass.name);
				initializeSuperAndSubTypeInfos(typeInfo, eClass);
			} else {
				throw new NotImplementedException(
					"During the analysis of the type hierarchy are only classifier with the type EClassImpl supported");
			}
		}
	}

	/**
	 * Initialize super and sub type infos.
	 * 
	 * @param typeInfo
	 *            the type info
	 * @param eClass
	 *            the Eclass
	 */
	def private void initializeSuperAndSubTypeInfos(TypeInfo typeInfo, EClass eClass) {
		// we don't have to call this function iteratively because the EAllSuperTypes List contains already the super types of the super types
		for (superType : eClass.getEAllSuperTypes) {
			var superTypeInfo = getOrCreateTypeInfo(superType.name);

			typeInfo.superTypeInfos.add(superTypeInfo);
			superTypeInfo.subTypeInfos.add(typeInfo);
		}
	}

	/**
	 * Gets or creates the type info.
	 * 
	 * @param typeName
	 *            the type name
	 * @return the type info
	 */
	def private TypeInfo getOrCreateTypeInfo(String typeName) {
		var typeInfo = typeInfos.findFirst[it.name == typeName];

		if (typeInfo == null) {
			typeInfo = new TypeInfo(metamodelName, typeName);
			typeInfos.add(typeInfo);
		}

		return typeInfo;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#getTypeInfo
	 */
	override TypeInfo getTypeInfo(String typeName) {
		var typeInfo = typeInfos.findFirst[it.name.equals(typeName)];

		if (typeInfo == null) {
			throw new IllegalArgumentException("No type info for the type '" + typeName + "' could be found.")
		}

		return typeInfo;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#getNsUri
	 */
	override String getNsUri() {
		return mainPackage.nsURI;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#getReturnTypeInfoOfFeature
	 */
	override ReturnTypeInfo getReturnTypeInfoOfFeature(String classifierName, String featureName) {
		var typeName = getTypeNameOfFeature(classifierName, featureName);
		if (typeName == null) {
			var possibleReturnTypeInfos = getAllPossibleReturnTypeInfosOfFeature(classifierName, featureName);
			return new ReturnTypeInfo(possibleReturnTypeInfos);
		}

		var ReturnTypeInfo returnTypeInfo;
		var isTypeComplex = isFeaturesTypeComplex(classifierName, featureName);
		var isTypeCollection = isFeaturesTypeACollection(classifierName, featureName);

		if (isTypeComplex) {
			returnTypeInfo = new ReturnTypeInfo(metamodelName, typeName);
		} 
		else {
			// the return type is primitive
			returnTypeInfo = new ReturnTypeInfo();
		}

		returnTypeInfo.isTypeCollection = isTypeCollection;
		return returnTypeInfo;
	}

	/**
	 * Gets the type name of the feature.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the type name of the feature
	 */
	def private String getTypeNameOfFeature(String classifierName, String featureName) {
		var structuralFeature = getFeature(classifierName, featureName);
		if (structuralFeature == null) {
			// The structural feature couldn't be found. One possibility is that
			// the element is not defined in this classifier but in a subtype of it.
			// There is also the possibility that multiple subtypes exists with the same element name
			// but different types and therefore the type of the element is ambiguous
			return null;
		}

		// the classifier name of the metamodel is unambigiuous
		var typeClassifier = structuralFeature.getEType
		return typeClassifier.name;
	}

	/**
	 * Gets all the possible return type infos of the feature.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return all the possible return type infos of the feature
	 */
	def private List<PossibleReturnTypeInfo> getAllPossibleReturnTypeInfosOfFeature(String classifierName,
		String featureName) {
		val possibleReurnTypeInfos = new ArrayList<PossibleReturnTypeInfo>();

		// This function should be called if:
		// the type is ambiguous.
		// the element is defined in a sub type of the classifier and not in the classifier itself or a super type of it.
		var typeInfo = getTypeInfo(classifierName);
		for (subTypeInfo : typeInfo.subTypeInfos) {
			var subTypeName = getTypeNameOfFeature(subTypeInfo.name, featureName);

			// we have to check if the type of the element exists and if it is already in the list. 
			// The element could be defined in a sub type of a sub type of the classifier so 
			// we would find the element in the sub and sub sub type
			if (subTypeName != null && !possibleReurnTypeInfos.contains(subTypeName)) {
				possibleReurnTypeInfos.add(new PossibleReturnTypeInfo(metamodelName, subTypeName, subTypeInfo.name));
			}
		}

		return possibleReurnTypeInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#getAllTypeInfosThatContainFeatureWithType
	 */
	override List<TypeInfo> getAllTypeInfosThatContainFeatureWithType(String containingFeatureType) {
		// we are looking for all classifier that contain a structural feature with a specific type
		val possibleTypeInfos = new ArrayList<TypeInfo>();

		for (eClassifier : mainPackage.getEClassifiers) {
			var eClass = eClassifier as EClassImpl;
			if (eClass != null) {
				// the structural feature list contains also all inherited structural features from super types
				var containsRequiredFeature = eClass.getEAllStructuralFeatures.exists [ structuralFeature |
					structuralFeature.getEType.name.equals(containingFeatureType);
				]

				if (containsRequiredFeature) {
					var typeInfo = getTypeInfo(eClass.name);
					possibleTypeInfos.add(typeInfo);
				}
			}
		}

		return possibleTypeInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#isFeaturesTypeComplex
	 */
	override Boolean isFeaturesTypeComplex(String classifierName, String featureName) {
		var structuralFeature = getFeature(classifierName, featureName);
		if (structuralFeature == null) {
			throw new IllegalArgumentException("The element " + featureName + " was not found in the classifier " +
				classifierName)
		}

		if (structuralFeature instanceof EReferenceImpl) {
			return true;
		} 
		else {
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.EcoreAnalyzer#isFeaturesTypeACollection
	 */
	override Boolean isFeaturesTypeACollection(String classifierName, String featureName) {
		var structuralFeature = getFeature(classifierName, featureName);
		if (structuralFeature == null) {
			throw new IllegalArgumentException("The element " + featureName + " was not found in the classifier " +
				classifierName)
		}

		// the default value of the upper bound is 1
		// it is a collection if the upper bound is unequal 1
		if (structuralFeature.upperBound != 1) {
			return true;
		}

		return false;
	}

	/**
	 * Gets the feature.
	 * 
	 * @param classifierName
	 *            the classifier name
	 * @param featureName
	 *            the feature name
	 * @return the feature
	 */
	def private EStructuralFeature getFeature(String classifierName, String featureName) {
		var eClassifier = mainPackage.getEClassifiers.findFirst [
			it.name.equals(classifierName);
		]
		var eClass = eClassifier as EClassImpl;

		// the structural feature list contains also all inherited structural features from super types
		var structuralFeature = eClass.getEAllStructuralFeatures.findFirst [
			it.name.equals(featureName);
		]

		return structuralFeature;
	}
}
