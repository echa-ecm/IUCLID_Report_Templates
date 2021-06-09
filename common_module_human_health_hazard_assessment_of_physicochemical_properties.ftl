
<!-- HUMAN HEALTH HAZARD ASSESSMENT OF PHYSICOCHEMICAL PROPERTIES template file -->

<!-- Get the GHS document -->
<#macro initGhsDocumentList _subject>
<#compress>
	<#assign classificationGhsList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "Ghs") />
</#compress>
</#macro>
	
<!-- Explosives study table -->
<#macro explosivesStudies _subject>
<#compress>
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Explosiveness") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
			
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else>
		The available information on explosivity is summarised in the following table:
				
		<@com.emptyLine/>
		<table border="1">
			<title>Information on explosivity</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
									
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<para>
								Evaluation of results: <@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
							</para>
							
							<para>
								Study results:
							</para>

							<para>Small-scale preliminary tests:</para>
							<@smallScalePrelimTestsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.SmallScalePreliminaryTests)/>
								
							<para>
							<@resultsOfTestSeriesExplosivesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsOfTestSeriesForExplosives)/>
							</para>
								
							<#if study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation?has_content>
								<para>
									Remarks: <@com.richText study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation/>
								</para>
							</#if>
							
							<para>
								<@com.richText study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation/>
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
		<@com.emptyLine/>
	</#if>
	
	<!-- Data waiving -->
	<#if dataWaivingStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Data waiving: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Data waiving: see Physicochemical properties.</para>
		</#if>
	</#if>
					
	<!-- Testing proposal -->
	<#if testingProposalStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Testing proposal: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Testing proposal: see Physicochemical properties.</para>
		</#if>
	</#if>
	
</#compress>
</#macro>
	
<!-- Summary discussion of explosives -->
<#macro explosivesSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Explosiveness") />
				
	<#if summaryList?has_content>
		<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Discussion</emphasis></para>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
			
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			
			<#assign valueForCsaText>
				<#if summary.ResultsAndDiscussion.Explosiveness?has_content>
				Explosiveness: <@com.picklist summary.ResultsAndDiscussion.Explosiveness/>
				</#if>
			</#assign>		
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
		</#list>
	</#if>
	
</#compress>
</#macro>
	
<!-- Classification according to GHS for Explosives -->
<#macro ghsExplosivesClassification _subject>
<#compress>

	<#assign ghsRecord = getGhsHasExplosiveness(classificationGhsList)/>					
	<#if ghsRecord?has_content>
	<para><emphasis role="HEAD-WoutNo">Classification according to GHS</emphasis></para>
		<#list ghsRecord as record>
			<para>
				<emphasis role="bold">Name:</emphasis> <@com.text record.GeneralInformation.Name/>
			</para>
			<para role="indent">
				<#if record.GeneralInformation.RelatedCompositions.Composition?has_content>
				Related composition: <@relatedCompositionList record.GeneralInformation.RelatedCompositions.Composition/>
				</#if>
			</para>
			<para role="indent">
				Classification: <@hazardClassification record.Classification.PhysicalHazards.Explosives/>
			</para>			
		</#list>
	</#if>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Explosiveness") />
	
	<#if summaryList?has_content>
		<#list summaryList as summary>
			<#if summary.Justification.Remarks?has_content>
				<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Justification for classification or non-classification: </emphasis></para>
				<@com.richText summary.Justification.Remarks/>
			</#if>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Flammability study table -->
<#macro flammabilityStudies _subject>
<#compress>
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Flammability") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
			
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else>
		The available information on flammability is summarised in the following table:
				
		<@com.emptyLine/>
		<table border="1">
			<title>Information on flammability</title>
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
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>
									
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#if study.ApplicantSummaryAndConclusion.InterpretationOfResults?has_content>
								<para>
									Evaluation of results: <@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
								</para>
							</#if>
							
							<para>
								Study results:
							</para>
								
							<para>Flammable gasses (lower and upper explosion limits):</para>
							<@flammableGasesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.FlammableGasesLowerAndUpperExplosionLimit)/>
								
							<para>Aerosols:</para>
							<@aerosolsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Aerosols)/>
							
							<para>Flammable solids:</para>
							<@flammableSolidsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.FlammableSolids)/>
							
							<para>Pyrophoric solids:</para>
							<@pyrophoricSolidsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.PyrophoricSolids)/>
							
							<para>Pyrophoric liquid:</para>
							<@pyrophoricLiquidList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.PyrophoricLiquids)/>
							
							<para>Self-heating substances/mixtures:</para>
							<@selfHeatingSubstancesMixturesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.SelfHeatingSubstancesMixtures)/>
							
							<para>Substances/ mixture which in contact with water emit flammable gases:</para>
							<@substancesMixturesWithWaterEmitFlammableGasesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.SubstancesMixturesWhichInContactWithWaterEmitFlammableGases)/>
							
							<#if study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation?has_content>
								<para>
									Remarks: <@com.richText study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation/>
								</para>
							</#if>
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
	<#if dataWaivingStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Data waiving: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Data waiving: see Physicochemical properties.</para>
		</#if>
	</#if>
					
	<!-- Testing proposal -->
	<#if testingProposalStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Testing proposal: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Testing proposal: see Physicochemical properties.</para>
		</#if>
	</#if>

</#compress>
</#macro>
				
<!-- Summary Discussion of flammability -->
<#macro flammabilitySummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Flammability") />
				
	
	<#if summaryList?has_content>
		<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Discussion</emphasis></para>		
		<#list summaryList as summary>
			
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			
			<#assign printSummaryName = summaryList?size gt 1 />
			<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
				
				<emphasis role="bold">Key value for chemical safety assessment:</emphasis>
					
				Flammability: <@com.picklist summary.KeyValueChemicalAssessment.Flammability/>
			
				<#if summary.KeyInformation.KeyInformation?has_content>
					<para><@com.richText summary.KeyInformation.KeyInformation/></para>
				</#if>
								
				<#if summary.Discussion.Discussion?has_content>
					<para><emphasis role="bold">Additional information:</emphasis> <@com.richText summary.Discussion.Discussion/></para>
				</#if>					
		</#list>
	</#if>		
	
</#compress>
</#macro>

<!-- Flash point study table -->
<#macro flashPointStudies _subject>
<#compress>
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "FlashPoint") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
	
	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else>
		The available information on flash point is summarised in the following table:
				
		<@com.emptyLine/>
		<table border="1">
			<title>Information on flash point</title>
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
								Determination of flash point 
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
							<#if study.ResultsAndDiscussion.FlashPoint?has_content>
								<para>Flash point:</para>
									<@flashPointList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.FlashPoint)/>
							</#if>
							
							<#if study.ResultsAndDiscussion.SustainingCombustibility?has_content>
								<para>Sustaining combustibility:</para>
									<@sustainingCombustabilityList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.SustainingCombustibility)/>
							</#if>
							
							<#if study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation?has_content>
								<para>
									Remarks: <@com.richText study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation/>
								</para>
							</#if>
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
	<#if dataWaivingStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Data waiving: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Data waiving: see Physicochemical properties.</para>
		</#if>
	</#if>
					
	<!-- Testing proposal -->
	<#if testingProposalStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Testing proposal: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Testing proposal: see Physicochemical properties.</para>
		</#if>
	</#if>

</#compress>
</#macro>

<!-- Summary Discussion for flash point -->
<#macro flashPointSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "FlashPoint") />
				
	
	<#if summaryList?has_content>
		<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Discussion</emphasis></para>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
		
			<#if summary.KeyInformation.KeyInformation?has_content>
			<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			
			<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
		</#list>
	</#if>	

</#compress>
</#macro>

<!-- Classification according to GHS for Flash point -->
<#macro ghsFlashPointClassification _subject>
<#compress>
	
	<#assign ghsRecord = getGhsHasFlammability(classificationGhsList)/>					
	<#if ghsRecord?has_content>
	<para><emphasis role="HEAD-WoutNo">Classification according to GHS</emphasis></para>
		<#list ghsRecord as record>
			<para>
				<emphasis role="bold">Name:</emphasis> <@com.text record.GeneralInformation.Name/>
			</para>
			<para role="indent">
				<#if record.GeneralInformation.RelatedCompositions.Composition?has_content>
				Related composition: <@relatedCompositionList record.GeneralInformation.RelatedCompositions.Composition/>
				</#if>
			</para>
			<para role="indent">
				Classification (gas): <@hazardClassification record.Classification.PhysicalHazards.FlammableGases/>
				<?linebreak?>
				Classification (liquid): <@hazardClassification record.Classification.PhysicalHazards.FlammableLiquids/>
				<?linebreak?>
				Classification (solid): <@hazardClassification record.Classification.PhysicalHazards.FlammableSolids/>
			</para>
		</#list>
	</#if>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Flammability") />
	
	<#if summaryList?has_content>
		<#list summaryList as summary>
			<#if summary.Justification.Remarks?has_content>
				<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Justification for classification or non-classification: </emphasis></para>
				<@com.richText summary.Justification.Remarks/>
			</#if>
		</#list>
	</#if>

</#compress>
</#macro>

<!-- Oxidising potential study table -->
<#macro oxidisingPropertiesStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "OxidisingProperties") />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>
			
	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else>
		The available information on the oxidising potential is summarised in the following table:
				
		<@com.emptyLine/>
		<table border="1">
			<title>Information on oxidising potential</title>
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
						
							<#if study.MaterialsAndMethods.StudyDesign.ContactWith?has_content || study.MaterialsAndMethods.StudyDesign.DurationOfTest?has_content>
								<para>
									<#if study.MaterialsAndMethods.StudyDesign.ContactWith?has_content>
										Contact with: <@com.picklist study.MaterialsAndMethods.StudyDesign.ContactWith/>
									</#if>
									
									<#if study.MaterialsAndMethods.StudyDesign.DurationOfTest?has_content>
										(<@com.range study.MaterialsAndMethods.StudyDesign.DurationOfTest/>)
									</#if>
								</para>
							</#if>
							
							<para>
								<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
							</para>					
							
							<para>
								<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
							</para>
						</td>
						<!-- Results -->
						<td>
							<#if study.ApplicantSummaryAndConclusion.InterpretationOfResults?has_content>
								<para>
									Evaluation of results: <@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
								</para>
							</#if>
						
							<para>Test results:</para>
							
							<#if study.ResultsAndDiscussion.TestResultOxidisingGases?has_content>
								<para>Oxidising gases:</para>
								<@oxidisingGasesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestResultOxidisingGases)/>
							</#if>
							
							<#if study.ResultsAndDiscussion.TestResultsOxidisingLiquids?has_content>
								<para>Oxidising liquids:</para>
								<@oxidisingLiquidsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestResultsOxidisingLiquids)/>
							</#if>
							
							<#if study.ResultsAndDiscussion.TestResultsOxidisingSolids?has_content>
								<para>Oxidising solids: </para>
								<@oxidisingSolidsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestResultsOxidisingSolids)/>
							</#if>
							
							<#if study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation?has_content>
								<para>
									Remarks: <@com.richText study.ResultsAndDiscussion.AnyOtherInformationOnResultsInclTables.OtherInformation/>
								</para>
							</#if>
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
	<#if dataWaivingStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Data waiving: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Data waiving: see Physicochemical properties.</para>
		</#if>
	</#if>
					
	<!-- Testing proposal -->
	<#if testingProposalStudyList?has_content>
		<#if csrRelevant??>
			<para>
				Testing proposal: see CSR section 1.3 Physicochemical properties.
			</para>
			<#else>
				<para>Testing proposal: see Physicochemical properties.</para>
		</#if>
	</#if>
	
</#compress>
</#macro>
	
<!-- Summary Discussion for Oxidising properties -->
<#macro oxidisingPropertiesSummary _subject>
<#compress>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "OxidisingProperties") />
					
	<#if summaryList?has_content>
		<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Discussion</emphasis></para>
		<#assign printSummaryName = summaryList?size gt 1 />
		<#list summaryList as summary>
		
			<#if summary.KeyInformation.KeyInformation?has_content>
			<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			
			<#assign valueForCsaText>
				<#if summary.KeyValueChemicalAssessment.Oxidising?has_content>			
				Oxidising properties: <@com.picklist summary.KeyValueChemicalAssessment.Oxidising/>
				</#if>
			</#assign>		
			
			<@studyandsummaryCom.endpointSummary summary valueForCsaText printSummaryName/>
			
		</#list>
	</#if>
	
</#compress>
</#macro>
	
<!-- Classification according to GHS for Oxidising Properties -->
<#macro ghsOxidisingPropertiesClassification _subject>
<#compress>

	<#assign ghsRecord = getGhsHasOxidation(classificationGhsList)/>	
	
	<#if ghsRecord?has_content>
	<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Classification according to GHS</emphasis></para>
	<#list ghsRecord as record>
			<para>
				<emphasis role="bold">Name:</emphasis> <@com.text record.GeneralInformation.Name/>
			</para>
			<para role="indent">
				<#if record.GeneralInformation.RelatedCompositions.Composition?has_content>
				Related composition: <@relatedCompositionList record.GeneralInformation.RelatedCompositions.Composition/>
				</#if>
			</para>
			<para role="indent">
				Classification (gas): <@hazardClassification record.Classification.PhysicalHazards.OxidisingGases/>
				<?linebreak?>
				Classification (liquid): <@hazardClassification record.Classification.PhysicalHazards.OxidisingLiquids/>
				<?linebreak?>
				Classification (solid): <@hazardClassification record.Classification.PhysicalHazards.OxidisingSolids/>
			</para>
		</#list>
	</#if>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "OxidisingProperties") />

	<#if summaryList?has_content>
		<#list summaryList as summary>
			<#if summary.Justification.Remarks?has_content>
				<@com.emptyLine/><para><emphasis role="HEAD-WoutNo">Justification for classification or non-classification:</emphasis></para>
				<@com.richText summary.Justification.Remarks/>
			</#if>
		</#list>
	</#if>
	
</#compress>
</#macro>

<!-- Macros and functions -->
<#macro smallScalePrelimTestsList preliminaryRepeatableBlock>
<#compress>
	<#if preliminaryRepeatableBlock?has_content>
		<#list preliminaryRepeatableBlock as blockItem>
			<#if blockItem.Parameter?has_content || blockItem.Value?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Parameter?has_content>
						<@com.picklist blockItem.Parameter/>: 
					</#if>
					
					<#if blockItem.Value?has_content>
						<@com.number blockItem.Value/>
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

<#macro resultsOfTestSeriesExplosivesList testSeriesRepeatableBlock>
<#compress>
	<#if testSeriesRepeatableBlock?has_content>
		<#list testSeriesRepeatableBlock as blockItem>
			<#if blockItem.Parameter?has_content || blockItem.Value?has_content || blockItem.TestSeries?has_content || blockItem.Method?has_content || blockItem.Results?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Parameter?has_content>
						Test series for explosives: <@com.picklist blockItem.Parameter/> 
					</#if>
					
					<#if blockItem.Value?has_content>
						<@com.number blockItem.Value/>
						<?linebreak?>
					</#if>
					
					<#if blockItem.TestSeries?has_content>
						(<@com.picklist blockItem.TestSeries/> 
					</#if>
					
					<#if blockItem.Method?has_content>
						<@com.picklist blockItem.Method/>)
						<?linebreak?>
					</#if>
					
					<#if blockItem.Results?has_content>
						<@com.picklist blockItem.Results/> 
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

<#macro flammableGasesList flammableRepeatableBlock>
<#compress>
	<#if flammableRepeatableBlock?has_content>
		<#list flammableRepeatableBlock as blockItem>
			<#if blockItem.Parameter?has_content || blockItem.Value?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Parameter?has_content>
						<@com.picklist blockItem.Parameter/> 
					</#if>
					
					<#if blockItem.Value?has_content>
						<@com.range blockItem.Value/>
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

<#macro aerosolsList aerosolsRepeatableBlock>
<#compress>
	<#if aerosolsRepeatableBlock?has_content>
		<#list aerosolsRepeatableBlock as blockItem>
			<#if blockItem.TypeOfAerosolTested?has_content || blockItem.ContentOfFlammableComponents?has_content || blockItem.TestParameter?has_content || blockItem.Value?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.TypeOfAerosolTested?has_content> 
						<@com.picklist blockItem.TypeOfAerosolTested/>
						content of flammable components %
					</#if>
					
					<#if blockItem.ContentOfFlammableComponents?has_content>
						<@com.range blockItem.ContentOfFlammableComponents/> 
					</#if>
					
					<#if blockItem.TestParameter?has_content>
						<@com.picklist blockItem.TestParameter/>,
					</#if>
					
					<#if blockItem.Value?has_content>
						<@com.range blockItem.Value/>
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

<#macro flammableSolidsList flammableRepeatableBlock>
<#compress>
	<#if flammableRepeatableBlock?has_content>
		<#list flammableRepeatableBlock as blockItem>
			<#if blockItem.TestProcedure?has_content || blockItem.BurningTime?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.TestProcedure?has_content>
						<@com.picklist blockItem.TestProcedure/>
					</#if>
					
					<#if blockItem.BurningTime?has_content>
						burning time: <@com.range blockItem.BurningTime/>
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

<#macro pyrophoricSolidsList pyrophoricSolidsRepeatableBlock>
<#compress>
	<#if pyrophoricSolidsRepeatableBlock?has_content>
		<#list pyrophoricSolidsRepeatableBlock as blockItem>
			<#if blockItem.TestProcedure?has_content || blockItem.Results?has_content || blockItem.Temp?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.TestProcedure?has_content>
						<@com.picklist blockItem.TestProcedure/> 
					</#if>
					
					<#if blockItem.Results?has_content>
						<@com.range blockItem.Results/> 
					</#if>
					
					<#if blockItem.Temp?has_content>
						at <@com.quantity blockItem.Temp/>
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

<#macro pyrophoricLiquidList pyrophoricLiquidRepeatableBlock>
<#compress>
	<#if pyrophoricLiquidRepeatableBlock?has_content>
		<#list pyrophoricLiquidRepeatableBlock as blockItem>
			<#if blockItem.TestProcedure?has_content || blockItem.Results?has_content || blockItem.Temp?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.TestProcedure?has_content>
						<@com.picklist blockItem.TestProcedure/> 
					</#if>
					
					<#if blockItem.Results?has_content>				
						<@com.range blockItem.Results/> 
					</#if>
					
					<#if blockItem.Temp?has_content>
						at <@com.quantity blockItem.Temp/>
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

<#macro selfHeatingSubstancesMixturesList selfHeatingRepeatableBlock>
<#compress>
	<#if selfHeatingRepeatableBlock?has_content>
		<#list selfHeatingRepeatableBlock as blockItem>
			<#if blockItem.Results?has_content || blockItem.TestProcedure?has_content || blockItem.MaxTempReached?has_content || blockItem.InductionTimeH?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Results?has_content>
						<@com.picklist blockItem.Results/> 
					</#if>
						
					<#if blockItem.TestProcedure?has_content>
						on <@com.picklist blockItem.TestProcedure/>:
					</#if>
					
					<#if blockItem.MaxTempReached?has_content>
						<@com.number blockItem.MaxTempReached/> (max temp. reached),
					</#if>
					
					<#if blockItem.InductionTimeH?has_content>
						<@com.number blockItem.InductionTimeH/> h (induction time)
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

<#macro substancesMixturesWithWaterEmitFlammableGasesList contactFlammableRepeatableBlock>
<#compress>
	<#if contactFlammableRepeatableBlock?has_content>
		<#list contactFlammableRepeatableBlock as blockItem>
			<#if blockItem.TestProcedure?has_content || blockItem.MaxRateOfGasRelease?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.TestProcedure?has_content>
						<@com.picklistMultiple blockItem.TestProcedure/>:
					</#if>
					
					<#if blockItem.MaxRateOfGasRelease?has_content>
						<@com.quantity blockItem.MaxRateOfGasRelease/> (max. rate of gas release)
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

<#macro flashPointList flashPointRepeatableBlock>
<#compress>
	<#if flashPointRepeatableBlock?has_content>
		<#list flashPointRepeatableBlock as blockItem>
			<#if blockItem.FPoint?has_content || blockItem.AtmPressure?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.FPoint?has_content>
						<@com.range blockItem.FPoint/>
					</#if>
					
					<#if blockItem.AtmPressure?has_content>
						at <@com.range blockItem.AtmPressure/>
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

<#macro sustainingCombustabilityList combustabilityRepeatableBlock>
<#compress>
	<#if combustabilityRepeatableBlock?has_content>
		<#list combustabilityRepeatableBlock as blockItem>
			<#if blockItem.Results?has_content || blockItem.TestProcedure?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Results?has_content>
						<@com.picklist blockItem.Results/>
					</#if>
					
					<#if blockItem.TestProcedure?has_content>
						(<@com.picklist blockItem.TestProcedure/>)
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

<#macro oxidisingGasesList oxidisingGasesRepeatableBlock>
<#compress>
	<#if oxidisingGasesRepeatableBlock?has_content>
		<#list oxidisingGasesRepeatableBlock as blockItem>
			<#if blockItem.Results?has_content || blockItem.Parameter?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.Results?has_content> 
						<@com.range blockItem.Results/>
					</#if>
					
					<#if blockItem.Parameter?has_content> 	
						(<@com.picklist blockItem.Parameter/>)
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

<#macro oxidisingLiquidsList oxidisingLiquidRepeatableBlock>
<#compress>
	<#if oxidisingLiquidRepeatableBlock?has_content>
		<#list oxidisingLiquidRepeatableBlock as blockItem>
			<#if blockItem.SampleTested?has_content || blockItem.Parameter?has_content || blockItem.Results?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.SampleTested?has_content>
						<@com.picklist blockItem.SampleTested/>:
					</#if>
					
					<#if blockItem.Parameter?has_content>
						<@com.picklist blockItem.Parameter/>:
					</#if>
					
					<#if blockItem.Results?has_content>
						<@com.range blockItem.Results/>
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

<#macro oxidisingSolidsList oxidisingSolidsRepeatableBlock>
<#compress>
	<#if oxidisingSolidsRepeatableBlock?has_content>
		<#list oxidisingSolidsRepeatableBlock as blockItem>
			<#if blockItem.SampleTested?has_content || blockItem.Parameter?has_content || blockItem.Results?has_content || blockItem.RemarksOnResults?has_content>
				<para role="indent">
					<#if blockItem.SampleTested?has_content>
						<@com.picklist blockItem.SampleTested/>:
					</#if>
					
					<#if blockItem.Parameter?has_content>
						<@com.picklist blockItem.Parameter/>:
					</#if>
					
					<#if blockItem.Results?has_content>
						<@com.range blockItem.Results/>
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

<#macro hazardStatementList HazardStatementRepeatableBlock>
<#compress>
	<#if HazardStatementRepeatableBlock?has_content>
		<#list HazardStatementRepeatableBlock as blockItem>
			<#if blockItem.HazardStatement?has_content>
				<para>
					<#if blockItem.HazardStatement?has_content>
						(Hazard Statement: <@com.picklist blockItem.HazardStatement/>)
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro relatedCompositionList relatedCompositionsValue>
<#compress>
	<#if relatedCompositionsValue?has_content>
		<#list relatedCompositionsValue as item>
			<#local composition = iuclid.getDocumentForKey(item) />
			<#if composition?has_content>
				<@com.text composition.GeneralInformation.Name/>
				<#if composition.GeneralInformation.StateForm?has_content>
					(<@com.picklist composition.GeneralInformation.StateForm/>)
				</#if>
				<#if item_has_next>; </#if>
			</#if>
		</#list>
	</#if>
</#compress>
</#macro>

<#macro hazardClassification hazardClassificationBlock>
<#compress>
	<@com.picklist hazardClassificationBlock.HazardCategory/>
	<#if hazardClassificationBlock.HazardStatement?has_content>
		(Hazard statement: <@com.picklist hazardClassificationBlock.HazardStatement/>)
	</#if>
	<@com.picklist hazardClassificationBlock.ReasonForNoClassification/>
</#compress>
</#macro>

<#function getGhsHasExplosiveness classificationGhsList>
	<#local ghs = []/>
	
	<#if !(classificationGhsList?has_content)>
		<#return [] />
	</#if>
	<#list classificationGhsList as classificationGhsList>
		<#if isGhsExplosive(classificationGhsList)>
			<#local ghs = ghs + [classificationGhsList]/>			
		</#if>	
	</#list>
	
	<#return ghs />	
</#function>

<#function isGhsExplosive classificationGhsList>
	<#return classificationGhsList.Classification.PhysicalHazards.Explosives.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.Explosives.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.Explosives.ReasonForNoClassification?has_content />
</#function>

<#function getGhsHasFlammability classificationGhsList>
	<#local ghs = []/>
	
	<#if !(classificationGhsList?has_content)>
		<#return [] />
	</#if>
	<#list classificationGhsList as classificationGhsList>
		<#if isGhsFlammable(classificationGhsList)>
			<#local ghs = ghs + [classificationGhsList]/>			
		</#if>	
	</#list>
	
	<#return ghs />	
</#function>

<#function isGhsFlammable classificationGhsList>
	<#return classificationGhsList.Classification.PhysicalHazards.FlammableGases.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableLiquids.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableSolids.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableGases.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableLiquids.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableSolids.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableGases.ReasonForNoClassification?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableLiquids.ReasonForNoClassification?has_content || classificationGhsList.Classification.PhysicalHazards.FlammableSolids.ReasonForNoClassification?has_content/>
</#function>

<#function getGhsHasOxidation classificationGhsList>
	<#local ghs = []/>
	
	<#if !(classificationGhsList?has_content)>
		<#return [] />
	</#if>
	<#list classificationGhsList as classificationGhsList>
		<#if isGhsOxidising(classificationGhsList)>
			<#local ghs = ghs + [classificationGhsList]/>			
		</#if>	
	</#list>
	
	<#return ghs />	
</#function>

<#function isGhsOxidising classificationGhsList>
	<#return classificationGhsList.Classification.PhysicalHazards.OxidisingGases.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingLiquids.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingSolids.HazardCategory?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingGases.HazardStatement?has_content || 	classificationGhsList.Classification.PhysicalHazards.OxidisingLiquids.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingSolids.HazardStatement?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingGases.ReasonForNoClassification?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingLiquids.ReasonForNoClassification?has_content || classificationGhsList.Classification.PhysicalHazards.OxidisingSolids.ReasonForNoClassification?has_content/>
</#function>

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

<#-- Macros added for PPP including new results -->

<#--1. Methods-->
<#macro physchemMethod study>
	<#compress>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign") && study.MaterialsAndMethods.StudyDesign?has_content>
			<para><emphasis role="bold">Study design:</emphasis></para>
			<para>
				<#local sd=study.MaterialsAndMethods.StudyDesign/>

				<#if sd.hasElement("ContactWith") && sd.ContactWith?has_content>
					<span role="indent">Contact with <@com.picklist sd.ContactWith/></span>
				</#if>
				<#if sd.hasElement("DurationOfTest") && sd.DurationOfTest?has_content>
					<span role="indent">Duration: <@com.range sd.DurationOfTest/></span>
				</#if>
				<#if sd.hasElement("AnalyticalMethod") && sd.AnalyticalMethod?has_content>
					<span role="indent">Analytical method: <@com.picklistMultiple sd.AnalyticalMethod/></span>
				</#if>
				<#if sd.hasElement("ContainerMaterial") && sd.ContainerMaterial?has_content>
					<span role="indent"><@com.picklist sd.ContainerMaterial/></span>
				</#if>
				<#if sd.hasElement("DetailsOnMethods") && sd.DetailsOnMethods?has_content>
					<span role="indent"><@com.text sd.DetailsOnMethods/></span>
				</#if>
			</para>
		</#if>

		<#if study.hasElement("MaterialsAndMethods.Reagents.Reagent") && study.MaterialsAndMethods.Reagents.Reagent?has_content>
			<para><emphasis role="bold">Reagents: </emphasis><@com.picklist study.MaterialsAndMethods.Reagents.Reagent/></para>
		</#if>

		<#if study.hasElement("MaterialsAndMethods.TitrationOfAcidityAndAlkalinity.DetailsOnTitrantUsed") && study.MaterialsAndMethods.TitrationOfAcidityAndAlkalinity.DetailsOnTitrantUsed?has_content>
			<para><emphasis role="bold">Titration of acidity / alkalinity: </emphasis><@com.text study.MaterialsAndMethods.TitrationOfAcidityAndAlkalinity.DetailsOnTitrantUsed/></para>
		</#if>

		<#-- Type of compatibility-->
		<#if study.hasElement("DataSource.TypeOfCompatibility.TypeOfCompatibilityLabel") && study.DataSource.TypeOfCompatibility.TypeOfCompatibilityLabel?has_content>
			<para><emphasis role="bold">Type of compatibility: </emphasis><@com.picklist study.DataSource.TypeOfCompatibility.TypeOfCompatibilityLabel/></para>
		</#if>

	</#compress>
</#macro>

<#--2. Results sections: new, non existing in common_module_human_health_hazard_assessment_of_physicochemical_properties-->
<#macro analyticalDeterminationList analyticalDeterminationRepeatableBlock>
	<#compress>
		<#if analyticalDeterminationRepeatableBlock?has_content>
			<#list analyticalDeterminationRepeatableBlock as blockItem>
					<para role="indent">
						<#if blockItem.PurposeOfAnalysis?has_content>
							Purpose of analysis: <@com.picklist blockItem.PurposeOfAnalysis/>.
						</#if>
						<#if blockItem.AnalysisType?has_content>
							Analysis type: <@com.picklistMultiple blockItem.AnalysisType/>.
						</#if>
						<#--						<#if blockItem.TypeOfInformationProvided?has_content>-->
						<#--							(<@com.picklist blockItem.TypeOfInformationProvided/>-->
						<#--							<#if blockItem.AttachedMethodsResults?has_content>-->
						<#--								- attachment-->
						<#--								&lt;#&ndash; NOTE: in future add attachment link&ndash;&gt;-->
						<#--							</#if>)-->
						<#--						<#elseif blockItem.AttachedMethodsResults?has_content>-->
						<#--							(attachment)-->
						<#--						</#if>-->
						<#if blockItem.RationaleForNoResults?has_content>
							Rationale for no results : <@com.picklist blockItem.RationaleForNoResults/>.
						</#if>
						<#if blockItem.Justification?has_content>
							Justification : <@com.text blockItem.Justification/>.
						</#if>
						<#if blockItem.Remarks?has_content>
							(<@com.text blockItem.Remarks/>)
						</#if>
					</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro analyticalDeterminationForNanoformsList analyticalDeterminationForNanoformsRepeatableBlock>
	<#compress>
		<#if analyticalDeterminationForNanoformsRepeatableBlock?has_content>
			<#list analyticalDeterminationForNanoformsRepeatableBlock as blockItem>
				<#if blockItem.Parameter?has_content || blockItem.PurposeOfAnalysis?has_content || blockItem.AnalysisType?has_content || blockItem.TypeOfInformationProvided?has_content || blockItem.AttachedMethodsResults?has_content ||
				blockItem.RationaleForNoResults?has_content || blockItem.Justification?has_content || blockItem.Remarks?has_content>
					<para role="indent">
						<#if blockItem.Parameter?has_content>
							Parameter: <@com.picklistMultiple blockItem.Parameter/>.
						</#if>
						<#if blockItem.PurposeOfAnalysis?has_content>
							Purpose of analysis: <@com.picklist blockItem.PurposeOfAnalysis/>.
						</#if>
						<#if blockItem.AnalysisType?has_content>
							Analysis type: <@com.picklistMultiple blockItem.AnalysisType/>.
						</#if>
						<#--						<#if blockItem.TypeOfInformationProvided?has_content>-->
						<#--							(<@com.picklist blockItem.TypeOfInformationProvided/>-->
						<#--							<#if blockItem.AttachedMethodsResults?has_content>-->
						<#--								- attachment-->
						<#--							&lt;#&ndash; NOTE: in future add attachment link&ndash;&gt;-->
						<#--							</#if>-->
						<#--							)-->
						<#--						<#elseif blockItem.AttachedMethodsResults?has_content>-->
						<#--							(attachment)-->
						<#--						</#if>-->
						<#if blockItem.RationaleForNoResults?has_content>
							Rationale for no results : <@com.picklist blockItem.RationaleForNoResults/>.
						</#if>
						<#if blockItem.Justification?has_content>
							Justification : <@com.picklist blockItem.Justification/>.
						</#if>
						<#if blockItem.Remarks?has_content>
							(<@com.picklist blockItem.Remarks/>)
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro meltingPointList meltingRepeatableBlock>
	<#compress>
		<#if meltingRepeatableBlock?has_content>
			<#list meltingRepeatableBlock as blockItem>
				<#if blockItem.DecompIndicator?has_content || blockItem.DecompTemp?has_content || blockItem.MeltingPoint?has_content || blockItem.Pressure?has_content || blockItem.SublimationIndicator?has_content || blockItem.SublimationTemp?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.MeltingPoint?has_content>
							Melting Point: <@com.range blockItem.MeltingPoint/>.
						</#if>
						<#if blockItem.Pressure?has_content>
							Pressure: <@com.range blockItem.Pressure/>.
						</#if>
						<#if blockItem.DecompIndicator?has_content || blockItem.DecompTemp?has_content>
							Decomposition: <@com.picklist blockItem.DecompIndicator/> (<@com.range blockItem.DecompTemp/>)
						</#if>
						<#if blockItem.SublimationIndicator?has_content || blockItem.SublimationTemp?has_content>
							Sublimation: <@com.picklist blockItem.SublimationIndicator/> (<@com.range blockItem.SublimationTemp/>)
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

<#macro boilingPointList boilingPointRepeatableBlock>
	<#compress>
		<#if boilingPointRepeatableBlock?has_content>
			<#list  boilingPointRepeatableBlock as blockItem>
				<#if blockItem.Decomposition?has_content || blockItem.DecompositionTemp?has_content || blockItem.BoilingPoint?has_content || blockItem.Pressure?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.BoilingPoint?has_content>
							Boiling Point: <@com.range blockItem.BoilingPoint/>.
						</#if>
						<#if blockItem.Pressure?has_content>
							Pressure: <@com.range blockItem.Pressure/>.
						</#if>
						<#if blockItem.Decomposition?has_content || blockItem.DecompositionTemp?has_content>
							Decomposition: <@com.picklist blockItem.Decomposition/> (<@com.range blockItem.DecompositionTemp/>)
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

<#macro vapourprList vapourprRepeatableBlock>
	<#compress>
		<#if vapourprRepeatableBlock?has_content>
			<#list  vapourprRepeatableBlock as blockItem>
				<#if blockItem.TestNo?has_content || blockItem.TempQualifier?has_content || blockItem.Pressure?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.TestNo?has_content>
							Test <@com.picklist blockItem.TestNo/>:
						</#if>
						<#if blockItem.TempQualifier?has_content>
							Temp: <@com.range blockItem.TempQualifier/>.
						</#if>
						<#if blockItem.Pressure?has_content>
							Pressure: <@com.range blockItem.Pressure/>.
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

<#macro vapourprAt50List vapourprAt50RepeatableBlock>
	<#compress>
		<#if vapourprAt50RepeatableBlock?has_content>
			<#list  vapourprAt50RepeatableBlock as blockItem>
				<#if blockItem.VapourPressure?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.VapourPressure?has_content>
							Pressure: <@com.range blockItem.VapourPressure/>.
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

<#macro vapourTransitionList vapourTransitionRepeatableBlock>
	<#compress>
		<#if vapourTransitionRepeatableBlock?has_content>
			<#list  vapourTransitionRepeatableBlock as blockItem>
				<#if blockItem.Indicator?has_content || blockItem.Temp?has_content || blockItem.VapourPressureAt10CBelowTransitionTemperature?has_content || blockItem.VapPrAt10?has_content ||
				blockItem.VapourPressureAt20CBelowTransitionTemperature?has_content || blockItem.VapPrAt20?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Indicator?has_content>
							<@com.picklist blockItem.Indicator/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.range blockItem.Temp/>.
						</#if>
						<#if blockItem.VapourPressureAt10CBelowTransitionTemperature?has_content>
							Pressure at 10°C below transition temperature: <@com.quantity blockItem.VapourPressureAt10CBelowTransitionTemperature/>.
						</#if>
						<#if blockItem.VapPrAt10?has_content>
							Pressure at 10°C above transition temperature: <@com.quantity blockItem.VapPrAt10/>.
						</#if>
						<#if blockItem.VapourPressureAt20CBelowTransitionTemperature?has_content>
							Pressure at 20°C below transition temperature: <@com.quantity blockItem.VapourPressureAt20CBelowTransitionTemperature/>.
						</#if>
						<#if blockItem.VapPrAt20?has_content>
							Pressure at 20°C above transition temperature: <@com.quantity blockItem.VapPrAt20/>.
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

<#macro henrysLawConstantHList henrysLawConstantHRepeatableBlock>
	<#compress>
		<#if henrysLawConstantHRepeatableBlock?has_content>
			<#list  henrysLawConstantHRepeatableBlock as blockItem>
				<#if blockItem.H?has_content || blockItem.Temp?has_content || blockItem.AtmPressure?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.H?has_content>
							H: <@com.range blockItem.H/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
						</#if>
						<#if blockItem.AtmPressure?has_content>
							Atm. pressure: <@com.quantity blockItem.AtmPressure/>.
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

<#macro appearanceList appearanceRepeatableBlock>
	<#compress>
		<#if appearanceRepeatableBlock?has_content>
			<#list  appearanceRepeatableBlock as blockItem>
				<#if blockItem.Form?has_content || blockItem.SubstanceColour?has_content || blockItem.Odour?has_content>
					<para role="indent">
						<#if blockItem.Form?has_content>
							Form: <@com.picklist blockItem.Form/>.
						</#if>
						<#if blockItem.SubstanceColour?has_content>
							Colour: <@com.text blockItem.SubstanceColour/>.
						</#if>
						<#if blockItem.Odour?has_content>
							Odour: <@com.picklist blockItem.Odour/>.
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro waterSolubilityList waterSolubilityRepeatableBlock>
	<#compress>
		<#if waterSolubilityRepeatableBlock?has_content>
			<#list  waterSolubilityRepeatableBlock as blockItem>
				<#if blockItem.Solubility?has_content || blockItem.ConcBasedOn?has_content || blockItem.LoadingOfAqueousPhase?has_content || blockItem.IncubationDuration?has_content ||
				blockItem.Temp?has_content || blockItem.Ph?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Solubility?has_content>
							Water solubility: <@com.range blockItem.Solubility/>.
						</#if>
						<#if blockItem.ConcBasedOn?has_content>
							Concentration based on <@com.picklist blockItem.ConcBasedOn/>.
						</#if>
						<#if blockItem.LoadingOfAqueousPhase?has_content>
							Loading of aqueous phase: <@com.quantity blockItem.LoadingOfAqueousPhase/>.
						</#if>
						<#if blockItem.IncubationDuration?has_content>
							Incubation duration: <@com.range blockItem.IncubationDuration/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
						</#if>
						<#if blockItem.Ph?has_content>
							Ph: <@com.quantity blockItem.Ph/>.
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

<#macro solubilityMetalList solubilityMetalRepeatableBlock>
	<#compress>
		<#if solubilityMetalRepeatableBlock?has_content>
			<#list  solubilityMetalRepeatableBlock as blockItem>
				<#if blockItem.TypeOfTest?has_content || blockItem.MeanDissolvedConc?has_content || blockItem.ElementAnalysed?has_content || blockItem.LoadingOfAqueousPhase?has_content ||
				blockItem.IncubationDuration?has_content || blockItem.TestConditions?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.TypeOfTest?has_content>
							Type of test: <@com.picklist blockItem.TypeOfTest/>.
						</#if>
						<#if blockItem.MeanDissolvedConc?has_content>
							Mean dissolved concentration: <@com.range blockItem.MeanDissolvedConc/>.
						</#if>
						<#if blockItem.ElementAnalysed?has_content>
							Element analysed: <@com.text blockItem.ElementAnalysed/>.
						</#if>
						<#if blockItem.LoadingOfAqueousPhase?has_content>
							Loading of aqueous phase: <@com.quantity blockItem.LoadingOfAqueousPhase/>.
						</#if>
						<#if blockItem.IncubationDuration?has_content>
							Incubation duration: <@com.quantity blockItem.IncubationDuration/>.
						</#if>
						<#if blockItem.TestConditions?has_content>
							Test conditions: <@com.text blockItem.TestConditions/>.
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

<#macro solubilityOrganicList solubilityOrganicRepeatableBlock>
	<#compress>
		<#if solubilityOrganicRepeatableBlock?has_content>
			<#list  solubilityOrganicRepeatableBlock as blockItem>
				<#if blockItem.Medium?has_content || blockItem.Solubility?has_content || blockItem.Temp?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Medium?has_content>
							Solvent: <@com.picklist blockItem.Medium/>.
						</#if>
						<#if blockItem.Solubility?has_content>
							Solubility: <@com.range blockItem.Solubility/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
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

<#macro partcoeffList partcoeffRepeatableBlock>
	<#compress>
		<#if partcoeffRepeatableBlock?has_content>
			<#list  partcoeffRepeatableBlock as blockItem>
				<#if blockItem.Type?has_content || blockItem.Partition?has_content || blockItem.Temp?has_content || blockItem.Ph?has_content ||blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Type?has_content>
							Type: <@com.picklist blockItem.Type/>.
						</#if>
						<#if blockItem.Partition?has_content>
							Partition coefficient: <@com.range blockItem.Partition/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
						</#if>
						<#if blockItem.Ph?has_content>
							pH: <@com.range blockItem.Ph/>.
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

<#macro dissociationConstantList dissociationConstantRepeatableBlock>
	<#compress>
		<#if dissociationConstantRepeatableBlock?has_content>
			<#list  dissociationConstantRepeatableBlock as blockItem>
				<#if blockItem.No?has_content || blockItem.pka?has_content || blockItem.Temp?has_content ||blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.No?has_content>
							No <@com.picklist blockItem.No/>:
						</#if>
						<#if blockItem.pka?has_content>
							pKa: <@com.range blockItem.pka/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
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

<#macro relativeSelfIgnitionTemperatureSolidsList relativeSelfIgnitionTemperatureSolidsRepeatableBlock>
	<#compress>
		<#if relativeSelfIgnitionTemperatureSolidsRepeatableBlock?has_content>
			<#list  relativeSelfIgnitionTemperatureSolidsRepeatableBlock as blockItem>
				<#if blockItem.RelativeSelfIgnitionTemperature?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.RelativeSelfIgnitionTemperature?has_content>
							Relative self-ignition temperature (solids): <@com.range blockItem.RelativeSelfIgnitionTemperature/>.
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

<#macro autoFlammabilityList autoFlammabilityRepeatableBlock>
	<#compress>
		<#if autoFlammabilityRepeatableBlock?has_content>
			<#list  autoFlammabilityRepeatableBlock as blockItem>
				<#if blockItem.Flammability?has_content || blockItem.AtmPressure?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Flammability?has_content>
							Auto-ignition temperature (liquids / gases): <@com.range blockItem.Flammability/>.
						</#if>
						<#if blockItem.AtmPressure?has_content>
							Atm pressure: <@com.range blockItem.AtmPressure/>.
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

<#macro selfIgnitionTemperatureOfDustAccumulationList selfIgnitionTemperatureOfDustAccumulationRepeatableBlock>
	<#compress>
		<#if selfIgnitionTemperatureOfDustAccumulationRepeatableBlock?has_content>
			<#list  selfIgnitionTemperatureOfDustAccumulationRepeatableBlock as blockItem>
				<#if blockItem.SelfIgnitionTemperature?has_content || blockItem.VolumeSurfaceRatioM?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.SelfIgnitionTemperature?has_content>
							Self-ignition temperature: <@com.range blockItem.SelfIgnitionTemperature/>.
						</#if>
						<#if blockItem.VolumeSurfaceRatioM?has_content>
							Volume / surface ratio (m): <@com.number blockItem.VolumeSurfaceRatioM/>.
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

<#macro surfaceTensionList surfaceTensionRepeatableBlock>
	<#compress>
		<#if surfaceTensionRepeatableBlock?has_content>
			<#list  surfaceTensionRepeatableBlock as blockItem>
				<#if blockItem.Tension?has_content || blockItem.Temp?has_content || blockItem.Conc?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Tension?has_content>
							Surface tension: <@com.range blockItem.Tension/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
						</#if>
						<#if blockItem.Conc?has_content>
							Conc: <@com.quantity blockItem.Conc/>.
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


<#macro phList phRepeatableBlock>
	<#compress>
		<#if phRepeatableBlock?has_content>
			<#list  phRepeatableBlock as blockItem>
				<#if blockItem.Value?has_content || blockItem.Temp?has_content || blockItem.Concentration?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Value?has_content>
							pH value: <@com.range blockItem.Value/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
						</#if>
						<#if blockItem.Concentration?has_content>
							Conc: <@com.range blockItem.Concentration/>.
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

<#macro acidityList acidityRepeatableBlock>
	<#compress>
		<#if acidityRepeatableBlock?has_content>
			<#list  acidityRepeatableBlock as blockItem>
				<#if blockItem.AcidityOrAlkalinity?has_content || blockItem.Value?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.AcidityOrAlkalinity?has_content>
							<@com.picklist blockItem.AcidityOrAlkalinity/>
							<#if blockItem.Value?has_content>: </#if>
						</#if>
						<#if blockItem.Value?has_content>
							<@com.range blockItem.Value/>.
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


<#macro densityList densityRepeatableBlock>
	<#compress>
		<#if densityRepeatableBlock?has_content>
			<#list  densityRepeatableBlock as blockItem>
				<#if blockItem.Type?has_content || blockItem.Density?has_content || blockItem.Temp?has_content ||blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.Type?has_content>
							<@com.picklist blockItem.Type/>
							<#if blockItem.Density?has_content>: </#if>
						</#if>
						<#if blockItem.Density?has_content>
							<@com.range blockItem.Density/>.
						</#if>
						<#if blockItem.Temp?has_content>
							Temp: <@com.quantity blockItem.Temp/>.
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

<#macro transformationList transformationRepeatableBlock>
	<#compress>
		<#if transformationRepeatableBlock?has_content>
			<#list  transformationRepeatableBlock as blockItem>
				<#if blockItem.No?has_content || blockItem.ReferenceSubstance?has_content>
					<para role="indent">
						<#if blockItem.No?has_content>
							<@com.picklist blockItem.No/>
						</#if>
						<#if blockItem.ReferenceSubstance?has_content>
							<#local referenceSubs = iuclid.getDocumentForKey(blockItem.ReferenceSubstance)/>
							<@com.text referenceSubs.ReferenceSubstanceName/>.
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro operatingTempList operatingTempRepeatableBlock>
	<#compress>
		<#if operatingTempRepeatableBlock?has_content>
			<#list  operatingTempRepeatableBlock as blockItem>
				<#if blockItem.OperatingTemp?has_content || blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.OperatingTemp?has_content>
							Temp: <@com.range blockItem.OperatingTemp/>.
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


<#macro degreeDissolutionList degreeDissolutionRepeatableBlock>
	<#compress>
		<#if degreeDissolutionRepeatableBlock?has_content>
			<#list  degreeDissolutionRepeatableBlock as blockItem>
				<#if blockItem.FlowTimeSec?has_content || blockItem.Concentration?has_content ||blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.FlowTimeSec?has_content>
							Flow time: <@com.number blockItem.FlowTimeSec/> sec.
						</#if>
						<#if blockItem.Concentration?has_content>
							Conc.: <@com.quantity blockItem.Concentration/>.
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



<#macro dilutionStabilityList dilutionStabilityRepeatableBlock>
	<#compress>
		<#if dilutionStabilityRepeatableBlock?has_content>
			<#list dilutionStabilityRepeatableBlock as blockItem>
				<#if blockItem.PresenceOfSeparatedMaterial?has_content || blockItem.Concentration?has_content ||blockItem.RemarksOnResults?has_content>
					<para role="indent">
						<#if blockItem.PresenceOfSeparatedMaterial?has_content>
							Presence of separated material: <@com.picklist blockItem.PresenceOfSeparatedMaterial/>.
						</#if>
						<#if blockItem.Concentration?has_content>
							Conc.: <@com.quantity blockItem.Concentration/>.
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

<#macro dilutionStability2List dilutionStability2RepeatableBlock>
	<#compress>
		<#if dilutionStability2RepeatableBlock?has_content>
			<#list dilutionStability2RepeatableBlock as blockItem>
				<#if blockItem.Concentration?has_content || blockItem.Test5Min?has_content || blockItem.Test18H?has_content >
					<para role="indent">
						<#if blockItem.Concentration?has_content>
							Conc.: <@com.quantity blockItem.Concentration/>.
						</#if>
						<#if blockItem.Test5Min.PresenceOfSediment5min?has_content || blockItem.Test5Min.AmountOfResidueG?has_content ||
						blockItem.Test5Min.RepeatabilityR?has_content || blockItem.Test5Min.ReproducibilityR?has_content >
							5min test:
							<#if blockItem.Test5Min.PresenceOfSediment5min?has_content>presence of sediment - <@com.picklist blockItem.Test5Min.PresenceOfSediment5min/></#if>
							<#if blockItem.Test5Min.AmountOfResidueG?has_content>(<@com.number blockItem.Test5Min.AmountOfResidueG/>g)</#if>
							<#if blockItem.Test5Min.RepeatabilityR?has_content>, r = <@com.picklist blockItem.Test5Min.RepeatabilityR/></#if>
							<#if blockItem.Test5Min.ReproducibilityR?has_content>, R = <@com.picklist blockItem.Test5Min.ReproducibilityR/></#if>
							.
						</#if>
						<#if blockItem.Test18H.PresenceOfSediment18h?has_content || blockItem.Test18H.AmountOfResidueG?has_content ||
						blockItem.Test18H.RepeatabilityR?has_content || blockItem.Test18H.ReproducibilityR?has_content >
							18h test:
							<#if blockItem.Test18H.PresenceOfSediment18h?has_content>presence of sediment - <@com.picklist blockItem.Test18H.PresenceOfSediment18h/></#if>
							<#if blockItem.Test18H.AmountOfResidueG?has_content>(<@com.number blockItem.Test18H.AmountOfResidueG/>g)</#if>
							<#if blockItem.Test18H.RepeatabilityR?has_content>, r = <@com.picklist blockItem.Test18H.RepeatabilityR/></#if>
							<#if blockItem.Test18H.ReproducibilityR?has_content>, R = <@com.picklist blockItem.Test18H.ReproducibilityR/></#if>
							.
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--3. Macro for Spectra - it's a flexible record and not an endpoint summary. Has a totally differnt layout than appendixE-->
<#macro opticalStudies _subject>
	<#compress>
		<#local studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "AnalyticalInformation") />

	<#-- Study results-->
		<@com.emptyLine/>

		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Studies</emphasis></para>
		<@com.emptyLine/>

		<#if !studyList?has_content>
			No relevant information available.
		<#else>
			${studyList?size} individual <#if studyList?size==1>study<#else>studies</#if> for spectra, molar extinction and/or optical purity <#if studyList?size==1>is<#else>are</#if> summarised below:
			<@com.emptyLine/>

			<#list studyList as study>
				<sect4 xml:id="${study.documentKey.uuid!}" label="/${study_index+1}"><title  role="HEAD-5" >${study.name}</title>

					<para><emphasis role="HEAD-WoutNo">Methods and results of analysis</emphasis></para>


					<#if study.AnalyticalInformation.MethodsAndResultsOfAnalysis.AnalyticalDetermination?has_content>
						<para><emphasis role="bold">Analytical determination:</emphasis></para>
						<@analyticalDeterminationList study.AnalyticalInformation.MethodsAndResultsOfAnalysis.AnalyticalDetermination/>
					</#if>
					<#if study.AnalyticalInformation.MethodsAndResultsOfAnalysis.OpticalActivity?has_content>
						<para><emphasis role="bold">Optical activity:</emphasis></para>
						<para role="indent"><@com.picklist study.AnalyticalInformation.MethodsAndResultsOfAnalysis.OpticalActivity/></para>
					</#if>
					<#if study.AnalyticalInformation.MethodsAndResultsOfAnalysis.AnalyticalDeterminationForNanoforms?has_content>
						<para><emphasis role="bold">Analytical determination for nanoforms:</emphasis></para>
						<@analyticalDeterminationForNanoformsList study.AnalyticalInformation.MethodsAndResultsOfAnalysis.AnalyticalDeterminationForNanoforms/>
					</#if>
					<#if study.AnalyticalInformation.MethodsAndResultsOfAnalysis.Remarks?has_content>
						<para><emphasis role="bold">Remarks:</emphasis></para>
						<para role="indent"><@com.text study.AnalyticalInformation.MethodsAndResultsOfAnalysis.Remarks/></para>
					</#if>
				</sect4>
			</#list>
		</#if>

	</#compress>
</#macro>

