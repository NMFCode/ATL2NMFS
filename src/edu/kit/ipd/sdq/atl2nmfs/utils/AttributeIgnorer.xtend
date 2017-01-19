package edu.kit.ipd.sdq.atl2nmfs.utils

import org.xmlunit.diff.ComparisonResult
import org.w3c.dom.Attr
import org.xmlunit.diff.ComparisonType
import org.xmlunit.diff.Comparison
import org.xmlunit.diff.DifferenceEvaluator

/**
 * The AttributeIgnorer Class.
 */
class AttributeIgnorer implements DifferenceEvaluator {
	
	/**
	 * Checks and manipulates the comparison result.
	 *
	 * @param comparison
	 *            the comparison object
	 * @param outcome
	 *            the outcome of the comparison object
	 * @return the comparison result
	 */
    override public ComparisonResult evaluate(Comparison comparison, ComparisonResult outcome) {
        if (outcome == ComparisonResult.EQUAL)
            return outcome;
        
        // ignore namespace prefix differences
        if (comparison.getType().equals(ComparisonType.NAMESPACE_PREFIX))
            return ComparisonResult.EQUAL;

        var controlNode = comparison.getControlDetails().getTarget();

        // ignore xmi version and xsi differences
        if (controlNode instanceof Attr) {
            var attr = controlNode as Attr;
            
            if (attr.getName().equals("xmi:version"))             
            {
                return ComparisonResult.EQUAL;
            }
            
            if (attr.getName().equals("xmlns:xsi"))             
            {
                return ComparisonResult.EQUAL;
            }
        }
        
        return outcome;
    }
	
}