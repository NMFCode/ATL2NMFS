<?xml version = '1.0' encoding = 'ISO-8859-1' ?>
<asm version="1.0" name="0">
	<cp>
		<constant value="A2BMultipleInput"/>
		<constant value="links"/>
		<constant value="NTransientLinkSet;"/>
		<constant value="col"/>
		<constant value="J"/>
		<constant value="main"/>
		<constant value="A"/>
		<constant value="OclParametrizedType"/>
		<constant value="#native"/>
		<constant value="Collection"/>
		<constant value="J.setName(S):V"/>
		<constant value="OclSimpleType"/>
		<constant value="OclAny"/>
		<constant value="J.setElementType(J):V"/>
		<constant value="TransientLinkSet"/>
		<constant value="A.__matcher__():V"/>
		<constant value="A.__exec__():V"/>
		<constant value="self"/>
		<constant value="__resolve__"/>
		<constant value="1"/>
		<constant value="J.oclIsKindOf(J):B"/>
		<constant value="18"/>
		<constant value="NTransientLinkSet;.getLinkBySourceElement(S):QNTransientLink;"/>
		<constant value="J.oclIsUndefined():B"/>
		<constant value="15"/>
		<constant value="NTransientLink;.getTargetFromSource(J):J"/>
		<constant value="17"/>
		<constant value="30"/>
		<constant value="Sequence"/>
		<constant value="2"/>
		<constant value="A.__resolve__(J):J"/>
		<constant value="QJ.including(J):QJ"/>
		<constant value="QJ.flatten():QJ"/>
		<constant value="e"/>
		<constant value="value"/>
		<constant value="resolveTemp"/>
		<constant value="S"/>
		<constant value="NTransientLink;.getNamedTargetFromSource(JS):J"/>
		<constant value="name"/>
		<constant value="__matcher__"/>
		<constant value="A.__matchRuleA():V"/>
		<constant value="A.__matchRuleB():V"/>
		<constant value="A.__matchRuleC():V"/>
		<constant value="__exec__"/>
		<constant value="RuleA"/>
		<constant value="NTransientLinkSet;.getLinksByRule(S):QNTransientLink;"/>
		<constant value="A.__applyRuleA(NTransientLink;):V"/>
		<constant value="RuleB"/>
		<constant value="A.__applyRuleB(NTransientLink;):V"/>
		<constant value="RuleC"/>
		<constant value="A.__applyRuleC(NTransientLink;):V"/>
		<constant value="__matchRuleA"/>
		<constant value="TypeA"/>
		<constant value="IN1"/>
		<constant value="MMOF!Classifier;.allInstancesFrom(S):QJ"/>
		<constant value="TransientLink"/>
		<constant value="NTransientLink;.setRule(MATL!Rule;):V"/>
		<constant value="s"/>
		<constant value="NTransientLink;.addSourceElement(SJ):V"/>
		<constant value="t"/>
		<constant value="TypeB"/>
		<constant value="NTransientLink;.addTargetElement(SJ):V"/>
		<constant value="NTransientLinkSet;.addLink2(NTransientLink;B):V"/>
		<constant value="12:3-15:4"/>
		<constant value="__applyRuleA"/>
		<constant value="NTransientLink;"/>
		<constant value="NTransientLink;.getSourceElement(S):J"/>
		<constant value="NTransientLink;.getTargetElement(S):J"/>
		<constant value="3"/>
		<constant value="OUT_"/>
		<constant value="nameA"/>
		<constant value="J.+(J):J"/>
		<constant value="elms"/>
		<constant value="13:12-13:18"/>
		<constant value="13:21-13:22"/>
		<constant value="13:21-13:28"/>
		<constant value="13:12-13:28"/>
		<constant value="13:4-13:28"/>
		<constant value="14:12-14:13"/>
		<constant value="14:12-14:18"/>
		<constant value="14:4-14:18"/>
		<constant value="link"/>
		<constant value="__matchRuleB"/>
		<constant value="B"/>
		<constant value="22:3-25:4"/>
		<constant value="__applyRuleB"/>
		<constant value="nameB"/>
		<constant value="23:12-23:18"/>
		<constant value="23:21-23:22"/>
		<constant value="23:21-23:28"/>
		<constant value="23:12-23:28"/>
		<constant value="23:4-23:28"/>
		<constant value="24:12-24:13"/>
		<constant value="24:12-24:18"/>
		<constant value="24:4-24:18"/>
		<constant value="__matchRuleC"/>
		<constant value="CElement"/>
		<constant value="TypeC"/>
		<constant value="IN2"/>
		<constant value="C"/>
		<constant value="32:3-34:4"/>
		<constant value="__applyRuleC"/>
		<constant value="elementName"/>
		<constant value="33:12-33:18"/>
		<constant value="33:21-33:22"/>
		<constant value="33:21-33:34"/>
		<constant value="33:12-33:34"/>
		<constant value="33:4-33:34"/>
	</cp>
	<field name="1" type="2"/>
	<field name="3" type="4"/>
	<operation name="5">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<getasm/>
			<push arg="7"/>
			<push arg="8"/>
			<new/>
			<dup/>
			<push arg="9"/>
			<pcall arg="10"/>
			<dup/>
			<push arg="11"/>
			<push arg="8"/>
			<new/>
			<dup/>
			<push arg="12"/>
			<pcall arg="10"/>
			<pcall arg="13"/>
			<set arg="3"/>
			<getasm/>
			<push arg="14"/>
			<push arg="8"/>
			<new/>
			<set arg="1"/>
			<getasm/>
			<pcall arg="15"/>
			<getasm/>
			<pcall arg="16"/>
		</code>
		<linenumbertable>
		</linenumbertable>
		<localvariabletable>
			<lve slot="0" name="17" begin="0" end="24"/>
		</localvariabletable>
	</operation>
	<operation name="18">
		<context type="6"/>
		<parameters>
			<parameter name="19" type="4"/>
		</parameters>
		<code>
			<load arg="19"/>
			<getasm/>
			<get arg="3"/>
			<call arg="20"/>
			<if arg="21"/>
			<getasm/>
			<get arg="1"/>
			<load arg="19"/>
			<call arg="22"/>
			<dup/>
			<call arg="23"/>
			<if arg="24"/>
			<load arg="19"/>
			<call arg="25"/>
			<goto arg="26"/>
			<pop/>
			<load arg="19"/>
			<goto arg="27"/>
			<push arg="28"/>
			<push arg="8"/>
			<new/>
			<load arg="19"/>
			<iterate/>
			<store arg="29"/>
			<getasm/>
			<load arg="29"/>
			<call arg="30"/>
			<call arg="31"/>
			<enditerate/>
			<call arg="32"/>
		</code>
		<linenumbertable>
		</linenumbertable>
		<localvariabletable>
			<lve slot="2" name="33" begin="23" end="27"/>
			<lve slot="0" name="17" begin="0" end="29"/>
			<lve slot="1" name="34" begin="0" end="29"/>
		</localvariabletable>
	</operation>
	<operation name="35">
		<context type="6"/>
		<parameters>
			<parameter name="19" type="4"/>
			<parameter name="29" type="36"/>
		</parameters>
		<code>
			<getasm/>
			<get arg="1"/>
			<load arg="19"/>
			<call arg="22"/>
			<load arg="19"/>
			<load arg="29"/>
			<call arg="37"/>
		</code>
		<linenumbertable>
		</linenumbertable>
		<localvariabletable>
			<lve slot="0" name="17" begin="0" end="6"/>
			<lve slot="1" name="34" begin="0" end="6"/>
			<lve slot="2" name="38" begin="0" end="6"/>
		</localvariabletable>
	</operation>
	<operation name="39">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<getasm/>
			<pcall arg="40"/>
			<getasm/>
			<pcall arg="41"/>
			<getasm/>
			<pcall arg="42"/>
		</code>
		<linenumbertable>
		</linenumbertable>
		<localvariabletable>
			<lve slot="0" name="17" begin="0" end="5"/>
		</localvariabletable>
	</operation>
	<operation name="43">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<getasm/>
			<get arg="1"/>
			<push arg="44"/>
			<call arg="45"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<load arg="19"/>
			<pcall arg="46"/>
			<enditerate/>
			<getasm/>
			<get arg="1"/>
			<push arg="47"/>
			<call arg="45"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<load arg="19"/>
			<pcall arg="48"/>
			<enditerate/>
			<getasm/>
			<get arg="1"/>
			<push arg="49"/>
			<call arg="45"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<load arg="19"/>
			<pcall arg="50"/>
			<enditerate/>
		</code>
		<linenumbertable>
		</linenumbertable>
		<localvariabletable>
			<lve slot="1" name="33" begin="5" end="8"/>
			<lve slot="1" name="33" begin="15" end="18"/>
			<lve slot="1" name="33" begin="25" end="28"/>
			<lve slot="0" name="17" begin="0" end="29"/>
		</localvariabletable>
	</operation>
	<operation name="51">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<push arg="6"/>
			<push arg="52"/>
			<findme/>
			<push arg="53"/>
			<call arg="54"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<get arg="1"/>
			<push arg="55"/>
			<push arg="8"/>
			<new/>
			<dup/>
			<push arg="44"/>
			<pcall arg="56"/>
			<dup/>
			<push arg="57"/>
			<load arg="19"/>
			<pcall arg="58"/>
			<dup/>
			<push arg="59"/>
			<push arg="6"/>
			<push arg="60"/>
			<new/>
			<pcall arg="61"/>
			<pusht/>
			<pcall arg="62"/>
			<enditerate/>
		</code>
		<linenumbertable>
			<lne id="63" begin="19" end="24"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="1" name="57" begin="6" end="26"/>
			<lve slot="0" name="17" begin="0" end="27"/>
		</localvariabletable>
	</operation>
	<operation name="64">
		<context type="6"/>
		<parameters>
			<parameter name="19" type="65"/>
		</parameters>
		<code>
			<load arg="19"/>
			<push arg="57"/>
			<call arg="66"/>
			<store arg="29"/>
			<load arg="19"/>
			<push arg="59"/>
			<call arg="67"/>
			<store arg="68"/>
			<load arg="68"/>
			<dup/>
			<getasm/>
			<push arg="69"/>
			<load arg="29"/>
			<get arg="70"/>
			<call arg="71"/>
			<call arg="30"/>
			<set arg="38"/>
			<dup/>
			<getasm/>
			<load arg="29"/>
			<get arg="72"/>
			<call arg="30"/>
			<set arg="72"/>
			<pop/>
		</code>
		<linenumbertable>
			<lne id="73" begin="11" end="11"/>
			<lne id="74" begin="12" end="12"/>
			<lne id="75" begin="12" end="13"/>
			<lne id="76" begin="11" end="14"/>
			<lne id="77" begin="9" end="16"/>
			<lne id="78" begin="19" end="19"/>
			<lne id="79" begin="19" end="20"/>
			<lne id="80" begin="17" end="22"/>
			<lne id="63" begin="8" end="23"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="3" name="59" begin="7" end="23"/>
			<lve slot="2" name="57" begin="3" end="23"/>
			<lve slot="0" name="17" begin="0" end="23"/>
			<lve slot="1" name="81" begin="0" end="23"/>
		</localvariabletable>
	</operation>
	<operation name="82">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<push arg="83"/>
			<push arg="52"/>
			<findme/>
			<push arg="53"/>
			<call arg="54"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<get arg="1"/>
			<push arg="55"/>
			<push arg="8"/>
			<new/>
			<dup/>
			<push arg="47"/>
			<pcall arg="56"/>
			<dup/>
			<push arg="57"/>
			<load arg="19"/>
			<pcall arg="58"/>
			<dup/>
			<push arg="59"/>
			<push arg="83"/>
			<push arg="60"/>
			<new/>
			<pcall arg="61"/>
			<pusht/>
			<pcall arg="62"/>
			<enditerate/>
		</code>
		<linenumbertable>
			<lne id="84" begin="19" end="24"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="1" name="57" begin="6" end="26"/>
			<lve slot="0" name="17" begin="0" end="27"/>
		</localvariabletable>
	</operation>
	<operation name="85">
		<context type="6"/>
		<parameters>
			<parameter name="19" type="65"/>
		</parameters>
		<code>
			<load arg="19"/>
			<push arg="57"/>
			<call arg="66"/>
			<store arg="29"/>
			<load arg="19"/>
			<push arg="59"/>
			<call arg="67"/>
			<store arg="68"/>
			<load arg="68"/>
			<dup/>
			<getasm/>
			<push arg="69"/>
			<load arg="29"/>
			<get arg="86"/>
			<call arg="71"/>
			<call arg="30"/>
			<set arg="38"/>
			<dup/>
			<getasm/>
			<load arg="29"/>
			<get arg="72"/>
			<call arg="30"/>
			<set arg="72"/>
			<pop/>
		</code>
		<linenumbertable>
			<lne id="87" begin="11" end="11"/>
			<lne id="88" begin="12" end="12"/>
			<lne id="89" begin="12" end="13"/>
			<lne id="90" begin="11" end="14"/>
			<lne id="91" begin="9" end="16"/>
			<lne id="92" begin="19" end="19"/>
			<lne id="93" begin="19" end="20"/>
			<lne id="94" begin="17" end="22"/>
			<lne id="84" begin="8" end="23"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="3" name="59" begin="7" end="23"/>
			<lve slot="2" name="57" begin="3" end="23"/>
			<lve slot="0" name="17" begin="0" end="23"/>
			<lve slot="1" name="81" begin="0" end="23"/>
		</localvariabletable>
	</operation>
	<operation name="95">
		<context type="6"/>
		<parameters>
		</parameters>
		<code>
			<push arg="96"/>
			<push arg="97"/>
			<findme/>
			<push arg="98"/>
			<call arg="54"/>
			<iterate/>
			<store arg="19"/>
			<getasm/>
			<get arg="1"/>
			<push arg="55"/>
			<push arg="8"/>
			<new/>
			<dup/>
			<push arg="49"/>
			<pcall arg="56"/>
			<dup/>
			<push arg="57"/>
			<load arg="19"/>
			<pcall arg="58"/>
			<dup/>
			<push arg="59"/>
			<push arg="99"/>
			<push arg="60"/>
			<new/>
			<pcall arg="61"/>
			<pusht/>
			<pcall arg="62"/>
			<enditerate/>
		</code>
		<linenumbertable>
			<lne id="100" begin="19" end="24"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="1" name="57" begin="6" end="26"/>
			<lve slot="0" name="17" begin="0" end="27"/>
		</localvariabletable>
	</operation>
	<operation name="101">
		<context type="6"/>
		<parameters>
			<parameter name="19" type="65"/>
		</parameters>
		<code>
			<load arg="19"/>
			<push arg="57"/>
			<call arg="66"/>
			<store arg="29"/>
			<load arg="19"/>
			<push arg="59"/>
			<call arg="67"/>
			<store arg="68"/>
			<load arg="68"/>
			<dup/>
			<getasm/>
			<push arg="69"/>
			<load arg="29"/>
			<get arg="102"/>
			<call arg="71"/>
			<call arg="30"/>
			<set arg="38"/>
			<pop/>
		</code>
		<linenumbertable>
			<lne id="103" begin="11" end="11"/>
			<lne id="104" begin="12" end="12"/>
			<lne id="105" begin="12" end="13"/>
			<lne id="106" begin="11" end="14"/>
			<lne id="107" begin="9" end="16"/>
			<lne id="100" begin="8" end="17"/>
		</linenumbertable>
		<localvariabletable>
			<lve slot="3" name="59" begin="7" end="17"/>
			<lve slot="2" name="57" begin="3" end="17"/>
			<lve slot="0" name="17" begin="0" end="17"/>
			<lve slot="1" name="81" begin="0" end="17"/>
		</localvariabletable>
	</operation>
</asm>
