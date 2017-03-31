package edu.kit.ipd.sdq.atl2nmfs.helper

import com.google.inject.Inject
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.MetamodelInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.ReturnTypeInfo
import java.util.Arrays
import java.util.List
import org.apache.commons.lang.NotImplementedException
import org.eclipse.emf.common.util.EList
import org.eclipse.m2m.atl.common.ATL.SimpleInPatternElement
import org.eclipse.m2m.atl.common.ATL.SimpleOutPatternElement
import org.eclipse.m2m.atl.common.OCL.BooleanExp
import org.eclipse.m2m.atl.common.OCL.BooleanType
import org.eclipse.m2m.atl.common.OCL.EnumLiteralExp
import org.eclipse.m2m.atl.common.OCL.IfExp
import org.eclipse.m2m.atl.common.OCL.IntegerExp
import org.eclipse.m2m.atl.common.OCL.IntegerType
import org.eclipse.m2m.atl.common.OCL.Iterator
import org.eclipse.m2m.atl.common.OCL.IteratorExp
import org.eclipse.m2m.atl.common.OCL.NavigationOrAttributeCallExp
import org.eclipse.m2m.atl.common.OCL.OclExpression
import org.eclipse.m2m.atl.common.OCL.OclModelElement
import org.eclipse.m2m.atl.common.OCL.OperationCallExp
import org.eclipse.m2m.atl.common.OCL.OperatorCallExp
import org.eclipse.m2m.atl.common.OCL.RealExp
import org.eclipse.m2m.atl.common.OCL.RealType
import org.eclipse.m2m.atl.common.OCL.StringExp
import org.eclipse.m2m.atl.common.OCL.StringType
import org.eclipse.m2m.atl.common.OCL.VariableDeclaration
import org.eclipse.m2m.atl.common.OCL.VariableExp
import org.apache.commons.lang.StringUtils
import org.eclipse.emf.ecore.impl.EClassImpl
import org.eclipse.m2m.atl.common.OCL.SetExp
import org.eclipse.m2m.atl.common.OCL.OclUndefinedExp

/**
 * The OclReturnTypeAnalyzerImpl Class.
 */
class OclReturnTypeAnalyzerImpl implements OclReturnTypeAnalyzer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	// TODO: use the passed type whenever the operation 'oclIsKindOf' is used since the return type is limited to this type. 
	// At the moment it is only considered in combination with the select iterator
	// TODO: Support: writeTo, println, refGetValue, refImmediateComposite, refInvokeOperation
	// this is a list with all ATL OCL operations which return type is dependent of the type of the source on which the operation is called
	private static final List<String> operationsWithComplexReturnType = Arrays.asList("debug", "refSetValue", "union",
		"flatten", "append", "prepend", "insertAt", "subSequence", "at", "first", "last", "including", "excluding",
		"intersection", "symetricDifference", "subOrderedSet", "asSequence", "asSet", "asBag");

	// this is a list with all ATL OCL operations which return type is a collection (set, orderedSet, bag or sequence)
	private static final List<String> operationsWithCollectionReturnType = Arrays.asList("asSequence", "asSet", "asBag",
		"split", "toSequence", "union", "flatten", "append", "prepend", "insertAt", "subSequence", "including",
		"excluding", "intersection", "operator", "symetricDifference", "subOrderedSet");

	// this is a list with all ATL OCL iterator expressions which return type is a collection (set, orderedSet, bag or sequence)
	private static final List<String> iteratorsWithCollectionReturnType = Arrays.asList("collect", "select", "reject",
		"sortedBy");

	private List<MetamodelInfo> inputMetamodelInfos;

	/**
	 * Class constructor.
	 * 
	 * @param atl2NmfSHelper
	 *            the atl2nmfS helper
	 */
	@Inject
	new(Atl2NmfSHelper atl2NmfSHelper) {
		this.atl2NmfSHelper = atl2NmfSHelper;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.OclReturnTypeAnalyzer#initialize
	 */
	override void initialize(List<MetamodelInfo> inputMetamodelInfos) {
		// the OCL expressions are only using input metamodel elements therefore
		// we only need the input metamodel infos to be able to infer the return types
		this.inputMetamodelInfos = inputMetamodelInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.OclReturnTypeAnalyzer#getReturnTypeInfo
	 */
	override ReturnTypeInfo getReturnTypeInfo(OclExpression expression) {
		// we are only interested in metamodel types
		// we don't need to determine the exact simple type like string or something similar
		// because we don't have to call a rule for a simple type but we need the correct metamodel type
		// to choose the right rule. So in case of a simple type we just return null
		return analyze(expression);
	}

	/**
	 * The double dispatch function indicating that no overloaded function was found.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(OclExpression expression) {
		// is called when no specific dispatch function for the expression type is implemented
		throw new NotImplementedException("No analyze dispatch function for the type " + expression.class.name +
			" implemented");
	}
	
	def private dispatch ReturnTypeInfo analyze(OclUndefinedExp undefined) {
		return new ReturnTypeInfo();
	}
	
	def private dispatch ReturnTypeInfo analyze(SetExp setExpression) {
		if (setExpression.elements.size == 0) return null;
		var inner = analyze(setExpression.elements.get(0));
		inner.isTypeCollection = true;
		return inner;
	}

	/**
	 * The double dispatch function to analyze a Void expression.
	 * 
	 * @param v
	 *            the void expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(Void v) {
		// called if the parameter is null
		return null;
	}

	/**
	 * The double dispatch function to analyze an EList<OclExpression>.
	 * 
	 * @param expressions
	 *            the OCL expressions
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(EList<OclExpression> expressions) {
		// TODO: support multiple elements
		if (expressions.size > 1) {
			throw new NotImplementedException("OCL Expression Lists with multiple expressions are not supported yet")
		} 
		else if (expressions.size == 0) {
			return null;
		}

		return analyze(expressions.get(0));
	}

	/**
	 * The double dispatch function to analyze an OperatorCallExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(OperatorCallExp expression) {
		var sourceReturnTypeInfo = analyze(expression.source);
		var argumentReturnTypeInfo = analyze(expression.arguments);

		if (sourceReturnTypeInfo.typePrimitive && argumentReturnTypeInfo.typePrimitive) {
			// the return type is primitive
			return new ReturnTypeInfo();
		} // Operator is used with at least one complex type
		else if (expression.operationName.equals("=") || expression.operationName.equals("<>")) {
			// the return type is primitive (in this case of type boolean)
			return new ReturnTypeInfo();
		} 
		else {
			throw new NotImplementedException(
				"The determination of the return Type of an OperatorCallExp where the operator is not '=' or '<>' and at least one argument is a complex type is not implemented yet");
		}
	}

	/**
	 * The double dispatch function to analyze an IfExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(IfExp expression) {
		var thenExpressionReturnTypeInfo = analyze(expression.thenExpression);
		var elseExpressionReturnTypeInfo = analyze(expression.elseExpression);
		
		if (expression.thenExpression instanceof OclUndefinedExp) {
			return elseExpressionReturnTypeInfo;
		}
		
		if (expression.elseExpression instanceof OclUndefinedExp) {
			return thenExpressionReturnTypeInfo;
		}

		if (thenExpressionReturnTypeInfo.typePrimitive && elseExpressionReturnTypeInfo.typePrimitive) {
			// the return type is primitive
			return new ReturnTypeInfo();
		} 
		else if (thenExpressionReturnTypeInfo.getTypeName.equals(elseExpressionReturnTypeInfo.getTypeName) &&
			thenExpressionReturnTypeInfo.getIsTypeCollection == elseExpressionReturnTypeInfo.getIsTypeCollection) {
			// both return types are equal so we just return one of them
			return thenExpressionReturnTypeInfo;
		} 
		else {
			throw new NotImplementedException(
				"The determination of the return Type of an IfExpression where the 'then' and 'else' return types are not equal is not implemented yet");
		}
	}

	/**
	 * The double dispatch function to analyze an OperationCallExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(OperationCallExp expression) {
		var ReturnTypeInfo returnTypeInfo = null;

		// check if the called operation is a functional helper
		if (atl2NmfSHelper.isFunctionalHelper(expression.operationName)) {
			var helperInfo = atl2NmfSHelper.getFunctionalHelperInfo(expression.operationName);
			if (helperInfo.returnTypePrimitive) {
				// the return type is primitive
				returnTypeInfo = new ReturnTypeInfo();
			} 
			else {
				var isClass = atl2NmfSHelper.findClassifier(helperInfo.returnTypeMetamodelName, helperInfo.returnTypeName) != null;
				returnTypeInfo = new ReturnTypeInfo(helperInfo.returnTypeMetamodelName, helperInfo.getReturnTypeName, isClass);
			}
		} // check if the called operation is a lazy or a unique lazy rule
		else if (atl2NmfSHelper.isLazyRule(expression.operationName)) {
			var lazyRuleInfo = atl2NmfSHelper.getRuleInfo(expression.operationName);
			var argumentsReturnTypeInfo = analyze(expression.arguments);
			returnTypeInfo = new ReturnTypeInfo(lazyRuleInfo, argumentsReturnTypeInfo);
		} 
		else if ("allInstances".equals(expression.operationName)) {
			var classifier = expression.source as OclModelElement;
			returnTypeInfo = new ReturnTypeInfo(classifier.model.name, classifier.name, true);
		}
		else {
			// an OCL operation is called
			// check if the return type of the operation is complex or not
			if (operationsWithComplexReturnType.contains(expression.operationName)) {
				// these operations have a return type which is dependent of the type of the source on which the operation is called
				returnTypeInfo = analyze(expression.source);
			} 
			else {
				// all other operations have a primitive return type like boolean or string
				returnTypeInfo = new ReturnTypeInfo();
			}

			// check if the operation returns a collection or not
			var isTypeCollection = operationsWithCollectionReturnType.contains(expression.operationName);
			returnTypeInfo.isTypeCollection = isTypeCollection;
		}

		return returnTypeInfo;
	}

	/**
	 * The double dispatch function to analyze an IteratorExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(IteratorExp expression) {
		var ReturnTypeInfo returnTypeInfo = null;
		if (expression.name.equals("select")) {
			// select returns an element or a collection of elements with the type of the element type of the source collection
			// special case: "select(c | c.oclIsKindOf(X!Y))"
			// in such a case it returns an element or a collection of elements with the type Y
			if (expression.body instanceof OperationCallExp) {
				var operationBodyExpression = expression.body as OperationCallExp;

				if (operationBodyExpression.operationName.equals("oclIsKindOf") && operationBodyExpression.source instanceof VariableExp) {
					var operationReturnTypeInfo = analyze(operationBodyExpression.arguments);
					var sourceReturnTypeInfo = analyze(expression.source);

					// we have to return the operation return type but have to use the isCollection variable of the source return type or it would be always false
					operationReturnTypeInfo.isTypeCollection = sourceReturnTypeInfo.getIsTypeCollection;
					return operationReturnTypeInfo;
				}
			}

			returnTypeInfo = analyze(expression.source);
		} 
		else if (expression.name.equals("any") || expression.name.equals("reject") ||
			expression.name.equals("sortedBy")) {

			// these iterators return an element or a collection of elements with the type of the element type of the source collection
			returnTypeInfo = analyze(expression.source);
		} 
		else if (expression.name.equals("collect")) {
			// returns a collection of elements which results in applying body to each element of the source collection
			// so we have to return the type of the body expression
			returnTypeInfo = analyze(expression.body);
		} 
		else {
			// all other iterator types like exists, forAll, ... return a boolean value
			returnTypeInfo = new ReturnTypeInfo();
		}

		// check if the iteration returns a collection or not
		var isTypeCollection = iteratorsWithCollectionReturnType.contains(expression.name);
		returnTypeInfo.setIsTypeCollection(isTypeCollection);

		return returnTypeInfo;
	}

	/**
	 * The double dispatch function to analyze a NavigationOrAttributeCallExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(NavigationOrAttributeCallExp expression) {
		var elementName = expression.name;

		// before we transform the source expression we have to check if an attribute helper is called
		if (atl2NmfSHelper.isAttributeHelper(elementName)) {
			// the attribute is an attribute helper
			var helperInfo = atl2NmfSHelper.getAttributeHelperInfo(elementName);

			if (helperInfo.returnTypePrimitive) {
				return new ReturnTypeInfo();
			} 
			else {
				var isClass = atl2NmfSHelper.findClassifier(helperInfo.returnTypeMetamodelName, helperInfo.returnTypeName) != null;
				return new ReturnTypeInfo(helperInfo.returnTypeMetamodelName, helperInfo.returnTypeName, isClass)
			}
		}

		val classifierReturnTypeInfo = analyze(expression.source);
		if (classifierReturnTypeInfo.typePrimitive || StringUtils.isBlank(elementName)) {
			// in case of a simple type is the classifier name null
			throw new IllegalArgumentException(
				"The classifier or the element name of a NavigationOrAttributeCallExp was null");
		}

		var metamodelInfo = inputMetamodelInfos.findFirst[it.name.equals(classifierReturnTypeInfo.metamodelName)];
		var returnTypeInfo = metamodelInfo.ecoreAnalyzer.getReturnTypeInfoOfFeature(
			classifierReturnTypeInfo.getTypeName, elementName);

		return returnTypeInfo;
	}

	/**
	 * The double dispatch function to analyze a VariableExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(VariableExp expression) {
		// calls SimpleInPatternElement, SimpleOutPatternElement or Iterator
		return analyze(expression.referredVariable);
	}

	/**
	 * The double dispatch function to analyze a VariableDeclaration.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(VariableDeclaration expression) {
		return analyze(expression.initExpression);
	}

	/**
	 * The double dispatch function to analyze a SimpleInPatternElement.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(SimpleInPatternElement expression) {
		return analyze(expression.type);
	}

	/**
	 * The double dispatch function to analyze a SimpleOutPatternElement.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(SimpleOutPatternElement expression) {
		// When analyzing the OCL return type from an expression of the input side and an SimpleOutPatternElement 
		// is analyzed it means that another target pattern element is referenced in the expression
		var returnTypeInfo = analyze(expression.type);
		returnTypeInfo.usageOfAnotherOutputPatternElement = true;
		returnTypeInfo.nameOfTheReferencedOutputPatternElement = expression.varName;
		return returnTypeInfo;
	}

	/**
	 * The double dispatch function to analyze an Iterator.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(Iterator expression) {
		// we want the type of the elements of the collection the iterator was called on
		var container = expression.eContainer;
		var iteratorExp = container as IteratorExp;

		return analyze(iteratorExp.source);
	}

	/**
	 * The double dispatch function to analyze a BooleanExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(BooleanExp expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze a StringExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(StringExp expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze an EnumLiteralExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(EnumLiteralExp expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze an IntegerExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(IntegerExp expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze a RealExp.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(RealExp expression) {
		// the return type is primitive		
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze an OclModelElement.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(OclModelElement expression) {
		var metamodelName = expression.model.name;
		var isClass = atl2NmfSHelper.findClassifier(metamodelName, expression.name) != null;
		return new ReturnTypeInfo(metamodelName, expression.name, isClass);
	}

	/**
	 * The double dispatch function to analyze a BooleanType.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(BooleanType expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze an IntegerType.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(IntegerType expression) {
		// the return type is primitive	
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze a RealType.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(RealType expression) {
		// the return type is primitive		
		return new ReturnTypeInfo();
	}

	/**
	 * The double dispatch function to analyze a StringType.
	 * 
	 * @param expression
	 *            the OCL expression
	 * @return the inferred return type info
	 */
	def private dispatch ReturnTypeInfo analyze(StringType expression) {
		// the return type is primitive
		return new ReturnTypeInfo();
	}
}
