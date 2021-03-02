
<!-- 5. HUMAN HEALTH HAZARD ASSESSMENT template file -->

<!-- Summary Discussion of Toxicokinetics (absorption, metabolism, distribution and elimination) -->
<#macro toxicokineticsSummary _subject>
<#compress>
    <#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ExposureRelatedObservationsHumans") />

    <#if summaryList?has_content>
        <para><emphasis role="HEAD-WoutNo">Summary and discussion of human information</emphasis></para>
        
			<!-- relevant to CSR only -->
			<#if csrRelevant??>
				<para>
					(Note: The following summary has been extracted from the endpoint summary of IUCLID section 7.10 Exposure related observations in humans. It may be appropriate to manually move or copy relevant part(s) to the "Summary and discussion" part of the corresponding CSR chapter(s).)
				</para>
			</#if>
		
        <#assign printSummaryName = summaryList?size gt 1 />
        <#list summaryList as summary>
            <@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
        </#list>
	</#if>
</#compress>
</#macro>

<!-- Non-human information: for CSR basic toxicokinetics and dermal absorption but for non-CSR basic toxicokinetics only -->
<#macro nonhumanInformationToxicokineticsStudies _subject>
<#compress>

	<#assign studyListBasic = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "BasicToxicokinetics") />
	<#assign studyListDermal = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DermalAbsorption") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyListBasic/>
	<#assign resultStudyListBasic = resultStudyList/>
	<#assign dataWaivingStudyListBasic = dataWaivingStudyList/>
	<#assign testingProposalStudyListBasic = testingProposalStudyList/>
	
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyListDermal/>
	<#assign resultStudyListDermal = resultStudyList/>
	<#assign dataWaivingStudyListDermal = dataWaivingStudyList/>
	<#assign testingProposalStudyListDermal = testingProposalStudyList/>

	<!-- Study results -->
	<#if (csrRelevant?? && !(resultStudyListBasic?has_content || resultStudyListDermal?has_content)) || (!(csrRelevant??) && !(resultStudyListBasic?has_content))>
		No relevant information available.
	
	<#else/>			
		The results are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
		<#if csrRelevant??>
		<title>Studies on absorption, metabolism, distribution and elimination</title>
			<#else>
			<title>Studies on basic toxicokinetics</title>
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

				<#list resultStudyListBasic as study>
					<tr>
						<!-- Method -->
						<td>
							<para>Basic toxicokinetics study</para>
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
							Main ADME results: <@ADMEList study.ResultsAndDiscussion.MainAdmeResults/>
							</para>

							<para>
							<@TransferList study.ResultsAndDiscussion.PharmacokineticStudies.TransferIntoOrgans/>
							</para>

							<para>
								Toxicokinetic parameters: <@ToxicokineticParametersList study.ResultsAndDiscussion.PharmacokineticStudies.ToxicokineticParameters/>
							</para>

							<para>
								Absorption: <@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnAbsorption/>
							</para>

							<para>
								Distribution: <@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnDistribution/>
							</para>

							<para>
								Excretion: <@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnExcretion/>
							</para>

							<para>
								Metabolites identified: <@com.picklist study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.MetabolitesIdentified/>
							</para>

							<para>
								Details on metabolites: <@com.text study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.DetailsOnMetabolites/>
							</para>

							<!--
							<para>
								TO DO - Evaluation of results: 	INTERPRETATION OF RESULTS NOT IN DOC - WHAT FIELD TO USE?
							</para>
							 -->
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
			
			<#if csrRelevant??>			
				<#list resultStudyListDermal as study>
					<tr>
						<!-- Method -->
						<td>
							<para>Dermal absorption study</para>
						<@nonHumanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.AbsorptionMatrices/>
							</para>

							<para>
								Total recovery: <@com.text study.ResultsAndDiscussion.TotalRecovery/>
							</para>

							<para>
								<#if study.ResultsAndDiscussion.Absorption?has_content>
									Percutaneous absorption rate: <@PercutaneousAbsorptionRateList study.ResultsAndDiscussion.Absorption/>
								</#if>
							</para>
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
		<#if dataWaivingStudyListBasic?has_content || dataWaivingStudyListDermal?has_content>
		  <para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		  <@studyandsummaryCom.dataWaiving dataWaivingStudyListBasic "Basic toxicokinetics" false/>
		  <@studyandsummaryCom.dataWaiving dataWaivingStudyListDermal "Dermal Absorption" false/>
		</#if>
		<#else/>
			<#if dataWaivingStudyListBasic?has_content>
			  <para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
			  <@studyandsummaryCom.dataWaiving dataWaivingStudyListBasic "Basic toxicokinetics" false/>
			</#if>
	</#if>

	<!-- Testing proposal -->
	<#if csrRelevant??>
		<#if testingProposalStudyListBasic?has_content || testingProposalStudyListDermal?has_content>
		  <para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		  <@studyandsummaryCom.testingProposal testingProposalStudyListBasic "Basic Toxicokinetics" false/>
		  <@studyandsummaryCom.testingProposal testingProposalStudyListDermal "Dermal Absorption" false/>
		</#if>
		<#else/>
			<#if testingProposalStudyListBasic?has_content>
			<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
			<@studyandsummaryCom.testingProposal testingProposalStudyListBasic "Basic Toxicokinetics" false/>
			</#if>
	</#if>	

	<#assign studyListBasic = [] />
	<#assign studyListDermal = [] />
	<#assign resultStudyListBasic = []/>
	<#assign dataWaivingStudyListBasic = []/>
	<#assign testingProposalStudyListBasic = []/>
	<#assign resultStudyListDermal = []/>
	<#assign dataWaivingStudyListDermal = []/>
	<#assign testingProposalStudyListDermal = []/>
		
</#compress>
</#macro>

<!-- Non-human information for dermal absorption only -->
<#macro nonhumanInformationDermalAbsorptionStudies _subject>
<#compress>

	<#assign studyListDermal = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DermalAbsorption") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyListDermal/>
	<#assign resultStudyListDermal = resultStudyList/>
	<#assign dataWaivingStudyListDermal = dataWaivingStudyList/>
	<#assign testingProposalStudyListDermal = testingProposalStudyList/>

	<!-- Study results -->
	<#if !csrRelevant?? && !resultStudyListDermal?has_content>
		No relevant information available.		
		<#else/>
			The results of studies on dermal absorption are summarised in the following table:
			
		<@com.emptyLine/>
		<table border="1">
		<title>Studies on dermal absorption</title>			
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
						
				<#list resultStudyListDermal as study>
					<tr>
						<!-- Method -->
						<td>
							<para>Dermal absorption study</para>
							<@nonHumanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.AbsorptionMatrices/>
							</para>

							<para>
								Total recovery: <@com.text study.ResultsAndDiscussion.TotalRecovery/>
							</para>

							<para>
								<#if study.ResultsAndDiscussion.Absorption?has_content>
									Percutaneous absorption rate: <@PercutaneousAbsorptionRateList study.ResultsAndDiscussion.Absorption/>
								</#if>
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
	<#if dataWaivingStudyListDermal?has_content>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaiving dataWaivingStudyListDermal "Dermal Absorption" false/>
	</#if>

	<!-- Testing proposal -->
	<#if testingProposalStudyListDermal?has_content>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposal testingProposalStudyListDermal "Dermal Absorption" false/>
	</#if>

	<#assign studyListDermal = [] />
	<#assign resultStudyListDermal = []/>
	<#assign dataWaivingStudyListDermal = []/>
	<#assign testingProposalStudyListDermal = []/>
		
</#compress>
</#macro>
		
<!-- Human information health surveillance, epidemiological data, direct observation in clinical cases, exposure observations -->
<#macro humanInformationToxicokineticsStudies _subject>
<#compress>

		<#assign studyList1 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
		<#assign studyList2 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
		<#assign studyList3 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
		<#assign studyList4 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />

		<!-- Study results -->
		<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
			No relevant information available.
		<#else/>
			The exposure-related observations in humans are summarised in the following table:
			<@com.emptyLine/>
			<table border="1">
				<title>Exposure-related observations on basic toxicokinetics and/or dermal absorption in humans</title>
				<col width="39%" />
				<col width="41%" />
				<col width="20%" />
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>

					<#list studyList1 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList2 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>

							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList3 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.RsExaminations/>
								</para>

								<para>
								 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
								 </para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList4 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
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

		<#assign studyList1 = [] />
		<#assign studyList2 = [] />
		<#assign studyList3 = [] />
		<#assign studyList4 = [] />
		
</#compress>
</#macro>

<!-- Summary and discussion of toxicokinetics -->
<#macro toxicokineticsSummaryAndDiscussion _subject>
<#compress>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Toxicokinetics") />

	<#if summaryList?has_content>	
	<#assign printSummaryName = summaryList?size gt 1 />

		<#list summaryList as summary>
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>					
				
			<#if printSummaryName>
				<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
			</#if>

			<para><@studyandsummaryCom.summaryKeyInformation summary/></para>
			
			<#if summary.KeyValue.Bioaccumulation?has_content || 
			summary.KeyValue.AbsorptionOral?has_content || 
			summary.KeyValue.AbsorptionDerm?has_content || 
			summary.KeyValue.AbsorptionInhal?has_content>
			
				<@com.emptyLine/>
				<para><emphasis role="bold">Value used for CSA:</emphasis></para>
				
				<#if summary.KeyValue.Bioaccumulation?has_content>
					<para>Bioaccumulation potential: <@com.picklist summary.KeyValue.Bioaccumulation/></para>
				</#if>
				
				<#if summary.KeyValue.AbsorptionOral?has_content>		
					<para>Absorption rate - oral (%): <@com.number summary.KeyValue.AbsorptionOral/></para>
				</#if>
				
				<#if summary.KeyValue.AbsorptionDerm?has_content>
					<para>Absorption rate - dermal (%): <@com.number summary.KeyValue.AbsorptionDerm/></para>
				</#if>
				
				<#if summary.KeyValue.AbsorptionInhal?has_content>
					<para>Absorption rate - inhalation (%): <@com.number summary.KeyValue.AbsorptionInhal/></para>
				</#if>
			
			</#if>
			
			<@studyandsummaryCom.relevantStudies summary/>
			
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>
			
		</#list>
		
		<!-- relevant to CSR only -->
		<#if csrRelevant??>
			<#assign studyList1 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList2 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList3 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList4 = getSortedBasicToxicokineticsOrDermalAbsorption(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
				<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
				See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
				<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>

	</#if>
	
</#compress>
</#macro>

<!-- Acute toxicity oral study table -->
<#macro acuteToxicityOralStudies _subject>
<#compress>
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AcuteToxicityOral") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The results of studies on acute toxicity after oral administration are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on acute toxicity after oral administration</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Acute toxicity after oral administration"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Acute toxicity after oral administration"/>

</#compress>
</#macro>

<!-- Acute toxicity: inhalation study table -->
<#macro acuteToxicityInhalationStudies _subject>
<#compress>		

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AcuteToxicityInhalation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The results of studies on acute toxicity after inhalation exposure are summarised in the following table:
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on acute toxicity after inhalation exposure</title>
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
						<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Acute toxicity after inhalation exposure"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Acute toxicity after inhalation exposure"/>

</#compress>
</#macro>

<!-- Acute toxicity: dermal study table -->
<#macro acuteToxicityDermalStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AcuteToxicityDermal") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The results of studies on acute toxicity after dermal administration are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on acute toxicity after dermal administration</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Acute toxicity after dermal administration"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Acute toxicity after dermal administration"/>

</#compress>
</#macro>

<!-- Acute toxicity: other routes study table -->
<#macro acuteToxicityOtherRoutesStudies _subject> 
<#compress>		
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AcuteToxicityOtherRoutes") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
	<#else/>
		The results of studies on acute toxicity (other routes) are summarised in the following table:
		
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on acute toxicity (other routes)</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Acute toxicity (other routes)"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Acute toxicity (other routes)"/>

</#compress>
</#macro>

<!-- Human information acute toxicity -->
<#macro acuteToxicityHumanInformationStudies _subject> 
<#compress>		

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedAcuteToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedAcuteToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedAcuteToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedAcuteToxicity(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
		No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on acute toxicity in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of acute toxicity -->
<#macro acuteToxicitySummaryStudies _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AcuteToxicity") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
			
	<#list summaryList as summary>
	
		<#if summary.KeyInformation.KeyInformation?has_content>
			<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
		</#if>
		<@com.emptyLine/>
	
		<#if printSummaryName>
			<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
		</#if>

		<para><@studyandsummaryCom.summaryKeyInformation summary/></para>
	   
		<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content || 
		summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content>

		<@com.emptyLine/>
		<para><emphasis role="bold">Value used for CSA:</emphasis></para>
		<para>Acute oral toxicity: 
			<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EndpointConclusion/></para>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content>
				(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelUnit/>) 
			</#if>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content>
				<@com.range summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.EndpointConclusion.EffectLevelValue/>
			</#if>
		</para>

		<para>Acute dermal toxicity: 
			<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EndpointConclusion/></para>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content>
				(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit/>)
			</#if>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content>
				<@com.range summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.EndpointConclusion.EffectLevelValue/>
			</#if>
		</para>

		<para>Acute inhalation toxicity: 
			<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion/></para>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content>
				(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit/>) 
			</#if>
			<#if summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content>
				<@com.range summary.KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue/>
			</#if>
		</para>
		</#if>
		
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		
		<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>

		<@justification summary "JustifClassifAcuteTox"/>

	</#list>	
	
		<!-- relevant to CSR only -->
		<#if csrRelevant??>	
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedAcuteToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedAcuteToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedAcuteToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedAcuteToxicity(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>

	</#if>
	
</#compress>
</#macro>

<!-- Skin irritation non-human information study table -->
<#macro skinIrritationNonHumanStudies _subject>
<#compress>

	<#assign studyListUnsorted = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SkinIrritationCorrosion") />
	<#assign studyList = getSortedSkinIrritationNonHuman(studyListUnsorted, ["skin irritation: in vitro / ex vivo", "skin irritation: in vivo", "skin irritation / corrosion, other"] ) />			
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
		<#else/>
			The results of studies on skin irritation are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on skin irritation</title>
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

					<#--TODO Could be possible improved with incorporating the condition in the previous call, i.e. populateResultAndDataWaivingAndTestingProposalStudyLists. It prints empty tables if none of the studies are Irrotation -->
						<tr>
							<!-- Method -->
							<td>
								<@nonHumanStudyMethod study />
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
								</para>

								<para>
									<@inVitroList study.ResultsAndDiscussion.InVitro.Results/>
								</para>

								<para>
									<@inVivoList study.ResultsAndDiscussion.InVivo.Results/>
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

		<#list resultStudyList as study>
			<para>
				Studies with results indicating corrosivity to the skin are summarised in section 5.4 Corrosivity.
			</para>
			<#break>
		</#list>

	</#if>

	<!-- Data waiving -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyListUnsorted/>
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Skin Irritation"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Skin Irritation"/>

</#compress>
</#macro>		

<!-- Human information Skin irritation -->
<#macro skinIrritationHumanStudies _subject>
<#compress>
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedSkinIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedSkinIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedSkinIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedSkinIrritation(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
		No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on skin irritation in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<para>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</para>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
			</tbody>
		</table>
	</#if>
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>	
	
<!-- Eye irritation non-human information study table -->
<#macro eyeIrritationNonHumanStudies _subject>
<#compress>
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EyeIrritation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
		<#else/>
			The results of studies on eye irritation are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on eye irritation</title>
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
							<#if com.picklistValueMatchesPhrases(study.AdministrativeData.Endpoint, ["eye irritation: in vitro / ex vivo"])>
							<para>in vitro study</para>
							<@nonHumanStudyMethod study/>
							</#if>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
							</para>
							
							<@EyeIrritationInVitroList study.ResultsAndDiscussion.InVitro.ResultsOfExVivoInVitroStudy/>
							
							<@EyeIrritationInVivoList study.ResultsAndDiscussion.InVivo.IrritationCorrosionResults/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Eye Irritation"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Eye Irritation"/>

</#compress>
</#macro>

<!-- Eye irritation Human information -->
<#macro eyeIrritationHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedEyeIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedEyeIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedEyeIrritation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedEyeIrritation(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on eye irritation in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />
	
</#compress>
</#macro>

<!-- Human information Respiratory tract human information -->
<#macro respiratoryTractHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedRespiratoryTract(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedRespiratoryTract(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedRespiratoryTract(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedRespiratoryTract(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
		No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on respiratory irritation in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of irritation -->
<#macro irritationSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "IrritationCorrosion") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
	
		<#list summaryList as summary>
			
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
			
			<#if printSummaryName>
				<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
			</#if>

			<para><@studyandsummaryCom.summaryKeyInformation summary/></para>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.SkinIrritationCorrosion.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EyeRespirationIrritation.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RespiratoryIrritation.EndpointConclusion.EndpointConclusion?has_content>
			<@com.emptyLine/>
			<para><emphasis role="bold">Value used for CSA:</emphasis></para>
			
			Skin irritation / corrosion: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.SkinIrritationCorrosion.EndpointConclusion.EndpointConclusion/>
			Eye irritation: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.EyeRespirationIrritation.EndpointConclusion.EndpointConclusion/>
			Respiratory irritation: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.RespiratoryIrritation.EndpointConclusion.EndpointConclusion/>
			</#if>
			
			<para><@studyandsummaryCom.relevantStudies summary/></para>	
			
			<para><@studyandsummaryCom.summaryAdditionalInformation summary/></para>

			<@justification summary "Remarks"/>

		</#list>
		
		<!-- relevant to CSR only -->
		<#if csrRelevant??>
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedRespiratoryTract(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedRespiratoryTract(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedRespiratoryTract(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedRespiratoryTract(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>
		
	</#if>

</#compress>
</#macro>

<!-- Corrosivity non human information study table -->
<#macro corrosivityNonHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SkinIrritationCorrosion") />
	<#assign studyList = getSortedSkinCorrosionNonHuman(studyList, ["skin corrosion: in vitro / ex vivo", "skin irritation / corrosion.*"] ) />
	
	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
		No relevant information available.
		<#else/>
			The results of studies on skin irritation related to corrosivity are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on skin irritation related to corrosivity</title>
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

					<#--TODO Could be possible improved with incorporating the condition in the previous call, i.e. populateResultAndDataWaivingAndTestingProposalStudyLists. It prints empty tables if none of the studies are Irrotation -->
						<tr>
							<!-- Method -->
							<td>
								<@nonHumanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
								</para>

								<para>
									<@inVitroList study.ResultsAndDiscussion.InVitro.Results/>
								</para>

								<para>
									<@inVivoList study.ResultsAndDiscussion.InVivo.Results/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Skin irritation"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Skin irritation"/>
			
</#compress>
</#macro>

<!-- Human information Corrosivity -->
<#macro corrosivityHumanStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SkinIrritationCorrosion") />
	<#assign studyList1 = getSortedSkinCorrosionNonHuman(studyList, ["skin corrosion: in vitro / ex vivo"]) />		
	
	<#if !(studyList1?has_content)>
		No relevant information available.
		<#else/>			
	
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
		<#assign studyList2 = getSortedSkinCorrosion(studyList) />		
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
		<#assign studyList3 = getSortedSkinCorrosion(studyList) />		
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
		<#assign studyList4 = getSortedSkinCorrosion(studyList) />		
		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
		<#assign studyList5 = getSortedSkinCorrosion(studyList) />			
				
		<!-- Study results -->
		<#if !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) && !(studyList5?has_content)>
		No relevant information available.
			
			<#else/>
			The exposure-related observations in humans are summarised in the following table:

			<@com.emptyLine/>
			<table border="1">
				<title>Exposure-related observations on corrosivity in humans</title>
				<col width="39%" />
				<col width="41%" />
				<col width="20%" />
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>							
					
					<#list studyList2 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList3 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>

							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList4 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.RsExaminations/>
								</para>

								<para>
								 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList5 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
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
	</#if>
		
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />
	<#assign studyList5 = [] />
		
</#compress>
</#macro>

<!-- Summary and discussion of corrosion -->
<#macro corrosivitySummary _subject>
<#compress>

	<!-- relevant to CSR only -->
	<#if csrRelevant??>

		<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SkinIrritationCorrosion") />	

		<#if studyList?has_content>
			<#list studyList as study>
			<@com.text study.name/>
				<para>
					The studies with results indicating corrosivity are discussed in section 5.3.4 Summary and discussion of irritation.
				</para>
				<#break>
			</#list>
		</#if>

		<#else>
			<!-- for non CSR users, the summary for corrosion is part of macro irritationSummary -->
			The studies with results indicating corrosivity are discussed in the Summary and discussion of irritation.
	</#if>
	
</#compress>
</#macro>

<!-- Sensitisation study table -->
<#macro skinSensitisationNonHumanStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SkinSensitisation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	 No relevant information available.
	<@com.emptyLine/>
	<#else/>
		The results of studies on skin sensitisation are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on skin sensitisation</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
							</para>

							<para>
							<#local endpoint><@com.picklist study.AdministrativeData.Endpoint/></#local>
								<#if study.ResultsAndDiscussion.InVivoLLNA.Results?has_content>								
								 <@inVivoLLNAList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.InVivoLLNA.Results) endpoint />
								</#if>
							</para>

							<para>
								<@inVivoNonLLNAList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TraditionalSensitisationTest.ResultsOfTest) endpoint/>
							</para>

							<para>
								<@inVitroLLNAList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.InVitroInChemico.Results) endpoint />
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Skin Sensitisation"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Skin Sensitisation"/>

</#compress>
</#macro>

<!-- Human information Skin sensitisation -->
<#macro skinSensitisationHumanStudies _subject>
<#compress>
      
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SensitisationData") />
	<#assign studyList1 = getSortedSkinSensitisation(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList2 = getSortedSkinSensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList3 = getSortedSkinSensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList4 = getSortedSkinSensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList5 = getSortedSkinSensitisationEndpoint(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) && !(studyList5?has_content)>
	 No relevant information available.
	<@com.emptyLine/>
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on skin sensitisation in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
						<@humanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList5 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />
	<#assign studyList5 = [] />

</#compress>
</#macro>

<!-- Respiratory system non human study table -->
<#macro respiratorySensitisationNonHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "RespiratorySensitisation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies on respiratory sensitisation are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on respiratory sensitisation</title>
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
						<#if com.picklistValueMatchesPhrases(study.AdministrativeData.Endpoint, ["respiratory sensitisation: in vitro", "respiratory sensitisation: in chemico"])>
							<para>in vitro study</para>							
						<@nonHumanStudyMethod study />
						</#if>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.picklist study.ApplicantSummaryAndConclusion.InterpretationOfResults/>
							</para>

							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Respiratory Sensitisation"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Respiratory Sensitisation"/>

</#compress>
</#macro>

<!-- Human information Respiratory sensitisation -->
<#macro respiratorySensitisationHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SensitisationData") />
	<#assign studyList1 = getSortedSkinSensitisationRespiratory(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList2 = getSortedRespiratorySensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList3 = getSortedRespiratorySensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList4 = getSortedRespiratorySensitisationEndpoint(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList5 = getSortedRespiratorySensitisationEndpoint(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) && !(studyList5?has_content)>
	No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on respiratory sensitisation in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
							 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList5 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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
	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />
	<#assign studyList5 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of sensitisation -->
<#macro sensitisationSummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Sensitisation") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
            
		<#list summaryList as summary>
			<#if summary.KeyInformation.KeyInformation?has_content>
			<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
			
			<#if summary?has_content>
				<emphasis role="HEAD-WoutNo">Skin sensitisation</emphasis>
				<para><@studyandsummaryCom.summaryKeyInformation summary/></para>
				<#else/>
				<para>no information available on skin sensitisation</para>
			</#if>

			<#if summary.KeyValueForChemicalSafetyAssessment.SkinSensitisation.EndpointConclusion.EndpointConclusion?has_content>
				<@com.emptyLine/>
				<emphasis role="bold">Value used for CSA:</emphasis> <@com.picklist summary.KeyValueForChemicalSafetyAssessment.SkinSensitisation.EndpointConclusion.EndpointConclusion/>
			</#if>
			
			<para><@studyandsummaryCom.relevantStudies summary/></para>	
			
			<#if summary.KeyValueForChemicalSafetyAssessment.SkinSensitisation.EndpointConclusion.AdditionalInformation?has_content>
				<para>Additional information: <@com.richText summary.KeyValueForChemicalSafetyAssessment.SkinSensitisation.EndpointConclusion.AdditionalInformation/></para>
			</#if>
		</#list>
	
		<!-- relevant to CSR only -->
		<#if csrRelevant??>        
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SensitisationData") />
			<#assign studyList1 = getSortedSkinSensitisationRespiratory(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList2 = getSortedRespiratorySensitisationEndpoint(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList3 = getSortedRespiratorySensitisationEndpoint(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList4 = getSortedRespiratorySensitisationEndpoint(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList5 = getSortedRespiratorySensitisationEndpoint(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) && !(studyList5?has_content)>
				<#else/>
				<@com.emptyLine/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>
	

		<#if summaryList?has_content>
			<#assign printSummaryName = summaryList?size gt 1 />
			
			<#list summaryList as summary>
				<#if summary.KeyInformation.KeyInformation?has_content>
					<@com.emptyLine/>
					<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
				</#if>
				<@com.emptyLine/>
				
				<#if summary?has_content>
					<emphasis role="HEAD-WoutNo">Respiratory sensitisation</emphasis>
					<#else/>
					<para>no information available on respiratory sensitisation</para>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RespiratorySensitisation.EndpointConclusion.EndpointConclusion?has_content>
					<@com.emptyLine/>
					<emphasis role="bold">Value used for CSA:</emphasis> <@com.picklist summary.KeyValueForChemicalSafetyAssessment.RespiratorySensitisation.EndpointConclusion.EndpointConclusion/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RespiratorySensitisation.EndpointConclusion.AdditionalInformation?has_content>
					<para>Additional information: <@com.richText summary.KeyValueForChemicalSafetyAssessment.RespiratorySensitisation.EndpointConclusion.AdditionalInformation/></para>
				</#if>
				<@justification summary "Remarks"/>
			</#list>
		</#if>

		<!-- relevant to CSR only -->
		<#if csrRelevant??>		
			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) && !(studyList5?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>		
		</#if>
		
	</#if>

</#compress>
</#macro>

<!-- Repeated dose toxicity study table -->
<#macro repeatedDoseToxicityOralStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "RepeatedDoseToxicityOral") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on repeated dose toxicity after oral administration</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
							</para>

							<para>
								<@TargetSystemOrganToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity)/>
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
	<#list dataWaivingStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: oral", "sub-chronic toxicity: oral"], ["short-term toxicity study (28 days) (oral)", "sub-chronic toxicity study (90 days) (oral)"], "Repeated dose toxicity after oral administration" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaivingRecord study endpoint/>
	</#list>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: oral", "sub-chronic toxicity: oral", "chronic toxicity: oral"], ["short-term toxicity study (28 days) (oral)", "sub-chronic toxicity study (90 days) (oral)", "chronic toxicity study (oral)"], "Repeated dose toxicity after oral administration" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

</#compress>
</#macro>

<!-- Repeated dose toxicity inhalation study table -->
<#macro repeatedDoseToxicityInhalationStudies _subject>
<#compress>			
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "RepeatedDoseToxicityInhalation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<@com.emptyLine/>
	<#else/>
		The results of studies are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on repeated dose toxicity after inhalation exposure</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
							</para>

							<para>
								<@TargetSystemOrganToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity)/>
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
	<#list dataWaivingStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: inhalation", "sub-chronic toxicity: inhalation"], ["short-term toxicity study (28 days) (inhalation)", "sub-chronic toxicity study (90 days) (inhalation)"], "Repeated dose toxicity after inhalation exposure" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaivingRecord study endpoint/>
	</#list>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: inhalation", "sub-chronic toxicity: inhalation", "chronic toxicity: inhalation"], ["short-term toxicity study (28 days) (inhalation)", "sub-chronic toxicity study (90 days) (inhalation)", "chronic toxicity study (inhalation)"], "Repeated dose toxicity after inhalation exposure" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

</#compress>
</#macro>

<!-- Repeated dose toxicity dermal study table -->
<#macro repeatedDoseToxicityDermalStudies _subject>
<#compress>		
						
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "RepeatedDoseToxicityDermal") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.

	<#else/>
		The results of studies are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on repeated dose toxicity after dermal administration</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
							</para>

							<para>
								<@TargetSystemOrganToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity)/>
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
	<#list dataWaivingStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: dermal", "sub-chronic toxicity: dermal"], ["short-term toxicity study (28 days) (dermal)", "sub-chronic toxicity study (90 days) (dermal)"], "Repeated dose toxicity after dermal administration" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaivingRecord study endpoint/>
	</#list>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextRepeatedDose(study.AdministrativeData.Endpoint, ["short-term repeated dose toxicity: dermal", "sub-chronic toxicity: dermal", "chronic toxicity: dermal"], ["short-term toxicity study (28 days) (dermal)", "sub-chronic toxicity study (90 days) (dermal)", "chronic toxicity study (dermal)"], "Repeated dose toxicity after dermal administration" )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

</#compress>
</#macro>

<!-- Repeated dose toxicity: other routes study table -->
<#macro repeatedDoseToxicityOtherRoutesStudies _subject>
<#compress>			

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "RepeatedDoseToxicityOther") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<@com.emptyLine/>
	<#else/>
		The results of studies on repeated dose toxicity (other routes) are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on repeated dose toxicity (other routes)</title>
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
							<@nonHumanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
							</para>

							<para>
								<@TargetSystemOrganToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Repeated Dose Toxicity"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Repeated Dose Toxicity"/>

</#compress>
</#macro>

<!-- Human information Repeated dose toxicity -->
<#macro repeatedDoseToxicityHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedRepeatedDoseToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedRepeatedDoseToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedRepeatedDoseToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedRepeatedDoseToxicity(studyList) />

		<!-- Study results -->
		<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content) >
		No relevant information available.
		<#else/>
			The exposure-related observations in humans are summarised in the following table:

			<@com.emptyLine/>
			<table border="1">
				<title>Exposure-related observations on skin sensitisation in humans</title>
				<col width="39%" />
				<col width="41%" />
				<col width="20%" />
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>

					<#list studyList1 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList2 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList3 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>

							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.RsExaminations/>
								</para>

								<para>
								 Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList4 as study>
						<tr>
							<!-- Method -->
							<td>
								<@humanStudyMethod study/>
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
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
		
		<#assign studyList1 = [] />
		<#assign studyList2 = [] />
		<#assign studyList3 = [] />
		<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of repeated dose toxicity -->
<#macro repeatedDoseToxicitySummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "RepeatedDoseToxicity") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />	

		<#list summaryList as summary>
		
		<#if summary.KeyInformation.KeyInformation?has_content>
		<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
		</#if>
		<@com.emptyLine/>
		
			<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.TestType?has_content || summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Species?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Organ?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Species?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Organ?has_content>
							
				<@studyandsummaryCom.summaryKeyInformation summary/>
			
				<#if summary.KeyValueForChemicalSafetyAssessment.ToxicEffectType?has_content>
				<@com.emptyLine/>
				Toxic effect type (for all routes and effects): <@com.picklist summary.KeyValueForChemicalSafetyAssessment.ToxicEffectType/>
				</#if>
			
				<#assign valueForCsaTextOralSystemic>
				<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EndpointConclusion/></para>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelUnit/>:
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.EffectLevelValue/>;
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.TestType?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.TestType/>,
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek?has_content>	
					<@com.text summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek/> hours/week;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Species?has_content>	
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Species/>)
				</#if>
			   <?linebreak?>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Organ?has_content>
					Target organs: <@com.picklistMultiple summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.EndpointConclusion.Organ/>
				</#if>
				</#assign>
			</#if>
							
			<@endpointSummary summary valueForCsaTextOralSystemic "valueForCsaTextOralSystemic" printSummaryName/>

			<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.TestType?has_content || summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Species?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Organ?has_content>
			
			<#assign valueForCsaTextInhalationSystemic>
				<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EndpointConclusion/></para>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelUnit/>:
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.EffectLevelValue/>;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.TestType?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.TestType/>,
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek?has_content>	
					<@com.text summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek/> hours/week;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Species?has_content>	
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Species/>)
				</#if>
				<?linebreak?>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Organ?has_content>
				Target organs: <@com.picklistMultiple summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.EndpointConclusion.Organ/>
				</#if>
			</#assign>
			</#if>
			
			<@endpointSummary summary valueForCsaTextInhalationSystemic "valueForCsaTextInhalationSystemic" printSummaryName/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.TestType?has_content || summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.Species?has_content>
			
			<#assign valueForCsaTextInhalationLocal>                    
				<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EndpointConclusion/></para>					
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelUnit/>:
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.EffectLevelValue/>;
					
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.TestType?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.TestType/>;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.EndpointConclusion.Species/>)
					
				</#if>
			</#assign>
			</#if>
			
			<@endpointSummary summary valueForCsaTextInhalationLocal "valueForCsaTextInhalationLocal" printSummaryName/>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.TestType?has_content || summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.Species?has_content>
			
			<#assign valueForCsaTextDermalSystemic>
			   <para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EndpointConclusion/></para>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelUnit/>:
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.EffectLevelValue/>;
					
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.TestType?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.TestType/>,
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek?has_content>	
					<@com.text summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.ExperimentalExposureTimePerWeek/> hours/week;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.EndpointConclusion.Species/>)
					
				</#if>
			</#assign>
			</#if>
			
			<@endpointSummary summary valueForCsaTextDermalSystemic "valueForCsaTextDermalSystemic" printSummaryName/>				
			
			<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.TestType?has_content || summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.Species?has_content>
			
			<#assign valueForCsaTextDermalLocal>
				<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EndpointConclusion/></para>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelUnit/>:
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.EffectLevelValue/>;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.TestType?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.TestType/>;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.EndpointConclusion.Species/>)
					
				</#if>
			</#assign>
			
			</#if>
			
			<@endpointSummary summary valueForCsaTextDermalLocal "valueForCsaTextDermalLocal" printSummaryName/>
			
			<para>
				<@justification summary "Remarks"/>					
			</para>			
				
				<!-- relevant to CSR only -->
				<#if csrRelevant??>
				<@studyandsummaryCom.modeOfActionRepeatedDoseToxicity summary />	
				</#if>
		</#list>		
		
		<!-- relevant to CSR only -->
		<#if csrRelevant??>
		
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedRepeatedDoseToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedRepeatedDoseToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedRepeatedDoseToxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedRepeatedDoseToxicity(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		
		</#if>

	</#if>

</#compress>
</#macro>	
	
<!-- Mutagenicity non human information in vitro study table -->
<#macro mutagenicityNonHumanInVitroStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "GeneticToxicityVitro") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of in vitro genotoxicity studies are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>In vitro genotoxicity studies:</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@TestResultsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestRs)/>
								<#assign remarksOnResults = study.ResultsAndDiscussion.RemarksOnResults>
									<#if remarksOnResults?has_content>
									Remarks: <@com.picklist study.ResultsAndDiscussion.RemarksOnResults/>
									</#if>
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
	<#list dataWaivingStudyList as study>
		<#assign endpoint = determineEndpointTextTypeOfAssay(study, "In vitro genotoxicity: " )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaivingRecord study endpoint/>
	</#list>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextTypeOfAssay(study, "In vitro genotoxicity: " )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

</#compress>
</#macro>

<!-- Mutagenicity non human information in vivo study table -->
<#macro mutagenicityNonHumanInVivoStudies _subject>
<#compress>		

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "GeneticToxicityVivo") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of in vivo genotoxicity studies are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>In vivo genotoxicity studies</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@TestResultsInVivoList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestRs)/>
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
	<#list dataWaivingStudyList as study>
		<#assign endpoint = determineEndpointTextStudyType(study, "In vivo genotoxicity: " )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		<@studyandsummaryCom.dataWaivingRecord study endpoint/>
	</#list>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextStudyType(study, "In vivo genotoxicity: " )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

</#compress>
</#macro>

<!-- Human information Mutagenicity -->
<#macro mutagenicityHumanStudies _subject>
<#compress>	

<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
<#assign studyList1 = getSortedGeneticToxicity(studyList) />
<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
<#assign studyList2 = getSortedGeneticToxicity(studyList) />
<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
<#assign studyList3 = getSortedGeneticToxicity(studyList) />
<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
<#assign studyList4 = getSortedGeneticToxicity(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations genetic toxicity in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study/>
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of mutagenicity -->
<#macro mutagenicitySummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "GeneticToxicity") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
	
		<#list summaryList as summary>
			<#if printSummaryName>
				<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
			</#if>
			
			<!-- in vitro -->
			
			<#if summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVitro.DescriptionOfKeyInformation.KeyInfo?has_content>
			<para><emphasis role="underline">The following information is taken into account for any hazard / risk assessment (genetic toxicity in vitro):</emphasis></para>
				<para><@com.richText summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVitro.DescriptionOfKeyInformation.KeyInfo/></para>
			</#if>
			
			<para>
				<#if summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVitro.EndpointConclusion.EndpointConclusion?has_content>
				<@com.emptyLine/>
				<emphasis role="bold">Value used for CSA (genetic toxicity in vitro):</emphasis> Genetic toxicity: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVitro.EndpointConclusion.EndpointConclusion/>
				</#if>
			</para>
		
			<!-- in vivo -->				
			
			<#if summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVivo.DescriptionOfKeyInformation.KeyInfo?has_content>
			<para><emphasis role="underline">The following information is taken into account for any hazard / risk assessment (genetic toxicity in vivo):</emphasis></para>
				<para><@com.richText summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVivo.DescriptionOfKeyInformation.KeyInfo/></para>
			</#if>
			
			<para>
				<#if summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVivo.EndpointConclusion.EndpointConclusion?has_content>
				<@com.emptyLine/>
				<emphasis role="bold">Value used for CSA (genetic toxicity in vivo):</emphasis> Genetic toxicity: <@com.picklist summary.KeyValueForChemicalSafetyAssessment.GeneticToxicityInVivo.EndpointConclusion.EndpointConclusion/>
				</#if>
			</para>
		
			<#if summary.JustificationForClassificationOrNonClassification.Remarks?has_content>
			<@com.emptyLine/>
				<para><emphasis role="bold"><emphasis role="underline">Justification for classification or non classification</emphasis></emphasis></para>
				<para><@com.richText summary.JustificationForClassificationOrNonClassification.Remarks/></para>
			</#if>
			
			<para><@studyandsummaryCom.relevantStudies summary/></para>	
			
			<#if summary.Discussion.Discussion?has_content>
				<para>
					<emphasis role="underline">Additional information:</emphasis>
					<@com.richText summary.Discussion.Discussion/>
				</para>
			</#if>
			
				<!-- relevant to CSR only -->
				<#if csrRelevant??>
				<@studyandsummaryCom.modeOfActionOtherGenetic summary />
				</#if>
		
		</#list>
			
			<!-- relevant to CSR only -->
			<#if csrRelevant??>						
				<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
				<#assign studyList1 = getSortedGeneticToxicity(studyList) />
				<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
				<#assign studyList2 = getSortedGeneticToxicity(studyList) />
				<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
				<#assign studyList3 = getSortedGeneticToxicity(studyList) />
				<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
				<#assign studyList4 = getSortedGeneticToxicity(studyList) />

				<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
					<#else/>
						<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
						See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
						<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
				</#if>				
			</#if>
		
	</#if>

</#compress>
</#macro>

<!-- Carcinogenicity non human oral study table -->
<#macro carcinogenicityNonHumanOralStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Carcinogenicity") />
	<#assign studyList1 = getSortedCarcinogenicityOral(studyList) />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList1/>
		
	<!-- Study results -->
	<#if !(resultStudyList?has_content)>
	No relevant information available.
	<#else/>
		The results of studies on carcinogenicity after oral administration are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on carcinogenicity after oral administration</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Carcinogenicity after oral administration" true/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Carcinogenicity after oral administration" true/>
	
	<#assign studyList = [] />
	<#assign studyList1 = [] />
	
</#compress>
</#macro>

<!-- Carcinogenicity non human inhalation study table -->
<#macro carcinogenicityNonHumanInhalationStudies _subject>
<#compress>			

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Carcinogenicity") />
	<#assign studyList = getSortedCarcinogenicityInhalation(studyList) />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !(resultStudyList?has_content)>
	No relevant information available.
	<#else/>
		The results of studies on carcinogenicity after inhalation exposure are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on carcinogenicity after inhalation exposure</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Carcinogenicity after inhalation exposure"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Carcinogenicity after inhalation exposure"/>

	<#assign studyList = [] />

</#compress>
</#macro>

<!-- Carcinogenicity non human dermal study table -->
<#macro carcinogenicityNonHumanDermalStudies _subject>
<#compress>
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Carcinogenicity") />
	<#assign studyList = getSortedCarcinogenicityDermal(studyList) />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !(resultStudyList?has_content)>
	No relevant information available.
	<#else/>
		The results of studies on carcinogenicity after dermal administration are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on carcinogenicity after dermal administration</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Carcinogenicity after dermal administration"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Carcinogenicity after dermal administration"/>

	<#assign studyList = [] />

</#compress>
</#macro>

<!-- Carcinogenicity non human other routes study table -->
<#macro carcinogenicityNonHumanOtherRoutesStudies _subject>
<#compress>

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Carcinogenicity") />
	<#assign studyList = getSortedCarcinogenicityOther(studyList) />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !(resultStudyList?has_content)>
	No relevant information available.
	<#else/>
		The results of studies on carcinogenicity (other routes) are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on carcinogenicity (other routes)</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Carcinogenicity (other routes)"/>

	<!-- Testing proposal -->
	<#list testingProposalStudyList as study>
		<#assign endpoint = determineEndpointTextRouteOfAdministration(study, "Carcinogenicity " )/>
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		<@studyandsummaryCom.testingProposalRecord study endpoint/>
	</#list>

	<#assign studyList = [] />

</#compress>
</#macro>

<!-- Human information Carcinogenicity -->
<#macro carcinogenicityHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedCarcinogenicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedCarcinogenicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedCarcinogenicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedCarcinogenicity(studyList) />

		<!-- Study results -->
		<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
		No relevant information available.
		<#else/>
			The exposure-related observations in humans are summarised in the following table:

			<@com.emptyLine/>
			<table border="1">
				<title>Exposure-related observations on carcinogenicity in humans</title>
				<col width="39%" />
				<col width="41%" />
				<col width="20%" />
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>

					<#list studyList1 as study>
						<tr>
							<!-- Method -->
							<td>
								
								<@humanStudyMethod study />
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList2 as study>
						<tr>
							<!-- Method -->
							<td>
								
								<@humanStudyMethod study />
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList3 as study>
						<tr>
							<!-- Method -->
							<td>
								
								<@humanStudyMethod study />
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.RsExaminations/>
								</para>

								<para>
									Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
								</para>
							</td>
							<!-- Remarks -->
							<td>
								<@studyandsummaryCom.studyRemarksColumn study/>
							</td>
						</tr>
						<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
					</#list>
					<#list studyList4 as study>
						<tr>
							<!-- Method -->
							<td>
								
								<@humanStudyMethod study />
							</td>
							<!-- Results -->
							<td>
								<para>
									<@com.text study.ResultsAndDiscussion.Results/>
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

		<#assign studyList1 = [] />
		<#assign studyList2 = [] />
		<#assign studyList3 = [] />
		<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of carcinogenicity -->
<#macro carcinogenicitySummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Carcinogenicity") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />
	
		<#list summaryList as summary>
		<#if summary?has_content>
		
			<#if summary.KeyInformation.KeyInformation?has_content>
			<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
		
			<para>
				<@com.richText summary.KeyInformation.KeyInformation/>
			</para>			
			
				<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content ||					
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.TestType?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Species?has_content ||
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Organ?has_content>
				
				<#assign valueForCsaTextOralCacrinogenicity>
					<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EndpointConclusion/></para>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
						
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.EffectLevelValue/>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.TestType/>);
					</#if>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Species?has_content>
						 (<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Species/>)							
					</#if>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Organ?has_content> 
					Target organs: <@com.picklistMultiple summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.EndpointConclusion.Organ/>
					</#if>
					
				</#assign>
				</#if>		
				<@endpointSummary summary valueForCsaTextOralCacrinogenicity "valueForCsaTextOralCacrinogenicity" printSummaryName/>
								
				<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content ||					
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.TestType?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Species?has_content ||
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Organ?has_content>
				
				<#assign valueForCsaTextDermalCarcinogenicity>
					 <para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EndpointConclusion/></para>
					 
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelUnit/>)
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Species/>)					
					</#if>					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Organ?has_content>
					Target organs: <@com.picklistMultiple summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.EndpointConclusion.Organ/>
					</#if>
				</#assign>
				</#if>		
				<@endpointSummary summary valueForCsaTextDermalCarcinogenicity "valueForCsaTextDermalCarcinogenicity" false/>
	
				<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content ||					
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.TestType?has_content || 
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Species?has_content ||
				summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Organ?has_content>
				
				<#assign valueForCsaTextInhalationCarcinogenicity>
					<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EndpointConclusion/></para>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
					
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.EffectLevelValue/>
					
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Species/>)							
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Organ?has_content>
					Target organs: <@com.picklistMultiple summary.KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.EndpointConclusion.Organ/>
					</#if>
				</#assign>
				</#if>					
				<@endpointSummary summary valueForCsaTextInhalationCarcinogenicity "valueForCsaTextInhalationCarcinogenicity" false/>

			<@justification summary "JustifClassifCarc"/>
				
			<!-- relevant to CSR only -->
			<#if csrRelevant??>
			<@studyandsummaryCom.modeOfActionOtherCarcinogenicity summary />
			</#if>
			
		</#if>	
		</#list>
		
		<!-- relevant to CSR only -->
		<#if csrRelevant??>        
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedCarcinogenicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedCarcinogenicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedCarcinogenicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedCarcinogenicity(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>			
		</#if>

	</#if>

</#compress>
</#macro>

<!-- Toxicity for reproduction non human, studies on fertility -->
<#macro toxicityForReproductionFertilityNonHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityReproduction") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies on fertility are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on fertility</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<#if study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.EffectLevelsP0.Efflevel?has_content || study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.TargetSystemOrganToxicityP0.TargetSystemOrganToxicity?has_content>
							<para>
							<emphasis role="bold">First parental generation (P0)</emphasis>
							</para>
								<#if study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.EffectLevelsP0.Efflevel?has_content>
								<para>
								<@EffectLevelsPoList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.EffectLevelsP0.Efflevel)/>
								</para>
								</#if>
								<#if study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.TargetSystemOrganToxicityP0.TargetSystemOrganToxicity?has_content>
								<para>
								<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration.TargetSystemOrganToxicityP0.TargetSystemOrganToxicity)/>
								</para>
								</#if>
							</#if>
							

							<#if study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.EffectLevelsP1.Efflevel?has_content || study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.TargetSystemOrganToxicityP1.TargetSystemOrganToxicity?has_content>
							<para>
							<emphasis role="bold">Second parental generation (P1)</emphasis>
							</para>
								<#if study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.EffectLevelsP1.Efflevel?has_content>
								<para>
								<@SecondparentalGenerationP1List studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.EffectLevelsP1.Efflevel)/>
								</para>
								</#if>
								<#if study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.TargetSystemOrganToxicityP1.TargetSystemOrganToxicity?has_content>
								<para>
								<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration.TargetSystemOrganToxicityP1.TargetSystemOrganToxicity)/>
								</para>
								</#if>
							</#if>				


							<#if study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.EffectLevelsF1.Efflevel?has_content || study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.TargetSystemOrganToxicityF1.TargetSystemOrganToxicity?has_content>
							<para>
							<emphasis role="bold">F1 generation</emphasis>
							</para>
								<#if study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.EffectLevelsF1.Efflevel?has_content>
								<para>
								<@FgenerationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.EffectLevelsF1.Efflevel)/>
								</para>
								</#if>
								<#if study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.TargetSystemOrganToxicityF1.TargetSystemOrganToxicity?has_content>
								<para>
								<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsOfExaminationsOffspring.TargetSystemOrganToxicityF1.TargetSystemOrganToxicity)/>
								</para>
								</#if>
							</#if>	

							<#if study.ResultsAndDiscussion.ResultsF2Generation.EffectLevelsF2.Efflevel?has_content>
								<para>
								<emphasis role="bold">F2 generation</emphasis>
								</para>
								<para>
								<@FgenerationList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsF2Generation.EffectLevelsF2.Efflevel)/>
								</para>
							</#if>	
							
							<#if study.ResultsAndDiscussion.ReproductiveToxicity.ReproductiveToxicity?has_content>
								<para>
								<emphasis role="bold">Overall reproductive toxicity</emphasis>
								</para>
								<para>
								<@OverallReproductiveToxicityList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ReproductiveToxicity.ReproductiveToxicity)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Toxicity for reproduction / fertility"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Toxicity for reproduction "/>
			
</#compress>
</#macro>

<!-- Toxicity to reproduction other studies study table -->	
<#macro toxicityForReproductionOtherStudiesNonHumanStudies _subject>
<#compress>	
			
<#assign resultstudyListOther = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ToxicityReproductionOther") />
	<#if !(resultstudyListOther?has_content)>
	No relevant information available.
	<#else/>
		The results of studies on the toxicity to reproduction (other studies) are summarised in the following table:
		
		<!-- Study results -->
		<@com.emptyLine/>
		<table border="1">
			<title>Studies on the toxicity to reproduction (other studies)</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list resultstudyListOther as study>
					<tr>
						<!-- Method -->
						<td>
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					
				</#list>
			</tbody>
		</table>
	</#if>

</#compress>
</#macro>

<!-- Human information Toxicity to reproduction -->	
<#macro toxicityForReproductionHumanStudies _subject>
<#compress>	
			
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedToxicityToReproInHumans(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedToxicityToReproInHumans(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedToxicityToReproInHumans(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedToxicityToReproInHumans(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on toxicity to reproduction / fertility in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
								<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
								<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
								<@humanStudyMethod study />

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
								<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Developmental toxicity non human study table -->
<#macro developmentalToxicityNonHumanStudies _subject>
<#compress>		
	
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DevelopmentalToxicityTeratogenicity") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies on developmental toxicity are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on developmental toxicity</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
							<emphasis role="bold">Maternal animals:</emphasis>
							</para>

							<para>
							<@MatAbnormalitiesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsMaternalAnimals.MaternalAbnormalities.MaternalAbnormalities)/>
							</para>

							<para>
							<@EffectLevelsMatAbnormalitiesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsMaternalAnimals.EffectLevelsMaternalAnimals.Efflevel)/>
							</para>

							<para>
							<emphasis role="bold">Fetuses:</emphasis>
							</para>

							<para>
							<@FetalAbnormalitiesList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ResultsFetuses.FetalAbnormalities.FetalAbnormalities)/>
							</para>

							<para>
							<@EffectLevelsFetusesList study.ResultsAndDiscussion.ResultsFetuses.EffectLevelsFetuses.Efflevel/>
							</para>

							<para>
							<emphasis role="bold">Overall developmental toxicity:</emphasis>
							</para>

							<para>
							<@OverallDevToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DevelopmentalToxicity.DevelopmentalToxicity)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Developmental Toxicity / teratogenicity"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Developmental Toxicity / teratogenicity"/>

</#compress>
</#macro>

<!-- Human information Developmental toxicity -->
<#macro developmentalToxicityHumanStudies _subject>
<#compress>			

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedDevelopmentToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedDevelopmentToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedDevelopmentToxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedDevelopmentToxicity(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	No relevant information available.
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on the developmental toxicity in humans</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
						<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of reproductive and developmental toxicity -->
<#macro developmentalAndReproductiveToxicitySummary _subject>
<#compress>	

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToReproduction") />

	<#if summaryList?has_content>	
	<#assign printSummaryName = summaryList?size gt 1 />
	
	<#list summaryList as summary>

		<#if summary.KeyValueForChemicalSafetyAssessment.ToxicEffectType?has_content>
		<@com.emptyLine/>
		Toxic effect type (for all routes and effects - fertility / developmental toxicity): <@com.picklist summary.KeyValueForChemicalSafetyAssessment.ToxicEffectType/>
		<@com.emptyLine/>
		</#if>	

		<para><emphasis role="bold">Effects on fertility</emphasis></para>
						
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.DescriptionOfKeyInformation.KeyInfo?has_content>
				<para><@com.emptyLine/>
				<emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis>
				</para>
								
				<para><@com.emptyLine/>
				<@com.richText summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.DescriptionOfKeyInformation.KeyInfo/>
				</para>
			</#if>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.TestType?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.Species?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.ExperimentalExposureTimePerWeek?has_content>
			
				<#assign valueForCsaTextOralFertilityEffects>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EndpointConclusion/>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EffectLevelUnit/>): 
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.TestType/>,
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.ExperimentalExposureTimePerWeek?has_content>	
						<@com.text summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.ExperimentalExposureTimePerWeek/> hours/week
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.Species?has_content>						
						<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaOralRoute.Species/>)					
					</#if>
				</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextOralFertilityEffects "valueForCsaTextOralFertilityEffects" printSummaryName/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.TestType?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.Species?has_content>
			<#assign valueForCsaTextDermalEffectsOnFertility>
				<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EndpointConclusion/>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EffectLevelUnit/>): 
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.EffectLevelValue/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.TestType?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.TestType/>,
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.ExperimentalExposureTimePerWeek?has_content>	
					<@com.text summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.ExperimentalExposureTimePerWeek/> hours/week;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.Species?has_content>						
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaDermalRoute.Species/>)
					
				</#if>
			</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextDermalEffectsOnFertility "valueForCsaTextDermalEffectsOnFertility" false/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelValue?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.TestType?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.Species?has_content>
			<#assign valueForCsaTextInhalationEffectsOnFertility>
				<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EndpointConclusion/>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelUnit/>):
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.EffectLevelValue/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.TestType?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.TestType/>,
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.ExperimentalExposureTimePerWeek?has_content>	
					<@com.text summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.ExperimentalExposureTimePerWeek/> hours/week;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.EffectOnFertilityViaInhalationRoute.Species/>)
					
				</#if>
			</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextInhalationEffectsOnFertility "valueForCsaTextInhalationEffectsOnFertility" false/>
		</#list>

			<#if csrRelevant??>
			   <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
                <#assign studyList1 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
                <#assign studyList2 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
                <#assign studyList3 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
                <#assign studyList4 = getSortedDevelopmentToxicity(studyList) />

                <#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
                    <#else/>
                        <para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
                        See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
                        <!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
                </#if>
				<@com.emptyLine/>
			</#if>
                
		<para><emphasis role="bold">Developmental toxicity</emphasis></para>
                
		<#list summaryList as summary>
		
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.DescriptionOfKeyInformation.KeyInfo?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
			
			<para>
			<@com.richText summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.DescriptionOfKeyInformation.KeyInfo/>
			</para>

			<emphasis role="underline">Effect on developmental toxicity - development (via oral route)</emphasis>	
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelValue?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.TestType?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.Species?has_content>
			
				<#assign valueForCsaTextOralDevelopmentalToxicity>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EndpointConclusion?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EndpointConclusion/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelUnit/>): 
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.EffectLevelValue/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.TestType?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.TestType/>;
				</#if>	
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaOralRoute.Species/>)						
				</#if>
				</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextOralDevelopmentalToxicity "valueForCsaTextOralDevelopmentalToxicity" false/>
			
			<emphasis role="underline">Effect on developmental toxicity - development (via dermal route)</emphasis>
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelValue?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelUnit?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.Species?has_content>
			<#assign valueForCsaTextDermalDevelopmentToxicity>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EndpointConclusion?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EndpointConclusion/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelUnit/>):
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.EffectLevelValue/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.Species?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaDermalRoute.Species/>)
				</#if>
			</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextDermalDevelopmentToxicity "valueForCsaTextDermalDevelopmentToxicity" false/>
			
			<emphasis role="underline">Effect on developmental toxicity - development (via inhalation route)</emphasis>
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EffectLevelValue?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.TestType?has_content ||
			summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.Species?has_content>
			<#assign valueForCsaTextInhalationDevelopmentalToxicity>
				<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EndpointConclusion/></para>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EffectLevelUnit?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EffectLevelUnit/>): 
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EffectLevelValue?has_content>
					<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.EffectLevelValue/>
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.TestType?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.TestType/>;
				</#if>
				<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.Species?has_content>
					<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.EffectOnDevelopmentalToxicityViaInhalationRoute.Species/>)
					
				</#if>
			</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextInhalationDevelopmentalToxicity "valueForCsaTextInhalationDevelopmentalToxicity" false/>

			<@justification summary "JustificationForClassificationOrNonClassification"/>
			
				<!-- relevant to CSR only -->
				<#if csrRelevant??>
				<@studyandsummaryCom.modeOfActionOtherReproductiveTox summary />	
				</#if>
			
		</#list>		
				
			<#if csrRelevant??>
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
                <#assign studyList1 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
                <#assign studyList2 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
                <#assign studyList3 = getSortedDevelopmentToxicity(studyList) />
                <#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
                <#assign studyList4 = getSortedDevelopmentToxicity(studyList) />

                <#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
                    <#else/>
				        <para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
                        See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
                        <!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
                </#if>
			</#if>
			
			
		<#assign summaryList1 = [] />

	</#if>
	
</#compress>
</#macro>

<!-- Neurotoxicity other effects study table -->
<#macro neurotoxicityOtherEffectsStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Neurotoxicity") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies on neurotoxicity are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on neurotoxicity</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
							<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Neurotoxicity"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Neurotoxicity"/>

</#compress>
</#macro>

<!-- Immunotoxicity other effects study table -->
<#macro immunotoxicityOtherEffectsStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "Immunotoxicity") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of studies on immunotoxicity are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Studies on immunotoxicity</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
							<@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Immunotoxicity"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Immunotoxicity"/>

</#compress>
</#macro>

<!-- Specific investigations: other studies study table -->
<#macro specificInvestigationsOtherStudies _subject>
<#compress>	
		
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "SpecificInvestigations") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of specific investigations (other studies) are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Specific investigations: other studies</title>
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
							<@nonHumanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
							<@com.text study.ResultsAndDiscussion.ResultsDetails/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Specific investigations: other studies"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Specific investigations: other studies"/>

</#compress>
</#macro>
	
<!-- Additional toxicological effects study table -->
<#macro additionalToxicologicalInformation _subject>
<#compress>			

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "AdditionalToxicologicalInformation") />

	<#-- Populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->
	<@populateResultAndDataWaivingAndTestingProposalStudyLists studyList/>

	<!-- Study results -->
	<#if !resultStudyList?has_content>
	No relevant information available.
	<#else/>
		The results of specific investigations (other studies) are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Specific investigations: other studies</title>
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
						<!-- Method TO TRANSFER TO MACRO -->
						<td>
						<@nonHumanStudyMethod study />
							
						</td>
						
						<!-- Results -->
						<td>
							<para>
								Applicant’s summary and conclusion: <@com.text study.ApplicantSummaryAndConclusion.Conclusions/>
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
	<@studyandsummaryCom.dataWaiving dataWaivingStudyList "Specific investigations: other studies"/>

	<!-- Testing proposal -->
	<@studyandsummaryCom.testingProposal testingProposalStudyList "Specific investigations: other studies"/>

</#compress>
</#macro>
	
<!-- Human information Other effects -->
<#macro otherEffectsHumanStudies _subject>
<#compress>	

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedNeurotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedNeurotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedNeurotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedNeurotoxicity(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	No relevant information available.
	<@com.emptyLine/>
	<#else/>
		The exposure-related observations in humans are summarised in the following table:

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on neurotoxicity</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
						<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedImmunotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedImmunotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedImmunotoxicity(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedImmunotoxicity(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
		<#else/>

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations on immunotoxicity</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
	<#assign studyList1 = getSortedEndpointNotSpecified(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
	<#assign studyList2 = getSortedEndpointNotSpecified(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
	<#assign studyList3 = getSortedEndpointNotSpecified(studyList) />
	<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
	<#assign studyList4 = getSortedEndpointNotSpecified(studyList) />

	<!-- Study results -->
	<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
	<#else/>

		<@com.emptyLine/>
		<table border="1">
			<title>Exposure-related observations: endpoint not specified</title>
			<col width="39%" />
			<col width="41%" />
			<col width="20%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Method</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>

				<#list studyList1 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList2 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList3 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />

						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.RsExaminations/>
							</para>

							<para>
								Outcome of incidence: <@com.text study.ResultsAndDiscussion.Outcome/>
							</para>
						</td>
						<!-- Remarks -->
						<td>
							<@studyandsummaryCom.studyRemarksColumn study/>
						</td>
					</tr>
					<@studyandsummaryCom.tableRowForJustificationForTypeOfInformation study/>
				</#list>
				<#list studyList4 as study>
					<tr>
						<!-- Method -->
						<td>
							<@humanStudyMethod study />
						</td>
						<!-- Results -->
						<td>
							<para>
								<@com.text study.ResultsAndDiscussion.Results/>
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

	<#assign studyList1 = [] />
	<#assign studyList2 = [] />
	<#assign studyList3 = [] />
	<#assign studyList4 = [] />

</#compress>
</#macro>

<!-- Summary and discussion of other effects -->
<#macro otherEffectsSummary _subject>
<#compress>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Neurotoxicity") />

	<#if summaryList?has_content>
	<#assign printSummaryName = summaryList?size gt 1 />

		<para><emphasis role="bold">Neurotoxicity</emphasis></para>
	   
		<#list summaryList as summary>
		
			<#if summary.KeyInformation.KeyInformation?has_content>
			 <para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
			
			<para>
			<@com.richText summary.KeyInformation.KeyInformation/>
			</para>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.Species?has_content>
				<#assign valueForCsaTextOralNeurotoxicity>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.EndpointConclusion.Species/>)					
					</#if>
				</#assign>
			</#if>
			<@endpointSummary summary valueForCsaTextOralNeurotoxicity "valueForCsaTextOralNeurotoxicity" printSummaryName/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.Species?has_content>
				<#assign valueForCsaTextDermalNeurotoxicity>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>	
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.EndpointConclusion.Species/>)
						
					</#if>
				</#assign>
			</#if>			
			<@endpointSummary summary valueForCsaTextDermalNeurotoxicity "valueForCsaTextDermalNeurotoxicity" false/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.Species?has_content>
				<#assign valueForCsaTextInhalationNeurotoxicity>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.TestType/>);
					</#if>	
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.EndpointConclusion.Species/>)
						
					</#if>
				</#assign>
			</#if>			
			<@endpointSummary summary valueForCsaTextInhalationNeurotoxicity "valueForCsaTextInhalationNeurotoxicity" false/>

			<@justification summary "JustifClassifRepTox"/>

		</#list>	
	</#if>
		
		<#if csrRelevant??>	
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedNeurotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedNeurotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedNeurotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedNeurotoxicity(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "Immunotoxicity") />

	<#if summaryList?has_content>
		<@com.emptyLine/>
		<para><emphasis role="bold">Immunotoxicity</emphasis></para>
		   
		<#list summaryList as summary>
			
			<#if summary.KeyInformation.KeyInformation?has_content>
			 <para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
			
			<para>
			<@com.richText summary.KeyInformation.KeyInformation/>
			</para>
			
			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.Species?has_content>
			
				<#assign valueForCsaTextOralImmunotoxicity>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.Species?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.EndpointConclusion.Species/>)
					
					</#if>
				</#assign>
			</#if>			
			<@endpointSummary summary valueForCsaTextOralImmunotoxicity "valueForCsaTextOralImmunotoxicity" false/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.Species?has_content>
				<#assign valueForCsaTextDermalImmunotoxicity>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelUnit/>) 
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.TestType?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.TestType/>)
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.EndpointConclusion.Species/>)
						
					</#if>
				</#assign>
			</#if>				
			<@endpointSummary summary valueForCsaTextDermalImmunotoxicity "valueForCsaTextDermalImmunotoxicity" false/>

			<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.TestType?has_content || 
			summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.Species?has_content>
				<#assign valueForCsaTextInhalationImmunotoxicity>				
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion?has_content>
						<para><@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EndpointConclusion/></para>
					</#if>		
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelUnit/>)
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue?has_content>
						<@com.quantity summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.EffectLevelValue/>
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.TestType?has_content>
					(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.TestType/>);
					</#if>
					<#if summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.Species?has_content>
						(<@com.picklist summary.KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.EndpointConclusion.Species/>)						
					</#if>
				</#assign>
			</#if>				
			<@endpointSummary summary valueForCsaTextInhalationImmunotoxicity "valueForCsaTextInhalationImmunotoxicity" false/>

			<@justification summary "JustifClassifRepTox"/>

		</#list>
	</#if>

		<#if csrRelevant??>
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "HealthSurveillanceData") />
			<#assign studyList1 = getSortedImmunotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EpidemiologicalData") />
			<#assign studyList2 = getSortedImmunotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "DirectObservationsClinicalCases") />
			<#assign studyList3 = getSortedImmunotoxicity(studyList) />
			<#assign studyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "ExposureRelatedObservationsOther") />
			<#assign studyList4 = getSortedImmunotoxicity(studyList) />

			<#if !(studyList1?has_content) && !(studyList2?has_content) && !(studyList3?has_content) && !(studyList4?has_content)>
				<#else/>
					<para><@com.emptyLine/><emphasis role="underline">Discussion of human information:</emphasis></para>
					See "Summary and discussion of human information" in chapter 5 HUMAN HEALTH HAZARD ASSESSMENT
					<!-- TO DO - TO FIND WHAT INFO GOES HERE - WITH ROBERTA -->
			</#if>
		</#if>

	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "SpecificInvestigationsOtherStudies") />

	<#if summaryList?has_content>
		<@com.emptyLine/>
		<emphasis role="bold">Specific investigations: other studies </emphasis>
			
		<#list summaryList as summary>
			
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
		
			<para>
				<@com.richText summary.KeyInformation.KeyInformation/>
			</para>
			
			<para><@studyandsummaryCom.relevantStudies summary/></para>	
			
			<para>
				Additional information: <@com.richText summary.Discussion.Discussion/>
			</para>
		</#list>
	</#if>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AdditionalToxicologicalInformation") />

	<#if summaryList?has_content>
		<@com.emptyLine/>
		<emphasis role="bold">Additional toxicological information </emphasis>
			
		<#list summaryList as summary>
		
			<#if summary.KeyInformation.KeyInformation?has_content>
				<para><@com.emptyLine/><emphasis role="underline">The following information is taken into account for any hazard / risk assessment:</emphasis></para>
			</#if>
			<@com.emptyLine/>
		
			<para>
				<@com.richText summary.KeyInformation.KeyInformation/>
			</para>
			
			<para><@studyandsummaryCom.relevantStudies summary/></para>	
			
			<para>
				Additional information: <@com.richText summary.Discussion.Discussion/>
			</para>
		</#list>
	</#if>

</#compress>
</#macro>

<!-- Macros and functions -->
<#-- TODO It seems that all getSorted... functions could be incorporated in one -->
<#function getSortedBasicToxicokineticsOrDermalAbsorption documentKey documentType documentSubtype>
    <#assign studyList = iuclid.getSectionDocumentsForParentKey(documentKey, documentType, documentSubtype) />
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["basic toxicokinetics", "dermal absorption"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedAcuteToxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["acute toxicity: oral", "acute toxicity: inhalation", "acute toxicity: dermal"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedSkinIrritation studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["skin irritation / corrosion"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedSkinCorrosion studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["skin irritation / corrosion"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedEyeIrritation studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["eye irritation"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedRespiratoryTract studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["respiratory irritation"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedCarcinogenicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["carcinogenicity"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedDevelopmentToxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["developmental toxicity / teratogenicity"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedToxicityToReproInHumans studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["toxicity to reproduction / fertility"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedNeurotoxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["neurotoxicity"])> 
			
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedImmunotoxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["immunotoxicity"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedEndpointNotSpecified studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["not applicable"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedCarcinogenicityOral studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, ["carcinogenicity: oral"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#if PurposeFlag?has_content>
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
	</#if>
    <#return returnList />
</#function>

<#function getSortedCarcinogenicityInhalation studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, ["carcinogenicity: inhalation"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#if PurposeFlag?has_content>
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
	</#if>
    <#return returnList />
</#function>

<#function getSortedCarcinogenicityDermal studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, ["carcinogenicity: dermal"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#if PurposeFlag?has_content>
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
	</#if>
    <#return returnList />
</#function>

<#function getSortedCarcinogenicityOther studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, ["carcinogenicity, other"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#if PurposeFlag?has_content>
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
	</#if>
    <#return returnList />
</#function>

<#function getSortedSkinSensitisation studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local TypeOfSensitisationStudied = study.MaterialsAndMethods.TypeOfSensitisationStudied />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(TypeOfSensitisationStudied, ["skin"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#if PurposeFlag?has_content>
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
	</#if>
    <#return returnList />
</#function>

<#function getSortedSkinSensitisationEndpoint studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["skin sensitisation"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedRespiratorySensitisationEndpoint studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["respiratory sensitisation"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedRepeatedDoseToxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["repeated dose toxicity: oral", "repeated dose toxicity: inhalation", "repeated dose toxicity: dermal"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedGeneticToxicity studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpointAddressed = study.MaterialsAndMethods.EndpointAddressed />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(endpointAddressed, ["genetic toxicity"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedSkinSensitisationRespiratory studyList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local TypeOfSensitisationStudied = study.MaterialsAndMethods.TypeOfSensitisationStudied />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistMultipleValueMatchesPhrases(TypeOfSensitisationStudied, ["respiratory"])>
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedSkinIrritationNonHuman studyList endpointValueList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
	<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, endpointValueList) >
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#function getSortedSkinCorrosionNonHuman studyList endpointValueList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	<#list studyList as study>
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, endpointValueList) >
			<#local returnList = returnList + [study] />
		</#if>
	</#list>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>

<#macro AbsorptionList AbsorptionRepeatableBlock>
<#compress>
	<#if AbsorptionRepeatableBlock?has_content>
		<#list AbsorptionRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Absorption?has_content>
					<@com.range blockItem.Absorption/> % 
				</#if>	
				<#if blockItem.TimePoint?has_content>	
					at (<@com.picklist blockItem.TimePoint/>)
				</#if>
				<#if blockItem.Dose?has_content>
					(<@com.text blockItem.Dose/>) 
				</#if>	
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#-- TODO The following DosesConcentrations... macros could be merged in one -->
<#macro DosesConcentrationsList DosesConcentrationsRepeatableBlock>
<#compress>
	<#if DosesConcentrationsRepeatableBlock?has_content>
		<#list DosesConcentrationsRepeatableBlock as blockItem>
			<para role="indent">
				<@com.quantity blockItem.DoseConc/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>
<#macro DosesConcentrationsWithRemarksList DosesConcentrationsRepeatableBlock>
<#compress>
	<#if DosesConcentrationsRepeatableBlock?has_content>
		<#list DosesConcentrationsRepeatableBlock as blockItem>
			<para role="indent">
				<@com.quantity blockItem.DoseConc/>
				<?linebreak?>
				<@com.text blockItem.Remarks/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro BasicToxicokineticsMainAdmeResultsList MainAdmeResultsRepeatableBlock>
<#compress>
	<#if MainAdmeResultsRepeatableBlock?has_content>
		<#list MainAdmeResultsRepeatableBlock as blockItem>
			<para role="indent">
				Type: <@com.picklist blockItem.Type/>
				<?linebreak?>
				Result: <@com.text blockItem.Results/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro BasicToxicokineticsDosesConcentrationsList DosesConcentrationsRepeatableBlock>
<#compress>
	<#if DosesConcentrationsRepeatableBlock?has_content>
		<#list DosesConcentrationsRepeatableBlock as blockItem>
			<para role="indent">
				Doses/conc.: <@com.range blockItem.DosesConcentrations/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro ToxicokineticParametersList ParametersRepeatableBlock>
<#compress>
	<#if ParametersRepeatableBlock?has_content>
		<#list ParametersRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.ToxicokineticParameters/> 
				<#if blockItem.TestNo?has_content>
					(Test No.: <@com.picklist blockItem.TestNo/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro ADMEList ADMERepeatableBlock>
<#compress>
	<#if ADMERepeatableBlock?has_content>
		<#list ADMERepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Type/>
				<#if blockItem.Results?has_content>
					: <@com.text blockItem.Results/>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro PercutaneousAbsorptionRateList  PercutaneousRepeatableBlock>
<#compress>
	<#if PercutaneousRepeatableBlock?has_content>
		<#list PercutaneousRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Absorption?has_content>
					<@com.range blockItem.Absorption/>(%) 
				</#if>	
				<#if blockItem.TimePoint?has_content>
					at <@com.quantity blockItem.TimePoint/>
				</#if>
				<#if blockItem.Dose?has_content>
					(<@com.text blockItem.Dose/>) 
				</#if>	
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro EyeIrritationInVitroList EyeIrritationInVitroRepeatableBlock>
<#compress>
	<#if EyeIrritationInVitroRepeatableBlock?has_content>
		<#list EyeIrritationInVitroRepeatableBlock as blockItem>
			<#if blockItem.RunExperiment?has_content || blockItem.Value?has_content>
				<para>
				<@com.picklist blockItem.IrritationParameter/>
				</para>
				<para role="indent">
					<para>
						<#if blockItem.RunExperiment?has_content>
							<@com.text blockItem.RunExperiment/>;
						</#if>
						
						<#if blockItem.Value?has_content>
							value <@com.range blockItem.Value/>
						</#if>
					</para>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro EyeIrritationInVivoList EyeIrritationInVivoRepeatableBlock>
<#compress>
	<#if EyeIrritationInVivoRepeatableBlock?has_content>
		<#list EyeIrritationInVivoRepeatableBlock as blockItem>
			<#if blockItem.Basis?has_content || blockItem.Score?has_content || blockItem.Scale?has_content || blockItem.TimePoint?has_content || blockItem.Reversibility?has_content || blockItem.RemarksOnResults?has_content>
				<para>
				<@com.picklist blockItem.Parameter/>
				</para>
				<para role="indent">
					<para>
						<#if blockItem.Basis?has_content>
							(<@com.picklist blockItem.Basis/>)
						</#if>
					
						<#if blockItem.Score?has_content>
							<@com.range blockItem.Score/>
						</#if>
					
						<#if blockItem.Scale?has_content>
							of max. <@com.number blockItem.Scale/>
						</#if>
					</para>
					
					<#if blockItem.TimePoint?has_content>
						<para>
							(Time point: <@com.picklist blockItem.TimePoint/>)
						</para>
					</#if>
					
					<#if blockItem.Reversibility?has_content>
						<para>
							<@com.picklist blockItem.Reversibility/>							
						</para>
					</#if>
					
					<#if blockItem.RemarksOnResults?has_content>
						<para>
							<@com.picklist blockItem.RemarksOnResults/>
						</para>
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TransferList  TransferRepeatableBlock>
<#compress>
	<#if TransferRepeatableBlock?has_content>
		<#list TransferRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.TransferType?has_content>
					Transfer (<@com.picklist blockItem.TransferType/>)
				</#if>	
				<#if blockItem.Observation?has_content>
					: <@com.picklist blockItem.Observation/> 
				</#if>
				<#if blockItem.TestNo?has_content>
					(<@com.picklist blockItem.TestNo/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro AbsorptionList AbsorptionRepeatableBlock>
<#compress>
	<#if AbsorptionRepeatableBlock?has_content>
		<#list AbsorptionRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Absorption?has_content>
					<@com.range blockItem.Absorption/> %
				</#if>
				<#if blockItem.TimePoint?has_content>
					at (<@com.picklist blockItem.TimePoint/>)
				</#if>
				<#if blockItem.Dose?has_content>
					(<@com.text blockItem.Dose/>)
				</#if>
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro BasicToxicokineticsMainAdmeResultsList MainAdmeResultsRepeatableBlock>
<#compress>
	<#if MainAdmeResultsRepeatableBlock?has_content>
		<#list MainAdmeResultsRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Type?has_content>
					Type: <@com.picklist blockItem.Type/>
				</#if>
				<#if blockItem.Results?has_content>
					Result: <@com.text blockItem.Results/>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro BasicToxicokineticsDosesConcentrationsList DosesConcentrationsRepeatableBlock>
<#compress>
	<#if DosesConcentrationsRepeatableBlock?has_content>
		<#list DosesConcentrationsRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.DosesConcentrations?has_content>
					Doses/conc.: <@com.range blockItem.DosesConcentrations/>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#-- TODO The following EffectLevels... macros could be merged in one -->
<#macro EffectLevelsList EffectsRepeatableBlock>
<#compress>
	<#if EffectsRepeatableBlock?has_content>
		<#list EffectsRepeatableBlock as blockItem>
			<#if blockItem.Endpoint?has_content || blockItem.Sex?has_content || blockItem.BasedOn?has_content || blockItem.RemarksOnResults?has_content>
			<para>
				<#if blockItem.Endpoint?has_content>
					<@com.picklist blockItem.Endpoint/>:
				</#if>
				<@com.range blockItem.EffectLevel/>
				<#if blockItem.Sex?has_content>
					(<@com.picklist blockItem.Sex/>)
				</#if>
				<#if blockItem.BasedOn?has_content>
					based on: (<@com.picklist blockItem.BasedOn/>) 
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


<#macro EffectLevelsMatAbnormalitiesList EffectsMaternalRepeatableBlock>
<#compress>
	<#if EffectsMaternalRepeatableBlock?has_content>
		<#list EffectsMaternalRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Endpoint?has_content>
					<@com.picklist blockItem.Endpoint/>:
				</#if>
				<#if blockItem.EffectLevel?has_content>
					<@com.range blockItem.EffectLevel/>
				</#if>
				<#if blockItem.BasedOn?has_content>
					based on: (<@com.picklist blockItem.BasedOn/>) 
				</#if>	
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>
<#macro EffectLevelsFetusesList EffectsFetusesRepeatableBlock>
<#compress>
	<#if EffectsFetusesRepeatableBlock?has_content>
		<#list EffectsFetusesRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Endpoint?has_content>
					<@com.picklist blockItem.Endpoint/>:
				</#if>
				<#if blockItem.EffectLevel?has_content>
					<@com.range blockItem.EffectLevel/>
				</#if>
				<#if blockItem.BasedOn?has_content>
					based on: (<@com.picklist blockItem.BasedOn/>) 
				</#if>	
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>
<#macro EffectLevelsExtendedList EffectsExtendedRepeatableBlock>
<#compress>
	<#if EffectsExtendedRepeatableBlock?has_content>
		<#list EffectsExtendedRepeatableBlock as blockItem>
			<para role="indent">
				<#if blockItem.Endpoint?has_content>
					<@com.picklist blockItem.Endpoint/>:
				</#if>
				<#if blockItem.EffectLevel?has_content>
					<@com.range blockItem.EffectLevel/> 
				</#if>
				<#if blockItem.Sex?has_content>
					(<@com.picklist blockItem.Sex/>)
				</#if>
				<#if blockItem.BasedOn?has_content>
					based on: (<@com.picklist blockItem.BasedOn/>)
				</#if>
				<#if blockItem.Basis?has_content>
					<@com.picklistMultiple blockItem.Basis/>
				</#if>
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TargetSystemOrganToxList TargetRepeatableBlock>
<#compress>
	<#if TargetRepeatableBlock?has_content>
		<#list TargetRepeatableBlock as blockItem>
			<#if com.picklistValueMatchesPhrases(blockItem.CriticalEffectsObserved,["yes"])>
				<#local text_1>
					<#if com.picklistValueMatchesPhrases(blockItem.TreatmentRelated,["yes"])>
						treatment-related
					<#else>
                    	not treatment-related
					</#if>
				</#local>
				<#local text_2>
					<#if com.picklistValueMatchesPhrases(blockItem.DoseResponseRelationship,["yes"])>
                    	dose-response: yes
					<#else>
                    	dose-response: no
					</#if>
				</#local>
				<para role="indent">
                    <emphasis role="bold">Target system  / organ toxicity</emphasis>
                    <?linebreak?>
					<#if blockItem.System?has_content>
						Lowest effective dose /concentration: <@com.picklist blockItem.System/>
					</#if>	
					<#if blockItem.Organ?has_content>
						: <@com.picklistMultiple blockItem.Organ/>
					</#if>
					<#if blockItem.LowestEffectiveDoseConc?has_content>
						(lowest effective dose/conc.: <@com.quantity blockItem.LowestEffectiveDoseConc/> ; ${text_1} ; ${text_2})
					</#if>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TargetSystemOrganToxforEffectLevelsList TargetEffectRepeatableBlock>
<#compress>
	<#if TargetEffectRepeatableBlock?has_content>
		<#list TargetEffectRepeatableBlock as blockItem>
			<#local criticalEffectsObserved><@com.picklist blockItem.CriticalEffectsObserved/>></#local>
			<#if criticalEffectsObserved?contains(".*yes.*")>
			<para role="indent">
				Target system / organ toxicity:
                <?linebreak?>
				<@com.quantity blockItem.LowestEffectiveDoseConc/>
				<#if blockItem.System?has_content>
					(on <@com.picklist blockItem.System/>
				</#if>
				<#if blockItem.Organ?has_content>
					<@com.picklistMultiple blockItem.Organ/>)
					<?linebreak?>
					<#else/>
					)
				</#if>
			</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro InductionList InductionRepeatableBlock Endpoint>
<#compress>
	<#if InductionRepeatableBlock?has_content>
		<#list InductionRepeatableBlock as blockItem>
			<#if Endpoint?contains(".*skin sensitisation: in vivo (non-LLNA).*")>
				<para role="indent">
					Induction: <@com.picklist blockItem.Route/>
					Vehicle: <@com.picklist blockItem.Vehicle/>
				</para>
			<#elseif Endpoint?contains(".*skin sensitisation: in vivo (LLNA).*")>
	            <para role="indent">
	                Vehicle: <@com.picklist blockItem.Vehicle/>
				</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#--TODO The following two macros could be possible merged to one -->
<#macro inVivoLLNAList inVivoLLNARepeatableBlock endPoint>
	<#if !endPoint?contains(".*(LLNA).*")>
		<#return>
	</#if>
	<#compress>
	<#if inVivoLLNARepeatableBlock?has_content>
		<#list inVivoLLNARepeatableBlock as blockItem>
				<#local parameter>
					<@com.picklist blockItem.Parameter />
				</#local>
				<#if parameter?contains(".*SI.*")>
					<#local prefix = "Stimulation index: " />
				<#else>
					<#local prefix = parameter + ": "/>
				</#if>
		        <para role="indent">
					${prefix} <@com.range blockItem.Value/> (<@com.picklist blockItem.RemarksOnResults/>)
				</para>
		</#list>
  	</#if>
	</#compress>
</#macro>
<#macro inVitroLLNAList inVivoLLNARepeatableBlock endPoint>
	<#if !endPoint?contains(".*in vitro.*") && !endPoint?contains(".*in chemico.*")>
		<#return>
	</#if>
	<#compress>
		<#if inVivoLLNARepeatableBlock?has_content>
			<#list inVivoLLNARepeatableBlock as blockItem>
				<#if com.picklistValueMatchesPhrases(blockItem.Parameter, ["other:"]) >
					<para role="indent">
						Results:
                        <?linebreak?>
						<@com.picklist blockItem.Parameter /> <@com.quantity blockItem.Value/> 
						<#if blockItem.RemarksOnResults?has_content>
							(<@com.picklist blockItem.RemarksOnResults/>)
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro inVivoNonLLNAList inVivoNonLLNARepeatableBlock endPoint>
	<#if endPoint?contains(".*non-LLNA.*")>
		<#compress>
		<#if inVivoNonLLNARepeatableBlock?has_content>
			<#list inVivoNonLLNARepeatableBlock as blockItem>
		<para role="indent">
			<#if blockItem.Reading?has_content>
				No. with positive reactions: <@com.picklist blockItem.Reading/>
			</#if>	
			<#if blockItem.NoWithReactions?has_content>
				: <@com.number blockItem.NoWithReactions/>
			</#if>
			<#if blockItem.TotalNoInGroup?has_content>
				out of <@com.number blockItem.TotalNoInGroup/>
				<?linebreak?>
			</#if>			
			<#if blockItem.Group?has_content>
				(<@com.picklist blockItem.Group/>
			</#if>
			<#if blockItem.HoursAfterChallenge?has_content>
				; <@com.number blockItem.HoursAfterChallenge/>
				<#else/>
				<?linebreak?>
			</#if>
			<#if blockItem.DoseLevel?has_content>
				h after challenge; dose: <@com.text blockItem.DoseLevel/>)
				<#else/>
				)
				<?linebreak?>
			</#if>
			<#if blockItem.RemarksOnResults?has_content>
				(<@com.picklist blockItem.RemarksOnResults/>)
			</#if>
		</para>
		</#list>
		</#if>
		</#compress>
	</#if>
</#macro>

<#macro ControlsList ControlRepeatableBlock>
<#compress>
	<#if ControlRepeatableBlock?has_content>
		<#list ControlRepeatableBlock as blockItem>
			<para role="indent">
				Positive control substance(s): <@com.picklistMultiple blockItem.PositiveControlSubstance/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TestResultsList TestResultsRepeatableBlock>
<#compress>
	<#if TestResultsRepeatableBlock?has_content>
		<#list TestResultsRepeatableBlock as blockItem>
			<#local genotoxicity><@com.picklist blockItem.Genotoxicity/></#local>
			<#local organism><@com.picklist blockItem.Organism/></#local>
			<#local metActIndicator><@com.picklist blockItem.MetActIndicator/></#local>
			<#local cytotoxicity><@com.picklist blockItem.Cytotoxicity/></#local>
			<#local vehContrValid><@com.picklist blockItem.VehContrValid/></#local>
			<#local negContrValid><@com.picklist blockItem.NegContrValid/></#local>
			<#local posContrValid><@com.picklist blockItem.PosContrValid/></#local>
			<#if genotoxicity?has_content || organism?has_content || metActIndicator?has_content || cytotoxicity?has_content || vehContrValid?has_content || negContrValid?has_content || posContrValid?has_content >
			<para role="indent">
				Test results:
				<?linebreak?>
				${genotoxicity} for ${organism};
				<?linebreak?>
				met. act.: ${metActIndicator}
				<?linebreak?>
				genotoxicity: ${genotoxicity}
				cytotoxicity: ${cytotoxicity}
				<?linebreak?>
				vehicle controls valid: ${vehContrValid}
				<?linebreak?>
				negative controls valid: ${negContrValid}
				<?linebreak?>
				positive controls valid: ${posContrValid}
				<?linebreak?>
			</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro TestResultsInVivoList TestResultsRepeatableBlock>
<#compress>
	<#if TestResultsRepeatableBlock?has_content>
		<#list TestResultsRepeatableBlock as blockItem>
			<#local genotoxicity><@com.picklist blockItem.Genotoxicity/></#local>
			<#local sex><@com.picklist blockItem.Sex/></#local>
			<#local toxicity><@com.picklist blockItem.Toxicity/></#local>
			<#local vehContrValid><@com.picklist blockItem.VehContrValid/></#local>
			<#local negContrValid><@com.picklist blockItem.NegContrValid/></#local>
			<#local posContrValid><@com.picklist blockItem.PosContrValid/></#local>
			<#local remarksOnResults><@com.picklist blockItem.RemarksOnResults/></#local>
			<#if genotoxicity?has_content || sex?has_content || toxicity?has_content || vehContrValid?has_content || negContrValid?has_content || posContrValid?has_content || remarksOnResults?has_content>
			<para role="indent">
				Genotoxicity: ${genotoxicity} (${sex})
				<?linebreak?>
				toxicity: ${toxicity}
				<?linebreak?>
                vehicle controls valid: ${vehContrValid}
                <?linebreak?>
                negative controls valid: ${negContrValid}
                <?linebreak?>
                positive controls valid: ${posContrValid}
                <?linebreak?>
                Remark: ${remarksOnResults}
			</para>
			</#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro SpeciesStrainList SpeciesStrainPath>
<#compress>
<#local SpeciesStrainRepeatableBlock = SpeciesStrainPath.SpeciesStrain/>
	<#if SpeciesStrainRepeatableBlock?has_content>
		<#list SpeciesStrainRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.SpeciesStrain/>
				<#if SpeciesStrainPath.MetabolicActivation?has_content>
					(<@com.picklist SpeciesStrainPath.MetabolicActivation/> met. act.)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>


<#macro EffectLevelsPoList EffectLevelsPORepeatableBlock>
<#compress>
	<#if EffectLevelsPORepeatableBlock?has_content>
		<#list EffectLevelsPORepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Endpoint/>
				<#if blockItem.EffectLevel?has_content>
					(PO) <@com.range blockItem.EffectLevel/>)
				<?linebreak?>
				</#if>
				<#if blockItem.Sex?has_content>
					(<@com.picklist blockItem.Sex/>) 
				</#if>
				<#if blockItem.Basis?has_content>
					based on: <@com.picklistMultiple blockItem.Basis/>
				<?linebreak?>
				</#if>
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro SecondparentalGenerationP1List SecondPgenerationEffectLevelsRepeatableBlock>
<#compress>
	<#if SecondPgenerationEffectLevelsRepeatableBlock?has_content>
		<#list SecondPgenerationEffectLevelsRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Endpoint/>
				<#if blockItem.EffectLevel?has_content>
					(P1): <@com.range blockItem.EffectLevel/>
				<?linebreak?>
				</#if>				
				<#if blockItem.Sex?has_content>
					(<@com.picklist blockItem.Sex/>) 
				</#if>	
				<#if blockItem.Basis?has_content>
					based on: <@com.picklistMultiple blockItem.Basis/>
				<?linebreak?>
				</#if>
				<@com.picklist blockItem.RemarksOnResults/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro FgenerationList FgenerationListRepeatableBlock>
<#compress>
	<#if FgenerationListRepeatableBlock?has_content>
		<#list FgenerationListRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Endpoint/> 
				<#if blockItem.EffectLevel?has_content>
					: <@com.range blockItem.EffectLevel/>
				<?linebreak?>
				</#if>
				<#if blockItem.Sex?has_content>
					(<@com.picklist blockItem.Sex/>) 
				</#if>
				<#if blockItem.Basis?has_content>
					based on: <@com.picklistMultiple blockItem.Basis/>
				<?linebreak?>
				</#if>
				<@com.picklist blockItem.RemarksOnResults/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro OverallReproductiveToxicityList ReproToxRepeatableBlock>
<#compress>
	<#if ReproToxRepeatableBlock?has_content>
		<#list ReproToxRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.ReproductiveEffectsObserved/>
				Lowest effective dose / concentration <@com.quantity blockItem.LowestEffectiveDoseConc/>
				<?linebreak?>
				Relation to other toxic effects: <@com.picklist blockItem.RelationToOtherToxicEffects/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro MatAbnormalitiesList MatAbnormalitiesRepeatableBlock>
<#compress>
	<#if MatAbnormalitiesRepeatableBlock?has_content>
		<#list MatAbnormalitiesRepeatableBlock as blockItem>
			<para role="indent">
				Maternal abnormalities <@com.picklist blockItem.Abnormalities/>
				<?linebreak?>
				<@com.picklistMultiple blockItem.Localisation/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro FetalAbnormalitiesList FetalAbnormalitiesRepeatableBlock>
<#compress>
	<#if FetalAbnormalitiesRepeatableBlock?has_content>
		<#list FetalAbnormalitiesRepeatableBlock as blockItem>
			<para role="indent">
				Fetal abnormalities <@com.picklist blockItem.Abnormalities/>
				<?linebreak?>
				<@com.picklistMultiple blockItem.Localisation/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro OverallDevToxList OverallDevToxRepeatableBlock>
<#compress>
	<#if OverallDevToxRepeatableBlock?has_content>
		<#list OverallDevToxRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.DevelopmentalEffectsObserved/>
				<?linebreak?>
				Lowest effective dose / concentration: <@com.quantity blockItem.LowestEffectiveDoseConc/>
				Relation to maternal toxicity: <@com.picklist blockItem.RelationToMaternalToxicity/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro endpointSummary summary valueCsa="" valueForCsaText="" printName=false>
	<para>
		<#if printName>
			<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
		</#if>
	</para>
	<#if valueForCsaText?has_content>
	
		<!-- oral systemic -->
		<#if valueForCsaText=="valueForCsaTextOralSystemic">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (via oral route - systemic effects):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- inhalation systemic -->
		<#if valueForCsaText=="valueForCsaTextInhalationSystemic">
			<para>
				<@com.emptyLine/>
				<emphasis role="bold">Value used for CSA (inhalation - systemic effects):</emphasis>
				<?linebreak?>
				${valueCsa}
			</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
			
		<!-- inhalation local -->
		<#if valueForCsaText=="valueForCsaTextInhalationLocal">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (inhalation - local effects):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>	
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>

		<!-- dermal systemic -->
		<#if valueForCsaText=="valueForCsaTextDermalSystemic">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (dermal - systemic effects):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>	
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal local -->
		<#if valueForCsaText=="valueForCsaTextDermalLocal">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (dermal - local effects):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@studyandsummaryCom.summaryAdditionalInformation summary/>
		</#if>
		
		<!-- oral carcinogenicity -->
		<#if valueForCsaText=="valueForCsaTextOralCacrinogenicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: oral):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- oral effects on fertility -->
		<#if valueForCsaText=="valueForCsaTextOralFertilityEffects">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: oral):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- oral effects immunotoxicity -->
		<#if valueForCsaText=="valueForCsaTextOralImmunotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: oral):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- oral effects neurotoxicity -->
		<#if valueForCsaText=="valueForCsaTextOralNeurotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: oral):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- oral effects developmental -->
		<#if valueForCsaText=="valueForCsaTextOralDevelopmentalToxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: oral):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal effects carcinogenicity -->
		<#if valueForCsaText=="valueForCsaTextDermalCarcinogenicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: dermal):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal effects immunotoxicity -->
		<#if valueForCsaText=="valueForCsaTextDermalImmunotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: dermal):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal effects on fertility -->
		<#if valueForCsaText=="valueForCsaTextDermalEffectsOnFertility">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: dermal):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal effects on developmental toxicity -->
		<#if valueForCsaText=="valueForCsaTextDermalDevelopmentToxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: dermal):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- dermal effects on neurotoxicity -->
		<#if valueForCsaText=="valueForCsaTextDermalNeurotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: dermal):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		</#if>
		
		<!-- inhalation immunotoxicity -->
		<#if valueForCsaText=="valueForCsaTextInhalationImmunotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: inhalation):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@studyandsummaryCom.summaryAdditionalInformation summary/>
		</#if>
		
		<!-- inhalation neurotoxicity -->
		<#if valueForCsaText=="valueForCsaTextInhalationNeurotoxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: inhalation):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@studyandsummaryCom.summaryAdditionalInformation summary/>
		</#if>
		
		<!-- inhalation carcinogenicity -->
		<#if valueForCsaText=="valueForCsaTextInhalationCarcinogenicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: inhalation):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@summaryAdditionalInformationForHumanHealth summary valueForCsaText/>
		</#if>
		
		<!-- inhalation effects on fertility -->
		<#if valueForCsaText=="valueForCsaTextInhalationEffectsOnFertility">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: inhalation):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@summaryAdditionalInformationForHumanHealth summary valueForCsaText/>
		</#if>
		
		<!-- inhalation effects on developmental toxicity -->
		<#if valueForCsaText=="valueForCsaTextInhalationDevelopmentalToxicity">
		<para>
			<@com.emptyLine/>
			<emphasis role="bold">Value used for CSA (route: inhalation):</emphasis>
			<?linebreak?>
			${valueCsa}
		</para>
		<para><@studyandsummaryCom.relevantStudies summary/></para>	
		<@summaryAdditionalInformationForHumanHealth summary valueForCsaText/>
		</#if>
				
	</#if>
</#macro>

<#macro summaryAdditionalInformationForHumanHealth summary valueForCsaText>
<#compress>
	
	<#if valueForCsaText=="valueForCsaTextInhalationEffectsOnFertility">
		<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.AdditionalInformation.AdditionalInfo?has_content>
		<?linebreak?>
		<@com.emptyLine/>
		<para><emphasis role="underline">Additional information:</emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.EffectsOnFertility.AdditionalInformation.AdditionalInfo/>
		</#if>
	</#if>
	
	<#if valueForCsaText=="valueForCsaTextInhalationDevelopmentalToxicity">
		<#if summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.AdditionalInformation.AdditionalInfo?has_content>
		<?linebreak?>
		<@com.emptyLine/>
		<para><emphasis role="underline">Additional information:</emphasis></para>
		<@com.richText summary.KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.AdditionalInformation.AdditionalInfo/>
		</#if>		
	</#if>
	
	<#if valueForCsaText=="valueForCsaTextInhalationCarcinogenicity">
		<#if summary.Discussion.Discussion?has_content>
		<?linebreak?>
		<@com.emptyLine/>
		<para><emphasis role="underline">Additional information:</emphasis></para>
		<@com.richText summary.Discussion.Discussion/>
		</#if>		
	</#if>
	
</#compress>	
</#macro>

<#-- TODO The following isXXXStudy macros could be merged in one -->
<#function isIrritationStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local InterpretationResults = study.ApplicantSummaryAndConclusion.InterpretationOfResults />
	<#return com.picklistValueMatchesPhrases(InterpretationResults, [".*irritant.*"]) />
</#function>
<#function isEyeIrritantStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local InterpretationResults = study.ApplicantSummaryAndConclusion.InterpretationOfResults />
	<#return com.picklistValueMatchesPhrases(InterpretationResults, [".*eye.*"]) />
</#function>
<#function isCorrosionStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local InterpretationResults = study.ApplicantSummaryAndConclusion.InterpretationOfResults />
	<#return com.picklistValueMatchesPhrases(InterpretationResults, [".*corrosive.* || .*irritant.* || .*classification.* || .*GHS.* || .*other:.* || .* .*"]) />
</#function>
<#function isRespiratoryTrackStudy study>
	<#if !(study?has_content)>
		<#return false>
	</#if>
	<#local InterpretationResults = study.ApplicantSummaryAndConclusion.InterpretationOfResults />
	<#return com.picklistValueMatchesPhrases(InterpretationResults, ["Category 1 (irreversible effects on the eye) based on GHS criteria"]) />
</#function>

<#macro inVitroList inVitroRepeatableBlock>
<#compress>
	<#if inVitroRepeatableBlock?has_content>
		<#local sortedList = iuclid.sortByField(inVitroRepeatableBlock, "IrritationCorrosionParameter", ["% tissue viability","transcutaneous electrical resistance (in kΩ)","dye content (µg/disc)","penetration time (in minutes)"]) />

		<#local currentHeader><@com.picklist sortedList[0].IrritationCorrosionParameter/></#local>
		<para>${currentHeader}</para>

		<#list sortedList as blockItem>
			<#local parameter><@com.picklist blockItem.IrritationCorrosionParameter/></#local>
			<#if !(currentHeader == parameter)>
				<#local currentHeader = parameter/>
				<para>${currentHeader}</para>
			</#if>
			<para role="indent">
				<#if blockItem.RunExperiment?has_content>
					<@com.text blockItem.RunExperiment/>. 
				</#if>
				<#if blockItem.Value?has_content>
					Value: <@com.range blockItem.Value/>
				</#if>
				<#if blockItem.RemarksOnResults?has_content>
					(<@com.picklist blockItem.RemarksOnResults/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro inVivoList inVivoRepeatableBlock>
<#compress>
	<#if inVivoRepeatableBlock?has_content>
		<#local sortedList = iuclid.sortByField(inVivoRepeatableBlock, "Parameter", ["overall irritation score","primary dermal irritation index (PDII)","erythema score","edema score"]) />

		<#local currentHeader><@com.picklist sortedList[0].Parameter/></#local>
		<para>${currentHeader}</para>

		<#list sortedList as blockItem>
			<#local parameter><@com.picklist blockItem.Parameter/></#local>
			<#if !(currentHeader == parameter)>
				<#local currentHeader = parameter/>
				<para>${currentHeader}</para>
			</#if>
			<para role="indent">
				<@com.range blockItem.Score/> 
				<#if blockItem.Scale?has_content>
					of max. <@com.number blockItem.Scale/>
				</#if>
				<#if blockItem.TimePoint?has_content>
					(Time point: <@com.picklist blockItem.TimePoint/>)
				</#if>
				<#if blockItem.Reversibility?has_content>			
					Reversibility: <@com.picklist blockItem.Reversibility/>
				</#if>
				<para>
					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#function determineEndpointTextRepeatedDose endpoint values valuesText emptyText >
    <#if endpoint?has_content>
        <#assign endpointValue><@com.picklist endpoint /></#assign>
        <#list values as value>
            <#if endpointValue == value>
                <#return valuesText[values?seq_index_of(value)] />
            </#if>
        </#list>
        <#return endpointValue />
    </#if>
    <#return emptyText />
</#function>
<#function determineEndpointTextTypeOfAssay study emptyText>
    <#if study?has_content && study.MaterialsAndMethods.TypeOfAssay?has_content>
        <#assign typeOfAssay><@com.picklist study.MaterialsAndMethods.TypeOfAssay/></#assign>
    </#if>
    <#assign endpoint>(<@com.picklist study.AdministrativeData.Endpoint/>)</#assign>
    <#return emptyText + typeOfAssay!"" + routeOfAdministration!"" + endpoint />
</#function>

<#function determineEndpointTextStudyType study emptyText >
    <#if study?has_content && study.MaterialsAndMethods.Studytype?has_content>
        <#assign studyType><@com.picklist study.MaterialsAndMethods.Studytype/></#assign>
    </#if>
    <#assign routeOfAdministration>(<@com.picklist study.MaterialsAndMethods.AdministrationExposure.RouteOfAdministration />)</#assign>
    <#assign endpoint>(<@com.picklist study.AdministrativeData.Endpoint/>)</#assign>
    <#return emptyText + studyType!"" + routeOfAdministration + endpoint />
</#function>
<#function determineEndpointTextRouteOfAdministration study emptyText >
    <#if study?has_content && study.MaterialsAndMethods.AdministrationExposure.RouteOfAdministration?has_content>
        <#assign routeOfAdministration>(<@com.picklist study.MaterialsAndMethods.AdministrationExposure.RouteOfAdministration />)</#assign>
        <#return emptyText + "(other routes)" + routeOfAdministration />
    </#if>
    <#return emptyText + "(Route: not specified)" />
</#function>

<#macro justification summary path>
	<#compress>
		<#local field = "summary.JustificationForClassificationOrNonClassification."+path />
		
		<#if (field?eval)?has_content >
		<@com.emptyLine/>
			<para><emphasis role="bold">Justification for classification or non classification: </emphasis><@com.richText field?eval /></para>
		</#if>
    </#compress>
	<@com.emptyLine/>
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


<#-- Macros to separate documents into three lists: 'study results', 'data waiving', 'testing proposal' -->
<#macro humanStudyMethod study>

<#local documentID = study.documentType +"."+ study.documentSubType />
	
	<#if study.hasElement("MaterialsAndMethods.StudyType")>
		<para>
			Study type: <@com.picklist study.MaterialsAndMethods.StudyType/>
		</para>
	</#if>	

	<para>
		<#if documentID=="ENDPOINT_STUDY_RECORD.ExposureRelatedObservationsOther"> <#elseif documentID=="ENDPOINT_STUDY_RECORD.SensitisationData">Type of population: <#else><@com.picklistMultiple study.MaterialsAndMethods.Method.TypeOfPopulation/></#if>
	</para>

	<#if !(documentID=="ENDPOINT_STUDY_RECORD.SensitisationData")>
		<para>
			<#if documentID=="ENDPOINT_STUDY_RECORD.DirectObservationsClinicalCases">Subjects:<#else>Details on study design: <@com.text study.MaterialsAndMethods.Method.DetailsOnStudyDesign/></#if>
		</para>

		<para>
			Endpoint addressed: <@com.picklistMultiple study.MaterialsAndMethods.EndpointAddressed/>
		</para>
	</#if>

	<#if documentID=="ENDPOINT_STUDY_RECORD.SensitisationData">
	Subjects: <@com.text study.MaterialsAndMethods.Method.Subjects/>
	</#if>

		<para>
			<#if study.hasElement("MaterialsAndMethods.TypeOfStudyInformation") && study.MaterialsAndMethods.TypeOfStudyInformation?has_content>
				Study type: <@com.text study.MaterialsAndMethods.TypeOfStudyInformation/>
			</#if>
		</para>

		<para>
			<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
		</para>

		<para>
		<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
		</para>

</#macro>

<#macro basicHumanStudyResults study>
	<para>
		<@com.text study.ResultsAndDiscussion.Results/>
	</para>
</#macro>

<#macro nonHumanStudyMethod study>

<#local documentID = study.documentType +"."+ study.documentSubType />

<#local adminpath = "study." + "AdministrativeData.Endpoint" />
<#local pathAdmin = adminpath?eval />

<#local carcinoOralValue><#if com.picklistValueMatchesPhrases(pathAdmin, ["carcinogenicity: oral"])></#if></#local>
<#local carcinoInhalationValue><#if com.picklistValueMatchesPhrases(pathAdmin, ["carcinogenicity: inhalation"])></#if></#local>
<#local carcinoDermalValue><#if com.picklistValueMatchesPhrases(pathAdmin, ["carcinogenicity: dermal"])></#if></#local>
<#local carcinoOtherValue><#if com.picklistValueMatchesPhrases(pathAdmin, ["carcinogenicity, other"])></#if></#local>

<#assign skinIrritation = getSortedSkinIrritationNonHumanStudy(study, ["skin irritation: in vitro / ex vivo", "skin irritation: in vivo", "skin irritation / corrosion, other"] ) />			
<#assign skinCorrosion = getSortedSkinCorrosionNonHumanStudy(study, ["skin corrosion: in vitro / ex vivo", "skin irritation / corrosion.*"]) />			

<#if csrRelevant??><#local endpointData><@com.picklist study.AdministrativeData.Endpoint/></#local></#if>

	<#-- endpoint and method type -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations">
		<para>
			Endpoint addressed: <@com.picklistMultiple study.MaterialsAndMethods.EndpointAddressed/>
		</para>

		<para>
			Type of effects studied: ${endpointData} 
			<#if study.MaterialsAndMethods.MethodType?has_content>
				(<@com.picklist study.MaterialsAndMethods.MethodType/>)
			</#if>
		</para>
	</#if>

	<#-- type of assay and endpoint, species, test concentration, controls -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro">
		<para>
			<@com.picklist study.MaterialsAndMethods.TypeOfAssay/> 
			<#if endpointData??>
				(${endpointData})
			</#if>
		</para>

		<para>
		<@SpeciesStrainList study.MaterialsAndMethods.Method/>
		</para>

		<para>
		Test concentrations: <@com.text study.MaterialsAndMethods.Method.TestConcentrationsWithJustificationForTopDose/>
		</para>

		<para>
		<@ControlsList study.MaterialsAndMethods.Method.Controls/>
		</para>
	</#if>

	<#-- study type -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo">	
		<para>
			<@com.picklist study.MaterialsAndMethods.Studytype/> 
		</para>
		
	<#elseif documentID=="ENDPOINT_STUDY_RECORD.AdditionalToxicologicalInformation">
		<para>
			Study type: <@com.text study.MaterialsAndMethods.TypeOfStudyInformation/>
		</para>
	</#if>

	<#-- endpoint -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo" || documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics" || documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption">
		<para>
			${endpointData}
		</para>

		<#if !endpointData?contains(".*in vivo.*")>
			<para>in vitro study</para>
		</#if>
	</#if>
	
	<#-- tissue studied -->
	<#if skinCorrosion?has_content>
	<para>Tissue studied: ${endpointData}</para>
	</#if>

	<#-- species and strain -->
	<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro") || !(documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation")>
		<para>
			<#if study.hasElement("MaterialsAndMethods.TestAnimals.Species")>
			<@com.picklist study.MaterialsAndMethods.TestAnimals.Species/> 
			</#if>

			<#if study.hasElement("MaterialsAndMethods.TestAnimals.Strain")>
				(<@com.picklist study.MaterialsAndMethods.TestAnimals.Strain/>)
			</#if>
		</para>
		<#elseif documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation">
			<#if study.hasElement("MaterialsAndMethods.InVivoTestSystem.TestAnimals.Species")>
				<para><@com.picklist study.MaterialsAndMethods.InVivoTestSystem.TestAnimals.Species/></para> 
			</#if>
			
			<#if study.hasElement("MaterialsAndMethods.InVivoTestSystem.TestAnimals.Strain")>
				<para>(<@com.picklist study.MaterialsAndMethods.InVivoTestSystem.TestAnimals.Strain/>)</para> 
			</#if>
	</#if>

	<#-- sex, coverage and endpoint -->
	<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro") || !(documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation") || !(skinIrritation?has_content) || !(skinCorrosion?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.DevelopmentalToxicityTeratogenicity")>		
		<#if study.hasElement("MaterialsAndMethods.TestAnimals.Sex")>
		<para>
			<@com.picklist study.MaterialsAndMethods.TestAnimals.Sex/>
		</para>
		</#if>
		

		<#if documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" || documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption">
			<para>
				Coverage (dermal absorption study): <@com.picklist study.MaterialsAndMethods.AdministrationExposure.TypeOfCoverage/>
			</para>
		</#if>

		<#if !(carcinoOtherValue?has_content) || !(carcinoDermalValue?has_content) || !(carcinoInhalationValue?has_content) || !(carcinoOralValue?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo") || !(documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral") || !(documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations") || !(documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetic") || !(documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption")>
			<para>
				${endpointData}
			</para>
		</#if>
	</#if>

	<#-- endpoint, induction, challenge -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation">
		<#if endpointData?contains(".*skin sensitisation: in vivo (LLNA).*")>
			<para>Local lymph node assay</para>
		</#if>

		<#if study.hasElement("MaterialsAndMethods.InVivoTestSystem.StudyDesignInVivoNonLLNA.Induction")>
			<@InductionList study.MaterialsAndMethods.InVivoTestSystem.StudyDesignInVivoNonLLNA.Induction endpointData/>

			<#elseif !endpointData?contains(".*skin sensitisation: in vivo (LLNA)") && !endpointData?contains(".*skin sensitisation:  in vitro.*")>
				<para>${endpointData}</para>
		</#if>
	
		<#elseif documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation">
		<para>Local lymph node assay</para>

		<para>
			<#if study.MaterialsAndMethods.TestSystem.RouteOfInductionExposure?has_content>
				Induction: <@com.picklist study.MaterialsAndMethods.TestSystem.RouteOfInductionExposure/>
			</#if>
		</para>

		<para>
			<#if study.MaterialsAndMethods.TestSystem.RouteOfChallengeExposure?has_content>
				Challenge: <@com.picklist study.MaterialsAndMethods.TestSystem.RouteOfChallengeExposure/>
			</#if>
		</para>
	</#if>

	<#-- coverage -->
	<#if skinIrritation?has_content>
		Coverage: <@com.picklist study.MaterialsAndMethods.TestSystem.TypeOfCoverage/> 
		<#if study.MaterialsAndMethods.TestSystem.PreparationOfTestSite?has_content>
			(<@com.picklist study.MaterialsAndMethods.TestSystem.PreparationOfTestSite/>)
		</#if>

	<#elseif documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityDermal">
		<para>
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.TypeOfCoverage")>
				Coverage: <@com.picklist study.MaterialsAndMethods.AdministrationExposure.TypeOfCoverage/>
			</#if>
		</para>
	</#if>

	<#-- route of administration and type of inhalation -->
	<#if !(carcinoDermalValue?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro") || !(documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityDermal") || !(documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation") || !(skinIrritation?has_content) || !(skinCorrosion?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal")>
	<para>
		<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.RouteOfAdministration")>
		<@com.picklist study.MaterialsAndMethods.AdministrationExposure.RouteOfAdministration/> 
		</#if>

		<#if documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation">
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.TypeOfInhalationExposure")>
				(<@com.picklist study.MaterialsAndMethods.AdministrationExposure.TypeOfInhalationExposure/>)
			</#if>
		</#if>
	</para>
	</#if>	
	
	<#--  type of inhalation -->
	<#if !(carcinoOtherValue?has_content) || !(carcinoOralValue?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo") || !(documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOther") || !(documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityInhalation") || !(documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOral") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral") || !(documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics") || !(documentID=="ENDPOINT_STUDY_RECORD.Neurotoxicity") || !(documentID=="ENDPOINT_STUDY_RECORD.Immunotoxicity") || !(documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations")>
		<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.TypeOfInhalationExposureIfApplicable")>
			(<@com.picklist study.MaterialsAndMethods.AdministrationExposure.TypeOfInhalationExposureIfApplicable/>)
		</#if>
	</#if>

	<#--  frequency of treatment exposure -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics">
		<para>
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.DurationAndFrequencyOfTreatmentExposure")>
				Exposure regime: <@com.text study.MaterialsAndMethods.AdministrationExposure.DurationAndFrequencyOfTreatmentExposure/>
			</#if>
		</para>
	</#if>

	<#--  duration of exposure -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption">
		<para>
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.DurationOfExposure")>			
				<@com.text study.MaterialsAndMethods.AdministrationExposure.DurationOfExposure/>
			</#if>
		</para>
	</#if>

	<#-- doses ocncentration -->
	<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro") || !(documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation") || !(skinIrritation?has_content) || !(skinCorrosion?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation")>
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption")>
		
			<para>
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.DosesConcentrations")>
				<@DosesConcentrationsWithRemarksList study.MaterialsAndMethods.AdministrationExposure.DosesConcentrations/>
			</#if>
			</para>
			
		<#elseif study.hasElement("MaterialsAndMethods.AdministrationExposure.Doses")>
			<para>
				Doses/conc.: <@com.text study.MaterialsAndMethods.AdministrationExposure.Doses/>
			</para>

		</#if>
	</#if>

	<#-- vehicle -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation" || documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation">
		<#if study.hasElement("MaterialsAndMethods.TestSystem.Vehicle")>
		<para>
			Vehicle: <@com.picklist study.MaterialsAndMethods.TestSystem.Vehicle/>
		</para>
		
		</#if>
		
		<#elseif documentID=="ENDPOINT_STUDY_RECORD.Neurotoxicity" || documentID=="ENDPOINT_STUDY_RECORD.Immunotoxicity" || documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations" || documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" || documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOral" || documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityInhalation" || documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityDermal" || documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOther" || documentID=="ENDPOINT_STUDY_RECORD.Carcinogenicity" || documentID=="ENDPOINT_STUDY_RECORD.ToxicityReproduction" || documentID=="ENDPOINT_STUDY_RECORD.ToxicityReproductionOther" || documentID=="ENDPOINT_STUDY_RECORD.DevelopmentalToxicityTeratogenicity"> 
			<para>
				<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.Vehicle")>
				Vehicle: <@com.picklist study.MaterialsAndMethods.AdministrationExposure.Vehicle/>
				</#if>
			</para>
	</#if>

	<#-- vehicle -->
	<#if skinIrritation?has_content || skinCorrosion?has_content>
		<para>
			<#if study.MaterialsAndMethods.InVitroTestSystem.Vehicle?has_content>
			Vehicle: <@com.picklist study.MaterialsAndMethods.InVitroTestSystem.Vehicle/>
			</#if>
		</para>
	</#if>

	<#-- duration of exposure, frequency of treatment, in vitro test system -->
	<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo") || !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro") || !(documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation") || !(documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation") || !(skinIrritation?has_content) || !(skinCorrosion?has_content) || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation") || !(documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral")>
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption") || !(documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics") >
	
		<para>
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.DurationOfTreatmentExposure")>
			Exposure: <@com.text study.MaterialsAndMethods.AdministrationExposure.DurationOfTreatmentExposure/> 
			</#if>
			
			<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.FrequencyOfTreatment")>
				(<@com.text study.MaterialsAndMethods.AdministrationExposure.FrequencyOfTreatment/>)
			</#if>
		</para>
		<#else>
			<para>
				<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.DetailsOnInVitroTestSystemIfApplicable")>
				<@com.text study.MaterialsAndMethods.AdministrationExposure.DetailsOnInVitroTestSystemIfApplicable/>
				</#if>
			</para>
		</#if>
	</#if>

	<#-- positive controls -->
	<#if documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo">
		<para>
		<#if study.hasElement("MaterialsAndMethods.AdministrationExposure.PositiveControls")><@com.text study.MaterialsAndMethods.AdministrationExposure.PositiveControls/></#if>
		</para>
	</#if>

	<#-- guideline followed -->
	<para>
		<@studyandsummaryCom.guidelineList study.MaterialsAndMethods.Guideline/>
	</para>

	<#-- method no. -->
	<para>
		<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
	</para>			

</#macro>

<#function getSortedSkinIrritationNonHumanStudy study endpointValueList>
	<#if !(study?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
	
		<#local endpoint = study.AdministrativeData.Endpoint />
	<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, endpointValueList) >
			<#local returnList = returnList + [study] />
		</#if>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>


<#function getSortedSkinCorrosionNonHumanStudy study endpointValueList>
	<#if !(studyList?has_content)>
		<#return []>
	</#if>
	<#local returnList = [] />
		<#local endpoint = study.AdministrativeData.Endpoint />
		<#local PurposeFlag = study.AdministrativeData.PurposeFlag />
		<#if com.picklistValueMatchesPhrases(endpoint, endpointValueList) >
			<#local returnList = returnList + [study] />
		</#if>
	<#-- sort resultStudyList according to PurposeFlag -->
	<#assign returnList = iuclid.sortByField(returnList, "AdministrativeData.PurposeFlag", ["key study","supporting study","weight of evidence","disregarded due to major methodological deficiencies","other information"]) />
    <#return returnList />
</#function>
