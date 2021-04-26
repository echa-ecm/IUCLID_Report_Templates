<!-- 4. ENVIRONMENTAL FATE PROPERTIES template file -->

<!-- General discussion of environmental fate and pathways -->
<#macro environmentalFateAndPathwaysSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "EnvironmentalFateAndPathways") />

	<#if summaryList?has_content>
		<para><emphasis role="underline"><emphasis role="bold">General discussion of environmental fate and pathways:</emphasis></emphasis></para>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
		</#list>
	</#if>		
</#compress>
</#macro>

<!-- Hydrolysis study data -->
<#macro hydrolysisStudies _subject>
<#compress>
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Hydrolysis") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList />
			
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on hydrolysis are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on hydrolysis</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.StudyDesign.EstimationMethodIfUsed/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Half-life (DT50):</para>
							<@hydrolysisHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DissipationHalfLifeOfParentCompound)/>									
							
							<para>Recovery (in %):</para>
							<@recoveryList study.ResultsAndDiscussion.TotalRecoveryOfTestSubstance/>
							
							<para>
								Transformation products: <@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Hydrolysis"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Hydrolysis"/>

</#compress>
</#macro>
	
<!-- Summary Discussion for hydrolysis -->
<#macro hydrolysisSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Hydrolysis") />
					
	<#if summaryList?has_content>
		<#list summaryList as summary>
		
			<#assign summarytext = getCSAValueTextHydrolysis(summary)/>					
			<#if summarytext?has_content>
				<@CSAValueText summary typeText typeText1 />
			</#if>
			
			<#assign summaryCSAValue = getCSAValuesHydrolysis(summary)/>
			<#if summaryCSAValue?has_content>
				<#assign valueForCsaText>
					<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeForHydrolysis?has_content>
						Half-life for hydrolysis: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeForHydrolysis /> 
					</#if>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content>
						at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf />
					</#if>
				</#assign>
			</#if>
			
			<#assign printSummaryName = summaryList?size gt 1 />
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>	
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Phototransformation in air study data -->
<#macro phototransformationInAirStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "PhototransformationInAir") />	
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList />
				
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on phototransformation in air are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on phototransformation in air</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.StudyDesign.EstimationMethodIfUsed/>
							</para>
							<para>
								Light source: <@com.picklist study.MaterialsAndMethods.StudyDesign.LightSource/>
							</para>
							<para>
								Light spectrum: <@com.range study.MaterialsAndMethods.StudyDesign.LightSpectrumWavelengthInNm/>
							</para>
							<para>
								Rel. light intensity: <@com.range study.MaterialsAndMethods.StudyDesign.RelativeLightIntensity/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Spectrum of substance:</para>
							<@spectrumOfSubstanceList study.ResultsAndDiscussion.SpectrumOfSubstance/>
							
							<para>Half-life (DT50):</para>
							<@phototransformationHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DissipationParentCompound)/>								
							
							<para>% Degradation:</para>
							<@degradationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
							
							<para>Degradation rate constant:</para>
							<@degradationRateConstantList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DegradationRateConstant)/>
							
							<para>Quantum yield: <@com.number study.ResultsAndDiscussion.QuantumYield/></para>
							
							<para>Transformation products:</para>
							<@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Phototransformation in air"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Phototransformation in air"/>

</#compress>
</#macro>	

<!-- Summary Discussion for Phototransformation in air -->
<#macro phototransformationInAirSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "PhototransformationInAir") />
		
	<#if summaryList?has_content>
	
		<#assign summaryCSAValue = getCSAValuesPhototransformationInAir(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInAir?has_content>
					Half-life in air: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInAir/>
				<?linebreak?>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.DegradationRateConstantWithOHRadicals?has_content>
					Degradation rate constant with OH radicals: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.DegradationRateConstantWithOHRadicals/>
				</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
				
</#compress>
</#macro>				
				
<!-- Phototransformation in water study table -->
<#macro phototransformationInWaterStudies _subject>
<#compress>
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Phototransformation") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
				
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on phototransformation in water are summarised in the following table:
		
		<table border="1">
			<title>Studies on phototransformation in water</title>
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
								Study type: <@com.picklist study.MaterialsAndMethods.StudyType/>
							</para>
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.StudyDesign.ComputationalMethods/>
							</para>
							<para>
								Light source: <@com.picklist study.MaterialsAndMethods.StudyDesign.LightSource/>
							</para>
							<para>
								Light spectrum: <@com.range study.MaterialsAndMethods.StudyDesign.LightSpectrumWavelengthInNm/>
							</para>
							<para>
								Rel. light intensity: <@com.range study.MaterialsAndMethods.StudyDesign.RelativeLightIntensity/>
							</para>
							<para>Sensitiser:</para>
							<@sensitiserList study.MaterialsAndMethods.StudyDesign.SensitiserForIndirectPhotolysis/>
						</td>
						<!-- Results -->
						<td>
							<para>Spectrum of substance:</para>
							<@spectrumOfSubstanceList study.ResultsAndDiscussion.SpectrumOfSubstance/>
							
							<para>Half-life (DT50):</para>
							<@phototransformationHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DissipationParentCompound)/>								
							
							<para>% Degradation:</para>
							<@degradationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
							
							<para>Quantum yield: <@com.number study.ResultsAndDiscussion.QuantumYield/></para>
							
							<para>Rate constant: <@com.range study.ResultsAndDiscussion.RateConstant/></para>
							
							<para>Transformation products:</para>
							<@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Phototransformation in water"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Phototransformation in water"/>

</#compress>
</#macro>	
	
<!-- Summary Discussion Phototransformation in water -->
<#macro phototransformationInWaterSummary _subject>
<#compress>	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "PhototransformationInWater") />	
				
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesPhototransformationInWater(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInWater?has_content>
				Half-life in freshwater: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInWater/>	
				</#if>
			</#assign>
		
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>	
	
<!-- Phototransformation in soil study table -->
<#macro phototransformationInSoilStudies _subject>
<#compress>		
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "PhotoTransformationInSoil") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on phototransformation in soil are summarised in the following table:
		
		<table border="1">
			<title>Studies on phototransformation in soil</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.StudyDesign.ComputationalMethods/>
							</para>
							<para>
								Light source: <@com.picklist study.MaterialsAndMethods.StudyDesign.LightSource/>
							</para>
							<para>
								Light spectrum: <@com.range study.MaterialsAndMethods.StudyDesign.LightSpectrumWavelengthInNm/>
							</para>
							<para>
								Rel. light intensity: <@com.range study.MaterialsAndMethods.StudyDesign.RelativeLightIntensity/>
							</para>
							<para>
								Details on soil: <@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnSoil/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Spectrum of substance:</para>
							<@spectrumOfSubstanceList study.ResultsAndDiscussion.Spectrum/>
							
							<para>Half-life (DT50):</para>
							<@phototransformationHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DissipationHalfLife)/>								
							
							<para>% Degradation:</para>
							<@degradationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
							
							<para>Quantum yield: <@com.number study.ResultsAndDiscussion.QuantumYield/></para>
							
							<para>Transformation products:</para>
							<@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Phototransformation in soil"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Phototransformation in soil"/>

</#compress>
</#macro>
	
<!-- Summary Discussion Phototransformation in soil -->
<#macro phototransformationInSoilSummary _subject>
<#compress>		
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "PhototransformationInSoil") />
								
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesInSoil(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInSoil?has_content>
				Half-life in soil: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInSoil/>
				</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
				
</#compress>
</#macro>

<!-- Biodegradation in water screening tests -->
<#macro biodegradationScreeningTestsStudies _subject>
<#compress>			

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BiodegradationInWaterScreeningTests") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on biodegradation in water (screening tests) are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Screening tests for biodegradation in water</title>
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
								<@com.picklist study.AdministrativeData.Endpoint/>:
							</para>
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.InoculumOrTestSystem/>
								
								<#if study.MaterialsAndMethods.StudyDesign.OxygenConditions?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.OxygenConditions/>)
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
							<para>
								<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
							</para>
							<para>% Degradation of test substance:</para>
							<@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Biodegradation in water: screening test"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Biodegradation in water: screening test"/>
	
</#compress>
</#macro>

<!-- Simulation tests (water and sediments) -->
<#macro biodegradationScreeningInWaterSedimentStudies _subject>
<#compress>	
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BiodegradationInWaterAndSedimentSimulationTests") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on biodegradation in water (screening tests) are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Simulation tests for biodegradation in water and sediment</title>
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
								<@com.picklist study.AdministrativeData.Endpoint/>:
							</para>
							<para>
								Test system: <@com.picklist study.MaterialsAndMethods.StudyDesign.InoculumOrTestSystem/>
								<#if study.MaterialsAndMethods.StudyDesign.OxygenConditions?has_content>
									(<@com.picklist study.MaterialsAndMethods.StudyDesign.OxygenConditions/>)
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
							<para>Half-life (DT50):</para>
							<@biodegradationHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.HalfLifeOfParentCompound50DisappearanceTimeDT50)/>
							<para>% Degradation of test substance:</para>
							<@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
							<para>
								Mineralization rate: <@com.quantity study.ResultsAndDiscussion.MineralizationRateInCO2/>
							</para>
							<para>
								Transformation products: <@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
							</para>
							<@transformationProductList study.ResultsAndDiscussion.IdentityTransformation/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Simulation testing for biodegradation in water and sediment"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Simulation testing for biodegradation in water and sediment"/>

</#compress>
</#macro>	
	
<!-- Summary Discussion of biodegradation in water screening tests -->
<#macro biodegradationScreeningInWaterScreeningTestsSummary _subject>
<#compress>	
		
	<!-- Discussion -->
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "BiodegradationInWaterScreeningTests") />
					
	<#if !summaryList?has_content>
	No relevant information available.
		<#else/>
		
		<#assign summaryCSAValue = getCSAValuesBiodegradationInWaterScreeningTests(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText_screening summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.BiodegradationInWater?has_content>
				Biodegradation in water: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.BiodegradationInWater/>
				</#if>
				<para>
				<#if summary.KeyValueForChemicalSafetyAssessment.TypeOfWater?has_content>
					Type of water: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.TypeOfWater />
				</#if>
				</para>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>	

<!-- Summary Discussion of biodegradation in water and sediment simulation tests -->
<#macro biodegradationScreeningInWaterSedimentSimulationSummary _subject>
<#compress>	
	
	<!-- Discussion -->
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "BiodegradationInWaterAndSedimentSimulationTests") />
	
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesBiodegradationInWaterAndSedimentSimulationTests(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText_simulation summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwater?has_content>
				Half-life in freshwater: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwater/> 
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfFreshwater?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfFreshwater/>
					<?linebreak?>
				</#if>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInMarineWater?has_content>
				Half-life in marine water: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInMarineWater/> 
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfMarineWater?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfMarineWater/>
					<?linebreak?>
				</#if>
				</#if>
				<?linebreak?>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwaterSediment?has_content>
				Half-life in freshwater sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwaterSediment/> 
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfFreshwaterSediment?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfFreshwaterSediment/>
					<?linebreak?>
				</#if>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInMarineWaterSediment?has_content>
				Half-life in marine water sediment: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInMarineWaterSediment/> 
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfMarineWaterSediment?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOfMarineWaterSediment/>
					<?linebreak?>
				</#if>
				</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>	

<!-- Biodegradation in soil study table -->		
<#macro biodegradationInSoilStudies _subject>
<#compress>
				
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BiodegradationInSoil") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The test results are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Simulation tests for biodegradation in soil</title>
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
								<#if study.AdministrativeData.Endpoint?has_content>
									<@com.picklist study.AdministrativeData.Endpoint/>:
								</#if>
							</para>
							<para>
								Test type: <@com.picklist study.MaterialsAndMethods.TestType/>
							</para>
							
							<para>Soil type:</para>
							<@soilTypeList study.MaterialsAndMethods.StudyDesign.SoilProperties/>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Half-life (DT50):</para>
							<@biodegradationInSoilHalfLifeList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.HalfLifeOfParentCompound)/>
							
							<para>% Degradation of test substance:</para>
							<@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Degradation)/>
							
							<para>Evaporation of parent compound: <@com.picklist study.ResultsAndDiscussion.EvaporationOfParentCompound/></para>
							
							<para>Volatile metabolites: <@com.picklist study.ResultsAndDiscussion.VolatileMetabolites/></para>
							
							<para>Residues: <@com.picklist study.ResultsAndDiscussion.Residues/></para>
							
							<para>
								Transformation products: <@com.picklist study.ResultsAndDiscussion.TransformationProducts/>
							</para>
							<@transformationProductList study.ResultsAndDiscussion.IdentityTransformation/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Soil simulation testing"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Soil simulation testing"/>

</#compress>
</#macro>
	
<!-- Summary Discussion for Biodegradation in soil -->
<#macro biodegradationInSoilSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "BiodegradationInSoil") />
	
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesInSoil(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueText summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HalflifeInSoil?has_content>
				Half-life in soil: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.HalflifeInSoil/> 
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf/>
				</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Summary Discussion for stability -->
<#macro stabilitySummary _subject>
<#compress>
	
	<#assign summaryStabilityList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Stability")/>
	<#if summaryStabilityList?has_content>	
	<#assign printStabilitySummaryName = summaryStabilityList?size gt 1 />
	<para><emphasis role="HEAD-WoutNo">Abiotic degradation</emphasis></para>				
		<#list summaryStabilityList as summary>
			<@studyandsummaryCom.endpointSummary summary "" printSummaryStabilityName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Summary Discussion for biodegradation -->
<#macro biodegradationSummary _subject>
<#compress>
	
	<#assign summaryBiodegradationList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Biodegradation") />	
	<#if summaryBiodegradationList?has_content >
	<#assign printBiodegradationSummaryName = summaryBiodegradationList?size gt 1 />
	<para><emphasis role="HEAD-WoutNo">Biotic degradation</emphasis></para>
		<#list summaryBiodegradationList as summary>
			<@studyandsummaryCom.endpointSummary summary "" printBiodegradationSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Environmental distribution study table -->
<#macro adsorptionDesorptionStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AdsorptionDesorption") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on adsorption/desorption are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Studies on adsorption/desorption</title>
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
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							<para>
								<@com.picklist study.MaterialsAndMethods.MethodType/>
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
							<para>Adsorption coefficient:</para>
							<@adsorptionCoefficientList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.AdsorptionCoefficient)/>
							
							<para>Partition coefficients:</para>
							<@partitionCoefficientList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.AdsorptionOther)/>
							
							<para>Mass balance (in %) at end of adsorption phase:</para>
							<@massBalanceAdsorptiontList study.ResultsAndDiscussion.ResultsBatchEquilibriumOrOtherMethod.MassBalanceAtEndOfAdsorptionPhase/>
							
							<para>Mass balance (in %) at end of desorption phase:</para>
							<@massBalanceDesorptiontList study.ResultsAndDiscussion.ResultsBatchEquilibriumOrOtherMethod.MassBalanceAtEndOfDesorptionPhase/>
							
							<para>
								Transformation products: <@com.picklist study.ResultsAndDiscussion.ResultsBatchEquilibriumOrOtherMethod.TransformationProducts/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Adsorption/desorption"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Adsorption/desorption"/>

</#compress>
</#macro>
	
<!-- Summary Discussion for Environmental distribution -->
<#macro adsorptionDesorptionSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AdsorptionDesorption") />
	<#if summaryList?has_content>
		<#list summaryList as summary>
	
			<#assign summaryCSAValue = getCSAValuesAdsorptionDesorption(summary)/>
			
			<#if summaryCSAValue?has_content>
			<@CSAValueTextEnvironmentAssessment summaryCSAValue typeText typeText1 />
				
			<#assign valueForCsaText>					
			Koc at 20°C: <@com.number summary.KeyValueForChemicalSafetyAssessment.KocAt20Celsius/>
			<?linebreak?>
			<#if summary.KeyValueForChemicalSafetyAssessment.OtherAdsorptionCoefficients?has_content>
				Other adsorption coefficients: 
				<#list summary.KeyValueForChemicalSafetyAssessment.OtherAdsorptionCoefficients as blockItem>
					<para role="indent">
						<@com.picklist blockItem.Type/>
						<#if blockItem.TypeValue?has_content || blockItem.AtTheTemperatureOf?has_content>
							<#if blockItem.TypeValue?has_content>
								: <@com.number blockItem.TypeValue/>
							</#if>
							<#if blockItem.AtTheTemperatureOf?has_content>
								at <@com.quantity blockItem.AtTheTemperatureOf/>
							</#if>
						</#if>
					</para>									
					</#list>
				</#if>
			</#assign>					
			</#if>
				
			<#assign printSummaryName = summaryList?size gt 1 />				
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
			
		</#list>
	</#if>
		
</#compress>
</#macro>		

<!-- Volatilisation study table -->	
<#macro henrysLawConstantStudies _subject>
<#compress>			
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HenrysLawConstant") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on volatilisation are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Studies on volatilisation</title>
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
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnMethods/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Henry's Law constant H:</para>
							<@henrysLawConstantList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.HenrysLawConstantH)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Volatilisation"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Volatilisation"/>

</#compress>
</#macro>	

<!-- Summary Discussion for Henry's law constant -->
<#macro henrysLawConstantSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "HenrysLawConstant") />
			
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesHenrysLawConstant(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextEnvironmentAssessment summaryCSAValue typeText typeText1 />
		</#if>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			<#assign valueForCsaText>
				<#if summary.KeyValueForChemicalSafetyAssessment.HenrysLawConstant?has_content>
					Henry's law constant (H): <@com.number summary.KeyValueForChemicalSafetyAssessment.HenrysLawConstant/> (in Pa m³/mol) 
				</#if>
				
				<#if summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content>
					at <@com.quantity summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf/>
				</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
		
</#compress>
</#macro>		
		
<!-- Distribution modelling study table -->
<#macro distributionModellingStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DistributionModelling") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The data from distribution modelling studies are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Distribution modelling studies</title>
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
								Media: <@com.picklist study.MaterialsAndMethods.Media/>
							</para>
							
							<para><@com.picklist study.MaterialsAndMethods.Model/></para>
							
							<para>
								Calculation programme: <@com.text study.MaterialsAndMethods.CalculationProgramme/>
							</para>
							
							<para>
								Input data: <@com.text study.MaterialsAndMethods.StudyDesign.TestSubstanceInputData/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Percent distribution in media:</para>
							<para>Air (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.AirPercentage/></para>
							<para>Water (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.WaterPercentage/></para>
							<para>Soil (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.SoilPercentage/></para>
							<para>Sediment (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.SedimentPercentage/></para>
							<para>Susp. sediment (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.SuspSedimentPercentage/></para>
							<para>Biota (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.BiotaPercentage/></para>
							<para>Aerosol (%): <@com.number study.ResultsAndDiscussion.PercentDistributionInMedia.AerosolPercentage/></para>
							<para>Other distribution results: <@com.text study.ResultsAndDiscussion.PercentDistributionInMedia.OtherDistributionResults/></para>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Distribution modelling"/>
		
	<!-- Testing proposal -->
	<#if testingProposalStudyList?has_content>
	<@com.emptyLine/>
		<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<#list testingProposalStudyList as study>
			<para><emphasis role="bold">Information requirement:</emphasis> Distribution modelling</para>
			<para role="indent">
				<emphasis role="bold">Model:</emphasis>
				<@com.picklist study.MaterialsAndMethods.Model/>
			</para>
			<para role="indent">
				 Media: <@com.picklist study.MaterialsAndMethods.Media/>
			</para>
			<para role="indent">
				<emphasis role="bold">Planned study period:</emphasis>
				<@com.text study.AdministrativeData.StudyPeriod/>
			</para>
			<para role="indent">
				<emphasis role="bold">Test material:</emphasis>
				<@com.testMaterialInformation study.MaterialsAndMethods.TestMaterials.TestMaterialInformation/>
			</para>
		</#list>
	</#if>
	
</#compress>
</#macro>	
	
<!-- Summary Discussion of environmental distribution -->
<#macro transportAndDistributionSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "TransportAndDistribution") />
			
	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
			<#list summaryList as summary>
				<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
			</#list>
	</#if>
</#compress>
</#macro>	

<!-- Bioaccumulation study table -->
<#macro bioaccumulationAquaticSedimentStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BioaccumulationAquaticSediment") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The studies on aquatic bioaccumulation are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Studies on aquatic bioaccumulation</title>
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
								<@com.picklist study.AdministrativeData.Endpoint/>
							</para>
							<para>
								<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
							</para>
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.RouteOfExposure/>
							</para>
							<para>
								<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
							</para>
							<para>
								Media type: <@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>
							</para>
							<para>
								Total exposure / uptake duration: <@com.range study.MaterialsAndMethods.StudyDesign.TotalExposureUptakeDuration/>
							</para>
							<para>
								Total depuration duration: <@com.range study.MaterialsAndMethods.StudyDesign.TotalDepurationDuration/>
							</para>
							<para>
								Details on estimation of bioconcentration: <@com.text study.MaterialsAndMethods.TestConditions.DetailsOnEstimationOfBioconcentration/>
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
							<para>Bioaccumulation factor:</para>
							<@bioaccumulationFactorList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.BioaccumulationFactor)/>
							
							<para>Elimination:</para>
							<@depurationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Depuration)/>
							
							<para>Lipid content:</para>
							<@lipidContentList study.ResultsAndDiscussion.LipidContent/>
							
							<para>Transformation products: <@com.text study.ResultsAndDiscussion.Metabolites/></para>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Aquatic bioaccumulation"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Aquatic bioaccumulation"/>

</#compress>
</#macro>	
	
<!-- Terrestrial bioaccumulation study table -->
<#macro bioaccumulationTerrestrialStudies _subject>
<#compress>	
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BioaccumulationTerrestrial") />
		
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The results of terrestrial bioaccumulation studies are summarised in the following table:
		<@com.emptyLine/>
		
		<table border="1">
			<title>Studies on terrestrial bioaccumulation</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>Bioaccumulation factor:</para>
							<@bioaccumulationFactorList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.BioaccumulationFactor)/>
							
							<para>Elimination:</para>
							<@depurationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Depuration)/>
							
							<para>Lipid content:</para>
							<@lipidContentList study.ResultsAndDiscussion.LipidContent/>
							
							<para>Transformation products: <@com.text study.ResultsAndDiscussion.Metabolites/></para>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Terrestrial bioaccumulation"/>
		
	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Terrestrial bioaccumulation"/>
		
</#compress>
</#macro>
	
<!-- Summary Discussion of bioaccumulation -->
<#macro bioaccumulationSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Bioaccumulation") />
	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
	
		<#list summaryList as summary>
			<#if summary?has_content>
				<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
			</#if>
		</#list>
	</#if>
</#compress>
</#macro>
		
<!-- Summary Discussion of bioaccumulation aquatic and sediment -->
<#macro bioaccumulationAquaticSedimentSummary _subject>
<#compress>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "BioaccumulationAquaticSediment") />				
	
	<#if summaryList?has_content>
		<#assign summaryCSAValue = getCSAValuesBioaccumulationAquaticSediment(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextBioaccumulationAquatic summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
							
			<#assign valueForCsaText>
			<#if summary.KeyValueForChemicalSafetyAssessment.BcfAquaticSpecies?has_content || summary.KeyValueForChemicalSafetyAssessment.BMFInFish?has_content>
					<#if summary.KeyValueForChemicalSafetyAssessment.BcfAquaticSpecies?has_content>
						BCF: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.BcfAquaticSpecies/>
					</#if>
					<?linebreak?>
					<#if summary.KeyValueForChemicalSafetyAssessment.BMFInFish?has_content>
						BMF in fish: <@com.number summary.KeyValueForChemicalSafetyAssessment.BMFInFish/> dimensionless
					</#if>
				
			</#if>
			</#assign>
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
</#compress>
</#macro>	

<!-- Summary Discussion of bioaccumulation terrestrial -->
<#macro bioaccumulationTerrestrialSummary _subject>
<#compress>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "BioaccumulationTerrestrial") />
		
	<para><emphasis role="HEAD-WoutNo"></emphasis></para>
	<#if summaryList?has_content>
		
		<#assign summaryCSAValue = getCSAValuesBioaccumulationTerrestrial(summaryList)/>
		<#if summaryCSAValue?has_content>
			<@CSAValueTextBioaccumulationTerrestrial summaryCSAValue typeText typeText1 />
		</#if>
		
		<#assign printSummaryName = summaryList?size gt 1 />
		
		<#list summaryList as summary>
			
				<#assign valueForCsaText>
					<#if summary.KeyValueForChemicalSafetyAssessment.BcfTerrestrialSpecies?has_content>
						BCF: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.BcfTerrestrialSpecies/>
					</#if>
				</#assign>
				
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
</#compress>
</#macro>
	
<!-- Secondary poisoning -->
<#macro ecotoxicologicalInformationSecondaryPoisoning _subject>
<#compress>	
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "EcotoxicologicalInformation") />
	
	<#if !summaryList?has_content>
		No relevant information available.
		<@com.emptyLine/>
	<#else/>
	
		<!-- TODO: this probably will need to be improved in case there are AEs -->
		<#assign firsSummary = summaryList[0] />
		
		<#if isNoBioaccumulationPotential(firsSummary)>
			<para>Based on the available information, there is no indication of a bioaccumulation potential and, hence, secondary poisoning is not considered relevant (see CSR chapter 7.5 "PNEC derivation and other hazard conclusions)").</para>
		<#elseif isPnecOral(firsSummary)>
			<para>
				<#if firsSummary.HazardForPredators.SecondaryPoisoning.HazAssessConclVal?has_content>
					The hazard assessment conclusion for secondary poisoning (PNECoral) is <@com.quantity firsSummary.HazardForPredators.SecondaryPoisoning.HazAssessConclVal/> (see CSR chapter 7.5 "PNEC derivation and other hazard conclusions").
				</#if>
			</para>
			<para><emphasis role="bold">Interpretation of the available data with regard to the potential to bio-accumulate in the food chain:</emphasis></para>
			<para>&gt;&gt;&gt;NOTE (please delete this instruction): As appropriate enter relevant information manually.&lt;&lt;&lt;</para>
		<#else>
			<para>Based on the available information the bioaccumulation potential cannot be judged (see CSR chapter 7.5 "PNEC derivation and other hazard conclusions").</para>
		</#if>
	</#if>
</#compress>
</#macro>

<!-- Macros and functions -->
<#macro hydrolysisHalfLifeList halfLifeRepeatableBlock>
<#compress>
	<#if halfLifeRepeatableBlock?has_content>
		<#list halfLifeRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Ph?has_content>
					t1/2 (pH <@com.number blockItem.Ph/>):
				</#if>
				
				<#if blockItem.HalfLife?has_content>
					<@com.range blockItem.HalfLife/> 
				</#if>

				<#if pppRelevant??>
					<#if blockItem.StDev?has_content>
						[sd=<@com.number blockItem.StDev/>]
					</#if>
				</#if>
				
				<#if blockItem.Temp?has_content>
					at <@com.quantity blockItem.Temp/>;
				</#if>	
				
				<#if blockItem.HydrolysisRateConstant?has_content>
					Rate constant: <@com.range blockItem.HydrolysisRateConstant/>;
				</#if>	
				
				<#if blockItem.Type?has_content>					
					Type: <@com.picklist blockItem.Type/> 
				</#if>

				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro recoveryList recoveryRepeatableBlock>
<#compress>
	<#if recoveryRepeatableBlock?has_content>
		<#list recoveryRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Ph?has_content>
					pH <@com.number blockItem.Ph/>:
				</#if>
				
				<#if blockItem.Recovery?has_content>
					<@com.range blockItem.Recovery/> 
				</#if>

				<#if pppRelevant??>
					<#if blockItem.StDev?has_content>
						[sd=<@com.number blockItem.StDev/>]
					</#if>
				</#if>
				
				<#if blockItem.Temp?has_content>
					at <@com.quantity blockItem.Temp/> 
				</#if>
				
				<#if blockItem.Duration?has_content>
					after <@com.range blockItem.Duration/>
				</#if>

				<#if pppRelevant??>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro spectrumOfSubstanceList spectrumRepeatableBlock>
<#compress>
	<#if spectrumRepeatableBlock?has_content>
		<#list spectrumRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Parameter?has_content>
					<@com.picklist blockItem.Parameter/>: 
				</#if>	
					
				<#if blockItem.Value?has_content>
					<@com.quantity blockItem.Value/>
				</#if>
					
				<#if blockItem.hasElement("RemarksOnResults")>
					(<@com.picklist blockItem.RemarksOnResults/>)
				<#else/>
					(<@com.text blockItem.Remarks/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro phototransformationHalfLifeList halfLifeRepeatableBlock>
<#compress>
	<#if halfLifeRepeatableBlock?has_content>
		<#list halfLifeRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.hasElement("HalfLife")>
					<@com.range blockItem.HalfLife/>
				<#else>
					<@com.range blockItem.DT50/>
				</#if>
				<#if blockItem.TestCondition?has_content>
					(<@com.text blockItem.TestCondition/>)
				</#if>

				<#if pppRelevant??>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro degradationList degradationRepeatableBlock>
<#compress>
	<#if degradationRepeatableBlock?has_content>
		<#list degradationRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.hasElement("DegradationPercent")>
					<@com.range blockItem.DegradationPercent/>
				<#else>
					<@com.range blockItem.Degr/>
				</#if>

				<#if pppRelevant??>
					%
					<#if blockItem.StDev?has_content>
						[<@com.number blockItem.StDev/>]
					</#if>
				</#if>

				after
				<#if blockItem.hasElement("TimePoint")>
					<@com.quantity blockItem.TimePoint/>
				<#else>
					<@com.quantity blockItem.SamplingTime/>
				</#if>
				<#if blockItem.TestCondition?has_content>
					(<@com.text blockItem.TestCondition/>)
				</#if>

				<#if pppRelevant??>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro sensitiserList sensitiserRepeatableBlock>
<#compress>
	<#if sensitiserRepeatableBlock?has_content>
		<#list sensitiserRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.TypeOfSensitiser/> 
				<#if blockItem.ConcentrationOfSensitiser?has_content>
					(<@com.range blockItem.ConcentrationOfSensitiser/>)
				</#if>

				<#if pppRelevant??>
					<#if blockItem.DetailsOnSensitiser?has_content>
						- <@com.text blockItem.DetailsOnSensitiser/>
					</#if>
				</#if>

			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro degradationRateConstantList degradationRateRepeatableBlock>
<#compress>
	<#if degradationRateRepeatableBlock?has_content>
		<#list degradationRateRepeatableBlock as blockItem>
			<para role="indent">
				<@com.range blockItem.RateConstant/> 
				<#if blockItem.ReactionWith?has_content>
					for reaction with <@com.picklist blockItem.ReactionWith/>
				</#if>
				<#if pppRelevant?? && blockItem.RemarksOnResults?has_content>
					(<@com.text blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro degradationOfTestSubstanceList degradationRepeatableBlock>
<#compress>
	<#if degradationRepeatableBlock?has_content>
		<#list degradationRepeatableBlock as blockItem>
			<para role="indent">
				<#if pppRelevant??>
					<#if blockItem.hasElement("SoilNo") && blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>

					<#if blockItem.Parameter?has_content>
						<@com.picklist blockItem.Parameter/> =
					</#if>
				</#if>

				<@com.range blockItem.Degr/>

				<#if pppRelevant??>
					<#if blockItem.Degr?has_content>
						%
					</#if>

					<#if blockItem.StDev?has_content>
						[sd=<@com.number blockItem.StDev/>]
					</#if>

					<#if blockItem.hasElement("ParentProduct") && blockItem.ParentProduct?has_content>
						for <@com.picklist blockItem.ParentProduct/>
						<#if blockItem.NameOrCodeForProduct?has_content>
							<#local product=iuclid.getDocumentForKey(blockItem.NameOrCodeForProduct)/>
							<@com.text product.ReferenceSubstanceName/>
						</#if>
					</#if>
				</#if>
				
				<#if blockItem.SamplingTime?has_content>
					after
					<@com.quantity blockItem.SamplingTime/>
				</#if>

				<#if !pppRelevant??>
					<#if blockItem.Parameter?has_content>
						(<@com.picklist blockItem.Parameter/>)
					</#if>
				</#if>

				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>

				<#if !(pppRelevant??) && blockItem.hasElement("SoilNo") && blockItem.SoilNo?has_content>
					(<@com.picklist blockItem.SoilNo/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro biodegradationHalfLifeList halfLifeRepeatableBlock>
<#compress>
	<#if halfLifeRepeatableBlock?has_content>
		<#list halfLifeRepeatableBlock as blockItem>
			<para role="indent">
			
				<@com.range blockItem.HalfLife/>

				<#if pppRelevant??>
					<#if blockItem.StDev?has_content>
						[sd=<@com.picklist blockItem.StDev/>]
					</#if>

					<#if blockItem.Type?has_content>
						(<@com.picklist blockItem.Type/>)
					</#if>
				</#if>

				<#if blockItem.Compartment?has_content>
					in
					<@com.picklist blockItem.Compartment/>
				</#if>
				
				<#if blockItem.Temp?has_content>
					at
					<@com.quantity blockItem.Temp/>
				</#if>

				<#if pppRelevant??>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro transformationProductList transformationProductBlock>
<#compress>
	<#if transformationProductBlock?has_content>
		<#list transformationProductBlock as blockItem>
			<#local referenceSubstance = iuclid.getDocumentForKey(blockItem.ReferenceSubstance) />
			<#if referenceSubstance?has_content>
				<para role="indent">
					<@com.picklist blockItem.No/> 

						<#if referenceSubstance.ReferenceSubstanceName?has_content>						
							<@com.referenceSubstanceName com.getReferenceSubstanceKey(blockItem.ReferenceSubstance) />						
						</#if>

				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro soilTypeList soilTypeBlock>
<#compress>
	<#if soilTypeBlock?has_content>
		<#list soilTypeBlock as blockItem>
			<para role="indent">
				<#if pppRelevant??>
					<#if blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>
				</#if>

				<@com.picklist blockItem.SoilType/>
				<#if !pppRelevant?? && blockItem.SoilNo?has_content>
					(<@com.picklist blockItem.SoilNo/>)
				</#if>

				<#if pppRelevant??>
					<#if blockItem.Clay?has_content>
						. Clay: <@com.range blockItem.Clay/>%
					</#if>
					<#if blockItem.Silt?has_content>
						. Silt: <@com.range blockItem.Silt/>%
					</#if>
					<#if blockItem.Sand?has_content>
						. Sand: <@com.range blockItem.Sand/>%
					</#if>
					<#if blockItem.OrgC?has_content>
						. Org.C: <@com.range blockItem.OrgC/>%
					</#if>
					<#if blockItem.Ph?has_content>
						. pH: <@com.range blockItem.Ph/>%
					</#if>
					<#if blockItem.CEC?has_content>
						. CEC: <@com.range blockItem.CEC/>%
					</#if>
					<#if blockItem.BulkDensityGCm?has_content>
						. Bulk density: <@com.range blockItem.BulkDensityGCm/>g/cm3
					</#if>
					<#if blockItem.MoistureContent?has_content>
						. Moisture: <@com.range blockItem.MoistureContent/>%
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro biodegradationInSoilHalfLifeList halfLifeRepeatableBlock>
<#compress>
	<#if halfLifeRepeatableBlock?has_content>
		<#list halfLifeRepeatableBlock as blockItem>
			<para role="indent">
				<#if pppRelevant??>
					<#if blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>
				</#if>

				<#if blockItem.HalfLife?has_content>
					<@com.range blockItem.HalfLife/> 
				</#if>

				<#if pppRelevant??>
					<#if blockItem.StDev?has_content>
						[sd=<@com.number blockItem.StDev/>]
					</#if>

					<#if blockItem.Temp?has_content>
						at <@com.range blockItem.Temp/>
					</#if>

					<#if blockItem.Type?has_content>
						(<@com.picklist blockItem.Type/>)
					</#if>
				<#else>

					<#if blockItem.SoilNo?has_content>
						(<@com.picklist blockItem.SoilNo/>)
					</#if>
				</#if>

				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro adsorptionCoefficientList adsorptionCoefficientRepeatableBlock>
<#compress>
	<#if adsorptionCoefficientRepeatableBlock?has_content>
		<#list adsorptionCoefficientRepeatableBlock as blockItem>
			<para role="indent">

				<#if pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						<@com.picklist blockItem.SampleNo/>:
					</#if>
				</#if>

				<#if blockItem.Type?has_content>
					<@com.picklist blockItem.Type/>: 
				</#if>
				
				<#if blockItem.Value?has_content>
					<@com.range blockItem.Value/>
				</#if>
				
				<#if blockItem.Temp?has_content>
					at <@com.quantity blockItem.Temp/>
				</#if>

				<#if pppRelevant??>
					<#if blockItem.Ph?has_content>
						at pH=<@com.number blockItem.Ph/>
					</#if>

					<#if blockItem.Matrix?has_content>
						(Matrix: <@com.text blockItem.Matrix/>)
					</#if>
				</#if>
					
				<#if blockItem.PercentageOfOrganicCarbon?has_content>
					(Org. C (%): <@com.range blockItem.PercentageOfOrganicCarbon/>)
				</#if>
				
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro partitionCoefficientList partitionCoefficientRepeatableBlock>
<#compress>
	<#if partitionCoefficientRepeatableBlock?has_content>
		<#list partitionCoefficientRepeatableBlock as blockItem>
			<para role="indent">

				<#if pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						<@com.picklist blockItem.SampleNo/>
					</#if>

					<#if blockItem.PhaseSystem?has_content>
						(<@com.picklist blockItem.PhaseSystem/>)
					</#if>

					<#if blockItem.SampleNo?has_content>:</#if>
				</#if>

				<#if blockItem.Type?has_content>
					<@com.picklist blockItem.Type/>: 
				</#if>
					
				<#if blockItem.Value?has_content>
					<@com.range blockItem.Value/> 
				</#if>	
					
				<#if blockItem.Temp?has_content>
					at <@com.quantity blockItem.Temp/>
				</#if>

				<#if pppRelevant??>
					<#if blockItem.Ph?has_content>
						at pH=<@com.number blockItem.Ph/>
					</#if>

					<#if blockItem.Matrix?has_content>
						(Matrix: <@com.text blockItem.Matrix/>)
					</#if>

					<#if blockItem.OrgCarbon?has_content>
						(Org. C (%): <@com.range blockItem.OrgCarbon/>)
					</#if>
				</#if>
					
				<#if blockItem.RemarksOnResults?has_content>					
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro massBalanceAdsorptiontList massBalanceAdsorptiontRepeatableBlock>
<#compress>
	<#if massBalanceAdsorptiontRepeatableBlock?has_content>
		<#list massBalanceAdsorptiontRepeatableBlock as blockItem>
			<para role="indent">

				<#if pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						<@com.picklist blockItem.SampleNo/>:
					</#if>
				</#if>

				<#if blockItem.AdsorptionPercentage?has_content>
					<@com.range blockItem.AdsorptionPercentage/> 
				</#if>
				
				<#if blockItem.Duration?has_content>
					after <@com.quantity blockItem.Duration/>
				</#if>

				<#if !pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						(<@com.picklist blockItem.SampleNo/>)
					</#if>
				<#else>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro massBalanceDesorptiontList massBalanceDesorptiontRepeatableBlock>
<#compress>
	<#if massBalanceDesorptiontRepeatableBlock?has_content>
		<#list massBalanceDesorptiontRepeatableBlock as blockItem>
			<para role="indent">

				<#if pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						<@com.picklist blockItem.SampleNo/>:
					</#if>
				</#if>

				<#if blockItem.DesorptionPercentage?has_content>
					<@com.range blockItem.DesorptionPercentage/> 
				</#if>
				
				<#if blockItem.Duration?has_content>
					after <@com.quantity blockItem.Duration/>
				</#if>

				<#if !pppRelevant??>
					<#if blockItem.SampleNo?has_content>
						(<@com.picklist blockItem.SampleNo/>)
					</#if>
				<#else>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro henrysLawConstantList henrysLawConstantRepeatableBlock>
<#compress>
	<#if henrysLawConstantRepeatableBlock?has_content>
		<#list henrysLawConstantRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.H?has_content>
					<@com.range blockItem.H/>
				</#if>
				
				<#if blockItem.Temp?has_content>
					at <@com.quantity blockItem.Temp/>
				</#if>
				
				<#if blockItem.AtmPressure?has_content>
					and <@com.quantity blockItem.AtmPressure/>
				</#if>
				
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro bioaccumulationFactorList bioaccumulationFactorRepeatableBlock>
<#compress>
	<#if bioaccumulationFactorRepeatableBlock?has_content>
		<#list bioaccumulationFactorRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Type?has_content>
					<@com.picklist blockItem.Type/>: 
				</#if>
				
				<#if blockItem.Value?has_content>
					<@com.range blockItem.Value/>
				</#if>
				
				<#if blockItem.Basis?has_content>
					(<@com.picklist blockItem.Basis/>)
				</#if>
				
				<#if blockItem.TimeOfPlateau?has_content>
					Time of plateau: <@com.quantity blockItem.TimeOfPlateau/>
				</#if>
				
				<#if blockItem.CalculationBasis?has_content>
					(<@com.picklist blockItem.CalculationBasis/>) 
				</#if>
				
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro depurationList depurationRepeatableBlock>
<#compress>
	<#if depurationRepeatableBlock?has_content>
		<#list depurationRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Elimination?has_content>
					<@com.picklist blockItem.Elimination/>; 
				</#if>
				
				<#if blockItem.Endpoint?has_content>
					<@com.picklist blockItem.Endpoint/>: 
				</#if>
				
				<#if blockItem.DepurationTime?has_content>
					<@com.quantity blockItem.DepurationTime/>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro lipidContentList lipidContentRepeatableBlock>
<#compress>
	<#if lipidContentRepeatableBlock?has_content>
		<#list lipidContentRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.LipidContent?has_content>
					<@com.range blockItem.LipidContent/> 
				</#if>
				
				<#if blockItem.TimePoint?has_content>
					(<@com.picklist blockItem.TimePoint/>)
				</#if>
				
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#function isNoBioaccumulationPotential ecotoxicologicalInformationSummary>
	<#if !(ecotoxicologicalInformationSummary?has_content)>
		<#return false>
	</#if>
	<#return com.picklistValueMatchesPhrases(ecotoxicologicalInformationSummary.HazardForPredators.SecondaryPoisoning.HazAssessConcl, ["no potential for bioaccumulation", "no potential to cause toxic effects if accumulated (in higher organisms) via the food chain"]) />
</#function>

<#function isPnecOral ecotoxicologicalInformationSummary>
	<#if !(ecotoxicologicalInformationSummary?has_content)>
		<#return false>
	</#if>
	<#return com.picklistValueMatchesPhrases(ecotoxicologicalInformationSummary.HazardForPredators.SecondaryPoisoning.HazAssessConcl, ["PNEC oral"]) />
</#function>


<#function getCSAValuesHenrysLawConstant summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAHenrysLawConstant(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>	
	
	<#return valuesCSA />	
</#function>
<#function isCSAHenrysLawConstant summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HenrysLawConstant?has_content || summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>

<#function getCSAValuesAdsorptionDesorption summary>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#if isCSAValuesAdsorptionDesorption(summary)>
		<#local valuesCSA = valuesCSA + [summary]/>			
	</#if>	
		<#list summary.KeyValueForChemicalSafetyAssessment.OtherAdsorptionCoefficients as blockItem>
			<#if isCSAAdsorptionDesorptionBlockItem(blockItem)>
				<#local valuesCSA = valuesCSA + [blockItem]/>			
			</#if>					
		</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAValuesAdsorptionDesorption summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.KocAt20Celsius?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>

<#function isCSAAdsorptionDesorptionBlockItem blockItem>
	<#return blockItem.Type?has_content || blockItem.TypeValue?has_content || blockItem.AtTheTemperatureOf?has_content />
</#function>
<#function getCSAValuesBiodegradationInWaterAndSedimentSimulationTests summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSABiodegradationInWaterAndSedimentSimulationTests(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>	
	
	<#return valuesCSA />	
</#function>
<#function isCSABiodegradationInWaterAndSedimentSimulationTests summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwater?has_content || summary.KeyValueForChemicalSafetyAssessment.HalflifeInFreshwaterSediment?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValuesBiodegradationInWaterScreeningTests summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSABiodegradationInWaterScreeningTests(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>	
	
	<#return valuesCSA />	
</#function>
<#function isCSABiodegradationInWaterScreeningTests summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.BiodegradationInWater?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValuesInSoil summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAPhototransformationInSoil(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>	
	
	<#return valuesCSA />	
</#function>
<#function isCSAPhototransformationInSoil summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HalflifeInSoil?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValuesPhototransformationInWater summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAPhototransformationInWater(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSAPhototransformationInWater summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HalflifeInWater?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValuesPhototransformationInAir summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSAPhototransformationInAir(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>

<#function isCSAPhototransformationInAir summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HalflifeInAir?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValuesBioaccumulationAquaticSediment summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSABioaccumulationAquaticSediment(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSABioaccumulationAquaticSediment summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.BcfAquaticSpecies?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>

<#function getCSAValuesBioaccumulationTerrestrial summaryList>
	<#local valuesCSA = []/>
	
	<#if !(summaryList?has_content)>
		<#return [] />
	</#if>
	
	<#list summaryList as summary>
		<#if isCSABioaccumulationTerrestrial(summary)>
			<#local valuesCSA = valuesCSA + [summary]/>			
		</#if>				
	</#list>
	
	<#return valuesCSA />	
</#function>
<#function isCSABioaccumulationTerrestrial summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.BcfTerrestrialSpecies?has_content || summary.KeyInformation.KeyInformation?has_content />
</#function>
<#function getCSAValueTextHydrolysis summary>
	<#local valuesCSA = []/>
	
	<#if !(summary?has_content)>
		<#return [] />
	</#if>
	
	<#if isCSAtext(summary)>
		<#local valuesCSA = valuesCSA + [summary]/>			
	</#if>		
	
	<#return valuesCSA />	
</#function>

<#function isCSAtext summary>
	<#return summary.KeyInformation.KeyInformation?has_content || summary.Discussion.Discussion?has_content | summary.KeyValueForChemicalSafetyAssessment.HalflifeForHydrolysis?has_content || summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content />
</#function>
<#function getCSAValuesHydrolysis summary>
	<#local valuesCSA = []/>
	
	<#if !(summary?has_content)>
		<#return [] />
	</#if>
	
	<#if isCSA(summary)>
		<#local valuesCSA = valuesCSA + [summary]/>			
	</#if>		
	
	<#return valuesCSA />	
</#function>

<#function isCSA summary>
	<#return summary.KeyValueForChemicalSafetyAssessment.HalflifeForHydrolysis?has_content || summary.KeyValueForChemicalSafetyAssessment.AtTheTemperatureOf?has_content />
</#function>

<#macro CSAValueText summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for any hazard / risk / persistency assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextEnvironmentAssessment summaryCSAValue typeText="Discussion" typeText1="The following information is taken into account for any environmental exposure assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextBioaccumulationAquatic summaryCSAValue typeText="Aquatic bioaccumulation" typeText1="The following information is taken into account for any environmental exposure assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>
<#macro CSAValueTextBioaccumulationTerrestrial summaryCSAValue typeText="Terrestrial bioaccumulation" typeText1="The following information is taken into account for any environmental exposure assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#macro CSAValueText_screening summaryCSAValue typeText="Discussion (screening testing)" typeText1="The following information is taken into account for any hazard / risk / persistency assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<#macro CSAValueText_simulation summaryCSAValue typeText="Discussion (simulation testing)" typeText1="The following information is taken into account for any hazard / risk / persistency assessment:">
<#compress>
	<para><emphasis role="HEAD-WoutNo">${typeText}</emphasis></para>
	<para><emphasis role="underline">${typeText1}</emphasis></para>
</#compress>
</#macro>

<!-- Macros and functions -->
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

<#---------------------------PPP additions------------------------------------>
<#macro results_biodegradationInSoil study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.MaterialMassBalance?has_content>
			<para>Material (mass) balance:</para>
			<para role="indent"><@massBalanceList res.MaterialMassBalance/></para>
		</#if>

		<#if res.Degradation?has_content>
			<para>% Degradation of test substance:</para>
			<para role="indent"><@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(res.Degradation)/></para>
		</#if>

		<#if res.HalfLifeOfParentCompound?has_content>
			<para>Half-life / dissipation time of parent compound:</para>
			<para role="indent"><@biodegradationInSoilHalfLifeList studyandsummaryCom.orderByKeyResult(res.HalfLifeOfParentCompound)/></para>
		</#if>

		<#if res.TransformationProducts?has_content || res.IdentityTransformation?has_content>
			<para>Transformation products: <@com.picklist res.TransformationProducts/></para>
			<para role="indent"><@transformationProductList res.IdentityTransformation/></para>
			<#if res.TransfProductsDetails?has_content>
				<para role="indent">(<@com.text res.TransfProductsDetails/>)</para>
			</#if>
		</#if>

		<#if res.EvaporationOfParentCompound?has_content>
			<para>Evaporation of parent compound: <@com.picklist res.EvaporationOfParentCompound/></para>
		</#if>

		<#if res.VolatileMetabolites?has_content>
			<para>Volatile metabolites: <@com.picklist res.VolatileMetabolites/></para>
		</#if>

		<#if res.Residues?has_content>
			<para>Residues: <@com.picklist res.Residues/></para>
		</#if>

		<#if res.DetailsOnResults?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text res.DetailsOnResults/></para>
		</#if>

		<#if res.ResultsWithReferenceSubstance?has_content>
			<para>Results with reference substance: </para>
			<para role="indent"><@com.text res.ResultsWithReferenceSubstance/></para>
		</#if>

	</#compress>
</#macro>

<#macro results_biodegradationWaterSedimentSimulation study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.TestPerformance?has_content>
			<para>Test performance:</para>
			<para role="indent"><@com.text res.TestPerformance/></para>
		</#if>

		<#if res.MeanTotalRecovery?has_content>
			<para>Mean total recovery:</para>
			<para role="indent"><@massBalanceRepeatableBlock res.MeanTotalRecovery/></para>
		</#if>

		<#if res.Degradation?has_content>
			<para>% Degradation:</para>
			<para role="indent"><@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(res.Degradation)/></para>
		</#if>

		<#if res.HalfLifeOfParentCompound50DisappearanceTimeDT50?has_content>
			<para>Half-life of parent compound / 50% disappearance time (DT50):</para>
			<para role="indent"><@biodegradationHalfLifeList studyandsummaryCom.orderByKeyResult(res.HalfLifeOfParentCompound50DisappearanceTimeDT50)/></para>
		</#if>

		<#if res.MineralizationRateInCO2?has_content>
			<para>Mineralization rate (in CO2): <@com.quantity study.ResultsAndDiscussion.MineralizationRateInCO2/></para>
		</#if>

		<#if res.TransformationProducts?has_content || res.IdentityTransformation?has_content>
			<para>Transformation products: <@com.picklist res.TransformationProducts/></para>
			<para role="indent"><@transformationProductList res.IdentityTransformation/></para>
			<#if res.TransfProductsDetails?has_content>
				<para role="indent">(<@com.text res.TransfProductsDetails/>)</para>
			</#if>
		</#if>

		<#if res.EvaporationOfParentCompound?has_content>
			<para>Evaporation of parent compound: <@com.picklist res.EvaporationOfParentCompound/></para>
		</#if>

		<#if res.VolatileMetabolites?has_content>
			<para>Volatile metabolites: <@com.picklist res.VolatileMetabolites/></para>
		</#if>

		<#if res.Residues?has_content>
			<para>Residues: <@com.picklist res.Residues/></para>
		</#if>

		<#if res.DetailsOnResults?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text res.DetailsOnResults/></para>
		</#if>

		<#if res.ResultsWithReferenceSubstance?has_content>
			<para>Results with reference substance: </para>
			<para role="indent"><@com.text res.ResultsWithReferenceSubstance/></para>
		</#if>

	</#compress>
</#macro>

<#macro results_phototransformation study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.PreliminaryStudy?has_content>
			<para>Preliminary study:</para>
			<para role="indent"><@com.text res.PreliminaryStudy/></para>
		</#if>

		<#if res.TestPerformance?has_content>
			<para>Test performance:</para>
			<para role="indent"><@com.text res.TestPerformance/></para>
		</#if>

		<#if res.hasElement("Spectrum")>
			<#local spectrumPath=res.Spectrum/>
		<#elseif res.hasElement("SpectrumOfSubstance")>
			<#local spectrumPath=res.SpectrumOfSubstance/>
		</#if>
		<#if spectrumPath?has_content>
			<para>Spectrum of substance:</para>
			<para role="indent"><@spectrumOfSubstanceList spectrumPath/></para>
		</#if>

		<#if res.Degradation?has_content>
			<para>% Degradation:</para>
			<para role="indent"><@degradationList studyandsummaryCom.orderByKeyResult(res.Degradation)/></para>
		</#if>

		<#if res.QuantumYield?has_content>
			<para>Quantum yield: <@com.number res.QuantumYield/></para>
		</#if>

		<#if res.hasElement("DissipationParentCompound")>
			<#local dissPath=res.DissipationParentCompound/>
		<#elseif res.hasElement("DissipationHalfLife")>
			<#local dissPath=res.DissipationHalfLife/>
		</#if>
		<#if dissPath?has_content>
			<para>Dissipation half-life of parent compound:</para>
			<para role="indent"><@phototransformationHalfLifeList studyandsummaryCom.orderByKeyResult(dissPath)/></para>
		</#if>

		<#if res.hasElement("PredictedEnvironmental") && res.PredictedEnvironmental?has_content>
			<para>Predicted environmental photolytic half-life:</para>
			<para role="indent"><@com.text res.PredictedEnvironmental/></para>
		</#if>

		<#if res.hasElement("DegradationRateConstant") && res.DegradationRateConstant?has_content>
			<para>Degradation rate constant:</para>
			<para role="indent"><@degradationRateConstantList studyandsummaryCom.orderByKeyResult(res.DegradationRateConstant)/></para>
		</#if>

		<#if res.TransformationProducts?has_content || res.IdentityTransformation?has_content>
			<para>Transformation products: <@com.picklist res.TransformationProducts/></para>
			<para role="indent"><@transformationProductList res.IdentityTransformation/></para>
		</#if>

		<#if res.hasElement("DetailsOnResults")>
			<#local detPath=res.DetailsOnResults/>
		<#elseif res.hasElement("ResultsDetails")>
			<#local detPath=res.ResultsDetails/>
		</#if>
		<#if detPath?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text detPath/></para>
		</#if>

		<#if res.ResultsReferenceSubstance?has_content>
			<para>Results with reference substance: </para>
			<para role="indent"><@com.text res.ResultsReferenceSubstance/></para>
		</#if>
	</#compress>
</#macro>

<#macro results_adsorptionDesorption study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.AdsorptionCoefficient?has_content>
			<para>Adsorption coefficient:</para>
			<para role="indent"><@adsorptionCoefficientList studyandsummaryCom.orderByKeyResult(res.AdsorptionCoefficient)/></para>
		</#if>

		<#if res.AdsorptionOther?has_content>
			<para>Partition coefficients:</para>
			<para role="indent"><@partitionCoefficientList studyandsummaryCom.orderByKeyResult(res.AdsorptionOther)/></para>
		</#if>

		<#if res.ResultsHplcMethod?has_content>
		<#--			<para><emphasis role="bold">HPLC method</emphasis></para>-->
			<#if res.ResultsHplcMethod.DetailsOnResultsHplcMethod?has_content>
				<para>HPLC method:</para>
				<para role="indent"><@com.text res.ResultsHplcMethod.DetailsOnResultsHplcMethod/></para>
			</#if>
		</#if>

		<#if res.ResultsBatchEquilibriumOrOtherMethod?has_content>
		<#--			<para><emphasis role="bold">Batch equilibrium or other method</emphasis></para>-->

			<#local res2=res.ResultsBatchEquilibriumOrOtherMethod/>

			<#if res2.AdsorptionAndDesorptionConstants?has_content>
				<para>Adsorption and desorption constants:</para>
				<para role="indent"><@com.text res2.AdsorptionAndDesorptionConstants/></para>
			</#if>

			<#if res2.RecoveryOfTestMaterial?has_content>
				<para>Recovery of test material:</para>
				<para role="indent"><@com.text res2.RecoveryOfTestMaterial/></para>
			</#if>

			<#if res2.ConcentrationOfTestSubstanceAtEndOfAdsorptionEquilibrationPeriod?has_content>
				<para>Concentration of test substance at end of adsorption equilibration period:</para>
				<para role="indent"><@com.text res2.ConcentrationOfTestSubstanceAtEndOfAdsorptionEquilibrationPeriod/></para>
			</#if>

			<#if res2.ConcentrationOfTestSubstanceAtEndOfDesorptionEquilibrationPeriod?has_content>
				<para>Concentration of test substance at end of desorption equilibration period:</para>
				<para role="indent"><@com.text res2.ConcentrationOfTestSubstanceAtEndOfDesorptionEquilibrationPeriod/></para>
			</#if>

			<#if res2.MassBalanceAtEndOfAdsorptionPhase?has_content>
				<para>Mass balance (in %) at end of adsorption phase:</para>
				<para role="indent"><@massBalanceAdsorptiontList res2.MassBalanceAtEndOfAdsorptionPhase/></para>
			</#if>

			<#if res2.MassBalanceAtEndOfDesorptionPhase?has_content>
				<para>Mass balance (in %) at end of desorption phase:</para>
				<para role="indent"><@massBalanceDesorptiontList res2.MassBalanceAtEndOfDesorptionPhase/></para>
			</#if>

			<#if res2.TransformationProducts?has_content || res2.IdentityTransformation?has_content>
				<para>Transformation products: <@com.picklist res2.TransformationProducts/></para>
				<para role="indent"><@transformationProductList res2.IdentityTransformation/></para>
			</#if>

			<#if res2.DetailsOnResultsBatchEquilibriumMethod?has_content>
				<para>Details:</para>
				<para role="indent"><@com.text res2.DetailsOnResultsBatchEquilibriumMethod/></para>
			</#if>

			<#if res2.Statistics?has_content>
				<para>Statistics:</para>
				<para role="indent"><@com.text res2.Statistics/></para>
			</#if>

		</#if>
	</#compress>
</#macro>

<#macro results_hydrolysis study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.PreliminaryStudy?has_content>
			<para>Preliminary study:</para>
			<para role="indent"><@com.text res.PreliminaryStudy/></para>
		</#if>

		<#if res.TestPerformance?has_content>
			<para>Test performance:</para>
			<para role="indent"><@com.text res.TestPerformance/></para>
		</#if>

		<#if res.TransformationProducts?has_content || res.IdentityTransformation?has_content>
			<para>Transformation products: <@com.picklist res.TransformationProducts/></para>
			<para role="indent"><@transformationProductList res.IdentityTransformation/></para>
			<#if res.DetailsOnHydrolysisAndAppearanceOfTransformationProducts?has_content>
				<para role="indent">(<@com.text res.DetailsOnHydrolysisAndAppearanceOfTransformationProducts/>)</para>
			</#if>
		</#if>

		<#if res.TotalRecoveryOfTestSubstance?has_content>
			<para>Total recovery of test substance (in %):</para>
			<para role="indent"><@recoveryList res.TotalRecoveryOfTestSubstance/></para>
		</#if>

		<#if res.DissipationHalfLifeOfParentCompound?has_content>
			<para>Dissipation DT50 of parent compound:</para>
			<para role="indent"><@hydrolysisHalfLifeList studyandsummaryCom.orderByKeyResult(res.DissipationHalfLifeOfParentCompound)/></para>
		</#if>

		<#if res.OtherKineticParameters?has_content>
			<para>Other kinetic parameters:</para>
			<para role="indent"><@com.text res.OtherKineticParameters/></para>
		</#if>

		<#if res.DetailsOnResults?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text res.DetailsOnResults/></para>
		</#if>

		<#if res.ResultsWithReferenceSubstance?has_content>
			<para>Results with reference substance: </para>
			<para role="indent"><@com.text res.ResultsWithReferenceSubstance/></para>
		</#if>
	</#compress>
</#macro>

<#macro results_biodegradationWaterScreening study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.PrelimStudyRs?has_content>
			<para>Preliminary study:</para>
			<para role="indent"><@com.text res.PrelimStudyRs/></para>
		</#if>

		<#if res.TestPerformance?has_content>
			<para>Test performance:</para>
			<para role="indent"><@com.text res.TestPerformance/></para>
		</#if>

		<#if res.Degradation?has_content>
			<para>% Degradation:</para>
			<para role="indent"><@degradationOfTestSubstanceList studyandsummaryCom.orderByKeyResult(res.Degradation)/></para>
		</#if>

		<#if res.ResultsDetails?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text res.ResultsDetails/></para>
		</#if>

		<#if res.Bod5CodResults?has_content>
			<para><emphasis role="bold">BOD / COD results:</emphasis></para>

			<#if res.Bod5CodResults.Bod5Cod?has_content>
				<para>BOD / COD:</para>
				<para role="indent"><@spectrumOfSubstanceList studyandsummaryCom.orderByKeyResult(res.Bod5CodResults.Bod5Cod)/></para>
			</#if>

			<#if res.Bod5CodResults.ResultsWithReferenceSubstance?has_content>
				<para>Results with reference substance:</para>
				<para role="indent"><@com.text res.Bod5CodResults.ResultsWithReferenceSubstance/></para>
			</#if>

		</#if>

	</#compress>
</#macro>

<#macro results_monitoring study>
	<#compress>
		<#local res=study.ResultsAndDiscussion/>

		<#if res.Concentration?has_content>
			<para>Concentration:</para>
			<para role="indent"><@concentrationList studyandsummaryCom.orderByKeyResult(res.Concentration)/></para>

		</#if>

		<#if res.DetailsOnResults?has_content>
			<para>Details:</para>
			<para role="indent"><@com.text res.DetailsOnResults/></para>
		</#if>

	</#compress>
</#macro>

<#--Lists-->
<#macro massBalanceList massBalanceRepeatableBlock>
	<#compress>
		<#if massBalanceRepeatableBlock?has_content>
			<#list massBalanceRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.hasElement("SoilNo") && blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>

					<#if blockItem.hasElement("Compartment") && blockItem.Compartment?has_content>
						<@com.picklist blockItem.Compartment/>:
					</#if>

					<#if blockItem.Recovery?has_content>
						<@com.number blockItem.Recovery/>% recovery
					</#if>

					<#if blockItem.StDev?has_content>
						[sd=<@com.number blockItem.StDev/>]
					</#if>

					<#if blockItem.TotalExtractable?has_content>
						.Total extractable: <@com.range blockItem.TotalExtractable/>%
					</#if>

					<#if blockItem.NonExtractable?has_content>
						.Non extractable: <@com.range blockItem.NonExtractable/>%
					</#if>

					<#if blockItem.CO2?has_content>
						.CO2: <@com.range blockItem.CO2/>%
					</#if>

					<#if blockItem.OtherVolatiles?has_content>
						.Other volatiles: <@com.range blockItem.OtherVolatiles/>%
					</#if>

					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro concentrationList concentrationRepeatableBlock>
	<#compress>
		<#if concentrationRepeatableBlock?has_content>
			<#list concentrationRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.Concentration?has_content>
						<@com.range blockItem.Concentration/>
					</#if>

					<#if blockItem.SubstanceOrMetabolite?has_content>
						(<@com.picklist blockItem.SubstanceOrMetabolite/>)
					</#if>

					<#if blockItem.Location?has_content || blockItem.Country?has_content>
						- location: <@com.text blockItem.Location/> <@com.picklist blockItem.Country/>
					</#if>

					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro testDurationList testDurationRepeatableBlock>
	<#compress>
		<#if testDurationRepeatableBlock?has_content>
			<#list testDurationRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>

					<#if blockItem.Duration?has_content>
						<@com.range blockItem.Duration/>
					</#if>

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro initialSubstanceConcentrationList initialSubstanceConcentrationRepeatableBlock>
	<#compress>
		<#if initialSubstanceConcentrationRepeatableBlock?has_content>
			<#list initialSubstanceConcentrationRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.hasElement("SoilNo") && blockItem.SoilNo?has_content>
						<@com.picklist blockItem.SoilNo/>:
					</#if>

					<#if blockItem.InitialConc?has_content>
						<@com.range blockItem.InitialConc/>
					</#if>

					<#if blockItem.BasedOn?has_content>
						based on <@com.picklist blockItem.BasedOn/>
					</#if>

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro experimentalConditionsList experimentalConditionsRepeatableBlock>
	<#compress>
		<#if experimentalConditionsRepeatableBlock?has_content>
			<#list experimentalConditionsRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.SoilNo?has_content>
						<@com.range blockItem.SoilNo/>:
					</#if>

					<#if blockItem.Temp?has_content>
						. Temperature: <@com.text blockItem.Temp/>
					</#if>

					<#if blockItem.Humidity?has_content>
						. Humidity: <@com.text blockItem.Humidity/>
					</#if>

					<#if blockItem.MicrobialBiomass?has_content>
						. Microbial biomass: <@com.text blockItem.MicrobialBiomass/>
					</#if>
					.

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro testDurationConditionList testDurationConditionRepeatableBlock>
	<#compress>
		<#if testDurationConditionRepeatableBlock?has_content>
			<#list testDurationConditionRepeatableBlock as blockItem>
				<para role="indent">

					<#if blockItem.hasElement("SampleNo") && blockItem.SampleNo?has_content>
						<@com.picklist blockItem.SampleNo/>:
					</#if>

					<#if blockItem.Duration?has_content>
						<@com.value blockItem.Duration/>
					</#if>

					<#if blockItem.Temp?has_content>
						at <@com.value blockItem.Temp/>
					</#if>

					<#if blockItem.hasElement("Moisture") && blockItem.Moisture?has_content>
						at <@com.quantity blockItem.Moisture/>% moisture
					</#if>

					<#if blockItem.hasElement("Ph") && blockItem.Ph?has_content>
						at pH=<@com.number blockItem.Ph/>
					</#if>

					<#if blockItem.hasElement("InitialConcMeasured") && blockItem.InitialConcMeasured?has_content>
						- initial concentration measured: <@com.value blockItem.InitialConcMeasured/>
					<#elseif blockItem.hasElement("ConcOfAdsorbedTestMat") && blockItem.ConcOfAdsorbedTestMat?has_content>
						- concentration of adsorbed test mat.: <@com.value blockItem.ConcOfAdsorbedTestMat/>
					</#if>

					<#if blockItem.hasElement("Remarks") && blockItem.Remarks?has_content>
						(<@com.text blockItem.Remarks/>)
					</#if>

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro matrixList matrixBlock>
	<#compress>
		<#if matrixBlock?has_content>
			<#list matrixBlock as blockItem>
				<para>

					<#if blockItem.MatrixNo?has_content>
						<@com.picklist blockItem.MatrixNo/>:
					</#if>

					<@com.picklist blockItem.MatrixType/>

					<#if pppRelevant??>
						<#if blockItem.Clay?has_content>
							. Clay: <@com.range blockItem.Clay/>%
						</#if>
						<#if blockItem.Silt?has_content>
							. Silt: <@com.range blockItem.Silt/>%
						</#if>
						<#if blockItem.Sand?has_content>
							. Sand: <@com.range blockItem.Sand/>%
						</#if>
						<#if blockItem.OrgCarbon?has_content>
							. Org.Carbon: <@com.range blockItem.OrgCarbon/>%
						</#if>
						<#if blockItem.Ph?has_content>
							. pH: <@com.range blockItem.Ph/>%
						</#if>
						<#if blockItem.CEC?has_content>
							. CEC: <@com.range blockItem.CEC/>%
						</#if>
						<#if blockItem.BulkDensityGCm?has_content>
							. Bulk density: <@com.range blockItem.BulkDensityGCm/>g/cm3
						</#if>

					</#if>

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro refSubList refSubBlock>
	<#compress>
		<#if refSubBlock?has_content>
			<#list refSubBlock as blockItem>
				<para role="indent">
					<@com.picklist blockItem.ReferenceSubstance/>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro paramBiodegradationList paramBiodegradationBlock>
	<#compress>
		<#if paramBiodegradationBlock?has_content>
			<#list paramBiodegradationBlock as blockItem>
				<para role="indent">
					<@com.picklist blockItem.ParameterFollowedForBiodegradationEstimation/>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--Methods-->
<#macro fateMethod study>
	<#compress>

	<#--General-->
		<#if study.hasElement("TestType") && study.MaterialsAndMethods.TestType?has_content>
			<para><emphasis role='bold'>Test type:</emphasis><@com.picklist study.MaterialsAndMethods.TestType/></para>
		</#if>

		<#if study.hasElement("TypeOfMeasurement") && study.MaterialsAndMethods.TypeOfMeasurement?has_content>
			<para><emphasis role='bold'>Type of measurement:</emphasis><@com.value study.MaterialsAndMethods.TypeOfMeasurement/></para>
		</#if>

		<#if study.hasElement("TypeOfStudy") && study.MaterialsAndMethods.TypeOfStudy?has_content>
			<para><emphasis role='bold'>Type of study:</emphasis><@com.picklist study.MaterialsAndMethods.TypeOfStudy/></para>
		</#if>

		<#if study.hasElement("TypeOfStudyInformation") && study.MaterialsAndMethods.TypeOfStudyInformation?has_content>
			<para><emphasis role='bold'>Type of study / information:</emphasis><@com.text study.MaterialsAndMethods.TypeOfStudyInformation/></para>
		</#if>

		<#if study.hasElement("MethodType") && study.MaterialsAndMethods.MethodType?has_content>
			<para><emphasis role='bold'>Type of method:</emphasis><@com.picklist study.MaterialsAndMethods.MethodType/></para>
		</#if>

		<#if study.hasElement("Media") && study.MaterialsAndMethods.Media?has_content>
			<para><emphasis role='bold'>Media:</emphasis><@com.value study.MaterialsAndMethods.Media/></para>
		</#if>

	<#--Study Design-->
		<#if study.MaterialsAndMethods.hasElement("StudyDesign") && study.MaterialsAndMethods.StudyDesign?has_content>
			<para><emphasis role='bold'>Study design:</emphasis></para>

			<#if study.documentSubType=="BiodegradationInSoil">
				<@methods_studyDesign_biodegradationSoil study/>
			<#elseif study.documentSubType=="PhotoTransformationInSoil" || study.documentSubType=="Phototransformation" || study.documentSubType=="PhototransformationInAir">
				<@methods_studyDesign_phototransformation study/>
			<#elseif study.documentSubType=="AdsorptionDesorption">
				<@methods_studyDesign_adsorptionDesorption study/>
			<#elseif study.documentSubType=="Hydrolysis">
				<@methods_studyDesign_hydrolysis study/>
			<#elseif study.documentSubType=="BiodegradationInWaterAndSedimentSimulationTests" || study.documentSubType=="BiodegradationInWaterScreeningTests" >
				<@methods_studyDesign_biodegradationWaterSediment study/>
			<#elseif study.documentSubType=="MonitoringData">
				<@methods_studyDesign_monitoring study/>
			</#if>
		</#if>

	</#compress>
</#macro>

<#macro methods_studyDesign_monitoring study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.DetailsOnAnalyticalMethods?has_content>
			<para>Details on analytical methods</para>
			<para role="indent"><@com.text stdes.DetailsOnAnalyticalMethods/></para>
		</#if>

		<#if stdes.DetailsOnSampling?has_content>
			<para>Sampling:</para>
			<para role="indent"><@com.text stdes.DetailsOnSampling/></para>
		</#if>
	</#compress>
</#macro>

<#macro methods_studyDesign_biodegradationSoil study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.OxygenConditions?has_content>
			<para>Oxygen conditions:</para>
			<para role="indent"><@com.picklist stdes.OxygenConditions/></para>
		</#if>

		<#if stdes.SoilClassification?has_content || stdes.SoilProperties?has_content ||  stdes.DetailsOnSoilCharacteristics?has_content>
			<para>Soil: <@com.picklist stdes.SoilClassification/></para>
			<@soilTypeList stdes.SoilProperties/>
			<para role="indent">Details:<@com.text stdes.DetailsOnSoilCharacteristics/></para>
		</#if>

		<#if stdes.DurationOfTestContactTime?has_content>
			<para>Duration of test (contact time):</para>
			<para role="indent"><@testDurationList stdes.DurationOfTestContactTime/></para>
		</#if>

		<#if stdes.InitialTestSubstanceConcentration?has_content>
			<para>Initial test substance concentration:</para>
			<para role="indent"><@initialSubstanceConcentrationList stdes.InitialTestSubstanceConcentration/></para>
		</#if>

		<#if stdes.ParameterFollowed?has_content>
			<para>Parameter followed for biodegradation estimation: <@com.picklistMultiple stdes.ParameterFollowed/></para>
		</#if>

		<#if stdes.DetailsOnAnalyticalMethods?has_content>
			<para>Details on analytical methods:</para>
			<para role="indent"><@com.text stdes.DetailsOnAnalyticalMethods/></para>
		</#if>

		<#if stdes.ExperimentalConditions?has_content || stdes.DetailsOnExperimentalConditions?has_content>
			<para>Experimental conditions:</para>
			<para role="indent"><@experimentalConditionsList stdes.ExperimentalConditions/></para>
			<para role="indent">Details: <@com.text stdes.DetailsOnExperimentalConditions/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_studyDesign_phototransformation study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.hasElement("Radiolabelling") && stdes.Radiolabelling?has_content>
			<para role="indent">Radiolabelling: <@com.picklist stdes.Radiolabelling/></para>
		</#if>

		<#if stdes.hasElement("EstimationMethodIfUsed") && stdes.EstimationMethodIfUsed?has_content>
			<para role="indent">Estimation method: <@com.text stdes.EstimationMethodIfUsed/></para>
		</#if>

		<#if (stdes.hasElement("AnalyticalMonitoring") && stdes.AnalyticalMonitoring?has_content) ||
		(stdes.hasElement("AnalyticalMethod") && stdes.AnalyticalMethod?has_content) ||
		(stdes.hasElement("DetailsOnAnalyticalMethods") &&stdes.DetailsOnAnalyticalMethods?has_content)>
			<para>Analytical methods:</para>
			<#if stdes.hasElement("AnalyticalMonitoring") &&  stdes.AnalyticalMonitoring?has_content>
				<para role="indent">Monitoring: <@com.picklist stdes.AnalyticalMonitoring/></para>
			</#if>

			<#if stdes.AnalyticalMethod?has_content>
				<para role="indent">Method: <@com.picklistMultiple stdes.AnalyticalMethod/></para>
			</#if>

			<#if stdes.DetailsOnAnalyticalMethods?has_content>
				<para role="indent">Details: <@com.text stdes.DetailsOnAnalyticalMethods/></para>
			</#if>
		</#if>

		<#if stdes.hasElement("DetailsOnSampling") && stdes.DetailsOnSampling?has_content>
			<para>Sampling:</para>
			<para role="indent"><@com.text stdes.DetailsOnSampling/></para>
		</#if>

		<#if stdes.hasElement("DetailsOnSoil") && stdes.DetailsOnSoil?has_content>
			<para>Soil:</para>
			<para role="indent"><@com.text stdes.DetailsOnSoil/></para>
		</#if>

		<#if stdes.hasElement("Buffers") && stdes.Buffers?has_content>
			<para>Buffers:</para>
			<para role="indent"><@com.text stdes.Buffers/></para>
		</#if>

		<#if stdes.LightSource?has_content || stdes.LightSpectrumWavelengthInNm?has_content ||
		stdes.RelativeLightIntensity?has_content || stdes.DetailsOnLightSource?has_content>
			<para>Light:</para>

			<#if stdes.LightSource?has_content>
				<para role="indent">Source: <@com.picklist stdes.LightSource/></para>
				<#if stdes.DetailsOnLightSource?has_content><para role="indent2"><@com.text stdes.DetailsOnLightSource/></para></#if>
			</#if>

			<#if stdes.LightSpectrumWavelengthInNm?has_content>
				<para role="indent">Spectrum: <@com.range stdes.LightSpectrumWavelengthInNm/>nm</para>
			</#if>

			<#if stdes.RelativeLightIntensity?has_content>
				<para role="indent">Relative intensity: <@com.range stdes.RelativeLightIntensity/></para>
			</#if>
		</#if>

		<#if stdes.hasElement("SensitiserForIndirectPhotolysis") && stdes.SensitiserForIndirectPhotolysis?has_content>
			<para>Sensitiser for indirect photolysis:</para>
			<para role="indent"><@sensitiserList stdes.SensitiserForIndirectPhotolysis/></para>
		</#if>

		<#if stdes.DetailsOnTestConditions?has_content>
			<para>Test conditions:</para>
			<para role="indent"><@com.text stdes.DetailsOnTestConditions/></para>
		</#if>

		<#if stdes.DurationOfTestAtGivenTestCondition?has_content>
			<para>Duration:</para>
			<para role="indent"><@testDurationConditionList stdes.DurationOfTestAtGivenTestCondition/></para>
		</#if>

		<#if stdes.ReferenceSubstance?has_content>
			<para>Reference substance: <@com.picklist stdes.ReferenceSubstance/></para>
		</#if>

		<#if stdes.hasElement("DarkControls") && stdes.DarkControls?has_content>
			<para>Dark controls: <@com.picklist stdes.DarkControls/></para>
		</#if>

		<#if stdes.hasElement("ComputationalMethods") && stdes.ComputationalMethods?has_content>
			<para>Computational methods:</para>
			<para role="indent"><@com.text stdes.ComputationalMethods/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_studyDesign_adsorptionDesorption study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.TestTemperature?has_content>
			<para>Test temperature:</para>
			<para role="indent"><@com.text stdes.TestTemperature/></para>
		</#if>

		<#if stdes.HPLCMethod.DetailsOnStudyDesignHplcMethod?has_content>
			<para>HPLC method:</para>
			<para role="indent"><@com.text stdes.HPLCMethod.DetailsOnStudyDesignHplcMethod/></para>
		</#if>

		<#if stdes.BatchEquilibriumOrOtherMethod?has_content>

			<#local batch=stdes.BatchEquilibriumOrOtherMethod/>

		<#--			<para>Batch equilibrium or other method:</para>-->

			<#if batch.AnalyticalMonitoring?has_content || batch.DetailsOnAnalyticalMethods?has_content>

				<para>Analytical methods:</para>

				<#if batch.AnalyticalMonitoring?has_content>
					<para role="indent">Monitoring: <@com.picklist batch.AnalyticalMonitoring/></para>
				</#if>

				<#if batch.DetailsOnAnalyticalMethods?has_content>
					<para role="indent">Details: <@com.text batch.DetailsOnAnalyticalMethods/></para>
				</#if>
			</#if>

			<#if batch.DetailsOnSampling?has_content>
				<para>Sampling:</para>
				<para role="indent"><@com.text batch.DetailsOnSampling/></para>
			</#if>

			<#if batch.MatrixProperties?has_content || batch.DetailsOnMatrix?has_content>
				<para>Matrix:</para>
				<para role="indent"><@matrixList batch.MatrixProperties/></para>
				<#if batch.DetailsOnMatrix?has_content><para role="indent">Details: <@com.text batch.DetailsOnMatrix/></para></#if>
			</#if>

			<#if batch.DetailsOnTestConditions?has_content>
				<para>Test conditions:</para>
				<para role="indent"><@com.text batch.DetailsOnTestConditions/></para>

			</#if>

			<#if batch.DurationOfAdsorptionEquilibration?has_content>
				<para>Duration of adsorption equilibration:</para>
				<para role="indent"><@testDurationConditionList batch.DurationOfAdsorptionEquilibration/></para>

			</#if>

			<#if batch.DurationOfDesorptionEquilibration?has_content>
				<para>Duration of desorption equilibration:</para>
				<para role="indent"><@testDurationConditionList batch.DurationOfDesorptionEquilibration/></para>

			</#if>

			<#if batch.ComputationalMethods?has_content>
				<para>Computational methods:</para>
				<para role="indent"><@com.text batch.ComputationalMethods/></para>
			</#if>
		</#if>

	</#compress>
</#macro>

<#macro methods_studyDesign_hydrolysis study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.AnalyticalMonitoring?has_content || stdes.DetailsOnAnalyticalMethods?has_content>
			<para>Analytical methods:</para>
			<#if stdes.AnalyticalMonitoring?has_content>
				<para role="indent">Monitoring: <@com.picklist stdes.AnalyticalMonitoring/></para>
			</#if>

			<#if stdes.DetailsOnAnalyticalMethods?has_content>
				<para role="indent"><@com.text stdes.DetailsOnAnalyticalMethods/></para>
			</#if>

		</#if>

		<#if stdes.DetailsOnSampling?has_content>
			<para>Sampling:</para>
			<para role="indent"><@com.text stdes.DetailsOnSampling/></para>
		</#if>

		<#if stdes.Buffers?has_content>
			<para>Buffers:</para>
			<para role="indent"><@com.text stdes.Buffers/></para>
		</#if>

		<#if stdes.EstimationMethodIfUsed?has_content>
			<para>Estimation method:</para>
			<para role="indent"><@com.text stdes.EstimationMethodIfUsed/></para>
		</#if>

		<#if stdes.DetailsOnTestConditions?has_content>
			<para>Test conditions:</para>
			<para role="indent"><@com.text stdes.DetailsOnTestConditions/></para>
		</#if>

		<#if stdes.DurationOfTest?has_content>
			<para>Duration:</para>
			<para role="indent"><@testDurationConditionList stdes.DurationOfTest/></para>
		</#if>

		<#if stdes.NumberOfReplicates?has_content>
			<para>Number of replicates:</para>
			<para role="indent"><@com.text stdes.NumberOfReplicates/></para>
		</#if>

		<#if stdes.PositiveControls?has_content>
			<para>Positive controls:</para>
			<para role="indent"><@com.picklist stdes.PositiveControls/></para>
		</#if>

		<#if stdes.NegativeControls?has_content>
			<para>Negative controls:</para>
			<para role="indent"><@com.picklist stdes.NegativeControls/></para>
		</#if>

		<#if stdes.StatisticalMethods?has_content>
			<para>Statistical methods:</para>
			<para role="indent"><@com.text stdes.StatisticalMethods/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_studyDesign_biodegradationWaterSediment study>
	<#compress>

		<#local stdes=study.MaterialsAndMethods.StudyDesign/>

		<#if stdes.OxygenConditions?has_content>
			<para role="indent">Oxygen conditions:</para>
			<para><@com.picklist stdes.OxygenConditions/></para>
		</#if>

		<#if stdes.InoculumOrTestSystem?has_content || stdes.DetailsOnInoculum>
			<para>Inoculum or test system: <@com.picklist stdes.InoculumOrTestSystem/></para>
			<para role="indent"><@com.text stdes.DetailsOnInoculum/></para>
		</#if>

		<#if stdes.hasElement("DetailsOnSourceAndPropertiesOfSurfaceWater") && stdes.DetailsOnSourceAndPropertiesOfSurfaceWater?has_content>
			<para>Details on source and properties of surface water:</para>
			<para role="indent"><@com.text stdes.DetailsOnSourceAndPropertiesOfSurfaceWater/></para>
		</#if>

		<#if stdes.hasElement("DetailsOnSourceAndPropertiesOfSediment") && stdes.DetailsOnSourceAndPropertiesOfSediment?has_content>
			<para>Details on source and properties of sediment:</para>
			<para role="indent"><@com.text stdes.DetailsOnSourceAndPropertiesOfSediment/></para>
		</#if>

		<#if stdes.DurationOfTestContactTime?has_content>
			<para>Duration of test (contact time):</para>
			<para role="indent"><@com.range stdes.DurationOfTestContactTime/></para>
		</#if>

		<#if stdes.InitialTestSubstanceConcentration?has_content>
			<para>Initial test substance concentration:</para>
			<para role="indent"><@initialSubstanceConcentrationList stdes.InitialTestSubstanceConcentration/></para>
		</#if>

		<#if stdes.ParameterFollowedForBiodegradationEstimation?has_content>
			<para>Parameter followed for biodegradation estimation:
			<#if stdes.ParameterFollowedForBiodegradationEstimation?node_type="picklist_multi">
				<@com.picklistMultiple stdes.ParameterFollowedForBiodegradationEstimation/>
			<#else></para><para role="indent"><@paramBiodegradationList stdes.ParameterFollowedForBiodegradationEstimation/>
			</#if>
			</para>
		</#if>

		<#if stdes.DetailsOnAnalyticalMethods?has_content>
			<para>Details on analytical methods:</para>
			<para role="indent"><@com.text stdes.DetailsOnAnalyticalMethods/></para>
		</#if>

		<#if stdes.DetailsOnStudyDesign?has_content>
			<para>Details on study design:</para>
			<para role="indent"><@com.text stdes.DetailsOnStudyDesign/></para>
		</#if>

		<#if stdes.ReferenceSubstance?has_content>
			<para>Reference substance:</para>
			<para role="indent"><@refSubList stdes.ReferenceSubstance/></para>
		</#if>

	</#compress>
</#macro>