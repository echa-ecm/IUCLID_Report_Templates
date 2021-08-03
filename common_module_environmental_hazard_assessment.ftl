
<!-- ENVIRONMENTAL HAZARD ASSESSMENT template file -->

<!-- Summary discussion Aquatic compartment (including sediment) -->
<#macro aquaticToxicitySummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AquaticToxicity") />

	<#if summaryList?has_content>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaTextAquaticToxicity>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextAquaticToxicity printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>
		
<!-- Short-term toxicity to fish study table -->
<#macro shortTermToxicityToFishStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ShortTermToxicityToFish") />
				
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Short-term effects on fish</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["LC50","LC0","LC100"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
			</tbody>
		</table>
	</#if>
		
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Short-term toxicity testing on fish"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Short-term toxicity testing on fish"/>

</#compress>
</#macro>	
	
<!-- Summary Discussion for short term toxicity to fish -->
<#macro shortTermToxicityToFishSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ShortTermToxicityToFish") />
				
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValueShortTermToxicityToFish(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextShortTermToxicityToFish summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			
			<@studyandsummaryCom.summaryKeyInformation summary/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.FreshWaterFish.FreshWaterFish?has_content>						
			<emphasis role="underline">Freshwater fish</emphasis>	
				<#assign shortTermToxicityToFishFreshwaterList = summary.KeyValueForChemicalSafetyAssessment.FreshWaterFish.FreshWaterFish/>
				<#if shortTermToxicityToFishFreshwaterList?has_content>
				<#list shortTermToxicityToFishFreshwaterList as shortTermToxicityToFishFreshwater> 
				
					<#if shortTermToxicityToFishFreshwater.DoseDescriptor?has_content || 
					shortTermToxicityToFishFreshwater.EffectConcentration?has_content>
					
						<#assign valueForCsaTextShortTermToxicityToFishFreshwater>
						
							<#if shortTermToxicityToFishFreshwater.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist shortTermToxicityToFishFreshwater.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if shortTermToxicityToFishFreshwater.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range shortTermToxicityToFishFreshwater.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
						<@com.emptyLine/>
					</#if>
					
				</#list>
				</#if>			
			</#if>
			<@endpointSummary summary valueForCsaTextShortTermToxicityToFishFreshwater "valueForCsaTextShortTermToxicityToFishFreshwater" false/>
					
			<#if summary.KeyValueForChemicalSafetyAssessment.MarineWaterFish.MarineWaterFish?has_content>						
			<emphasis role="underline">Marine water fish</emphasis>	
				<#assign shortTermToxicityToFishMarineList = summary.KeyValueForChemicalSafetyAssessment.MarineWaterFish.MarineWaterFish/>
				<#if shortTermToxicityToFishMarineList?has_content>
				<#list shortTermToxicityToFishMarineList as shortTermToxicityToFishMarine> 
				
					<#if shortTermToxicityToFishMarine.DoseDescriptor?has_content || 
					shortTermToxicityToFishMarine.EffectConcentration?has_content>
					
						<#assign valueForCsaTextShortTermToxicityToFishMarine>
						
							<#if shortTermToxicityToFishMarine.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist shortTermToxicityToFishMarine.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if shortTermToxicityToFishMarine.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range shortTermToxicityToFishMarine.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
					</#if>
					
				</#list>
				</#if>			
			</#if>			
			<@endpointSummary summary valueForCsaTextShortTermToxicityToFishMarine "valueForCsaTextShortTermToxicityToFishMarine" false/>
			<para><@studyandsummaryCom.relevantStudies summary/></para>		
			<para><@studyandsummaryCom.assessmentEntitiesList summary/></para>	
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>
			
		</#list>
	</#if>
				
</#compress>
</#macro>

<!-- Long-term toxicity to fish study table -->
<#macro longTermToxicityToFishStudies _subject>
<#compress>
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "LongTermToxToFish") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
		<@com.emptyLine/>
		<table border="1">
			<title>Long-term effects on fish</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","IC10"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
	</#if>
		
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Long-term toxicity testing to aquatic vertebrates"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Long-term toxicity testing on fish" true/>
			
</#compress>
</#macro>			
			
<!-- Summary Discussion for long term toxicity to fish -->
<#macro longTermToxicityToFishSummary _subject>
<#compress>			
			
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "LongTermToxicityToFish") />
				
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesLongTermToxicityToFish(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextLongTermToxicityToFish summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			
			<@studyandsummaryCom.summaryKeyInformation summary/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.FreshWaterFish.FreshWaterFish?has_content>						
			<emphasis role="underline">Freshwater fish</emphasis>	
				<#assign longTermToxicityToFishFreshwaterList = summary.KeyValueForChemicalSafetyAssessment.FreshWaterFish.FreshWaterFish/>
				<#if longTermToxicityToFishFreshwaterList?has_content>
				<#list longTermToxicityToFishFreshwaterList as longTermToxicityToFishFreshwater> 
				
					<#if longTermToxicityToFishFreshwater.DoseDescriptor?has_content || 
					longTermToxicityToFishFreshwater.EffectConcentration?has_content>
					
						<#assign valueForCsaTextLongTermToxicityToFishFreshwater>
						
							<#if longTermToxicityToFishFreshwater.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist longTermToxicityToFishFreshwater.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if longTermToxicityToFishFreshwater.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range longTermToxicityToFishFreshwater.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
						<@com.emptyLine/>
					</#if>
					
				</#list>
				</#if>			
			</#if>
			<@endpointSummary summary valueForCsaTextLongTermToxicityToFishFreshwater "valueForCsaTextLongTermToxicityToFishFreshwater" false/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.MarineWaterFish.MarineWaterFish?has_content>						
			<emphasis role="underline">Marine water fish</emphasis>	
				<#assign longTermToxicityToFishMarineList = summary.KeyValueForChemicalSafetyAssessment.MarineWaterFish.MarineWaterFish/>
				<#if longTermToxicityToFishMarineList?has_content>
				<#list longTermToxicityToFishMarineList as longTermToxicityToFishMarine> 
				
					<#if longTermToxicityToFishMarine.DoseDescriptor?has_content || 
					longTermToxicityToFishMarine.EffectConcentration?has_content>
					
						<#assign valueForCsaTextLongTermToxicityToFishMarine>
						
							<#if longTermToxicityToFishMarine.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist longTermToxicityToFishMarine.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if longTermToxicityToFishMarine.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range longTermToxicityToFishMarine.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
					</#if>
					
				</#list>
				</#if>			
			</#if>			
			<@endpointSummary summary valueForCsaTextLongTermToxicityToFishMarine "valueForCsaTextLongTermToxicityToFishMarine" false/>
			<para><@studyandsummaryCom.relevantStudies summary/></para>		
			<para><@studyandsummaryCom.assessmentEntitiesList summary/></para>	
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>			
			
		</#list>
	</#if>
		
</#compress>
</#macro>	
	
<!-- Aquatic invertebrates study table -->
<#macro shortTermToxicityToAquaticInvertebratesStudies _subject>
<#compress>	
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ShortTermToxicityToAquaInv") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Short-term effects on aquatic invertebrates</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["EC50","IC50","LC50","EC0","IC0","LC0","EC100","LC100"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
			</tbody>
		</table>
	</#if>
		
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Short-term toxicity testing on aquatic invertebrates"/>
			
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Short-term toxicity testing on aquatic invertebrates"/>
		
</#compress>
</#macro>		
		
<!-- Summary Discussion for aquatic invertebrates -->
<#macro shortTermToxicityToAquaticInvertebratesSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ShortTermToxicityToAquaticInvertebrates") />
					
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesShortTermToxicityToAquaticInvertebrates(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextShortTermToxicityToAquaticInvertebrates summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			
			<@studyandsummaryCom.summaryKeyInformation summary/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.FreshWaterInvertebrates.FreshWaterInvertebrates?has_content>						
			<emphasis role="underline">Freshwater fish</emphasis>	
				<#assign shortTermToxicityToAquaticInvertebratesFreshwaterList = summary.KeyValueForChemicalSafetyAssessment.FreshWaterInvertebrates.FreshWaterInvertebrates/>
				<#if shortTermToxicityToAquaticInvertebratesFreshwaterList?has_content>
				<#list shortTermToxicityToAquaticInvertebratesFreshwaterList as shortTermToxicityToAquaticInvertebratesFreshwater> 
				
					<#if shortTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor?has_content || 
					shortTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration?has_content>
					
						<#assign valueForCsaTextShortTermToxicityToAquaticInvertebratesFreshwater>
						
							<#if shortTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist shortTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if shortTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range shortTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration/>
								</para>
							</#if>
						
						</#assign>
						<@com.emptyLine/>
					</#if>
					
				</#list>
				</#if>			
			</#if>
			<@endpointSummary summary valueForCsaTextShortTermToxicityToAquaticInvertebratesFreshwater "valueForCsaTextShortTermToxicityToAquaticInvertebratesFreshwater" false/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.MarineWaterInvertebrates.MarineWaterInvertebrates?has_content>						
			<emphasis role="underline">Marine fish</emphasis>	
				<#assign shortTermToxicityToAquaticInvertebratesMarineList = summary.KeyValueForChemicalSafetyAssessment.MarineWaterInvertebrates.MarineWaterInvertebrates/>
				<#if shortTermToxicityToAquaticInvertebratesMarineList?has_content>
				<#list shortTermToxicityToAquaticInvertebratesMarineList as shortTermToxicityToAquaticInvertebratesMarine> 
				
					<#if shortTermToxicityToAquaticInvertebratesMarine.DoseDescriptor?has_content || 
					shortTermToxicityToAquaticInvertebratesMarine.EffectConcentration?has_content>
					
						<#assign valueForCsaTextShortTermToxicityToAquaticInvertebratesMarine>
						
							<#if shortTermToxicityToAquaticInvertebratesMarine.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist shortTermToxicityToAquaticInvertebratesMarine.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if shortTermToxicityToAquaticInvertebratesMarine.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range shortTermToxicityToAquaticInvertebratesMarine.EffectConcentration/>
								</para>
							</#if>
						
						</#assign>
					</#if>
					
				</#list>
				</#if>			
			</#if>
			<@endpointSummary summary valueForCsaTextShortTermToxicityToAquaticInvertebratesMarine "valueForCsaTextShortTermToxicityToAquaticInvertebratesMarine" false/>
			<para><@studyandsummaryCom.relevantStudies summary/></para>		
			<para><@studyandsummaryCom.assessmentEntitiesList summary/></para>	
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>			
			
		</#list>
	</#if>
	
</#compress>
</#macro>


<!-- Long-term toxicity to aquatic invertebrates study table -->
<#macro longTermToxicityToAquaticInvertebratesStudies _subject>
<#compress>			
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "LongTermToxicityToAquaInv") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
									No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Long-term effects on aquatic invertebrates</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","IC10"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
	</#if>
		
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Long-term toxicity testing on aquatic invertebrates"/>
			
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Long-term toxicity testing on aquatic invertebrates"/>

</#compress>
</#macro>	
					
<!-- Summary Discussion for Long-term toxicity to aquatic invertebrates -->
<#macro longTermToxicityToAquaticInvertebratesSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "LongTermToxicityToAquaticInvertebrates") />
		
	
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForLongTermToxicityToAquaticInvertebrates(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextLongTermToxicityToAquaticInvertebrates summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			
			<@studyandsummaryCom.summaryKeyInformation summary/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.FreshWaterInvertebrates.FreshWaterInvertebrates?has_content>						
			<emphasis role="underline">Freshwater fish</emphasis>	
				<#assign longTermToxicityToAquaticInvertebratesFreshwaterList = summary.KeyValueForChemicalSafetyAssessment.FreshWaterInvertebrates.FreshWaterInvertebrates/>
				<#if longTermToxicityToAquaticInvertebratesFreshwaterList?has_content>
				<#list longTermToxicityToAquaticInvertebratesFreshwaterList as longTermToxicityToAquaticInvertebratesFreshwater> 
				
					<#if longTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor?has_content || 
					longTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration?has_content>
					
						<#assign valueForCsaTextLongTermToxicityToAquaticInvertebratesFreshwater>
						
							<#if longTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist longTermToxicityToAquaticInvertebratesFreshwater.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if longTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range longTermToxicityToAquaticInvertebratesFreshwater.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
						<@com.emptyLine/>
					</#if>
					
				</#list>
				</#if>			
			</#if>			
			<@endpointSummary summary valueForCsaTextLongTermToxicityToAquaticInvertebratesFreshwater "valueForCsaTextLongTermToxicityToAquaticInvertebratesFreshwater" false/>
						
			<#if summary.KeyValueForChemicalSafetyAssessment.MarineWaterInvertebrates.MarineWaterInvertebrates?has_content>						
			<emphasis role="underline">Marine fish</emphasis>	
				<#assign longTermToxicityToAquaticInvertebratesMarineList = summary.KeyValueForChemicalSafetyAssessment.MarineWaterInvertebrates.MarineWaterInvertebrates/>
				<#if longTermToxicityToAquaticInvertebratesMarineList?has_content>
				<#list longTermToxicityToAquaticInvertebratesMarineList as longTermToxicityToAquaticInvertebratesMarine> 
				
					<#if longTermToxicityToAquaticInvertebratesMarine.DoseDescriptor?has_content || 
					longTermToxicityToAquaticInvertebratesMarine.EffectConcentration?has_content>
					
						<#assign valueForCsaTextLongTermToxicityToAquaticInvertebratesMarine>
						
							<#if longTermToxicityToAquaticInvertebratesMarine.DoseDescriptor?has_content>
								<para>Dose descriptor: <@com.picklist longTermToxicityToAquaticInvertebratesMarine.DoseDescriptor/>
								</para><?linebreak?>
							</#if>
							
							<#if longTermToxicityToAquaticInvertebratesMarine.EffectConcentration?has_content>
								<para>Effect concentration: <@com.range longTermToxicityToAquaticInvertebratesMarine.EffectConcentration/>
								</para><?linebreak?>
							</#if>
						
						</#assign>
					</#if>
					
				</#list>
				</#if>			
			</#if>
			<@endpointSummary summary valueForCsaTextLongTermToxicityToAquaticInvertebratesMarine "valueForCsaTextLongTermToxicityToAquaticInvertebratesMarine" false/>
			<para><@studyandsummaryCom.relevantStudies summary/></para>		
			<para><@studyandsummaryCom.assessmentEntitiesList summary/></para>	
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>
			
		</#list>
	</#if>
	
</#compress>
</#macro>	
	
<!-- Algae and aquatic plants for CSR, if not CSR, then Algae only: study table -->
<#macro toxicityToAquaticAlgaeStudies _subject>
<#compress>	
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToAquaticAlgae") />		
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	<#assign resultStudyList1 = resultStudyList/>
	<#assign dataWaivingStudyList1 = dataWaivingStudyList/>
	<#assign testingProposalStudyList1 = testingProposalStudyList/>
	
	<#if csrRelevant??>
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToAquaticPlant") />
		<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		<#assign resultStudyList2 = resultStudyList/>
		<#assign dataWaivingStudyList2 = dataWaivingStudyList/>
		<#assign testingProposalStudyList2 = testingProposalStudyList/>
	</#if>
	
	<!-- Study results -->
	<#if (csrRelevant?? && !(resultStudyList1?has_content || resultStudyList2?has_content)) || (!(csrRelevant??) && !(resultStudyList1?has_content))>
		No relevant information available.
	
	<#else/>			
		The results are summarised in the following table:
	
		<@com.emptyLine/>
		<table border="1">
			<#if csrRelevant??>
			<title>Effects on algae and aquatic plants</title>
			<#else>
				<title>Effects on algae</title>
			</#if>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<#if study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies?has_content>
									<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/> (algae)
								</#if>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["EC50","IC50","NOEC","LOEC","EC10","IC10","EC20","IC20","EC0","IC0","EC100","IC100"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>

				<#if csrRelevant??>
					<#list resultStudyList2 as study>
						<tr>
							<!-- Method -->
							<td>
								<para>
									<#if study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies?has_content>
										<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/> (aquatic plants)
									</#if>
								</para>
								
								<para>
									<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
								</para>
								
								<para>
									<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
								</para>
								
								<para>
									<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
								</para>
								
								<para>
									<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
								</para>
							</td>
							<!-- Results -->
							<td>
								<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["EC50","IC50","NOEC","LOEC","EC10","IC10","EC20","IC20","EC0","IC0","EC100","IC100"]) />
								<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
					</#list>
				</#if>
			</tbody>
		</table>
	</#if>
	<!-- Data waiving -->
	<#if csrRelevant??>
		<#if dataWaivingStudyList1?has_content || dataWaivingStudyList2?has_content>
			<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList1 "Growth inhibition study with algae / cyanobacteria" false/>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList2 "Growth inhibition study with aquatic plants other than algae" false/>
		</#if> 
		<#else>
		<#if dataWaivingStudyList1?has_content>
			<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList1 "Growth inhibition study with algae / cyanobacteria" false/>
		</#if>
	</#if>
			
	<!-- Testing proposal -->
	<#if csrRelevant??>
		<#if testingProposalStudyList1?has_content || testingProposalStudyList2?has_content>
			<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
			<@studyandsummaryCom.testingProposal testingProposalStudyList1 "Effects on algae" false/>
			<@studyandsummaryCom.testingProposal testingProposalStudyList2 "Effects on aquatic plants " false/>
		</#if>
		<#else>
		<#if testingProposalStudyList1?has_content>
			<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
			<@studyandsummaryCom.testingProposal testingProposalStudyList1 "Effects on algae" false/>
		</#if>
	</#if>
	
	<#assign resultStudyList1 = []/>
	<#assign dataWaivingStudyList1 = []/>
	<#assign testingProposalStudyList1 = []/>
	<#assign resultStudyList2 = []/>
	<#assign dataWaivingStudyList2 = []/>
	<#assign testingProposalStudyList2 = []/>
	
</#compress>
</#macro>

<!-- Aquatic plants for non CSR reports study table -->
<#macro toxicityToAquaticPlantStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToAquaticPlant") />
	
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	<#assign resultStudyList2 = resultStudyList/>
	<#assign dataWaivingStudyList2 = dataWaivingStudyList/>
	<#assign testingProposalStudyList2 = testingProposalStudyList/>
	
	<!-- Study results -->
	<#if !resultStudyList2?has_content>
		No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on aquatic plants</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<#if study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies?has_content>
									<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/> (aquatic plants)
								</#if>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["EC50","IC50","NOEC","LOEC","EC10","IC10","EC20","IC20","EC0","IC0","EC100","IC100"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
	</#if>
		
	<!-- Data waiving -->
	<#if dataWaivingStudyList2?has_content>
		<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaiving dataWaivingStudyList2 "Growth inhibition study with aquatic plants other than algae" false/>
	</#if> 		
			
	<!-- Testing proposal -->
	<#if testingProposalStudyList1?has_content || testingProposalStudyList2?has_content>
		<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposal testingProposalStudyList2 "Effects on aquatic plants " false/>
	</#if>
	
	<#assign resultStudyList2 = []/>
	<#assign dataWaivingStudyList2 = []/>
	<#assign testingProposalStudyList2 = []/>
		
</#compress>
</#macro>
	
<!-- Summary Discussion Aquatic Algae -->		
<#macro toxicityToAquaticAlgaeSummary _subject>
<#compress>		
		
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToAquaticAlgae") />
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityToAquaticAlgae(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToAquaticAlgae summaryCSAValue typeText typeText1 typeText2 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.KeyValue3?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.KeyValue4?has_content>
			<#assign valueForCsaTextToxicityToAquaticAlgae>
				EC50 for freshwater algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue1/><?linebreak?>
				EC50 for marine water algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue2/><?linebreak?>
				EC10/LC10 or NOEC for freshwater algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue3/><?linebreak?>
				EC10/LC10 or NOEC for marine water algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue4/>
			</#assign>
			</#if>
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToAquaticAlgae printSummaryName/>
		</#list>
	</#if>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToAquaticAlgae") />
	<#if summaryList?has_content>
		<#if isContentForAquaticAlgae(summaryList)>
			<para><emphasis role="HEAD-WoutNo">Discussion</emphasis></para>
		</#if>
	</#if>

</#compress>
</#macro>

<!-- Summary Discussion Aquatic Plants -->		
<#macro toxicityToAquaticPlantSummary _subject>
<#compress>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityPlants") />
	<#if summaryList?has_content>

		<#assign summaryCSAValue = getValuesForToxicityPlants(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityPlants summaryCSAValue typeText typeText1 typeText2 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.KeyValue3?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.KeyValue4?has_content>
			
			<#assign valueForCsaTextToxicityPlants>
				EC50 for freshwater algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue1/><?linebreak?>
				EC50 for marine water algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue2/><?linebreak?>
				EC10/LC10 or NOEC for freshwater algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue3/><?linebreak?>
				EC10/LC10 or NOEC for marine water algae: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue4/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityPlants printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Sediment organisms study table -->
<#macro sedimentToxicityStudies _subject>
<#compress>		
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SedimentToxicity") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on sediment organisms</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
								
								<#if study.MaterialsAndMethods.StudyDesign.StudyType?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>)
								</#if>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							
							<para>
								Sediment: <@com.picklist study.MaterialsAndMethods.StudyDesign.TypeOfSediment/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LOEC","EC10","LC10","LD10","EC50","LC50","LD50","EC0","LC0","LD0"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on sediment organisms"/>
			
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Effects on sediment organisms"/>

</#compress>
</#macro>
	
<!-- Summary Discussion of sediment toxicity -->
<#macro sedimentToxicitySummary _subject>
<#compress>		

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "SedimentToxicity") />

	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForSedimentToxicity(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextSedimentToxicity summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForFreshwaterSediment?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForMarineWaterSediment?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForFreshwaterSediment?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForMarineWaterSediment?has_content>
			<#assign valueForCsaTextSediment>
				EC50 or LC50 for freshwater sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForFreshwaterSediment/><?linebreak?>
				EC50 or LC50 for marine water sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForMarineWaterSediment/><?linebreak?>
				EC10, LC10 or NOEC for freshwater sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForFreshwaterSediment/><?linebreak?>
				EC10, LC10 or NOEC for marine water sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForMarineWaterSediment/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextSediment printSummaryName/>
		</#list>
	</#if>
									
</#compress>
</#macro>

<!-- Other aquatic organisms study table -->
<#macro toxicityOtherAquaticOrganismsStudies _subject>
<#compress>			
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToOtherAqua") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on other aquatic organisms</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","IC10","LC10","EC50","IC50","LC50","EC0","IC0","LC0"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on other aquatic organisms"/>
			
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Effects on other aquatic organisms"/>
			
</#compress>
</#macro>			
			
<!-- Summary Discussion of toxicity other aquatic organisms -->
<#macro toxicityOtherAquaticOrganismsSummary _subject>
<#compress>		
		
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityOtherAquaOrganisms") />		
	
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValues(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>	
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>				
			<#assign valueForCsaTextToxicityOtherAquaOrganisms></#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityOtherAquaOrganisms printSummaryName/>
		</#list>
	</#if>
									
</#compress>
</#macro>	

<!-- Summary Discussion of Terrestrial toxicity -->
<#macro terrestrialToxicitySummary _subject>
<#compress>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "TerrestrialToxicity") />

	<#if summaryList?has_content>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
		</#list>
	</#if>

</#compress>
</#macro>

<!-- Toxicity to soil macro-organisms and terrestrial arthropods for CSR and soil macro-organisms for non-CSR: study table -->
<#macro toxicityToSoilMacroOrganismsStudies _subject>
<#compress>		
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToSoilMacroorganismsExceptArthropods") />
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	<#assign resultStudyList1 = resultStudyList/>
	<#assign dataWaivingStudyList1 = dataWaivingStudyList/>
	<#assign testingProposalStudyList1 = testingProposalStudyList/>
	
	<#if csrRelevant??>
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToTerrestrialArthropods") />
		<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		<#assign resultStudyList2 = resultStudyList/>
		<#assign dataWaivingStudyList2 = dataWaivingStudyList/>
		<#assign testingProposalStudyList2 = testingProposalStudyList/>
	</#if>
		
	<!-- Study results -->
	<#if (csrRelevant?? && !(resultStudyList1?has_content || resultStudyList2?has_content)) || (!(csrRelevant??) && !(resultStudyList1?has_content))>
		No relevant information available.
	
	<#else/>			
		The results are summarised in the following table:
			
			<@com.emptyLine/>
		<table border="1">
			<#if csrRelevant??>
			<title>Effects on soil macro-organisms</title>
			<#else>
				<title>Soil Macro-organisms Except Arthropods</title>
			</#if>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
					
				<#list resultStudyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
								
								<#if study.MaterialsAndMethods.TestOrganisms.AnimalGroup?has_content>
									(<@com.picklist study.MaterialsAndMethods.TestOrganisms.AnimalGroup/>)
								</#if>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
									
								<#if study.MaterialsAndMethods.StudyDesign.StudyType?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>)
								</#if>
							</para>
							
							<para>
								Substrate: <@com.picklist study.MaterialsAndMethods.StudyDesign.SubstrateType/>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","LD10","EC50","LC50","LD50"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>						
				</#list>
				
				<#if csrRelevant??>			
					<#list resultStudyList2 as study>
					
						<#if isSoilMacroOrganismsInvolved(study)> 
							<tr>
								<!-- Method -->
								<td>
									<para>
										<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/> (<@com.picklist study.MaterialsAndMethods.TestOrganisms.AnimalGroup/>)
									</para>
									
									<para>
										Application method: <@com.picklist study.MaterialsAndMethods.ApplicationMethod/>
									</para>
									
									<para>
										<@com.picklist study.AdministrativeData.Endpoint/>
										
										<#if study.MaterialsAndMethods.StudyDesign.StudyType?has_content>
											(<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>)
										</#if>
									</para>
									
									<para>
										<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
									</para>
									
									<para>
										<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
									</para>
								</td>
								<!-- Results -->
								<td>
									<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","LD10","EC50","LC50","LD50"]) />
									<@effectList sortedEffectList study/>
								</td>
								<!-- Remarks -->
								<td>
									<@studyandsummaryCom.studyRemarksColumn study/>
								</td>
							</tr>
						</#if>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
				</#if>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<#if csrRelevant??>
		<#if dataWaivingStudyList1?has_content || dataWaivingStudyList2?has_content>
			<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList1 "Toxicity to soil macro-organisms except arthropods" false/>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList2 "Toxicity to soil arthropods" false/>
		</#if> 
		<#else>
		<#if dataWaivingStudyList1?has_content>		
		<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
			<@studyandsummaryCom.dataWaiving dataWaivingStudyList1 "Toxicity to soil macro-organisms except arthropods" false/>
		</#if>
	</#if>
			
	<!-- Testing proposal -->
	<#if csrRelevant??>
		<#if testingProposalStudyList1?has_content || testingProposalStudyList2?has_content>
			<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
			<@studyandsummaryCom.testingProposal testingProposalStudyList1 "Toxicity to soil macro-organisms except arthropods" false/>
			<@studyandsummaryCom.testingProposal testingProposalStudyList2 "Toxicity to soil arthropods" false/>
		</#if>
		<#else>
		<#if testingProposalStudyList1?has_content>
		<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
			<@studyandsummaryCom.testingProposal testingProposalStudyList1 "Toxicity to soil macro-organisms except arthropods" false/>
		</#if>
	</#if>
	
	<#assign resultStudyList1 = []/>
	<#assign dataWaivingStudyList1 = []/>
	<#assign testingProposalStudyList1 = []/>
	<#assign resultStudyList2 = []/>
	<#assign dataWaivingStudyList2 = []/>
	<#assign testingProposalStudyList2 = []/>
		
</#compress>
</#macro>	

<!-- Toxicity to Terrestrial Arthropods for non CSR: study table -->
<#macro toxicityToTerrestrialArthropodsStudies _subject>
<#compress>		

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToTerrestrialArthropods") />
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	<#assign resultStudyList2 = resultStudyList/>
	<#assign dataWaivingStudyList2 = dataWaivingStudyList/>
	<#assign testingProposalStudyList2 = testingProposalStudyList/>
			
	<!-- Study results -->
	<#if !resultStudyList2?has_content>
		No relevant information available.		
		<#else/>
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on terrestrial arthropods</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>					
				
				<#list resultStudyList2 as study>
				<#if (csrRelevant?? && !(isSoilMacroOrganismsInvolved(study))) || !(csrRelevant??)>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/> (<@com.picklist study.MaterialsAndMethods.TestOrganisms.AnimalGroup/>)
							</para>
							
							<para>
								Application method: <@com.picklist study.MaterialsAndMethods.ApplicationMethod/>
							</para>
							
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
								
								<#if study.MaterialsAndMethods.StudyDesign.StudyType?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>)
								</#if>
							</para>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","LD10","EC50","LC50","LD50"]) />
							<@effectList sortedEffectList study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#if>
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<#if dataWaivingStudyList2?has_content>
		<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaiving dataWaivingStudyList2 "Toxicity to soil arthropods" false/>
	</#if>          
			
	<!-- Testing proposal -->
	<#if testingProposalStudyList2?has_content>
		<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposal testingProposalStudyList2 "Toxicity to soil arthropods" false/>
	</#if>
	
	<#assign resultStudyList2 = []/>
	<#assign dataWaivingStudyList2 = []/>
	<#assign testingProposalStudyList2 = []/>
		
</#compress>
</#macro>		
			
<!-- Summary Discussion for soil macroorganisms except arthropods -->	
<#macro toxicityToSoilMacroorganismsExceptArthropodsSummary _subject>
<#compress>			
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToSoilMacroorganismsExceptArthropods") />
	<#if summaryList?has_content>
	
		<#assign summaryCSAValue = getValuesForToxicityToSoilMacroorganismsExceptArthropods(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToSoilMacroorganismsExceptArthropods summaryCSAValue typeText typeText1 />
		</#if>	
		
		<#assign printSummaryName = summaryList?size gt 1 />
			<#list summaryList as summary>
				<@com.emptyLine/>
				<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilMacroorganisms?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilMacroorganisms?has_content> 
				<#assign valueForCsaTextSoilMacroorganismsExceptArthropods>
					Short-term EC50 or LC50 for soil macro-organisms: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilMacroorganisms/><?linebreak?>
					Long-term EC10/LC10 or NOEC for soil macro-organisms: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilMacroorganisms/>
				</#assign>
				</#if>
				
				<@studyandsummaryCom.endpointSummary summary valueForCsaTextSoilMacroorganismsExceptArthropods printSummaryName/>
			</#list>
	</#if>
		
</#compress>
</#macro>
		
<!-- Summary Discussion for soil macroorganisms except arthropods -->	
<#macro toxicityToTerrestrialArthropodsSummary _subject>
<#compress>			
					
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToTerrestrialArthropods") />
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityToTerrestrialArthropods(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToTerrestrialArthropods summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilDwellingArthropods?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilDwellingArthropods?has_content> 
			<#assign valueForCsaTextToxicityToTerrestrialArthropods>
				Short-term EC50 or LC50 for soil dwelling arthropods: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilDwellingArthropods/><?linebreak?>
				Long-term EC10/LC10 or NOEC for soil dwelling arthropods: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilDwellingArthropods/>
			</#assign>
			</#if>
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToTerrestrialArthropods printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Toxicity to terrestrial plants study table -->
<#macro toxicityToTerrestrialPlantsStudies _subject>
<#compress>		
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToTerrestrialPlants") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on terrestrial plants</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
					
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
							<@TestOrgsForTerrestrialPlants study.MaterialsAndMethods.TestOrganisms.TestOrganisms/>
							</para>
							
							<para>									
								<@com.picklist study.AdministrativeData.Endpoint/> 
								
								<#if study.MaterialsAndMethods.StudyDesign.StudyType?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>)
								</#if>
							</para>
							
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							
							<para>
								Substrate: <@com.picklist study.MaterialsAndMethods.StudyDesign.SubstrateType/>
							</para>
								
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
								
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<@effectIncludingSpeciesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectConcentrations)/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>	
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on terrestrial plants"/>
				
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "" true/>

</#compress>
</#macro>
				
<!-- Summary Discussion for toxicity to terrestrial plants -->﻿
<#macro toxicityToTerrestrialPlantsSummary _subject>
<#compress>		

	<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToTerrestrialPlants") />
			
	<#if summaryList?has_content>
		
		<#local summaryCSAValue = getValuesForToxicityToTerrestrialPlants(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToTerrestrialPlants summaryCSAValue typeText typeText1 />
		</#if>
		
		<#local printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForTerrestrialPlants?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForTerrestrialPlants?has_content> 
			<#local valueForCsaTextToxicityToTerrestrialPlants>
				Short-term EC50 or LC50 for terrestrial plants: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForTerrestrialPlants/><?linebreak?>
				Long-term EC10/LC10 or NOEC for terrestrial plants: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForTerrestrialPlants/>
			</#local>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToTerrestrialPlants printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Toxicity to soil micro-organisms study table -->
<#macro toxicityToSoilMicroorganismsStudies _subject>
<#compress>		
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToSoilMicroorganisms") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on soil micro-organisms</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
					
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								Species/Inoculum: <@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsInoculum/>
							</para>	
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
								
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","EC10","EC25","EC50","EC100"]) />
							<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>						
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on soil micro-organisms"/>
				
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Effects on soil micro-organisms"/>
	
</#compress>
</#macro>	
	
<!-- Summary Discussion for toxicity to soil microorganisms-->
<#macro toxicityToSoilMicroorganismsSummary _subject>
<#compress>			
		
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToSoilMicroorganisms") />
					
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityToSoilMicroorganisms(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToSoilMicroorganisms summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50ForSoilMicroorganisms?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10OrNoecForSoilMicroorganisms?has_content> 
			
			<#assign valueForCsaTextToxicityToSoilMicroorganisms>
				Short-term EC50 or LC50 for soil micro-organisms: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50ForSoilMicroorganisms/><?linebreak?>
				Long-term EC10/LC10 or NOEC for soil micro-organisms: 
				<@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10OrNoecForSoilMicroorganisms/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToSoilMicroorganisms printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Summary Discussion toxicity to terrestrial arthropods summary short version -->
<#macro toxicityToTerrestrialArthropodsSummaryShortVersion _subject>
<#compress>		

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToTerrestrialArthropods") />
	
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValues(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>			
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>			
			<#assign valueForCsaTextToxicityToTerrestrialArthropods></#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToTerrestrialArthropods printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Microbiological activity in sewage treatment systems study table -->
<#macro toxicityToMicroorganismsStudies _subject>
<#compress>		

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToMicroorganisms") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
			
	<!-- Study results -->
		<#if !resultStudyList?has_content>
		No relevant information available.
		<#else/>
			The results are summarised in the following table:
				
			<@com.emptyLine/>
			<table border="1">
				<title>Effects on micro-organisms</title>
				<col width="39%" />
				<col width="41%" />
				<col width="20%" />
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>
							
					<#list resultStudyList as study>
						<tr>
							<!-- Method -->
							<td>
								<para>
									<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
								</para>
									
								<para>
									<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
								</para>
								
								<para>
									<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
								</para>
								
								<para>
									<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
								</para>
								
								<para>
									<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
								</para>
							</td>
							<!-- Results -->
							<td>
								<#assign sortedEffectList = iuclid.sortByField(study.ResultsAndDiscussion.EffectConcentrations, "Endpoint", ["NOEC","LOEC","EC10","LC10","IC10","EC50","IC50","EC0","IC0"]) />
								<@effectList studyandsummaryCom.orderByKeyResult(sortedEffectList) study/>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>			
					</#list>
				</tbody>
			</table>
		</#if>	
		
		<!-- Data waiving -->
		<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on aquatic micro-organisms"/>
					
		<!-- Testing proposal -->
		<@studyandsummaryCom.testingProposal testingProposalStudyList "Effects on aquatic micro-organisms"/>
</#compress>
</#macro>
				
<!-- Summary Discussion for toxicity to microorganisms summary -->
<#macro toxicityToMicroorganismsSummary _subject>
<#compress>			
		
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityMicroorganisms") />
			
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityMicroorganisms(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityMicroorganisms summaryCSAValue typeText typeText1 />
		</#if>	
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content> 
			<#assign valueForCsaTextToxicityMicroorganisms>
			EC50/LC50 for aquatic micro-organisms: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue1/>
			EC10/LC10 or NOEC for aquatic micro-organisms: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.KeyValue2/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityMicroorganisms printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Toxicity to birds study table-->
<#macro toxicityToBirdsStudies _subject>
<#compress>	
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToBirds") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on birds</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
					
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
								
							<para>
								<@com.picklist study.AdministrativeData.Endpoint/>
								<#if study.MaterialsAndMethods.TestMaterials.DoseMethod?has_content>
									(<@com.picklist study.MaterialsAndMethods.TestMaterials.DoseMethod/>)
								</#if>
							</para>
								
							<para>
								<#if study.MaterialsAndMethods.StudyDesign.NominalAndMeasuredDosesConcentrations?has_content>
									Doses: <@com.text study.MaterialsAndMethods.StudyDesign.NominalAndMeasuredDosesConcentrations/>
								</#if>
							</para>
						
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<@effectBirdsList study.ResultsAndDiscussion.EffectLevels/>
							
							<para>
								<@com.text study.ResultsAndDiscussion.RepellencyFactors/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>		
				</#list>
			</tbody>
		</table>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Toxicity to birds"/>
				
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Toxicity to birds"/>

</#compress>
</#macro>
				
<!-- Summary Discussion for toxicity to birds -->
<#macro toxicityToBirdsSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToBirds") />
			
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityToBirds(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextToxicityToBirds summaryCSAValue typeText typeText1 />
		</#if>	
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForBirds?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForBirds?has_content> 
			<#assign valueForCsaTextToxicityToBirds>
				Short-term EC50 or LC50 for birds: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForBirds/>
				Long-term EC10/LC10 or NOEC for birds: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForBirds/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToBirds printSummaryName/>
		</#list>
	</#if>		

</#compress>
</#macro>
	
<!-- Toxicity to mammals study table -->
<#macro toxicityToOtherAboveGroundOrganismsStudies _subject>
<#compress>	
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToOtherAboveGroundOrganisms") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
		
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
			<title>Effects on mammals</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
					
				<#list resultStudyList as study>
					<tr>
						<!-- Method -->
						<td>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
								
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.StudyType/>
							</para>
								
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<@effectList study.ResultsAndDiscussion.EffectConcentrations study/>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>	
				</#list>
			</tbody>
		</table>
		<@com.emptyLine/>
	</#if>
	
	<!-- Data waiving -->
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Effects on other above-ground organisms / mammals"/>
				
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Effects on other above-ground organisms / mammals"/>
	
</#compress>
</#macro>
				
<!-- Summary Discussion for toxicity to other above ground organisms -->
<#macro toxicityToOtherAboveGroundOrganismsSummary _subject>
<#compress>			

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToOtherAboveGroundOrganisms") />
					
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getValuesForToxicityToOtherAboveGroundOrganisms(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueToxicityToOtherAboveGroundOrganisms summaryCSAValue typeText typeText1 />
		</#if>	
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@com.emptyLine/>
			<#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForMammals?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForMammals?has_content> 
			<#assign valueForCsaTextToxicityToOtherAboveGroundOrganisms>
			Short-term EC50 or LC50 for mammals: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForMammals/>
			Long-term EC10/LC10 or NOEC for mammals: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForMammals/>
			</#assign>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToOtherAboveGroundOrganisms printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Summary Discussion for additional toxicological information -->
<#macro additionalToxicologicalInformationSummary _subject>
<#compress>			

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AdditionalEcotoxicologicalInformation") />
					
	<#if summaryList?has_content>		
	 <#assign printSummaryName = summaryList?size gt 1 />
        <#list summaryList as summary>
            <@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
        </#list>
	</#if>
	
</#compress>
</#macro>	

<!-- Macros and functions -->
<#macro endpointSummary summary valueCsa="" valueForCsaText="" printName=false>
	<para>
		<#if printName>
			<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
		</#if>
	</para>
	<#if valueForCsaText?has_content>
	
		<!-- short-term toxicity to fish freshwater -->
		<#if valueForCsaText=="valueForCsaTextShortTermToxicityToFishFreshwater">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>						
		</#if>
		
		<!-- short-term toxicity to fish marine -->
		<#if valueForCsaText=="valueForCsaTextShortTermToxicityToFishMarine">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>						
		</#if>
		
		<!-- long-term toxicity to aquatic invertebrates freshwater -->
		<#if valueForCsaText=="valueForCsaTextLongTermToxicityToAquaticInvertebratesFreshwater">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>						
		</#if>
		
		<!-- long-term toxicity to aquatic invertebrates marine -->
		<#if valueForCsaText=="valueForCsaTextLongTermToxicityToAquaticInvertebratesMarine">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>						
		</#if>
		
		<!-- short-term toxicity to aquatic invertebrates freshwater -->
		<#if valueForCsaText=="valueForCsaTextShortTermToxicityToAquaticInvertebratesFreshwater">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>						
		</#if>
		
		<!-- short-term toxicity to aquatic invertebrates  marine -->
		<#if valueForCsaText=="valueForCsaTextShortTermToxicityToAquaticInvertebratesMarine">
		<para>
			<@com.emptyLine/>
			${valueCsa}
		</para>				
		</#if>
	</#if>
</#macro>
		
<#macro effectList effectConcRepeatableBlock study>
<#compress>
	<#if effectConcRepeatableBlock?has_content>
		<#list effectConcRepeatableBlock as blockItem>
			<#if blockItem.Endpoint?has_content || blockItem.Duration?has_content 
			|| blockItem.EffectConc?has_content || blockItem.ConcBasedOn?has_content
			|| blockItem.NominalMeasured?has_content || blockItem.BasisForEffect?has_content
			|| blockItem.RemarksOnResults?has_content>
				<para>
					<#if blockItem.Endpoint?has_content> 
						<@com.picklist blockItem.Endpoint/>
					</#if>
					
					<#if blockItem.Duration?has_content> 
						(<@com.quantity blockItem.Duration/>):
					</#if>
					
					<#if blockItem.EffectConc?has_content> 
						<@com.range blockItem.EffectConc/> 
					</#if>
					
					<#if blockItem.ConcBasedOn?has_content> 
						<@com.picklist blockItem.ConcBasedOn/>
					</#if>
					
					<#if blockItem.NominalMeasured?has_content>
						(<@com.picklist blockItem.NominalMeasured/>)
					</#if>

           <#local docDefId = study.documentType +"."+ study.documentSubType/>
              <#if !(docDefId=="ENDPOINT_STUDY_RECORD.ToxicityToAquaticPlant")>

                <#if blockItem.BasisForEffect?has_content>
                  based on: <@com.picklist blockItem.BasisForEffect/>
                </#if>

              <#elseif docDefId=="ENDPOINT_STUDY_RECORD.ToxicityToAquaticPlant">

                <#if blockItem.BasisForEffectMulti?has_content>
                  based on: <@com.picklistMultiple blockItem.BasisForEffectMulti/>
                </#if>
              </#if>

              <#if blockItem.RemarksOnResults?has_content>
                (<@com.picklist blockItem.RemarksOnResults/>)
              </#if>
        </para>
      </#if>
</#list>
</#if>
    
</#compress>
</#macro>

<#macro effectIncludingSpeciesList effectConcIncludingSpeciesRepeatableBlock>
<#compress>
	<#if effectConcIncludingSpeciesRepeatableBlock?has_content>
		<#list effectConcIncludingSpeciesRepeatableBlock as blockItem>
			<#if blockItem.Species?has_content || blockItem.Endpoint?has_content 
			|| blockItem.Duration?has_content || blockItem.EffectConc?has_content
			|| blockItem.ConcBasedOn?has_content || blockItem.NominalMeasured?has_content
			|| blockItem.BasisForEffect?has_content || blockItem.RemarksOnResults?has_content>
				<para>
					<#if blockItem.Species?has_content>
						<@com.picklist blockItem.Species/>
					</#if>
					
					<#if blockItem.Endpoint?has_content>
						<@com.picklist blockItem.Endpoint/>
					</#if>
					
					<#if blockItem.Duration?has_content>
						(<@com.quantity blockItem.Duration/>):
					</#if>
					
					<#if blockItem.EffectConc?has_content>
						<@com.range blockItem.EffectConc/> 
					</#if>
					
					<#if blockItem.ConcBasedOn?has_content>
						<@com.picklist blockItem.ConcBasedOn/>
					</#if>
					
					<#if blockItem.NominalMeasured?has_content>
						(<@com.picklist blockItem.NominalMeasured/>)
					</#if>
										
					<#if blockItem.BasisForEffect?has_content>
						based on: <@com.picklist blockItem.BasisForEffect/>
					</#if>
					
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro effectBirdsList effectConcBirdsRepeatableBlock>
<#compress>
	<#if effectConcBirdsRepeatableBlock?has_content>
		<#list effectConcBirdsRepeatableBlock as blockItem>
			<#if blockItem.Endpoint?has_content || blockItem.Duration?has_content 
			|| blockItem.EffectLevel?has_content || blockItem.ConcDoseBasedOn?has_content
			|| blockItem.BasisForEffect?has_content || blockItem.RemarksOnResults?has_content>
				<para>
					<#if blockItem.Endpoint?has_content>
						<@com.picklist blockItem.Endpoint/> 
					</#if>
					
					<#if blockItem.Duration?has_content>
						(<@com.quantity blockItem.Duration/>):
					</#if>
					
					<#if blockItem.EffectLevel?has_content>
						<@com.range blockItem.EffectLevel/> 
					</#if>
					
					<#if blockItem.ConcDoseBasedOn?has_content>
						<@com.picklist blockItem.ConcDoseBasedOn/>
					</#if>
										
					<#if blockItem.BasisForEffect?has_content>
						based on: <@com.picklist blockItem.BasisForEffect/>
					</#if>
					
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TestOrgsForTerrestrialPlants TestOrgsRepeatableBlock>
<#compress>
	<#if TestOrgsRepeatableBlock?has_content>
		<#list TestOrgsRepeatableBlock as blockItem>
			<#if blockItem.Species?has_content || blockItem.PlantGroup?has_content>
				<para role="indent">
					<#if blockItem.Species?has_content>
						<@com.picklist blockItem.Species/>
					</#if>
					
					<#if blockItem.PlantGroup?has_content>
						(<@com.picklist blockItem.PlantGroup/>)	
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
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

<#function isSoilMacroOrganismsInvolved study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local AnimalGroup = study.MaterialsAndMethods.TestOrganisms.AnimalGroup />
	<#local TestOrganismsSpecies = study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies />
	<#local ApplicationMethod = study.MaterialsAndMethods.ApplicationMethod />
	
	<#if com.picklistValueMatchesPhrases(AnimalGroup, [".*soil.*"])>
		<#return true>
	<#elseif com.isPicklistEmptyOrOther(AnimalGroup)/>
		<#if com.picklistValueMatchesPhrases(TestOrganismsSpecies, [".*soil.*"])>
			<#return true>
		<#elseif com.isPicklistEmptyOrOther(TestOrganismsSpecies)/>
			<#if com.picklistValueMatchesPhrases(ApplicationMethod, ["soil"])>
				<#return true>
			</#if>
		</#if>
	</#if>
	
	<#return false>
</#function>

<#function isGuidelineListEmptyOrOther GuidelineList>
	<#if !(GuidelineList?has_content)>
		<#return true>
	</#if>
	<#if GuidelineList?size gt 1 >
		<#return false>
	</#if>
	<#local Guideline = GuidelineList[0].Guideline />
	<#return com.isPicklistEmptyOrOther(Guideline) />
</#function>

<#function instructionNeededForAtmosphericCompartment>	
	<#local studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToTerrestrialPlants") />
	<#if studyList?has_content>
		<#list studyList as study>
			<#if com.picklistValueMatchesPhrases(study.MaterialsAndMethods.StudyDesign.StudyType, [".*field study"])>
				<#return true />
			</#if>
		</#list>
  	</#if>
	
	<#local studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityToTerrestrialArthropods") />
	<#if studyList?has_content>
		<#list studyList as study>
			<#if com.picklistValueMatchesPhrases(study.MaterialsAndMethods.ApplicationMethod, ["spray"])>
				<#return true />
			</#if>
		</#list>
  	</#if>
	
	<#return false />
</#function>

<#function isContentForAquaticAlgae summaryList>
	
	<#if !(summaryList?has_content)>		
		<#return true />
	</#if>
	<#if summaryList?has_content>		
		<#return false />
	</#if>
	
	<#return false />
</#function>

<#function getValues summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSA(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>

<#function isCSA summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content />
</#function>

<#macro CSAValueText summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for any hazard / risk assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#function getValuesForToxicityToBirds summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToBirds(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>

<#function isCSAToxicityToBirds summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForBirds?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForBirds?has_content />
</#function>

<#function getValuesForToxicityToOtherAboveGroundOrganisms summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToOtherAboveGroundOrganisms(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>

<#function isCSAToxicityToOtherAboveGroundOrganisms summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForMammals?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForMammals?has_content />
</#function>

<#function getValuesForToxicityToSoilMicroorganisms summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToSoilMicroorganisms(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityToSoilMicroorganisms summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50ForSoilMicroorganisms?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10OrNoecForSoilMicroorganisms?has_content />
</#function>

<#function getValuesForToxicityToTerrestrialPlants summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToTerrestrialPlants(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityToTerrestrialPlants summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForTerrestrialPlants?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForTerrestrialPlants?has_content />
</#function>

<#function getValuesForLongTermToxicityToAquaticInvertebrates summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSALongTermToxicityToAquaticInvertebrates(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSALongTermToxicityToAquaticInvertebrates summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content />
</#function>

<#function getValuesShortTermToxicityToAquaticInvertebrates summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAShortTermToxicityToAquaticInvertebrates(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAShortTermToxicityToAquaticInvertebrates summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content />
</#function>

<#function getValuesLongTermToxicityToFish summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSALongTermToxicityToFish(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSALongTermToxicityToFish summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content />
</#function>


<#function getValuesForToxicityToTerrestrialArthropods summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToTerrestrialArthropods(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityToTerrestrialArthropods summary>
	<#return summary.KeyInformation.KeyInformation?has_content || 
	summary.Discussion.Discussion?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilDwellingArthropods?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilDwellingArthropods?has_content />
</#function>
<#function getValuesForToxicityToAquaticAlgae summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToAquaticAlgae(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityToAquaticAlgae summary>
	<#return summary.KeyInformation.KeyInformation?has_content || 
	summary.Discussion.Discussion?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content ||
	summary.KeyValueForChemicalSafetyAssessment.KeyValue3?has_content ||
	summary.KeyValueForChemicalSafetyAssessment.KeyValue4?has_content />
</#function>
<#function getValueShortTermToxicityToFish summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAShortTermToxicityToFish(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAShortTermToxicityToFish summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
					summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content />
</#function>

<#function getValuesForToxicityToSoilMacroorganismsExceptArthropods summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityToSoilMacroorganismsExceptArthropods(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityToSoilMacroorganismsExceptArthropods summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForSoilMacroorganisms?has_content || summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForSoilMacroorganisms?has_content />
</#function>
<#function getValuesForToxicityPlants summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityPlants(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityPlants summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue3?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.KeyValue4?has_content />
</#function>


<#function getValuesForSedimentToxicity summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSASedimentToxicity(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSASedimentToxicity summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForFreshwaterSediment?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.Ec50Lc50ForMarineWaterSediment?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForFreshwaterSediment?has_content || 
	summary.KeyValueForChemicalSafetyAssessment.Ec10Lc10OrNoecForMarineWaterSediment?has_content />
</#function>
<#function getValuesForToxicityMicroorganisms summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAToxicityMicroorganisms(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAToxicityMicroorganisms summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue1?has_content || summary.KeyValueForChemicalSafetyAssessment.KeyValue2?has_content />
</#function>

<#macro CSAValueTextToxicityMicroorganisms summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for effects on aquatic micro-organisms for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#macro CSAValueTextToxicityToBirds summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for effects on birds for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#macro CSAValueToxicityToOtherAboveGroundOrganisms summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for effects on mammals for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityToSoilMicroorganisms summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for toxicity on soil micro-organisms for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityToTerrestrialPlants summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for toxicity on terrestrial plants for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextLongTermToxicityToAquaticInvertebrates summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for long-term toxicity to aquatic invertebrates for the derivation of PNEC">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextShortTermToxicityToAquaticInvertebrates summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for short-term toxicity to aquatic invertebrates for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextLongTermToxicityToFish summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for long-term fish toxicity for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextShortTermToxicityToFish summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for acute fish toxicity for the derivation of PNEC:">
<#compress>
	<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityToAquaticAlgae summaryCSAValue typeText="Discussion" typeText1="Effects on algae / cyanobacteria" typeText2="The following information is taken into account for effects on algae / cyanobacteria for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="HEAD-WoutNo">${typeText1}</emphasis></para>
	<para><emphasis role="underline">${typeText2}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityPlants summaryCSAValue typeText="Discussion" typeText1="Effects on aquatic plants other than algae" typeText2="The following information is taken into account for effects on aquatic plants other than algae for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="HEAD-WoutNo">${typeText1}</emphasis></para>
	<para><emphasis role="underline">${typeText2}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextSedimentToxicity summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for sediment toxicity for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityToSoilMacroorganismsExceptArthropods summaryCSAValue typeText="Discussion of effects on soil macro-organisms except arthropods" typeText1="The following information is taken into account for effects on soil macro-organisms except arthropods for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextToxicityToTerrestrialArthropods summaryCSAValue typeText="Discussion of effects on soil dwelling arthropods" typeText1="The following information is taken into account for effects on soil dwelling arthropods for the derivation of PNEC:">
<#compress>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#-- Macros to separate documents into three lists: 'study results', 'data waiving', 'testing proposal' -->

<#macro populateResultAndDataWaivingAndTestingProposalStudyLists studyList>
	<#assign resultStudyList = [] />
	<#assign dataWaivingStudyList = [] />
	<#assign testingProposalStudyList = [] />
	<#if studyList?has_content>
		<#list studyList as study>
			<#if isTestingProposalStudy(study)>
				<#assign testingProposalStudyList = testingProposalStudyList + [study] />
			<#elseif isDataWaivingStudy(study)>
				<#assign dataWaivingStudyList = dataWaivingStudyList + [study] />
			<#elseif isRelevantAdequacyOfStudy(study)>
				<#assign resultStudyList = resultStudyList + [study] />
			</#if>
		</#list>
	</#if>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign resultStudyList = iuclid.sortByField(resultStudyList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
</#macro>

<#function isRelevantAdequacyOfStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
    <#return PurposeFlag?has_content && !com.picklistValueMatchesPhrases(PurposeFlag, ["other information"]) />
</#function>

<#function isDataWaivingStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
	<#local DataWaiving = study.AdministrativeData.DataWaiving />
    <#return !(PurposeFlag?has_content) && DataWaiving?has_content />
</#function>

<#function isTestingProposalStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
    <#return com.picklistValueMatchesPhrases(study.AdministrativeData.StudyResultType, ["experimental study planned.*"]) />
</#function>


<#---------------------------------------------PPP additions------------------------------------------------->
<#--1. Results-->

<#--Toxicity to birds
	NOTE: could be merged with the general macro-->
<#macro results_toxicityToBirds study>
	<#compress>

		<#if study.ResultsAndDiscussion.EffectLevels?has_content>
			<para>Effect levels:</para>
			<para role="indent"><@effectBirdsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/></para>
		</#if>

		<@com.children study.ResultsAndDiscussion/>
	</#compress>
</#macro>

<#--Macro for general toxicity results, applicable to different document sub types-->
<#macro results_envToxicity study>
	<#compress>
		<#if study.ResultsAndDiscussion.EffectConcentrations?has_content>
			<para>Effect concentrations:</para>
			<para role="indent"><@effectList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectConcentrations) study/></para>
		</#if>

		<@com.children study.ResultsAndDiscussion/>

	</#compress>
</#macro>

<#--Bioaccumulation-->
<#macro results_bioaccumulation study>
	<#compress>
		<#if study.ResultsAndDiscussion.LipidContent?has_content>
			<para>Lipid content:</para>
			<para role="indent"><@lipidContentList study.ResultsAndDiscussion.LipidContent/></para>
		</#if>

		<#if study.ResultsAndDiscussion.BioaccumulationFactor?has_content>
			<para>Bioconcentration factor:</para>
			<para role="indent"><@bioConcFactorList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.BioaccumulationFactor)/></para>
		</#if>

		<#if study.ResultsAndDiscussion.Depuration?has_content>
			<para>Depuration:</para>
			<para role="indent"><@depurationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Depuration)/></para>
		</#if>

		<@com.children study.ResultsAndDiscussion/>

	</#compress>
</#macro>


<#macro lipidContentList lipidContentRepeatableBlock>
	<#compress>
		<#if lipidContentRepeatableBlock?has_content>
			<#list lipidContentRepeatableBlock as blockItem>
				<#if blockItem.LipidContent?has_content || blockItem.TimePoint?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.TimePoint?has_content>
							<@com.picklist blockItem.TimePoint/>:
						</#if>

						<#if blockItem.LipidContent?has_content>
							<@com.range blockItem.LipidContent/>
						</#if>

						<#if blockItem.RemarksOnResults?has_content>
							(<@com.picklist blockItem.RemarksOnResults/>)
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro bioConcFactorList bioConcFactorRepeatableBlock>
	<#compress>
		<#if bioConcFactorRepeatableBlock?has_content>
			<#list bioConcFactorRepeatableBlock as blockItem>
				<#if blockItem.Type?has_content || blockItem.Value?has_content || blockItem.Basis?has_content ||
				blockItem.TimeOfPlateau?has_content || blockItem.CalculationBasis?has_content || blockItem.RemarksOnResults?has_content >
					<para role="indent">
						<#if blockItem.Type?has_content>
							<@com.picklist blockItem.Type/>:
						</#if>

						<#if blockItem.Value?has_content>
							<@com.range blockItem.Value/>
						</#if>

						<#if blockItem.Basis?has_content>
							on <@com.picklist blockItem.Basis/>
						</#if>

						<#if blockItem.TimeOfPlateau?has_content>
							. Time of plateau: <@com.quantity blockItem.TimeOfPlateau/>
						</#if>

						<#if blockItem.CalculationBasis?has_content>
							. Calculation basis: <@com.picklist blockItem.CalculationBasis/>
						</#if>

						<#if blockItem.RemarksOnResults?has_content>
							(<@com.picklist blockItem.RemarksOnResults/>)
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro depurationList depurationRepeatableBlock>
	<#compress>
		<#if depurationRepeatableBlock?has_content>
			<#list depurationRepeatableBlock as blockItem>
				<#if blockItem.Elimination?has_content || blockItem.Endpoint?has_content || blockItem.DepurationTime?has_content ||
				blockItem.RemarksOnResults?has_content >
					<para role="indent">
						<#if blockItem.Elimination?has_content>
							elimination: <@com.picklist blockItem.Elimination/>
						</#if>

						<#if blockItem.Endpoint?has_content>
							<@com.picklist blockItem.Endpoint/>:
						</#if>

						<#if blockItem.DepurationTime?has_content>
							<@com.quantity blockItem.DepurationTime/>
						</#if>

						<#if blockItem.RemarksOnResults?has_content>
							(<@com.picklist blockItem.RemarksOnResults/>)
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--2. methods-->
<#macro ecotoxMethod study>
	<#compress>

	<#--Test organisms-->
	<#--NOTE: sometimes (ToxicityToTerrestrialPlants) is a repeatable block-->
		<#if study.MaterialsAndMethods.hasElement("TestOrganisms") && study.MaterialsAndMethods.TestOrganisms?has_content>
			<#local to=study.MaterialsAndMethods.TestOrganisms/>
			<para><emphasis role='bold'>Test organisms:</emphasis>
				<#if study.documentSubType=="ToxicityToTerrestrialPlants">
					<@TestOrgsForTerrestrialPlants to.TestOrganisms/>
				<#else>
					<#if to.hasElement("TestOrganismsSpecies") && to.TestOrganismsSpecies?has_content>
						<@com.picklist to.TestOrganismsSpecies/>

					<#elseif to.hasElement("TestOrganismsInoculum") && to.TestOrganismsInoculum?has_content>
						<@com.picklist to.TestOrganismsInoculum/>
					</#if>

					<#if to.hasElement("AnimalGroup") && to.AnimalGroup?has_content>
						(<@com.value to.AnimalGroup/>)
					</#if>

					<#if to.hasElement("DetailsOnTestOrganisms") && to.DetailsOnTestOrganisms?has_content>
						<para role="indent">
							(<@com.text to.DetailsOnTestOrganisms/>)
						</para>
					</#if>
				</#if>
			</para>
		</#if>

	<#--Sampling and analysis-->
		<#if study.MaterialsAndMethods.hasElement("SamplingAndAnalysis") && study.MaterialsAndMethods.SamplingAndAnalysis?has_content>
			<para><emphasis role='bold'>Sampling and analysis:</emphasis>
				<@com.children study.MaterialsAndMethods.SamplingAndAnalysis/>
			</para>
		</#if>

	<#--Test solutions-->
		<#if study.MaterialsAndMethods.hasElement("TestSolutions") && study.MaterialsAndMethods.TestSolutions?has_content>
			<para><emphasis role='bold'>Test solutions:</emphasis>
				<@com.children study.MaterialsAndMethods.TestSolutions/>
			</para>
		</#if>

	<#--Test substrate-->
		<#if study.MaterialsAndMethods.hasElement("TestSubstrate") && study.MaterialsAndMethods.TestSubstrate?has_content>
			<para><emphasis role='bold'>Test substrate:</emphasis>
				<@com.children study.MaterialsAndMethods.TestSubstrate/>
			</para>
		</#if>

	<#--Study design-->
		<#if study.MaterialsAndMethods.hasElement("StudyDesign") && study.MaterialsAndMethods.StudyDesign?has_content>
			<para><emphasis role='bold'>Study design:</emphasis>
				<@com.children study.MaterialsAndMethods.StudyDesign/>
			</para>
		</#if>

	<#--Examinations-->
		<#if study.MaterialsAndMethods.hasElement("Examinations") && study.MaterialsAndMethods.Examinations?has_content>
			<para><emphasis role='bold'>Examinations:</emphasis>
				<@com.children study.MaterialsAndMethods.Examinations/>
			</para>
		</#if>

	<#--Test conditions-->
		<#if study.MaterialsAndMethods.hasElement("TestConditions") && study.MaterialsAndMethods.TestConditions?has_content>
			<para><emphasis role='bold'>Test conditions:</emphasis>
				<@com.children study.MaterialsAndMethods.TestConditions/>
			</para>
		</#if>

	</#compress>
</#macro>

<#--3. summaries-->
<#--General macro to print individual ecotox summaries, with CSA data in table format-->
<#macro ecotoxPPPsummary _subject docSubType>
	<#compress>

		<#-- Get doc-->
		<#if docSubType=="AquaticToxicityRacReporting">
			<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", docSubType) />
		<#else>
			<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />
		</#if>

		<#-- Iterate-->
		<#if summaryList?has_content>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

			<#assign printSummaryName = summaryList?size gt 1 />

			<#list summaryList as summary>
				<@com.emptyLine/>

				<#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

				<#--CSA path-->
				<#if summary.hasElement("KeyValueForCsa")>
					<#local csaPath=summary["KeyValueForCsa"]>
				<#elseif summary.hasElement("KeyValueForChemicalSafetyAssessment")>
					<#local csaPath=summary["KeyValueForChemicalSafetyAssessment"]>
				<#elseif summary.hasElement("KeyValueCsa")>
					<#local csaPath=summary["KeyValueCsa"]>
				</#if>

				<#--Key Information-->
				<#if summary.hasElement("KeyInformation") && summary.KeyInformation.KeyInformation?has_content>
					<para><emphasis role="bold">Key information: </emphasis></para>
					<para role="indent"><@com.richText summary.KeyInformation.KeyInformation/></para>
				</#if>

				<#--Links (only for cases with no standard table)-->
				<#if (!(csaPath??) || docSubType=="BioaccumulationAquaticSediment_EU_PPP")
						&& summary.hasElement("LinkToRelevantStudyRecord.Link") && summary.LinkToRelevantStudyRecord.Link?has_content>
					<para><emphasis role="bold">Link to relevant study records: </emphasis></para>
					<para role="indent">
						<#list summary.LinkToRelevantStudyRecord.Link as link>
							<#if link?has_content>
								<#local studyReference = iuclid.getDocumentForKey(link) />
								<para>
									<command  linkend="${studyReference.documentKey.uuid!}">
										<@com.text studyReference.name/>
									</command>
								</para>
							</#if>
						</#list>
					</para>
				</#if>

				<#--CSA-->
				<#if summary.documentSubType=="AquaticToxicityRacReporting" && summary.KeyInformation.RACValues?has_content>
					<para><emphasis role="bold">RAC values: </emphasis></para>
					<para role="small"><@RACvaluesTable summary.KeyInformation.RACValues/></para>

				<#elseif summary.documentSubType=="BioaccumulationTerrestrial" && summary.KeyValueForChemicalSafetyAssessment.BcfTerrestrialSpecies?has_content>
					<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
					<para>
						BCF (terrestrial species): <@com.quantity summary.KeyValueForChemicalSafetyAssessment.BcfTerrestrialSpecies/>
					</para>

				<#elseif summary.documentSubType=="BioaccumulationAquaticSediment_EU_PPP" && summary.KeyValueCsa?has_content>
					<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
					<#if summary.KeyValueCsa.BioconcentrationFish?has_content>
						<para role="small"><@bioconcentrationFishTable summary.KeyValueCsa/></para>
					</#if>
					<#if summary.KeyValueCsa.FishBmf?has_content>
						<para>BMF (fish) = <@com.number summary.KeyValueCsa.FishBmf/></para>
					</#if>
				<#elseif csaPath?? && csaPath?has_content>
					<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
					<para role="small"><@ecoToxCSAtable summary/></para>
				</#if>

				<#--Hier tier testing-->
				<#if summary.hasElement("HigherTierTesting.field1350") && summary.HigherTierTesting.field1350?has_content>
					<para><emphasis role="bold">Higher tier testing for safety assessment:</emphasis></para>
					<para role="indent"><@com.richText summary.HigherTierTesting.field1350/></para>
				</#if>

				<#--Discussion-->
				<#if summary.hasElement("Discussion") && summary.Discussion.Discussion?has_content>
					<para><emphasis role="bold">Discussion:</emphasis></para>
					<para role="indent"><@com.richText summary.Discussion.Discussion/></para>
				</#if>

			</#list>
		</#if>
	</#compress>
</#macro>

<#--This macro merges all summaries of the indicated types, including all endpoints in one single table-->
<#--NOTE: does not work for RAC, or BioAccummulation (aquatic and terrestrial) since they have different format-->
<#macro ecotoxPPPsummary_merged _subject docSubTypes>
	<#compress>

		<#--Get all documents, from same or different type-->
		<#if !docSubTypes?is_sequence>
			<#local docSubTypes=[docSubTypes]/>
		</#if>

		<#local allSummaryList=[]/>
		<#list docSubTypes as docSubType>
			<#if docSubType=="AquaticToxicityRacReporting">
				<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", docSubType) />
			<#else>
				<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />
			</#if>
			<#local allSummaryList = allSummaryList + summaryList/>
		</#list>

		<#--Iterate through summaries and create section lists-->
		<#assign keyInfo=[]/>
		<#assign endpointsHash={}/>
		<#assign higherTier=[]/>
		<#assign discussion=[]/>

		<#if allSummaryList?has_content>
			<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

			<#list allSummaryList as summary>

				<#-- Key information-->
				<#if summary.KeyInformation.KeyInformation?has_content>
					<#local summaryKeyInfo><para role="indent"><@com.richText summary.KeyInformation.KeyInformation/></para></#local>
					<#assign keyInfo = keyInfo + [summaryKeyInfo]/>
				</#if>


				<#--CSA value -->
				<#-- 1.Get hashmap-->
				<#local summarySeq = getEcotoxSummarySeq(summary)/>

				<#list summarySeq as seqEntry>
					<#if endpointsHash[seqEntry["name"]]??>
						<#local newSeqEntry = endpointsHash[seqEntry["name"]] + [seqEntry]/>
						<#local endpointsHash = endpointsHash + {seqEntry["name"]:newSeqEntry}/>
					<#else>
						<#local endpointsHash = endpointsHash + {seqEntry["name"]:[seqEntry]}/>
					</#if>
				</#list>

				<#--Hier tier testing-->
				<#if summary.hasElement("HigherTierTesting.field1350") && summary.HigherTierTesting.field1350?has_content>
					<#local summaryHigherTier><para role="indent"><@com.richText summary.HigherTierTesting.field1350/></para></#local>
					<#assign higherTier = higherTier + [summaryHigherTier]/>
				</#if>

				<#--Discussion-->
				<#if summary.hasElement("Discussion.Discussion") && summary.Discussion.Discussion?has_content>
					<#local summaryDiscussion><para role="indent"><@com.richText summary.Discussion.Discussion/></para></#local>
					<#assign discussion =  discussion + [summaryDiscussion]/>
				</#if>
			</#list>

			<#if keyInfo?has_content>
				<para><emphasis role="bold">Key information: </emphasis></para>
				${keyInfo?join("")}
			</#if>

			<#if endpointsHash?has_content>
				<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
				<@getEcotoxSummaryFromHash endpointsHash/>
			</#if>

			<#if higherTier?has_content>
				<para><emphasis role="bold">Higher tier testing for safety assessment:</emphasis></para>
				${higherTier?join("")}
			</#if>

			<#if discussion?has_content>
				<para><emphasis role="bold">Discussion:</emphasis></para>
				${discussion?join("")}
			</#if>


		</#if>
	</#compress>
</#macro>


<#--Function to crete a hashmap with CSA info from ecotox summaries-->
<#function getEcotoxSummarySeq summary>

	<#local mySeq=[]/>

	<#-- consider different path names (missing RAC, and bioterrestrial)-->
	<#if summary.hasElement("KeyValueForCsa")>
		<#local csaPath=summary["KeyValueForCsa"]>
	<#elseif summary.hasElement("KeyValueForChemicalSafetyAssessment")>
		<#local csaPath=summary["KeyValueForChemicalSafetyAssessment"]>
	<#elseif summary.hasElement("KeyValueCsa")>
		<#local csaPath=summary["KeyValueCsa"]>
	</#if>

	<#-- consider case where links are outside of the table-->
	<#local generalLinks=""/>
	<#if summary.hasElement("LinkToRelevantStudyRecord.Link") && summary.LinkToRelevantStudyRecord.Link?has_content>
		<#local generalLinks><#compress>
			<#list summary.LinkToRelevantStudyRecord.Link as link>
				<#if link?has_content>
					<#local studyReference = iuclid.getDocumentForKey(link) />
					<command  linkend="${studyReference.documentKey.uuid!}">
						<@com.text studyReference.name/>
					</command>
					<#if link_has_next><?linebreak?></#if>
				</#if>
			</#list>
		</#compress></#local>
	</#if>

	<#-- iterate CSA blocks-->
	<#list csaPath?children as block>
		<#if block?node_type=="repeatable" && block?has_content>
			<#local testType=block?node_name?replace("([A-Z]{1})", " $1", "r")?replace("_list", "")?lower_case?cap_first/>

			<#list block as item>
				<#--Test type-->
				<#local testType><#compress>
					${testType}
					<#if item.hasElement("TypeOfStudy") && item.TypeOfStudy?has_content>
						<?linebreak?>(<@com.picklist item.TypeOfStudy/>)
					</#if>
				</#compress></#local>

				<#--Links-->
				<#local links><#compress>
					<#if item.hasElement("Link")>
						<#if item.Link?has_content>
							<#local studyReference = iuclid.getDocumentForKey(item.Link) />
							<command  linkend="${studyReference.documentKey.uuid!}">
								<@com.text studyReference.name/>
							</command>
						</#if>
					<#elseif generalLinks?has_content>
						${generalLinks}
					</#if>
				</#compress></#local>

				<#-- Organisms-->
				<#local orgs><#compress>
					<#if item.hasElement("AnimalGroup") && item.AnimalGroup?has_content>
						<#if item.AnimalGroup?node_type=="picklist_multi">
							<@com.picklistMultiple item.AnimalGroup/>
						<#else>
							<@com.text item.AnimalGroup/>
						</#if>
						<#if item.TestOrganismsSpecies?has_content>: </#if>
					</#if>
					<#if item.hasElement("TestOrganismsSpecies") && item.TestOrganismsSpecies?has_content>
						<@com.picklistMultiple item.TestOrganismsSpecies/>
					</#if>
				</#compress></#local>

				<#-- Substance-->
				<#local substance><#compress>
					<#if item.Substance?has_content>
						<#local refSubstance=iuclid.getDocumentForKey(item.Substance)/>
						<@com.text refSubstance.ChemicalName/>
					</#if>
					<#if item.ParentMetabolite?has_content>
						<?linebreak?>(<@com.picklist item.ParentMetabolite/>)
					</#if>
				<#--								PreparationApplicationTestSubstance (richText) details preparation/application substance-->
				</#compress></#local>

				<#-- Endpoint -->
				<#local endpoint><#compress>
					<#if item.DoseDescriptor?has_content>
						<@com.picklist item.DoseDescriptor/>:
						<#if item.hasElement("EffectConcentration")><@com.range item.EffectConcentration/>
						<#elseif item.hasElement("EffectConc")><@com.range item.EffectConc/>
						<#elseif item.hasElement("EffectValue")><@com.range item.EffectValue/>
						</#if>
					</#if>
					<#if item.hasElement("NominalMeasured") && item.NominalMeasured?has_content>
						<?linebreak?>(<@com.picklist item.NominalMeasured/>)
					</#if>
					<#if item.BasisForEffect?has_content>
						<?linebreak?>(basis: <@com.picklistMultiple item.BasisForEffect/>)
					</#if>
				</#compress></#local>

				<#--append-->
				<#if links?has_content || endpoint?has_content || orgs?has_content || substance?has_content>
					<#local mySeq = mySeq + [{'name': testType!, "links" : links!, "endpoint":endpoint!, "substance":substance!, "organisms":orgs!}]/>
				</#if>

			</#list>
		</#if>
	</#list>


	<#--special cases-->
	<#if csaPath.hasElement("EcTenLcTenNoecMarineWaterFish") && csaPath.EcTenLcTenNoecMarineWaterFish?has_content>
		<#local endpoint>EC10 / LC10 / NOEC: <@com.range csaPath.EcTenLcTenNoecMarineWaterFish/></#local>
		<#local mySeq = mySeq + [{'name': "Long-term toxicity to marine fish", "links" : generalLinks!, "endpoint":endpoint, "substance":"",
		"organisms":"Marine fish"}]/>
	</#if>

	<#return mySeq/>

</#function>

<#--Macro for the basic summary table of ecotox CSA using info stored in a hashmap-->
<#macro getEcotoxSummaryFromHash hash>
	<#compress>
		<table border="1">
			<tbody valign="middle">
			<tr align="center">
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Test type</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Organism</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Substance</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
			</tr>

			<#--			<#list hash?keys?sort as key>-->
			<#list hash?keys as key>
				<#local seq = hash[key]/>
				<#local usespan = true />
				<#list seq as item>
					<tr>
						<#if usespan>
							<td rowspan="${seq?size}">${key}</td>
							<#local usespan = false />
						</#if>
						<td>${item.links}</td>
						<td>${item.organisms}</td>
						<td>${item.substance}</td>
						<td>${item.endpoint}</td>
					</tr>
				</#list>
			</#list>
			</tbody></table>
	</#compress>
</#macro>

<#--Macro for the basic summary table of ecotox CSA, using other independent functions/macros-->
<#macro ecoToxCSAtable summary>
	<#compress>

		<#-- 1.Get hashmap-->
		<#local endpointsHash={}/>
		<#local summarySeq = getEcotoxSummarySeq(summary)/>

		<#list summarySeq as seqEntry>
			<#if endpointsHash[seqEntry["name"]]??>
				<#local newSeqEntry = endpointsHash[seqEntry["name"]] + [seqEntry]/>
				<#local endpointsHash = endpointsHash + {seqEntry["name"]:newSeqEntry}/>
			<#else>
				<#local endpointsHash = endpointsHash + {seqEntry["name"]:[seqEntry]}/>
			</#if>
		</#list>

		<@getEcotoxSummaryFromHash endpointsHash/>

	</#compress>
</#macro>

<#--Table for RAC-->
<#macro RACvaluesTable rac>
	<#compress>

		<table border="1">
			<tbody valign="middle">

			<tr align="center">
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Test type</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Organism</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Substance</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
			</tr>

			<#list rac as item>
				<tr>
					<td>
						<@com.picklist item.TimeScale/> <@com.picklist item.Tier/>
					</td>
					<td>
						<@com.picklistMultiple item.TestOrganisms/>
					</td>
					<td>
						<#if item.Substance?has_content>
							<#local refSubstance=iuclid.getDocumentForKey(item.Substance)/>
							<@com.text refSubstance.ChemicalName/>
						</#if>
						<#if item.ParentMetabolite?has_content>
							<?linebreak?>(<@com.picklist item.ParentMetabolite/>)
						</#if>
					</td>
					<td>
						<#if item.RacValueType?has_content && item.RacValue?has_content>
							<@com.picklist item.RacValueType/>: <@com.quantity item.RacValue/>
						</#if>
						<#if item.AssessmentFactor?has_content>
							<?linebreak?>(assessment factor: <@com.picklistMultiple item.AssessmentFactor/>)
						</#if>
					</td>
				</tr>
			</#list>

			</tbody>
		</table>
	</#compress>
</#macro>

<#--Table for bioconcentration in fish-->
<#macro bioconcentrationFishTable csa>
	<#compress>

<#--	&lt;#&ndash; consider case where links are outside of the table&ndash;&gt;-->
<#--		<#local generalLinks=""/>-->
<#--		<#if csa?parent.hasElement("LinkToRelevantStudyRecord.Link") && csa?parent.LinkToRelevantStudyRecord.Link?has_content>-->
<#--			<#local generalLinks><#compress>-->
<#--				<#list csa?parent.LinkToRelevantStudyRecord.Link as link>-->
<#--					<#if link?has_content>-->
<#--						<#local studyReference = iuclid.getDocumentForKey(link) />-->
<#--						<command  linkend="${studyReference.documentKey.uuid!}">-->
<#--							<@com.text studyReference.name/>-->
<#--						</command>-->
<#--						<#if link_has_next><?linebreak?></#if>-->
<#--					</#if>-->
<#--				</#list>-->
<#--			</#compress></#local>-->
<#--		</#if>-->

		<table border="1">
			<tbody valign="middle">

			<tr align="center">
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Substance</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Nature/level residues</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
<#--				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>-->
			</tr>

			<#list csa.BioconcentrationFish as item>
				<tr>
					<td>
						<#if item.Substance?has_content>
							<#local refSubstance=iuclid.getDocumentForKey(item.Substance)/>
							<@com.text refSubstance.ChemicalName/>
						</#if>
						<#if item.ParentMetabolite?has_content>
							<?linebreak?>(<@com.picklist item.ParentMetabolite/>)
						</#if>
					</td>
					<td>
						<#if item.LogPow?has_content>
							logPo/w = <@com.text item.LogPow/><?linebreak?>
						</#if>
						<#if item.BcfAquaticSpecies?has_content>
							BCF (aquatic species) = <@com.quantity item.BcfAquaticSpecies/><?linebreak?>
						</#if>
						<#if item.CtFiftyClearaceTime?has_content>
							CT50 = <@com.quantity item.CtFiftyClearaceTime/><?linebreak?>
						</#if>
						<#if item.CtNinetyClearaceTime?has_content>
							CT90 = <@com.quantity item.CtNinetyClearaceTime/><?linebreak?>
						</#if>
					</td>
					<td>
						<#if item.NatureAndLevelOfResidues?has_content>
							<@com.richText item.NatureAndLevelOfResidues/>
						</#if>
					</td>
					<td>
						<#if item.Remarks?has_content>
							<@com.richText item.Remarks/>
						</#if>
					</td>
<#--					<td>${generalLinks}</td>-->
				</tr>
			</#list>
<#--			<#if csa.FishBmf?has_content>-->
<#--				<tr>-->
<#--					<td></td>-->
<#--					<td>-->
<#--						BMF (fish) = <@com.number csa.FishBmf/><?linebreak?>-->
<#--					</td>-->
<#--					<td></td>-->
<#--					<td></td>-->
<#--					<td>${generalLinks}</td>-->
<#--				</tr>-->
<#--			</#if>-->

			</tbody>
		</table>
	</#compress>
</#macro>

<#--Summary of ecotox risk assessment-->
<#macro ecotoxRiskAssessmentPPP>
	<#compress>

		<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", "EcotoxRiskAssessmentPesticides") />

		<#if summaryList?has_content>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

			<#assign printSummaryName = summaryList?size gt 1 />

			<#list summaryList as summary>
				<@com.emptyLine/>

				<#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

				<#--Assessment(table)-->
				<#if summary.EcotoxRiskAssessmentPesticides?has_content>

					<para><emphasis role="bold">Ecotoxicological risk assessment of pesticides:</emphasis></para>
					<para>

						<table border="1">
<#--							<title>Ecotoxicological risk assessment of pesticides</title>-->

							<col width="25%" />
							<col width="75%" />

							<tbody valign="middle">

							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentBirds.field9187?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Birds</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentBirds.field9187/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentWildMammals.field8618?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Wild mammals</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentWildMammals.field8618/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentOtherTerrestrialVertebrates.field593?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Other terrestrial vertebrates</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentOtherTerrestrialVertebrates.field593/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentAquaticOrganisms.field4291?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Aquatic organisms</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentAquaticOrganisms.field4291/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentBees.field9185?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Bees</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentBees.field9185/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentNonBees.field5875?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Non-target arthropods other than bees</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentNonBees.field5875/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSoilMesoMacrofauna.field9216?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Non-target soil meso- and macrofauna</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSoilMesoMacrofauna.field9216/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSoilTransformation.field9651?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Soil nitrogen transformation</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSoilTransformation.field9651/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentHigherPlants.field4576?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Terrestrial non-target higher plants</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentHigherPlants.field4576/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSewageTreatmentMethods.field6508?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Biological methods for sewage treatment</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentSewageTreatmentMethods.field6508/></td>
								</tr>
							</#if>
							<#if summary.EcotoxRiskAssessmentPesticides.RiskAssessmentToOtherTerrestrialOrganismsFloraAndFauna.field2441?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Other terrestrial organisms (flora and fauna)</emphasis></th>
									<td><@com.richText summary.EcotoxRiskAssessmentPesticides.RiskAssessmentToOtherTerrestrialOrganismsFloraAndFauna.field2441/></td>
								</tr>
							</#if>

							</tbody>
						</table>
					</para>
				</#if>

			<#--Add Information-->
				<#if summary.AdditionalInformation.field9160?has_content>
					<para><emphasis role="bold">Additional information: </emphasis></para>
					<para role="indent"><@com.richText summary.AdditionalInformation.field9160/></para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro ecotoxicologicalInformationSummary>
	<#compress>
		<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "EcotoxicologicalInformation") />

		<#if summaryList?has_content>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Summary of ecotoxicological information</emphasis></para>

			<#assign printSummaryName = summaryList?size gt 1 />

			<#list summaryList as summary>
				<@com.emptyLine/>

				<#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

			<#-- iterate over blocks-->
			<#--				<para><emphasis role="bold">Hazard assessment: </emphasis></para>-->

				<table border="1">
					<title>Hazard assessment</title>
					<col width="20%" />
					<col width="40%" />
					<col width="40%" />

					<tbody valign="middle">

					<tr align="center">
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment conclusion</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Explanation</emphasis></th>
					</tr>

					<#local hazardBlocks=["HazardForAquaticOrganisms","HazardForAir","HazardForTerrestrialOrganisms","HazardForPredators"]/>
					<#list summary?children as section>
						<#if hazardBlocks?seq_contains(section?node_name)>
							<#local sectionName=section?node_name?replace("HazardFor", "")?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first/>
							<#list section?children as block>
								<#local blockName=block?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first/>
								<#if block?has_content>
									<tr>
										<td>${sectionName}: ${blockName}</td>
										<td>
											<@com.picklist block.HazAssessConcl/>
											<#if block.HazAssessConclVal?has_content>
												: <@com.quantity block.HazAssessConclVal/>
											</#if>

											<#if block.hasElement("PNECFreshwaterIntermittentReleases") && block.PNECFreshwaterIntermittentReleases?has_content>
												<?linebreak?>(PNEC (intermittent releases) = <@com.quantity block.PNECFreshwaterIntermittentReleases/>)
											<#elseif block.hasElement("PNECMarineWaterIntermittentReleases") && block.PNECMarineWaterIntermittentReleases?has_content>
												<?linebreak?>(PNEC (intermittent releases) = <@com.quantity block.PNECMarineWaterIntermittentReleases/>)
											</#if>

											<#if block.hasElement("AssessmentFactor") && block.AssessmentFactor?has_content>
												<@com.emptyLine/>
												<?linebreak?>assessment factor = <@com.number block.AssessmentFactor/>
											</#if>
											<#if block.hasElement("ExtrapolationMethod") && block.ExtrapolationMethod?has_content>
												<@com.emptyLine/>
												<?linebreak?>extrapolation method: <@com.picklist block.ExtrapolationMethod/>
											</#if>

										</td>
										<td><@com.richText block.Justification/></td>
									</tr>
								</#if>
							</#list>
						</#if>
					</#list>
					</tbody>
				</table>

			<#--Add Information-->
				<#if summary.Discussion.Discussion?has_content>
					<para><emphasis role="bold">Additional information: </emphasis></para>
					<para role="indent"><@com.richText summary.Discussion.Discussion/></para>
				</#if>

			<#--Conclusion-->
				<#if summary.ConclusionOnClassification.JustificationEnv?has_content>
					<para><emphasis role="bold">Conclusion on classification: </emphasis></para>
					<para role="indent"><@com.richText summary.ConclusionOnClassification.JustificationEnv/></para>
				</#if>

			</#list>

		</#if>
	</#compress>
</#macro>