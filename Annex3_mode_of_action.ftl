<!-- APPENDIX: Information on MOA -->

<#list studyandsummaryCom.modeOfActionRepeatedDosesToxicity as summary>	
	<para xml:id="${summary.documentKey.uuid!}"></para>
	<#if summary?has_content>
		<para><emphasis role="bold">Section 5.6.3: <@nameOfSummary summary/></emphasis></para>
		<para><emphasis role="underline">Detailed information on mode of action / Human relevance framework: </emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.ModeOfActionAnalysisHumanRelevanceFramework.ModeOfActionAnalysis/>
		<@com.emptyLine/>
	</#if>
</#list>

<#list studyandsummaryCom.modeOfActionsOthersGenetic as summary>
	<para xml:id="${summary.documentKey.uuid!}"></para>	
	<#if summary?has_content>
		<para><emphasis role="bold">Section 5.7.3: <@nameOfSummary summary/></emphasis></para>
		<para><emphasis role="underline">Detailed information on mode of action / Human relevance framework: </emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.MoAHumanRelevanceFramework.MoAHumanRelevanceFramework/>
		<@com.emptyLine/>
	</#if>
</#list>

<#list studyandsummaryCom.modeOfActionsOthersCarcinogenicity as summary>
	<para xml:id="${summary.documentKey.uuid!}"></para>	
	<#if summary?has_content>
		<para><emphasis role="bold">Section 5.8.3: <@nameOfSummary summary/></emphasis></para>
		<para><emphasis role="underline">Detailed information on mode of action / Human relevance framework: </emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.MoAHumanRelevanceFramework.MoAHumanRelevanceFramework/>
		<@com.emptyLine/>
	</#if>
</#list>

<#list studyandsummaryCom.modeOfActionsOthersReproductiveTox as summary>
	<para xml:id="${summary.documentKey.uuid!}"></para>
	<#if summary?has_content>
		<para><emphasis role="bold">Section 5.9.3: <@nameOfSummary summary/></emphasis></para>
		<para><emphasis role="underline">Detailed information on mode of action / Human relevance framework: </emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.MoAAnalysisHumanRelevanceFramework.MoAAnalysisHumanRelevanceFramework/>
		<@com.emptyLine/>
	</#if>
</#list>

<#macro nameOfSummary summary printName=true>
	<#if printName>
		<@com.text summary.name/>
	</#if>	
</#macro>