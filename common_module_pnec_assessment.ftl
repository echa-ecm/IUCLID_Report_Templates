<!-- 7.6. PNEC derivation and other hazard conclusions -->

<#macro pnecEnvironmentalStudies _subject>
<section>
	<title role="HEAD-2">PNEC derivation and other hazard conclusions</title>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "EcotoxicologicalInformation") />
	<#if summaryList?has_content>
		<#assign printSummaryName = summaryList?size gt 1 />
		
		<#list summaryList as summary>
			<#if printSummaryName>
				<para><@com.emptyLine/><emphasis role="underline"><@com.text summary.name/></emphasis></para>
			</#if>
			
			<@generateReport summary />
		</#list>
	</#if>
</section>	
</#macro>

<#macro generateReport summary>
	<table border="1">
		<title>Hazard assessment conclusion for the environment</title>
		<col width="15%" />
		<col width="25%" />
		<col width="55%" />
		<tbody>
			<tr>
				<th><?dbfo bgcolor="#FDCE9B" ?><emphasis role="bold">Compartment</emphasis></th>
				<th><?dbfo bgcolor="#FDCE9B" ?><emphasis role="bold">Hazard conclusion</emphasis></th>
				<th><?dbfo bgcolor="#FDCE9B" ?><emphasis role="bold">Remarks/Justification</emphasis></th>
			</tr>
			
			<!-- Freshwater -->
			<tr>
				<!-- Compartment -->
				<td>
					Freshwater
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAquaticOrganisms.Freshwater/>
					<para>
						Intermittent releases: <@com.quantity summary.HazardForAquaticOrganisms.Freshwater.PNECFreshwaterIntermittentReleases/>
					</para>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAquaticOrganisms.Freshwater/>
				</td>
			</tr>
			
			<!-- Marine water -->
			<tr>
				<!-- Compartment -->
				<td>
					Marine water
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAquaticOrganisms.MarineWater/>
					<para>
						Intermittent releases: <@com.quantity summary.HazardForAquaticOrganisms.MarineWater.PNECMarineWaterIntermittentReleases/>
					</para>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAquaticOrganisms.MarineWater/>
				</td>
			</tr>
			
			<!-- Sediments (freshwater) -->
			<tr>
				<!-- Compartment -->
				<td>
					Sediments (freshwater)
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAquaticOrganisms.SedimentFreshWater/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAquaticOrganisms.SedimentFreshWater/>
				</td>
			</tr>
			
			<!-- Sediments (marine water) -->
			<tr>
				<!-- Compartment -->
				<td>
					Sediments (marine water)
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAquaticOrganisms.SedimentMarineWater/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAquaticOrganisms.SedimentMarineWater/>
				</td>
			</tr>
			
			<!-- Sewage treatment plant -->
			<tr>
				<!-- Compartment -->
				<td>
					Sewage treatment plant
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAquaticOrganisms.STP/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAquaticOrganisms.STP/>
				</td>
			</tr>
			
			<!-- Soil -->
			<tr>
				<!-- Compartment -->
				<td>
					Soil
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForTerrestrialOrganisms.Soil/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForTerrestrialOrganisms.Soil/>
				</td>
			</tr>
			
			<!-- Air -->
			<tr>
				<!-- Compartment -->
				<td>
					Air
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForAir.Air/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForAir.Air/>
				</td>
			</tr>
			
			<!-- Secondary poisoning -->
			<tr>
				<!-- Compartment -->
				<td>
					Secondary poisoning
				</td>
				<!-- Hazard conclusion -->
				<td>
					<@hazardConclusion summary.HazardForPredators.SecondaryPoisoning/>
				</td>
				<!-- Remarks/Justification -->
				<td>
					<@hazardRemarks summary.HazardForPredators.SecondaryPoisoning/>
				</td>
			</tr>
				
		</tbody>
	</table>

	<para><emphasis role="underline">Conclusion on environmental classification</emphasis></para>
	
	<@com.richText summary.ConclusionOnClassification.JustificationEnv/>
	
	<#if summary.Discussion.Discussion?has_content>
		<para><emphasis role="underline">General discussion</emphasis></para>
		
		<@com.richText summary.Discussion.Discussion/>
	</#if>
</#macro>

<#macro hazardConclusion hazardConclusionBlock>
<#compress>
	<#if hazardConclusionBlock.HazAssessConcl?has_content || hazardConclusionBlock.HazAssessConclVal?has_content>
		<para>
			<#if hazardConclusionBlock.HazAssessConcl?has_content>
				<@com.picklist hazardConclusionBlock.HazAssessConcl/>: 
			</#if>
			
			<#if hazardConclusionBlock.HazAssessConclVal?has_content>
				<@com.quantity hazardConclusionBlock.HazAssessConclVal/>
			</#if>
		</para>
	</#if>
</#compress>
</#macro>

<#macro hazardRemarks hazardConclusionBlock>
<#compress>
	<#if hazardConclusionBlock.hasElement("AssessmentFactor")>		
		<#if com.picklistValueMatchesPhrases(hazardConclusionBlock.HazAssessConcl, [".*PNEC.*"])>
			<para>
				<#if hazardConclusionBlock.AssessmentFactor?has_content>
				Assessment factor: <@com.number hazardConclusionBlock.AssessmentFactor/>
				</#if>
			</para>
		</#if>
	</#if>
	<#if hazardConclusionBlock.hasElement("ExtrapolationMethod")>
		<#if com.picklistValueMatchesPhrases(hazardConclusionBlock.HazAssessConcl, [".*PNEC.*"])>
			<para>
				Extrapolation method: <@com.picklist hazardConclusionBlock.ExtrapolationMethod/>
			</para>
		</#if>
	</#if>
	<#if hazardConclusionBlock.hasElement("ExtrapolationMethod")>
		<#if com.picklistValueMatchesPhrases(hazardConclusionBlock.HazAssessConcl, [".*PNEC.*"])>
			<para>
				<@com.picklist hazardConclusionBlock.HazAssessConcl/>
			</para>
		</#if>
	</#if>	
	
	<para>
		<@com.richText hazardConclusionBlock.Justification/>
	</para>
</#compress>
</#macro>