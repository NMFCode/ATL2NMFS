package edu.kit.ipd.sdq.atl2nmfs.helper

import com.google.inject.Inject
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleInfo
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.RuleType
import edu.kit.ipd.sdq.atl2nmfs.helper.infos.TypeInfo
import java.util.ArrayList
import java.util.List
import org.apache.commons.lang.NotImplementedException
import org.eclipse.m2m.atl.common.ATL.LazyMatchedRule
import org.eclipse.m2m.atl.common.ATL.MatchedRule
import org.eclipse.m2m.atl.common.ATL.Module

/**
 * The AtlRuleAnalyzerImpl Class.
 */
class AtlRuleAnalyzerImpl implements AtlRuleAnalyzer {
	private final Atl2NmfSHelper atl2NmfSHelper;

	private List<RuleInfo> ruleInfos;

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
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer#analyzeRules
	 */
	override void analyzeRules(Module atlModule) {
		ruleInfos = new ArrayList<RuleInfo>();

		// retrieve the matched rules (matched, lazyMatched and uniqueLazyMatched)
		// since called rules are an imperative construct we don't support them
		for (element : atlModule.elements) {
			if (element instanceof MatchedRule) {
				// lazy matched rules and unique lazy matched rules are represented by the LayzMatchedRule class
				// which is a subclass of the MatchedRule class. Therefore they can be treated as matched rules				
				analyzeMatchedRule(element);
			}
		}
	}

	/**
	 * Analyze the passed matched rule.
	 * 
	 * @param matchedRule
	 *            the matched rule
	 */
	def private void analyzeMatchedRule(MatchedRule matchedRule) {
		if (matchedRule.inPattern.elements.size > 1) {
			throw new NotImplementedException("Multiple Input Patterns for an ATL Rule are not supported yet");
		}

		// initialize the type of the rule
		var RuleType ruleType;
		if (matchedRule instanceof LazyMatchedRule) {
			val lazyMatchedRule = matchedRule as LazyMatchedRule;
			if (lazyMatchedRule.isIsUnique) {
				ruleType = RuleType.UNIQUELAZYMATCHED;
			} 
			else {
				ruleType = RuleType.LAZYMATCHED;
			}
		} 
		else {
			ruleType = RuleType.MATCHED;
		}

		var ruleInfo = new RuleInfo(atl2NmfSHelper, matchedRule, ruleType);
		ruleInfos.add(ruleInfo);
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer#isLazyRule
	 */
	override Boolean isLazyRule(String ruleName) {
		return ruleInfos.exists[it.ruleType != RuleType.MATCHED && it.name.equals(ruleName)];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer#getAllRuleInfos
	 */
	override List<RuleInfo> getAllRuleInfos() {
		return ruleInfos;
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer#getRuleInfo
	 */
	override RuleInfo getRuleInfo(String ruleName) {
		return ruleInfos.findFirst[it.getName.equals(ruleName)];
	}

	/* (non-Javadoc)
	 * @see edu.kit.ipd.sdq.atl2nmfs.helper.AtlRuleAnalyzer#getPossibleRuleInfosForInputTypeInfo
	 */
	override List<RuleInfo> getPossibleRuleInfosForInputTypeInfo(TypeInfo inputTypeInfo) {
		val possibleRuleInfos = new ArrayList<RuleInfo>();

		// we have to return all rules who match the input type and also all rules who match a sub type of the input type 
		val foundRuleInfos = getPossibleRulesForInputType(inputTypeInfo.name);
		possibleRuleInfos.addAll(foundRuleInfos);

		for (subTypeInfo : inputTypeInfo.subTypeInfos) {
			val foundSubTypeRuleInfos = getPossibleRulesForInputType(subTypeInfo.name);
			possibleRuleInfos.addAll(foundSubTypeRuleInfos);
		}

		return possibleRuleInfos;
	}

	/**
	 * Gets the possible rules for the passed input type.
	 * 
	 * @param inputType
	 *            the input type
	 * @return the possible rules for the passed input type
	 */
	def private List<RuleInfo> getPossibleRulesForInputType(String inputType) {
		// only matched rules are considered since lazy matched rules and unique lazy matched rules
		// have to be called directly and therefore must be excluded here
		var possibleRuleInfos = ruleInfos.filter [ ruleInfo |
			ruleInfo.getInputTypeName == inputType && ruleInfo.ruleType == RuleType.MATCHED
		].toList;

		return possibleRuleInfos;
	}
}
