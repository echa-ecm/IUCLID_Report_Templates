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
							</#if>

							<@nonHumanStudyMethod study/>
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
						</#if>

						<@nonHumanStudyMethod study />
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
					<@com.range blockItem.Absorption/>
<#--					(%) -->
				</#if>	
				<#if blockItem.TimePoint?has_content>
					at <@com.quantity blockItem.TimePoint/>
				</#if>
				<#if blockItem.Dose?has_content>
					<#if pppRelevant??>
						for dose <@com.text blockItem.Dose/>
						<#if blockItem.ConcentrateDilution?has_content>
							(<@com.picklist blockItem.ConcentrateDilution/>)
						<#else>
							(<@com.text blockItem.Dose/>)
						</#if>
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
						<?linebreak?>based on: (<@com.picklist blockItem.BasedOn/>)
					</#if>
					<#if pppRelevant??>
						<#if blockItem.Basis?has_content>
							<?linebreak?>basis:<@com.picklistMultiple blockItem.Basis/>
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
						<?linebreak?>based on: (<@com.picklist blockItem.BasedOn/>)
					</#if>
					<#if pppRelevant??>
						<#if blockItem.Basis?has_content>
							<?linebreak?>basis: <@com.picklistMultiple blockItem.Basis/>
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
                    <#if !pppRelevant??><emphasis role="bold">Target system  / organ toxicity</emphasis><?linebreak?></#if>
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
			<#local criticalEffectsObserved><@com.picklist blockItem.CriticalEffectsObserved/></#local>
			<#if criticalEffectsObserved?contains("yes") || pppRelevant??>
				<para role="indent">
					<#if !pppRelevant??>
						Target system / organ toxicity:
						<?linebreak?>
						<@com.quantity blockItem.LowestEffectiveDoseConc/>
					<#else>
						Critical effects observed: ${criticalEffectsObserved}
						<#if blockItem.LowestEffectiveDoseConc?has_content><?linebreak?>Lowest effective dose/conc. = <@com.quantity blockItem.LowestEffectiveDoseConc/></#if>
					</#if>

					<#if blockItem.System?has_content>
						(on <@com.picklist blockItem.System/>
					</#if>
					<#if blockItem.Organ?has_content>
						<@com.picklistMultiple blockItem.Organ/>)
						<?linebreak?>
					<#else>
						)
					</#if>

					<#if pppRelevant??>
						<#local details=[]/>
						<#if blockItem.TreatmentRelated?has_content>
							<#local tr>treatment related: <@com.picklist blockItem.TreatmentRelated/></#local>
							<#local details=details+[tr]/>
						</#if>
						<#if blockItem.DoseResponseRelationship?has_content>
							<#local dr>dose-response relationship: <@com.picklist blockItem.DoseResponseRelationship/></#local>
							<#local details=details+[dr]/>
						</#if>
						<#if blockItem.RelevantForHumans?has_content>
							<#local hu>relevant for humans: <@com.picklist blockItem.RelevantForHumans/></#local>
							<#local details=details+[hu]/>
						</#if>
						<#if details?has_content>
							<?linebreak?>(${details?join("; ")})
						</#if>
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
			<#if Endpoint?contains("skin sensitisation: in vivo (non-LLNA)")>
				<para role="indent">
					Induction: <@com.picklist blockItem.Route/>
					Vehicle: <@com.picklist blockItem.Vehicle/>
				</para>
			<#elseif Endpoint?contains("skin sensitisation: in vivo (LLNA)")>
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
	<#if !endPoint?contains("(LLNA)")>
		<#return>
	</#if>
	<#compress>
	<#if inVivoLLNARepeatableBlock?has_content>
		<#list inVivoLLNARepeatableBlock as blockItem>
				<#local parameter>
					<@com.picklist blockItem.Parameter />
				</#local>
				<#if parameter?contains("SI")>
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
	<#if !endPoint?contains("in vitro") && !endPoint?contains("in chemico")>
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
	<#if endPoint?contains("non-LLNA")>
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
				<#if !pppRelevant??>Test results:<?linebreak?></#if>

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
					<#if pppRelevant?? && blockItem.Generation?has_content>(<@com.picklist blockItem.Generation/>)</#if>
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

				<#if pppRelevant??>
					<#local details=[]/>
					<#if blockItem.TreatmentRelated?has_content>
						<#local tr>treatment related: <@com.picklist blockItem.TreatmentRelated/></#local>
						<#local details=details+[tr]/>
					</#if>
					<#if blockItem.DoseResponseRelationship?has_content>
						<#local dr>dose-response relationship: <@com.picklist blockItem.DoseResponseRelationship/></#local>
						<#local details=details+[dr]/>
					</#if>
					<#if blockItem.RelevantForHumans?has_content>
						<#local hu>relevant for humans: <@com.picklist blockItem.RelevantForHumans/></#local>
						<#local details=details+[hu]/>
					</#if>
					<#if details?has_content>
						<?linebreak?>(${details?join("; ")})
					</#if>
				</#if>
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
				<#if !pppRelevant??>Maternal abnormalities </#if><@com.picklist blockItem.Abnormalities/>
				<?linebreak?>
				localisation: <@com.picklistMultiple blockItem.Localisation/>
				<#if pppRelevant?? && blockItem.DescriptionIncidenceAndSeverity?has_content>
					<?linebreak?>description: <@com.text blockItem.DescriptionIncidenceAndSeverity/>
				</#if>
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
				<#if !pppRelevant??>Fetal abnormalities </#if><@com.picklist blockItem.Abnormalities/>
				<?linebreak?>
				localisation: <@com.picklistMultiple blockItem.Localisation/>
				<#if pppRelevant?? && blockItem.DescriptionIncidenceAndSeverity?has_content>
					<?linebreak?>description: <@com.text blockItem.DescriptionIncidenceAndSeverity/>
				</#if>
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
				<?linebreak?>
				Relation to maternal toxicity: <@com.picklist blockItem.RelationToMaternalToxicity/>

				<#if pppRelevant??>
					<#local details=[]/>
					<#if blockItem.TreatmentRelated?has_content>
						<#local tr>treatment related: <@com.picklist blockItem.TreatmentRelated/></#local>
						<#local details=details+[tr]/>
					</#if>
					<#if blockItem.DoseResponseRelationship?has_content>
						<#local dr>dose-response relationship: <@com.picklist blockItem.DoseResponseRelationship/></#local>
						<#local details=details+[dr]/>
					</#if>
					<#if blockItem.RelevantForHumans?has_content>
						<#local hu>relevant for humans: <@com.picklist blockItem.RelevantForHumans/></#local>
						<#local details=details+[hu]/>
					</#if>
					<#if details?has_content>
						<?linebreak?>(${details?join("; ")})
					</#if>
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro resultsOfAssaysList block role='indent'>
	<#compress>
		<#if block?has_content>
			<#list block as blockItem>
				<para role="${role}">

					<@com.picklist blockItem.MaterialDetected/>
					<#if blockItem.Detected>detected<#else>NOT detected</#if>

					<#if blockItem.SampleType?has_content>
						in <@com.picklist blockItem.SampleType/>
					</#if>

					<#if blockItem.TimePoint?has_content>
						at <@com.quantity blockItem.TimePoint/>
					</#if>

					<#if blockItem.Quantity?has_content>
						: <@com.range blockItem.Quantity/>
					</#if>

				</para>
			</#list>
		</#if>
	</#compress>
</#macro>


<#macro assaysList block role='indent'>
	<#compress>
		<#if block?has_content>
			<#list block as blockItem>
				<para role="${role}">

					<@com.picklist blockItem.AssayType/>:
					<#if blockItem.LinkAnalyticalMethod?has_content>
						analytical method(s):
						<#list blockItem.LinkAnalyticalMethod as anmethlink>
							<#local anmeth = iuclid.getDocumentForKey(anmethlink)/>
							<@com.text anmeth.name/>
							<#if anmethlink_has_next>, </#if>
						</#list>
					</#if>
					<#if blockItem.Remarks?has_content>
						(<@com.text blockItem.Remarks/>)
					</#if>
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

	<#if !pppRelevant??>
		<#if study.hasElement("MaterialsAndMethods.StudyType")>
			<para>
				Study type: <@com.picklist study.MaterialsAndMethods.StudyType/>
			</para>
		</#if>

		<para>
			<#if documentID=="ENDPOINT_STUDY_RECORD.ExposureRelatedObservationsOther">
				<#-- placeholder -->
			<#elseif documentID=="ENDPOINT_STUDY_RECORD.SensitisationData">
				Type of population: <@com.picklistMultiple study.MaterialsAndMethods.Method.TypeOfPopulation/>
			<#else>
				<@com.picklistMultiple study.MaterialsAndMethods.Method.TypeOfPopulation/>
			</#if>
		</para>

		<#if !(documentID=="ENDPOINT_STUDY_RECORD.SensitisationData")>
			<para>
				<#if documentID=="ENDPOINT_STUDY_RECORD.DirectObservationsClinicalCases">
					Subjects: <@com.text study.MaterialsAndMethods.Method.Subjects/>
				<#else>
					Details on study design: <@com.text study.MaterialsAndMethods.Method.DetailsOnStudyDesign/>
				</#if>
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
	<#else>
	<#--ideally this should be merged with the above-->
		<@toxHumanMethodPPP study/>
	</#if>
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

	<#--	NOTE: PPP: interim solution - to be changed-->
	<#if !pppRelevant??>
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
	  <#if documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo" ||
		   documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics" ||
		   documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption" ||
		   documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation">
			<para>
				${endpointData}
			</para>

			<#if !endpointData?contains("in vivo")>
				<para>in vitro study</para>
			</#if>
		</#if>

		<#-- tissue studied -->
		<#if skinCorrosion?has_content>
		<para>Tissue studied: ${endpointData}</para>
		</#if>

		<#-- species and strain -->
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro" || documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation")>
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
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro" ||
			documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation" ||
			skinIrritation?has_content ||
			skinCorrosion?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.DevelopmentalToxicityTeratogenicity")>
			<#if study.hasElement("MaterialsAndMethods.TestAnimals.Sex")>
			<para>
				<@com.picklist study.MaterialsAndMethods.TestAnimals.Sex/>
			</para>
			</#if>
			<#if study.hasElement("MaterialsAndMethods.InVivoTestSystem.TestAnimals.Sex")>
			<para>
				<@com.picklist study.MaterialsAndMethods.InVivoTestSystem.TestAnimals.Sex/>
			</para>
			</#if>

			<#if documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" || documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption">
				<para>
					Coverage (dermal absorption study): <@com.picklist study.MaterialsAndMethods.AdministrationExposure.TypeOfCoverage/>
				</para>
			</#if>

			<#if !(carcinoOtherValue?has_content ||
			  carcinoDermalValue?has_content ||
			  carcinoInhalationValue?has_content ||
			  carcinoOralValue?has_content ||
			  documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo" ||
			  documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation" ||
			  documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation" ||
			  documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes" ||
			  documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" ||
			  documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation" ||
			  documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral" ||
			  documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations" ||
			  documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetic" ||
			  documentID=="ENDPOINT_STUDY_RECORD.DermalAbsorption")>
				<para>
					${endpointData}
				</para>
			</#if>
		</#if>

		<#-- endpoint, induction, challenge -->
		<#if documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation">
			<#if endpointData?contains("skin sensitisation: in vivo (LLNA)")>
				<para>Local lymph node assay</para>
			</#if>

			<#if study.hasElement("MaterialsAndMethods.InVivoTestSystem.StudyDesignInVivoNonLLNA.Induction")>
				<@InductionList study.MaterialsAndMethods.InVivoTestSystem.StudyDesignInVivoNonLLNA.Induction endpointData/>

				<#elseif !endpointData?contains("skin sensitisation: in vivo (LLNA)") && !endpointData?contains("skin sensitisation:  in vitro")>
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
		<#if !(carcinoDermalValue?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro" ||
			documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityDermal" ||
			documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation" ||
			skinIrritation?has_content ||
			skinCorrosion?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal")>
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
		<#if !(carcinoOtherValue?has_content ||
			carcinoOralValue?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo" ||
			documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOther" ||
			documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityInhalation" ||
			documentID=="ENDPOINT_STUDY_RECORD.RepeatedDoseToxicityOral" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral" ||
			documentID=="ENDPOINT_STUDY_RECORD.BasicToxicokinetics" ||
			documentID=="ENDPOINT_STUDY_RECORD.Neurotoxicity" ||
			documentID=="ENDPOINT_STUDY_RECORD.Immunotoxicity" ||
			documentID=="ENDPOINT_STUDY_RECORD.SpecificInvestigations")>
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

		<#-- doses concentration -->
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro" ||
			documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation" ||
			skinIrritation?has_content ||
			skinCorrosion?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation")>
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
		<#if !(documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVivo" ||
			documentID=="ENDPOINT_STUDY_RECORD.GeneticToxicityVitro" ||
			documentID=="ENDPOINT_STUDY_RECORD.RespiratorySensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.SkinSensitisation" ||
			documentID=="ENDPOINT_STUDY_RECORD.EyeIrritation" ||
			skinIrritation?has_content ||
			skinCorrosion?has_content ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOtherRoutes" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityDermal" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityInhalation" ||
			documentID=="ENDPOINT_STUDY_RECORD.AcuteToxicityOral")>
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

	<#else>
		<@toxNonHumanMethodPPP study/>
	</#if>

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

<#-------------------------------------PPP: additions------------------------------------------------------------->
<#--1. Methods-->
<#macro toxNonHumanMethodPPP study>
	<#compress>

	<#-- General tox method characteristics-->
		<#if study.MaterialsAndMethods.hasElement("ObjectiveOfStudyPick") && study.MaterialsAndMethods.ObjectiveOfStudyPick?has_content>
			<para><emphasis role="bold">Objective: </emphasis><@com.picklistMultiple study.MaterialsAndMethods.ObjectiveOfStudyPick/></para>
		</#if>

	<#--Type of study-->
		<#if study.MaterialsAndMethods.hasElement("TypeOfStudy") && study.MaterialsAndMethods.TypeOfStudy?has_content>
			<para><emphasis role='bold'>Type of study: </emphasis><@com.picklist study.MaterialsAndMethods.TypeOfStudy/></para>
		<#elseif study.MaterialsAndMethods.hasElement("Studytype") && study.MaterialsAndMethods.Studytype?has_content>
			<para><emphasis role='bold'>Type of assay: </emphasis><@com.picklist study.MaterialsAndMethods.Studytype/></para>
		<#elseif study.MaterialsAndMethods.hasElement("TypeOfStudyInformation") && study.MaterialsAndMethods.TypeOfStudyInformation?has_content>
			<para><emphasis role='bold'>Type of information: </emphasis><@com.text study.MaterialsAndMethods.TypeOfStudyInformation/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("EndpointAddressed") && study.MaterialsAndMethods.EndpointAddressed?has_content>
			<para><emphasis role='bold'>Endpoint addressed: </emphasis><@com.picklistMultiple study.MaterialsAndMethods.EndpointAddressed/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("MethodType") && study.MaterialsAndMethods.MethodType?has_content>
			<para><emphasis role="bold">Method type: </emphasis><@com.picklist study.MaterialsAndMethods.MethodType/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("TestType") && study.MaterialsAndMethods.TestType?has_content>
			<para><emphasis role="bold">Test type: </emphasis><@com.value study.MaterialsAndMethods.TestType/></para>
		</#if>


		<#if study.MaterialsAndMethods.hasElement("LimitTest") && study.MaterialsAndMethods.LimitTest?has_content>
			<para><emphasis role="bold">Limit test: </emphasis><@com.picklist study.MaterialsAndMethods.LimitTest/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("JustificationForNonLLNAMethod") && study.MaterialsAndMethods.JustificationForNonLLNAMethod?has_content>
			<para><emphasis role="bold">Justification for non-LLNA method: </emphasis><@com.text study.MaterialsAndMethods.JustificationForNonLLNAMethod/></para>
		</#if>

	<#-- Test animals-->
		<#if study.MaterialsAndMethods.hasElement("TestAnimals") && study.MaterialsAndMethods.TestAnimals?has_content>
			<@methods_testAnimals study.MaterialsAndMethods.TestAnimals/>
		</#if>

	<#--Administration/exposure-->
		<#if study.MaterialsAndMethods.hasElement("AdministrationExposure") && study.MaterialsAndMethods.AdministrationExposure?has_content>
			<@methods_administrationExposure study.MaterialsAndMethods.AdministrationExposure/>
		</#if>

	<#--Test system-->
		<#if study.MaterialsAndMethods.hasElement("TestSystem") && study.MaterialsAndMethods.TestSystem?has_content>
			<#if study.documentSubType=="PhototoxicityVitro">
				<@methods_testSystemPhototox study.MaterialsAndMethods.TestSystem/>
			<#else>
				<@methods_testSystem study.MaterialsAndMethods.TestSystem/>
			</#if>
		</#if>

	<#--In vitro test system-->
		<#if study.MaterialsAndMethods.hasElement("InVitroTestSystem") && study.MaterialsAndMethods.InVitroTestSystem?has_content>
			<#if study.documentSubType=="SkinIrritationCorrosion">
				<@methods_inVitroIrritation study.MaterialsAndMethods.InVitroTestSystem/>
			<#elseif study.documentSubType=="SkinSensitisation">
				<@methods_inVitroSensitisation study.MaterialsAndMethods.InVitroTestSystem/>
			</#if>
		</#if>

	<#--In chemico test system (skin sensitisation)-->
		<#if study.MaterialsAndMethods.hasElement("InChemicoTestSystem") && study.MaterialsAndMethods.InChemicoTestSystem?has_content>
			<@methods_inChemico study.MaterialsAndMethods.InChemicoTestSystem/>
		</#if>

	<#--In vivo test system-->
		<#if study.MaterialsAndMethods.hasElement("InVivoTestSystem") && study.MaterialsAndMethods.InVivoTestSystem?has_content>
			<@methods_inVivo study.MaterialsAndMethods.InVivoTestSystem/>
		</#if>

	<#--Examinations-->
		<#if study.MaterialsAndMethods.hasElement("Examinations") && study.MaterialsAndMethods.Examinations?has_content>
			<@methods_examinations study.MaterialsAndMethods.Examinations/>
		</#if>

	<#--Method (genotox vitro)-->
		<#if study.MaterialsAndMethods.hasElement("Method") && study.MaterialsAndMethods.Method?has_content>
			<#if study.documentSubType=='GeneticToxicityVitro'>
				<@methods_methodGenotox study.MaterialsAndMethods.Method/>
			<#else>
				<@methods_method study.MaterialsAndMethods.Method/>
			</#if>
		</#if>

	</#compress>
</#macro>

<#macro toxHumanMethodPPP study>
	<#compress>

	<#--Type of study-->
		<#if study.MaterialsAndMethods.hasElement("TypeOfSensitisationStudied") && study.MaterialsAndMethods.TypeOfSensitisationStudied?has_content>
			<para><emphasis role='bold'>Type of sensitisation studied: </emphasis><@com.picklist study.MaterialsAndMethods.TypeOfSensitisationStudied/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("TypeOfStudy") && study.MaterialsAndMethods.TypeOfStudy?has_content>
			<para><emphasis role='bold'>Type of study: </emphasis><@com.picklist study.MaterialsAndMethods.TypeOfStudy/></para>
		<#elseif study.MaterialsAndMethods.hasElement("Studytype") && study.MaterialsAndMethods.Studytype?has_content>
			<para><emphasis role='bold'>Type of assay: </emphasis><@com.picklist study.MaterialsAndMethods.Studytype/></para>
		<#elseif study.MaterialsAndMethods.hasElement("TypeOfStudyInformation") && study.MaterialsAndMethods.TypeOfStudyInformation?has_content>
			<para><emphasis role='bold'>Type of information: </emphasis><@com.text study.MaterialsAndMethods.TypeOfStudyInformation/></para>
		</#if>

		<#if study.MaterialsAndMethods.hasElement("EndpointAddressed") && study.MaterialsAndMethods.EndpointAddressed?has_content>
			<para><emphasis role='bold'>Endpoint adressed: </emphasis><@com.picklistMultiple study.MaterialsAndMethods.EndpointAddressed/></para>
		</#if>

	<#--Method-->
		<#if study.MaterialsAndMethods.hasElement("Method") && study.MaterialsAndMethods.Method?has_content>
			<@methods_method study.MaterialsAndMethods.Method/>
		</#if>

	</#compress>
</#macro>

<#macro methods_testAnimals testAn subSection=false>
	<#compress>
		<para>
			<#if subSection>
				Test animals:
			<#else>
				<emphasis role="bold">Test animals:</emphasis>
			</#if>
		</para>

		<para role="indent">
			<@com.picklist testAn.Species/>
			<#if testAn.Strain?has_content>
				(<@com.picklist testAn.Strain/>)
			</#if>

			<#if testAn.hasElement("Sex") && testAn.Sex?has_content>
				, <@com.picklist testAn.Sex/>
			</#if>

			<#--			<#if testAn.hasElement("State") && testAn.State?has_content>-->
			<#--				, <@com.picklist testAn.Sex/>-->
			<#--			</#if>-->

			<#if testAn.hasElement("DetailsOnSpeciesStrainSelectio") && testAn.DetailsOnSpeciesStrainSelectio?has_content>
				- <@com.text testAn.DetailsOnSpeciesStrainSelectio/>
			<#elseif testAn.hasElement("DetailsOnSpeciesStrainSelection") && testAn.DetailsOnSpeciesStrainSelection?has_content>
				- <@com.text testAn.DetailsOnSpeciesStrainSelection/>
			</#if>
		</para>

		<#if testAn.hasElement("OrganismDetails") && testAn.OrganismDetails?has_content>
			<para role="indent">
				<@com.text testAn.OrganismDetails/>
			</para>
		</#if>

		<#if testAn.hasElement("DetailsOnTestAnimalsAndEnvironmentalConditions") && testAn.DetailsOnTestAnimalsAndEnvironmentalConditions?has_content>
			<para role="indent">
				<@com.text testAn.DetailsOnTestAnimalsAndEnvironmentalConditions/>
			</para>
		</#if>

	</#compress>
</#macro>

<#macro methods_administrationExposure admExp>
	<#compress>
		<para><emphasis role="bold">Administration / Exposure:</emphasis></para>

		<#if admExp.hasElement("RouteOfAdministration") && admExp.RouteOfAdministration?has_content>
			<para>Route of administration: <@com.picklist admExp.RouteOfAdministration/></para>
			<#if admExp.hasElement("DetailsOnRouteOfAdministration") && admExp.DetailsOnRouteOfAdministration?has_content>
				<para role="indent">
					<@com.text admExp.DetailsOnRouteOfAdministration/>
				</para>
			</#if>
		</#if>

		<#if admExp.hasElement("TypeOfCoverage") && admExp.TypeOfCoverage?has_content>
			<para>Type of coverage: <@com.picklist admExp.TypeOfCoverage/></para>
		</#if>

		<#if admExp.hasElement("TypeOfInhalationExposure") && admExp.TypeOfInhalationExposure?has_content>
			<para>Type of inhalation exposure: <@com.picklist admExp.TypeOfInhalationExposure/></para>
		</#if>

		<#--Cell culture conditions-->
		<#if admExp.hasElement("CellCultures") && admExp.CellCultures?has_content>
			<para>Cell culture: <@com.picklistMultiple admExp.CellCultures/></para>
		</#if>
		<#if admExp.hasElement("PlatingConditions") && admExp.PlatingConditions?has_content>
			<para>Plating conditions: <@com.text admExp.PlatingConditions/></para>
		</#if>
		<#if admExp.hasElement("IncubationConditions") && admExp.IncubationConditions?has_content>
			<para>Incubation conditions: <@com.text admExp.IncubationConditions/></para>
		</#if>

		<#--Vehicle-->
		<#if admExp.hasElement("Vehicle") && admExp.Vehicle?has_content>
			<para>Vehicle:
				<#if admExp.Vehicle?node_type=="picklist_single">
					<@com.picklist admExp.Vehicle/>
				<#else>
					<@com.text admExp.Vehicle/>
				</#if>
			</para>
		</#if>

		<#--Inhalation parameters-->
		<#if admExp.hasElement("MassMedianAerodynamicDiameter") && admExp.MassMedianAerodynamicDiameter?has_content>
			<para>Mass median aerodynamic diameter (MMAD): <@com.range admExp.MassMedianAerodynamicDiameter/></para>
		</#if>
		<#if admExp.hasElement("GeometricStandardDeviation") && admExp.GeometricStandardDeviation?has_content>
			<para>Geometric standard deviation (GSD): <@com.range admExp.GeometricStandardDeviation/></para>
		</#if>
		<#if admExp.hasElement("RemarksOnMMAD") && admExp.RemarksOnMMAD?has_content>
			<para>Remarks on MMAD/GSD:</para><para role="indent"><@com.text admExp.RemarksOnMMAD/></para>
        </#if>

		<#if admExp.hasElement("AnalyticalVerificationOfTestAtmosphereConcentrations") && admExp.AnalyticalVerificationOfTestAtmosphereConcentrations?has_content>
			<para>Analytical verification of test atmosphere concentrations: <@com.picklist admExp.AnalyticalVerificationOfTestAtmosphereConcentrations/></para>
		</#if>

		<#-- Details on exposure or similar -->
		<#if admExp.hasElement("DetailsOnExposure") && admExp.DetailsOnExposure?has_content>
			<para>Details on exposure: </para><para role="indent"><@com.text admExp.DetailsOnExposure/></para>
		<#elseif admExp.hasElement("DetailsOnDermalExposure") && admExp.DetailsOnDermalExposure?has_content>
			<para>Details on exposure: </para><para role="indent"><@com.text admExp.DetailsOnDermalExposure/></para>
		<#elseif admExp.hasElement("DetailsOnInhalationExposure") && admExp.DetailsOnInhalationExposure?has_content>
			<para>Details on exposure: </para><para role="indent"><@com.text admExp.DetailsOnInhalationExposure/></para>
		<#elseif admExp.hasElement("DetailsOnOralExposure") && admExp.DetailsOnOralExposure?has_content>
			<para>Details on exposure: </para><para role="indent"><@com.text admExp.DetailsOnOralExposure/></para>
		</#if>

		<#--Duration/Frequency-->
		<#if admExp.hasElement("DurationOfTreatmentExposure") && admExp.DurationOfTreatmentExposure?has_content>
			<para>Duration of treatment / exposure: <@com.text admExp.DurationOfTreatmentExposure/></para>
		</#if>
		<#if admExp.hasElement("FrequencyOfTreatment") && admExp.FrequencyOfTreatment?has_content>
			<para>Frequency: <@com.text admExp.FrequencyOfTreatment/></para>
		</#if>
		<#if admExp.hasElement("DurationAndFrequencyOfTreatmentExposure") && admExp.DurationAndFrequencyOfTreatmentExposure?has_content>
			<para>Duration and frequency of exposure: <@com.text admExp.DurationAndFrequencyOfTreatmentExposure/></para>
		</#if>
		<#if admExp.hasElement("DurationOfExposure") && admExp.DurationOfExposure?has_content>
			<para>Duration of exposure:
				<#if admExp.DurationOfExposure?node_type=="picklist_single">
					<@com.picklist admExp.DurationOfExposure/>
				<#elseif admExp.DurationOfExposure?node_type=="range">
					<@com.range admExp.DurationOfExposure/>
				<#else>
					<@com.text admExp.DurationOfExposure/>
				</#if>
			</para>

			<#if admExp.hasElement("RemarksOnDuration") && admExp.RemarksOnDuration?has_content>
				<para role="indent"><@com.text admExp.RemarksOnDuration/></para>
			</#if>
		</#if>
		<#if admExp.hasElement("DurationOfTest") && admExp.DurationOfTest?has_content>
			<para>Duration of test:</para><para role="indent"><@com.text admExp.DurationOfTest/></para>
		</#if>
		<#if admExp.hasElement("PostExposurePeriod") && admExp.PostExposurePeriod?has_content>
			<para>Post exposure period:</para><para role="indent"><@com.text admExp.PostExposurePeriod/></para>
		</#if>

		<#-- Doses concentrations -->
		<#if admExp.hasElement("DosesConcentrations") && admExp.DosesConcentrations?has_content>
			<para>Doses / concentrations:</para>
			<#if admExp.DosesConcentrations?node_type=="repeatable">
				<@DosesConcentrationsWithRemarksList admExp.DosesConcentrations/>
			<#--						<@keyTox.DosesConcentrationsList admExp.DosesConcentrations/>-->
			<#else>
				<para role="indent"><@com.value admExp.DosesConcentrations/></para>
			</#if>

		</#if>
		<#if admExp.hasElement("Doses") && admExp.Doses?has_content>
			<para>Doses:</para><para role="indent"><@com.text admExp.Doses/></para>
		</#if>
		<#if admExp.hasElement("Concentrations") && admExp.Concentrations?has_content>
			<para>Concentrations:</para><para role="indent"><@com.text admExp.Concentrations/></para>
		</#if>

		<#if admExp.hasElement("AnalyticalVerificationOfDosesOrConcentrations") && admExp.AnalyticalVerificationOfDosesOrConcentrations?has_content>
			<para>Analytical verification of doses / concentrations: <@com.picklist admExp.AnalyticalVerificationOfDosesOrConcentrations/></para>
			<#if admExp.hasElement("DetailsOnAnalyticalVerificationOfDosesOrConcentrations") && admExp.DetailsOnAnalyticalVerificationOfDosesOrConcentrations?has_content>
				<para role="indent"><@com.text admExp.DetailsOnAnalyticalVerificationOfDosesOrConcentrations/></para>
			</#if>
		</#if>

		<#--Assays-->
		<#if admExp.hasElement("Assays") && admExp.Assays?has_content>
			<para>Assays:</para>
			<@assaysList admExp.Assays/>
		</#if>

		<#-- Animals -->
		<#if admExp.hasElement("NoOfAnimalsPerSexPerDose") && admExp.NoOfAnimalsPerSexPerDose?has_content>
			<para>No. of animals per sex per dose / concentration:</para><para role="indent"><@com.text admExp.NoOfAnimalsPerSexPerDose/></para>
		</#if>
		<#if admExp.hasElement("NoOfAnimalsPerGroup") && admExp.NoOfAnimalsPerGroup?has_content>
			<para>No. of animals per group: </para><para role="indent"><@com.text admExp.NoOfAnimalsPerGroup/></para>
		</#if>
		<#if admExp.hasElement("DetailsOnMatingProcedure") && admExp.DetailsOnMatingProcedure?has_content>
			<para>Mating procedure:</para><para role="indent"><@com.text admExp.DetailsOnMatingProcedure/></para>
		</#if>
		<#if admExp.hasElement("ControlAnimal") && admExp.ControlAnimal?has_content>
			<para>Control animals:</para><para role="indent"><@com.value admExp.ControlAnimal/></para>
		<#elseif admExp.hasElement("ControlAnimals") && admExp.ControlAnimals?has_content>
			<para>Control animals:</para><para role="indent"><@com.value admExp.ControlAnimals/></para>
		<#elseif admExp.hasElement("Controls") && admExp.Controls?has_content>
			<para>Controls:</para><para role="indent"><@com.text admExp.Controls/></para>
		</#if>
		<#if admExp.hasElement("PositiveControl") && admExp.PositiveControl?has_content>
			<para>Positive control:</para><para role="indent"><@com.text admExp.PositiveControl/></para>
		</#if>

		<#-- Details-->
		<#if admExp.hasElement("OtherTreatments") && admExp.OtherTreatments?has_content>
			<para>Other treatments:</para><para role="indent"><@com.text admExp.OtherTreatments/></para>
		</#if>

		<#if admExp.hasElement("DetailsOnStudyDesign") && admExp.DetailsOnStudyDesign?has_content>
			<para>Study design:</para><para role="indent"><@com.text admExp.DetailsOnStudyDesign/></para>
		</#if>

		<#if admExp.hasElement("DetailsOnStudySchedule") && admExp.DetailsOnStudySchedule?has_content>
			<para>Study schedule:</para><para role="indent"><@com.text admExp.DetailsOnStudySchedule/></para>
		</#if>

		<#if admExp.hasElement("DetailsOnDosingAndSampling") && admExp.DetailsOnDosingAndSampling?has_content>
			<para>Dosing / sampling:</para><para role="indent"><@com.text admExp.DetailsOnDosingAndSampling/></para>
		</#if>

		<#if admExp.hasElement("DetailsOnInVitroTestSystemIfApplicable") && admExp.DetailsOnInVitroTestSystemIfApplicable?has_content>
			<para>In vitro test system:</para><para role="indent"><@com.text admExp.DetailsOnInVitroTestSystemIfApplicable/></para>
		</#if>

		<#if admExp.hasElement("Statistics") && admExp.Statistics?has_content>
			<para>Statistics:</para><para role="indent"><@com.text admExp.Statistics/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_examinations exam>
	<#compress>
		<para><emphasis role="bold">Examinations:</emphasis></para>

		<#list exam?children as child>
			<#if child?has_content>
				<para>${child?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}:</para><para role="indent"><@com.text child/></para>
			</#if>
		</#list>
	</#compress>
</#macro>

<#macro methods_methodGenotox method>
	<#compress>
		<para><emphasis role="bold">Method:</emphasis></para>

		<#if method.TargetGene?has_content><para>Target gene:</para><para role="indent"><@com.text method.TargetGene/></para></#if>
		<#if method.SpeciesStrain?has_content>
			<para>Species / strain:</para> <@speciesStrainMethodList method.SpeciesStrain/>
		</#if>

		<#if method.CytokinesisBlockIfUsed?has_content><para>Cytokinesis block: </para><para role="indent"><@com.text method.CytokinesisBlockIfUsed /></para></#if>
		<#if method.MetabolicActivation?has_content><para>Metabolic activation: <@com.picklist method.MetabolicActivation/></para>
			<#if method.MetabolicActivationSystem?has_content><para role="indent"><@com.text method.MetabolicActivationSystem/></para></#if>
		</#if>

		<#if method.TestConcentrationsWithJustificationForTopDose?has_content><para role="indent">Doses:</para><para role="indent"><@com.text method.TestConcentrationsWithJustificationForTopDose/></para></#if>
		<#if method.Vehicle?has_content><para role="indent">Vehicle: </para><para role="indent"><@com.text method.Vehicle/></para></#if>

		<#if method.Controls?has_content>
			<para>Controls:</para> <@controlsList method.Controls/>
		</#if>

		<#if method.DetailsOnTestSystemAndConditions?has_content><para>Test conditions:</para><para role="indent"><@com.text method.DetailsOnTestSystemAndConditions/></para>
			<#if method.RationaleForTestConditions?has_content><para role="indent2"><@com.text method.RationaleForTestConditions/></para></#if>
		</#if>

		<#if method.EvaluationCriteria?has_content><para>Evaluation criteria:</para><para role="indent"><@com.text method.EvaluationCriteria/></para></#if>
		<#if method.Statistics?has_content><para role="indent">Statistics:</para><para role="indent"><@com.text method.Statistics/></para></#if>

	</#compress>
</#macro>

<#macro methods_method method>
	<#compress>

		<#--specific for Medical data docs-->

		<para><emphasis role="bold">Method:</emphasis></para>
		<#if method.hasElement("TypeOfPopulation") && method.TypeOfPopulation?has_content>
			<para>Type of population:<@com.picklistMultiple method.TypeOfPopulation/></para>
		</#if>
		<#if method.hasElement("Subjects") && method.Subjects?has_content>
			<para>Subjects: </para><para role="indent"><@com.text method.Subjects/></para>
		</#if>
		<#if method.hasElement("Controls") && method.Controls?has_content>
			<para>Controls: </para><para role="indent"><@com.text method.Controls/></para>
		</#if>
		<#if method.hasElement("EthicalApproval") && method.EthicalApproval?has_content>
			<para>Ethical approval: <@com.picklist method.EthicalApproval/></para>
		</#if>
		<#if method.hasElement("DetailsOnStudyDesign") && method.DetailsOnStudyDesign?has_content>
			<para>Details on study design: </para><para role="indent"><@com.text method.DetailsOnStudyDesign/></para>
		</#if>
		<#if method.hasElement("RouteOfExposure") && method.RouteOfExposure?has_content>
			<para>Route of exposure: <@com.picklistMultiple method.RouteOfExposure/></para>
		</#if>
		<#if method.hasElement("RouteOfAdministration") && method.RouteOfAdministration?has_content>
			<para>Route of administration: <@com.picklist method.RouteOfAdministration/></para>
		</#if>
		<#if method.hasElement("ReasonOfExposure") && method.ReasonOfExposure?has_content>
			<para>Reason: <@com.picklist method.ReasonOfExposure/></para>
		</#if>
		<#if method.hasElement("ExposureAssessment") && method.ExposureAssessment?has_content>
			<para>Exposure assessment: <@com.picklist method.ExposureAssessment/></para>
			<#if method.hasElement("DetailsOnExposure") && method.DetailsOnExposure?has_content>
				<para role="indent"><@com.text method.DetailsOnExposure/></para>
			</#if>
		</#if>
		<#if method.hasElement("ClinicalHistory") && method.ClinicalHistory?has_content>
			<para>Clinical history: </para><para role="indent"><@com.text method.ClinicalHistory/></para>
		</#if>
		<#if method.hasElement("Examinations") && method.Examinations?has_content>
			<para>Examinations: </para><para role="indent"><@com.text method.Examinations/></para>
		</#if>
		<#if method.hasElement("MedicalTreatment") && method.MedicalTreatment?has_content>
			<para>Medical treatment: </para><para role="indent"><@com.text method.MedicalTreatment/></para>
		</#if>
		<#if method.hasElement("StatisticalMethods") && method.StatisticalMethods?has_content>
			<para>Statistics: </para><para role="indent"><@com.text method.StatisticalMethods/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_testSystem testSys>
	<#-- Used in skin irritation, eye irritation-->
	<#compress>
		<para><emphasis role="bold">Test system:</emphasis></para>

		<#if testSys.hasElement("TypeOfCoverage") && testSys.TypeOfCoverage?has_content>
			<para>Type of coverage: <@com.picklist testSys.TypeOfCoverage/></para>
		</#if>

		<#if testSys.hasElement("PreparationOfTestSite") && testSys.PreparationOfTestSite?has_content>
			<para>Preparation of test site: <@com.picklist testSys.PreparationOfTestSite/></para>
		</#if>

		<#--Controls-->
		<#if testSys.Controls?has_content>
			<para>Controls: <@com.picklistMultiple testSys.Controls/></para>
		</#if>

		<#--Vehicle-->
		<#if testSys.Vehicle?has_content>
			<para>Vehicle: <@com.picklist testSys.Vehicle/></para>
		</#if>

		<#-- Doses concentrations (name has _list appended)-->
		<#if testSys.AmountConcentrationApplied?has_content>
			<para>Doses: </para><para role="indent"><@com.text testSys.AmountConcentrationApplied/></para>
		</#if>

		<#--Duration/Frequency-->
		<#if testSys.hasElement("DurationOfTreatmentExposure") && testSys.DurationOfTreatmentExposure?has_content>
			<para>Duration: </para><para role="indent"><@com.text testSys.DurationOfTreatmentExposure/></para>
		</#if>
		<#if testSys.ObservationPeriod?has_content>
			<para>Observation period: </para><para role="indent"><@com.text testSys.ObservationPeriod/></para>
		</#if>
		<#if testSys.hasElement("DurationOfPostTreatmentIncubationInVitro") && testSys.DurationOfPostTreatmentIncubationInVitro?has_content>
			<para>Duration of post-treatment incubation (in vitro): </para><para role="indent"><@com.text testSys.DurationOfPostTreatmentIncubationInVitro/></para>
		</#if>

		<#--No animals-->
		<#if testSys.NumberOfAnimals?has_content>
			<para role="indent">No. of animals / in-vitro replicates: <@com.text testSys.NumberOfAnimals/></para>
		</#if>

		<#--Details-->
		<#if testSys.DetailsOnStudyDesign?has_content>
			<para>Details on study design: </para><para role="indent"><@com.text testSys.DetailsOnStudyDesign/></para>
		</#if>
	</#compress>
</#macro>

<#macro methods_testSystemPhototox testSys>
	<#compress>
		<para><emphasis role="bold">Test system:</emphasis></para>

		<#--Species-->
		<#if testSys.SpeciesStrain?has_content>
			<para>Species / strain / cell type:</para><@speciesStrainMethodList testSys.SpeciesStrain/>
		</#if>

		<#--Controls-->
		<#if testSys.Controls?has_content>
			<para>Controls: </para><@controlsList testSys.Controls/>
		</#if>

		<#--Vehicle-->
		<#if testSys.Vehicle?has_content>
			<para>Vehicle: <@com.picklist testSys.Vehicle/></para>
		</#if>
		<#if testSys.VehicleSolvent?has_content>
			<para>Vehicle / solvent: </para><para role="indent"><@com.text testSys.VehicleSolvent/></para>
		</#if>

		<#--Other-->
		<#if testSys.TestSystemExpConditions?has_content>
			<para>Details on test system and experimental conditions:</para><para role="indent"><@com.text testSys.TestSystemExpConditions/></para>
		</#if>
		<#if testSys.EvaluationCriteria?has_content>
			<para>Evaluation criteria: </para><para role="indent"><@com.text testSys.EvaluationCriteria/></para>
		</#if>
		<#if testSys.Statistics?has_content>
			<para>Statistics: </para><para role="indent"><@com.text testSys.Statistics/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_inVitroIrritation vitroSys>
	<#compress>
		<para><emphasis role="bold">In vitro test system:</emphasis></para>

		<#--Test system-->
		<#if vitroSys.TestSystem?has_content>
			<para>Test system: <@com.picklist vitroSys.TestSystem/></para>
			<#if vitroSys.DetailsOnTestSystem?has_content>
				<para role="indent"><@com.text vitroSys.DetailsOnTestSystem/></para>
			</#if>
			<#if vitroSys.JustificationForTestSystemUsed?has_content>
				<para role="indent">Justification: <@com.text vitroSys.JustificationForTestSystemUsed/></para>
			</#if>
		</#if>

		<#--Species and cell type -->
		<#if vitroSys.SourceSpecies?has_content>
			<para>Source species: <@com.picklist vitroSys.SourceSpecies/>
				<#if vitroSys.SourceStrain?has_content>
					(<@com.picklist vitroSys.SourceStrain/>)
				</#if>
			</para>
			<#if vitroSys.DetailsOnAnimalUsedAsSourceOfTestSystem?has_content>
				<para role="indent"><@com.text vitroSys.DetailsOnAnimalUsedAsSourceOfTestSystem/></para>
			</#if>
		</#if>

		<#if vitroSys.CellType?has_content>
			<para>Cell type: <@com.picklist vitroSys.CellType/>
				<#if vitroSys.CellSource?has_content>
					from <@com.picklist vitroSys.CellSource/>
				</#if>
			</para>
		</#if>

		<#--Vehicle-->
		<#if vitroSys.Vehicle?has_content>
			<para>Vehicle: <@com.picklist vitroSys.Vehicle/></para>
		</#if>

		<#if vitroSys.ControlSamples?has_content>
			<para>Control samples: <@com.picklistMultiple vitroSys.ControlSamples/></para>
		</#if>

		<#--Treatment-->
		<#if vitroSys.AmountConcentrationApplied?has_content>
			<para>Doses: </para><para role="indent"><@com.text vitroSys.AmountConcentrationApplied/></para>
		</#if>
		<#if vitroSys.DurationOfTreatmentExposure?has_content>
			<para>Duration:</para><para role="indent"><@com.text vitroSys.DurationOfTreatmentExposure/></para>
		</#if>
		<#if vitroSys.DurationOfPostTreatmentIncubationIfApplicable?has_content>
			<para>Duration of post-treatment incubation: </para><para role="indent"><@com.text vitroSys.DurationOfPostTreatmentIncubationIfApplicable/></para>
		</#if>

		<#if vitroSys.NumberOfReplicates?has_content>
			<para>No. of replicates: </para><para role="indent"><@com.text vitroSys.NumberOfReplicates/></para>
		</#if>
	</#compress>
</#macro>

<#macro methods_inVitroSensitisation vitroSys>
	<#compress>
		<para><emphasis role="bold">In vitro test system:</emphasis></para>

	<#--Test system-->
		<#if vitroSys.DetailsTestSystem?has_content>
			<para>Test system: <@com.picklist vitroSys.DetailsTestSystem/></para>
		</#if>

	<#--Controls-->
		<#if vitroSys.VehicleSolventControl?has_content>
			<para>Vehicle / solvent control: <@com.picklist vitroSys.VehicleSolventControl/></para>
		</#if>
		<#if vitroSys.NegativeControl?has_content>
			<para>Negative control: <@com.picklist vitroSys.NegativeControl/></para>
		</#if>
		<#if vitroSys.control?has_content>
			<para>Positive control: <@com.picklist vitroSys.control/></para>
		</#if>

		<#if vitroSys.DetailsOnStudyDesign?has_content>
			<para>Details on study design: </para><para role="indent"><@com.text vitroSys.DetailsOnStudyDesign/></para>
		</#if>
	</#compress>
</#macro>

<#macro methods_inVivo vivoSys>
<#--	skin sensitisation-->
	<#compress>
		<para><emphasis role="bold">In vivo test system:</emphasis></para>

	<#--Test animals-->
		<#if vivoSys.TestAnimals?has_content>
			<@methods_testAnimals vivoSys.TestAnimals true/>
		</#if>

	<#--NonLLNA-->
		<#if vivoSys.StudyDesignInVivoNonLLNA?has_content>
			<@methods_inVivoNonLLNA vivoSys.StudyDesignInVivoNonLLNA />
		</#if>

	<#--LLNA-->
		<#if vivoSys.StudyDesignInVivoLLNA?has_content >
			<@methods_inVivoLLNA vivoSys.StudyDesignInVivoLLNA />
		</#if>
	</#compress>
</#macro>

<#macro methods_inVivoLLNA llna>
	<#compress>
		<para>Study design: LLNA</para>

		<#if llna.Vehicle?has_content>
			<para role="indent">Vehicle: <@com.picklist llna.Vehicle/></para>
		</#if>
		<#if llna.Concentration?has_content>
			<para role="indent">Concentration: <@com.text llna.Concentration/></para>
		</#if>
		<#if llna.NoOfAnimalsPerDose?has_content>
			<para role="indent">No animals per dose: <@com.text llna.NoOfAnimalsPerDose/></para>
		</#if>
		<#if llna.PositiveControlSubstances?has_content>
			<para role="indent">Positive control substances: <@com.picklistMultiple llna.PositiveControlSubstances/></para>
		</#if>
		<#if llna.DetailsOnStudyDesign?has_content>
			<para role="indent">Details on study design: <@com.text llna.DetailsOnStudyDesign/></para>
		</#if>
		<#if llna.Statistics?has_content>
			<para role="indent">Statistics: <@com.text llna.Statistics/></para>
		</#if>
	</#compress>
</#macro>

<#macro methods_inVivoNonLLNA nonllna>
	<#compress>
		<para>Study design: non-LLNA</para>

		<#if nonllna.Induction?has_content>
			<para role="indent">Induction:</para>
			<@InductionChallengeList nonllna.Induction "indent2"/>
		</#if>

		<#if nonllna.Challenge?has_content>
			<para role="indent">Challenge:</para>
			<@InductionChallengeList nonllna.Challenge "indent2"/>
		</#if>

		<#if nonllna.NoOfAnimalsPerDose?has_content>
			<para role="indent">No animals per dose: <@com.text nonllna.NoOfAnimalsPerDose/></para>
		</#if>
		<#if nonllna.PositiveControlSubstances?has_content>
			<para role="indent">Positive control substances: <@com.picklist nonllna.PositiveControlSubstances/></para>
		</#if>
		<#if nonllna.ChallengeControls?has_content>
			<para role="indent">Challenge controls: <@com.text nonllna.ChallengeControls/></para>
		</#if>
		<#if nonllna.DetailsOnStudyDesign?has_content>
			<para role="indent">Details on study design: <@com.text nonllna.DetailsOnStudyDesign/></para>
		</#if>

	</#compress>
</#macro>

<#macro methods_inChemico chemSys>
<#--skin sensitisation-->
	<#compress>
		<para><emphasis role="bold">In chemico test system:</emphasis></para>

		<#if chemSys.DetailsTestSystem?has_content>
			<para>Test system: <@com.picklistMultiple chemSys.DetailsTestSystem/></para>
		</#if>

		<#if chemSys.VehicleSolvent?has_content>
			<para>Vehicle / solvent: <@com.picklist chemSys.VehicleSolvent/></para>
		</#if>

		<#if chemSys.PositiveControl?has_content>
			<para>Positive control: <@com.picklist chemSys.PositiveControl/></para>
		</#if>

		<#if chemSys.DetailsOnStudyDesign?has_content>
			<para>Details on study design: </para><para role="indent"><@com.text chemSys.DetailsOnStudyDesign/></para>
		</#if>

	</#compress>
</#macro>

<#macro InductionChallengeList InductionChallengeRepeatableBlock role="indent">
	<#compress>
		<#if InductionChallengeRepeatableBlock?has_content>
			<#list InductionChallengeRepeatableBlock as blockItem>
				<para role = "${role}">
					<#if blockItem.hasElement("No") && blockItem.No?has_content>
						<@com.picklist blockItem.No/>.
					</#if>
					Route: <@com.picklist blockItem.Route/>.
					Vehicle: <@com.picklist blockItem.Vehicle/>.
					<#if blockItem.ConcentrationAmount?has_content>
						Conc.: <@com.text blockItem.ConcentrationAmount/>.
					</#if>
					<#if blockItem.DaySDuration?has_content>
						Duration: <@com.text blockItem.DaySDuration/>.
					</#if>
					<#if blockItem.hasElement("AdequacyOfInduction") && blockItem.AdequacyOfInduction?has_content>
						Adequacy: <@com.picklist blockItem.AdequacyOfInduction/>.
					<#elseif blockItem.hasElement("AdequacyOfChallenge") && blockItem.AdequacyOfChallenge?has_content>
						Adequacy: <@com.picklist blockItem.AdequacyOfChallenge/>.
					</#if>
				</para>

			</#list>
		</#if>
	</#compress>
</#macro>

<#--There is an existing macro in keyTOX but combines different elements in that case-->
<#macro speciesStrainMethodList speciesStrainRepeatableBlock role="indent">
	<#compress>
		<#if speciesStrainRepeatableBlock?has_content>
			<#list speciesStrainRepeatableBlock as blockItem>
				<para role="${role}">
					<#if blockItem.hasElement("SpeciesStrain") && blockItem.SpeciesStrain?has_content>
						<@com.picklist blockItem.SpeciesStrain/>
					<#elseif blockItem.hasElement("SpeciesStrainCell") && blockItem.SpeciesStrainCell?has_content>
						<@com.picklist blockItem.SpeciesStrainCell/>
					</#if>

					<#if blockItem.hasElement("AdditionalStrainCharacteristics") && blockItem.AdditionalStrainCharacteristics?has_content>
						(<@com.picklist blockItem.AdditionalStrainCharacteristics/>)
					</#if>

					<#if blockItem.hasElement("MammalianCellDetails") && blockItem.MammalianCellDetails?has_content>
						- <@com.text blockItem.MammalianCellDetails/>
					<#elseif blockItem.hasElement("DetailsOnMammalianCellLinesIfApplicable") && blockItem.DetailsOnMammalianCellLinesIfApplicable?has_content>
						- <@com.text blockItem.DetailsOnMammalianCellLinesIfApplicable/>
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--Same as above-->
<#macro controlsList controlRepeatableBlock role="indent">
	<#compress>
		<#if controlRepeatableBlock?has_content>
			<#list controlRepeatableBlock as blockItem>
				<para role="${role}">
					Negative: <@com.picklist blockItem.NegativeControls/>.
					<#if blockItem.hasElement("SolventControls") && blockItem.SolventControls?has_content>
						Solvent/vehicle controls: <@com.picklist blockItem.SolventControls/>.
					</#if>
					<#if blockItem.hasElement("TrueNegativeControls") && blockItem.TrueNegativeControls?has_content>
						True negative controls: : <@com.picklist blockItem.TrueNegativeControls/>.
					</#if>

					<?linebreak?>

					Positive: <@com.picklist blockItem.PositiveControls/>
					<#if blockItem.PositiveControls?has_content>
					<#if blockItem.hasElement("PositiveControlSubstance") && blockItem.PositiveControlSubstance?has_content>
						(<@com.picklist blockItem.PositiveControlSubstance/>)
					</#if>
					</#if>.<?linebreak?>

					<#if blockItem.Remarks?has_content>
						Remarks: <@com.text blockItem.Remarks/>
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--2. Results-->

<#--These three macros are changed with respect to the original; however probably some table format would be better-->
<#macro inVivoLLNAList_ inVivoLLNARepeatableBlock role="indent">
	<#compress>
		<#if inVivoLLNARepeatableBlock?has_content>
			<#list inVivoLLNARepeatableBlock as blockItem>
				<para role="${role}">
					<#local parameter><@com.picklist blockItem.Parameter /></#local>
					<#if parameter=="SI">
						<#local parameter = "Stimulation index" />
					</#if>
					${parameter} = <@com.range blockItem.Value/>
					<#if blockItem.Variability?has_content>
						(var: <@com.text blockItem.Variability/>)
					</#if>
					<#if blockItem.TestGroupRemarks?has_content>
						<?linebreak?>(<@com.text blockItem.TestGroupRemarks/>)
					</#if>
					<#if blockItem.RemarksOnResults?has_content>
						<?linebreak?>(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro inVitroLLNAList_ inVivoLLNARepeatableBlock role="indent">
	<#compress>
		<#if inVivoLLNARepeatableBlock?has_content>
			<#list inVivoLLNARepeatableBlock as blockItem>
				<para role="${role}">
					<#if blockItem.RunExperiment?has_content>
						<@com.picklist blockItem.RunExperiment/>:
					</#if>
					<@com.picklist blockItem.Parameter /> = <@com.quantity blockItem.Value/>
					<#if blockItem.AtConcentration?has_content>
						at concentration of <@com.quantity blockItem.AtConcentration/>
					</#if>
					.<?linebreak?>

					<#local info=[]/>
					<#if blockItem.Group?has_content>
						<#local group><@com.picklist blockItem.Group/></#local>
						<#local info = info + [group]/>
					</#if>
					<#if blockItem.VehicleControlsValid?has_content>
						<#local veh>vehicle control: <@com.picklist blockItem.VehicleControlsValid/></#local>
						<#local info = info + [veh]/>
					</#if>
					<#if blockItem.PositiveControlsValid?has_content>
						<#local pos>pos. control: <@com.picklist blockItem.PositiveControlsValid/></#local>
						<#local info = info + [pos]/>
					</#if>
					<#if blockItem.NegativeControlsValid?has_content>
						<#local neg>neg. control: <@com.picklist blockItem.NegativeControlsValid/></#local>
						<#local info = info + [neg]/>
					</#if>
					<#if info?has_content>(${info?join("; ")})<?linebreak?></#if>

					<#if blockItem.CellViability?has_content>
						<?linebreak?>(<@com.text blockItem.CellViability/>)
					</#if>

					<#if blockItem.RemarksOnResults?has_content>
						<?linebreak?>(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro inVivoNonLLNAList_ inVivoNonLLNARepeatableBlock role="indent">
	<#compress>
		<#if inVivoNonLLNARepeatableBlock?has_content>
			<#list inVivoNonLLNARepeatableBlock as blockItem>
				<para role="${role}">
					<#if blockItem.Reading?has_content>
						<@com.picklist blockItem.Reading/>:
					</#if>
					<#if blockItem.NoWithReactions?has_content>
						<@com.number blockItem.NoWithReactions/> positive reactions
					</#if>
					<#if blockItem.TotalNoInGroup?has_content>
						out of <@com.number blockItem.TotalNoInGroup/>
					</#if>
					.<?linebreak?>
					<#local info=[]/>
					<#if blockItem.Group?has_content>
						<#local group><@com.picklist blockItem.Group/></#local>
						<#local info = info + [group]/>
					</#if>
					<#if blockItem.HoursAfterChallenge?has_content>
						<#local hours><@com.number blockItem.HoursAfterChallenge/>h after challenge</#local>
						<#local info = info + [hours]/>
					</#if>
					<#if blockItem.DoseLevel?has_content>
						<#local dose>dose: <@com.text blockItem.DoseLevel/></#local>
						<#local info = info + [dose]/>
					</#if>
					<#if info?has_content>(${info?join("; ")})<?linebreak?></#if>

					<#if blockItem.ClinicalObservations?has_content>
						clinical observations: <@com.text blockItem.ClinicalObservations/><?linebreak?>
					</#if>

					<#if blockItem.RemarksOnResults?has_content>
						(<@com.picklist blockItem.RemarksOnResults/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--Also this macro covers all genotox studies in one, and improves the layout-->
<#macro TestResultsList_ TestResultsRepeatableBlock>
	<#compress>
		<#if TestResultsRepeatableBlock?has_content>
			<#list TestResultsRepeatableBlock as blockItem>
				<#local genotoxicity><@com.picklist blockItem.Genotoxicity/></#local>
				<#local organism><#if blockItem.hasElement("Organism")><@com.picklist blockItem.Organism/></#if></#local>
				<#local sex><#if blockItem.hasElement("Sex")><@com.picklist blockItem.Sex/></#if></#local>
				<#local metActIndicator><#if blockItem.hasElement("MetActIndicator")><@com.picklist blockItem.MetActIndicator/></#if></#local>
				<#local cytotoxicity><#if blockItem.hasElement("Cytotoxicity")><@com.picklist blockItem.Cytotoxicity/></#if></#local>
				<#local toxicity><#if blockItem.hasElement("Toxicity")><@com.picklist blockItem.Toxicity/></#if></#local>

				<#local vehContrValid><#if blockItem.VehContrValid?has_content>Vehicle: <@com.picklist blockItem.VehContrValid/>. </#if></#local>
				<#local negContrValid><#if blockItem.NegContrValid?has_content>Negative: <@com.picklist blockItem.NegContrValid/>. </#if></#local>
				<#local posContrValid><#if blockItem.PosContrValid?has_content>Positive: <@com.picklist blockItem.PosContrValid/>. </#if></#local>
				<#local truenegContrValid><#if blockItem.hasElement("TrueNegativeControlsValidity") && blockItem.TrueNegativeControlsValidity?has_content>True negative: <@com.picklist blockItem.TrueNegativeControlsValidity/>. </#if></#local>

				<#local remarks><#if blockItem.hasElement("RemarksOnResults")><@com.picklist blockItem.RemarksOnResults/></#if></#local>

				<#if genotoxicity?has_content || cytotoxicity?has_content || toxicity?has_content>
					<para role="indent">
						<#if organism?has_content>For ${organism}: </#if>

						<#if genotoxicity?has_content>Genotoxicity: ${genotoxicity}.</#if>
						<#if cytotoxicity?has_content>Cytotoxicity: ${cytotoxicity}.</#if>
						<#if toxicity?has_content>Toxicity: ${toxicity}.</#if>

						<#if metActIndicator?has_content && metActIndicator!="not specified" && metActIndicator!="not applicable">
							<?linebreak?>(${metActIndicator} metabolic activation)
						</#if>

						<#if sex?has_content>
							<?linebreak?>(Sex: ${sex})
						</#if>

						<#if vehContrValid?has_content || posContrValid?has_content || negContrValid?has_content || truenegContrValid?has_content>
							<?linebreak?>Controls: ${vehContrValid}${negContrValid}${truenegContrValid}${posContrValid}
						</#if>

						<#if remarks?has_content>
							<?linebreak?>Remarks: ${remarks}
						</#if>
					</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--Results subsections-->
<#--macrotised-->
<#macro results_basicToxicokinetics study>
	<#compress>
	<#--		PreliminaryStudies-->
		<#if study.ResultsAndDiscussion.PreliminaryStudies?has_content>
			<para>Preliminary studies: </para><para role="indent"><@com.text study.ResultsAndDiscussion.PreliminaryStudies/></para>
		</#if>

		<#if study.ResultsAndDiscussion.MainAdmeResults?has_content>
			<para>Main ADME results: </para><@ADMEList study.ResultsAndDiscussion.MainAdmeResults/>
		</#if>

		<#if study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnAbsorption?has_content>
			<para>Absorption:</para><para role="indent"><@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnAbsorption/></para>
		</#if>

		<#if study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnDistribution?has_content>
			<para>Distribution: </para><para role="indent"><@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnDistribution/></para>
		</#if>

		<#if study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnExcretion?has_content>
			<para>Excretion: </para><para role="indent"><@com.text study.ResultsAndDiscussion.PharmacokineticStudies.DetailsOnExcretion/></para>
		</#if>

		<#if study.ResultsAndDiscussion.PharmacokineticStudies.TransferIntoOrgans?has_content>
			<para>Transfer into organs:</para><@TransferList study.ResultsAndDiscussion.PharmacokineticStudies.TransferIntoOrgans/>
		</#if>

		<#if study.ResultsAndDiscussion.PharmacokineticStudies.ToxicokineticParameters?has_content>
			<para>Toxicokinetic parameters: </para><@ToxicokineticParametersList study.ResultsAndDiscussion.PharmacokineticStudies.ToxicokineticParameters/>
		</#if>

		<#if study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.MetabolitesIdentified?has_content || study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.DetailsOnMetabolites?has_content >
			<para>Metabolites identified: <@com.picklist study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.MetabolitesIdentified/></para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.MetaboliteCharacterisationStudies.DetailsOnMetabolites/></para>
		</#if>

		<#if study.ResultsAndDiscussion.EnzymaticActivity.EnzymaticActivityMeasured?has_content>
			<para>Enzymatic activity: </para><para role="indent"><@com.text study.ResultsAndDiscussion.EnzymaticActivity.EnzymaticActivityMeasured/></para>
		</#if>

		<#if study.ResultsAndDiscussion.Bioaccessibility.BioaccessibilityTestingResults?has_content>
			<para>Bioaccessibility (or Bioavailability):</para><para role="indent"><@com.text study.ResultsAndDiscussion.Bioaccessibility.BioaccessibilityTestingResults/></para>
		</#if>

	</#compress>
</#macro>

<#macro results_acuteToxicity study>
	<#compress>
		<#if study.ResultsAndDiscussion.hasElement("Preliminary") && study.ResultsAndDiscussion.Preliminary?has_content>
			<para>Preliminary study: </para><para role="indent"><@com.text study.ResultsAndDiscussion.Preliminary/></para>
		</#if>

		<#if study.ResultsAndDiscussion.EffectLevels?has_content>
			<para>Effect levels:</para>
            <para role="indent"><@EffectLevelsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels)/></para>
		</#if>

		<#if study.ResultsAndDiscussion.Mortality?has_content>
			<para>Mortality: </para><para role="indent"><@com.text study.ResultsAndDiscussion.Mortality/></para>
		</#if>

		<#if study.ResultsAndDiscussion.ClinicalSigns?has_content>
			<para>Clinical signs: </para>
			<para role="indent">
				<@com.value study.ResultsAndDiscussion.ClinicalSigns/>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.BodyWeight?has_content>
			<para>Body weight: </para><para role="indent"><@com.value study.ResultsAndDiscussion.BodyWeight/></para>
		</#if>

		<#if study.ResultsAndDiscussion.GrossPathology?has_content>
			<para>Gross pathology: </para><para role="indent"><@com.text study.ResultsAndDiscussion.GrossPathology/></para>
		</#if>

		<#if study.ResultsAndDiscussion.OtherFindings?has_content>
			<para>Other findings: </para><para role="indent"><@com.text study.ResultsAndDiscussion.OtherFindings/></para>
		</#if>
	</#compress>
</#macro>

<#macro results_skinIrritation study>
	<#compress>

	<#--In vitro
    NOTE: missing vehicle and negative controls of effect-->
		<#if study.ResultsAndDiscussion.InVitro.Results?has_content>
			<para><@inVitroList study.ResultsAndDiscussion.InVitro.Results/></para>
		</#if>

		<#if study.ResultsAndDiscussion.InVitro.OtherEffectsAcceptanceOfResults?has_content>
			<para>Other effects / acceptance of results: </para><para role="indent"><@com.text study.ResultsAndDiscussion.InVitro.OtherEffectsAcceptanceOfResults/></para>
		</#if>

	<#--In vivo
    NOTE: missing "basis" of effect-->
		<#if study.ResultsAndDiscussion.InVivo.Results?has_content>
			<para>
				<@inVivoList study.ResultsAndDiscussion.InVivo.Results/>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.InVivo.IrritationCorrosionResponseData?has_content>
			<para>Irritant/corrosive response: </para><para role="indent"><@com.text study.ResultsAndDiscussion.InVivo.IrritationCorrosionResponseData/></para>
		</#if>

		<#if study.ResultsAndDiscussion.InVivo.OtherEffects?has_content>
			<para>Other effects:</para><para role="indent"><@com.text study.ResultsAndDiscussion.InVivo.OtherEffects/></para>
		</#if>

	</#compress>
</#macro>


<#macro results_eyeIrritation study>
	<#compress>

	<#--In vitro
    NOTE: missing vehicle and negative controls of effect-->
	<#if study.ResultsAndDiscussion.InVitro.ResultsOfExVivoInVitroStudy?has_content>
		<para><@EyeIrritationInVitroList study.ResultsAndDiscussion.InVitro.ResultsOfExVivoInVitroStudy/></para>
	</#if>

	<#if study.ResultsAndDiscussion.InVitro.OtherEffectsAcceptanceOfResults?has_content>
		<para>Other effects / acceptance of results: </para><para role="indent"><@com.text study.ResultsAndDiscussion.InVitro.OtherEffectsAcceptanceOfResults/></para>
	</#if>

	<#--In vivo
    NOTE: missing "basis" of effect-->
	<#if study.ResultsAndDiscussion.InVivo.IrritationCorrosionResults?has_content>
		<para>
			<@EyeIrritationInVivoList study.ResultsAndDiscussion.InVivo.IrritationCorrosionResults/>
		</para>
	</#if>

	<#if study.ResultsAndDiscussion.InVivo.IrritationCorrosionResponseData?has_content>
		<para>Irritant/corrosive response: </para><para role="indent"><@com.text study.ResultsAndDiscussion.InVivo.IrritationCorrosionResponseData/></para>
	</#if>

	<#if study.ResultsAndDiscussion.InVivo.OtherEffects?has_content>
		<para>Other effects:</para><para role="indent"><@com.text study.ResultsAndDiscussion.InVivo.OtherEffects/></para>
	</#if>

	</#compress>
</#macro>

<#macro results_skinSensitisation study>
	<#compress>
		<#if study.ResultsAndDiscussion.PositiveControlResults?has_content>
			<para>Positive control results: </para><para role="indent"><@com.text study.ResultsAndDiscussion.PositiveControlResults/></para>
		</#if>

		<#if study.ResultsAndDiscussion.InVivoLLNA.Results?has_content>
			<para>Results:
				<@inVivoLLNAList_ studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.InVivoLLNA.Results) />
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.TraditionalSensitisationTest.ResultsOfTest?has_content>
			<para>Results:
				<@inVivoNonLLNAList_ studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TraditionalSensitisationTest.ResultsOfTest)/>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.InVitroInChemico.Results?has_content>
			<para>Results:
				<@inVitroLLNAList_ studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.InVitroInChemico.Results) />
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.InVivoLLNA.CellularProliferationDataObservations?has_content>
			<para>Cellular proliferation / observations:</para><para role="indent"><@com.text study.ResultsAndDiscussion.InVivoLLNA.CellularProliferationDataObservations/></para>
		</#if>

		<#if study.ResultsAndDiscussion.InVitroInChemico.PredictionModelOutcome?has_content>
			<para>Outcome of prediction model:</para><para role="indent"><@com.picklist study.ResultsAndDiscussion.InVitroInChemico.PredictionModelOutcome/></para>
		</#if>
		<#if study.ResultsAndDiscussion.InVitroInChemico.OtherEffectsAcceptanceOfResults?has_content>
			<para>Other effects / acceptance of results:</para><para role="indent"><@com.text study.ResultsAndDiscussion.InVitroInChemico.OtherEffectsAcceptanceOfResults/></para>
		</#if>
	</#compress>
</#macro>

<#--Macro to parse sections consisting in a repetition of picklist-text fields, such as examinations-->
<#macro examinationsSection path exclude=[]>
	<#compress>
		<#local examinations=path?children/>
		<#list examinations as exam>
			<#local name=exam?node_name>

			<#if !exclude?seq_contains(name)>
				<#if (exam_index%2)==0>
					<#if exam?has_content || examinations[exam_index+1]?has_content>
						<#local fieldName=name?replace("Observ", "")?replace("([A-Z]{1})", " $1", "r")?cap_first/>
						<para role="indent">${fieldName}: <@com.picklist exam/></para>
						<para role="indent2"><@com.text examinations[exam_index+1]/></para>
					</#if>
				</#if>
			</#if>
		</#list>
	</#compress>
</#macro>

<#macro results_repDoseCarciNeuroImmuno study>
	<#compress>
		<#if study.ResultsAndDiscussion.ResultsOfExaminations?has_content>
			<para>Examinations:
				<#local examinations=study.ResultsAndDiscussion.ResultsOfExaminations?children/>
				<#list examinations as exam>
					<#local name=exam?node_name>
					<#if name!="DetailsOnResults" && name!="RelevanceOfCarcinogenicEffectsPotential" && name!="SpecificImmunotoxicExaminations">
						<#if (exam_index%2)==0>
							<#if exam?has_content || examinations[exam_index+1]?has_content>
								<#local fieldName=name?replace("Observ", "")?replace("([A-Z]{1})", " $1", "r")?cap_first/>
								<para role="indent">${fieldName}: <@com.picklist exam/></para>
									<para role="indent2"><@com.text examinations[exam_index+1]/></para>
							</#if>
						</#if>
					<#elseif name=="RelevanceOfCarcinogenicEffectsPotential" && exam?has_content>
						<para role="indent">Relevance of carcinogenic effects / potential: </para><para role="indent2"><@com.text exam/></para>
					<#elseif name=="DetailsOnResults" && exam?has_content>
						<para role="indent">Details: </para><para role="indent2"><@com.text exam/></para>
					</#if>
				</#list>
			</para>
		</#if>

		<#--Immunotoxic examinations: same concept as above (could be a macro not to repeat everything)-->
		<#if study.ResultsAndDiscussion.ResultsOfExaminations.hasElement("SpecificImmunotoxicExaminations") &&
				study.ResultsAndDiscussion.ResultsOfExaminations.SpecificImmunotoxicExaminations?has_content>
			<para>Specific immunotoxic examinations:
				<#local examinations=study.ResultsAndDiscussion.ResultsOfExaminations.SpecificImmunotoxicExaminations?children/>
				<#list examinations as exam>
					<#local name=exam?node_name>
					<#if (exam_index%2)==0>
						<#if exam?has_content || examinations[exam_index+1]?has_content>
							<#local fieldName=name?replace("Observ", "")?replace("([A-Z]{1})", " $1", "r")?cap_first/>
							<para role="indent">${fieldName}: <@com.picklist exam/></para>
								<para role="indent2"><@com.text examinations[exam_index+1]/></para>
						</#if>
					</#if>
				</#list>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.EffectLevels.Efflevel?has_content>
			<para>Effect levels:</para>
				<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
		</#if>

		<#if study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity?has_content>
			<para>Target system  / organ toxicity:</para>
				<@TargetSystemOrganToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TargetSystemOrganToxicity.TargetSystemOrganToxicity)/>
		</#if>
	</#compress>
</#macro>

<#--This macro uses a new macro and not the existing one - but it's very similar and could be adapted-->
<#macro results_geneticToxicity study>
	<#compress>
		<#if study.ResultsAndDiscussion.TestRs?has_content>
			<para>Test results:</para>
				<#--					<@keyTox.TestResultsList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestRs)/>-->
				<#--						<@keyTox.TestResultsInVivoList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestRs)/>-->
				<@TestResultsList_ studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.TestRs)/>
		</#if>

		<#if study.ResultsAndDiscussion.ResultsDetails?has_content>
			<para>Additional information on results: </para><para role="indent"><@com.text study.ResultsAndDiscussion.ResultsDetails/></para>
		</#if>

		<#if study.ResultsAndDiscussion.hasElement("RemarksOnResults") && study.ResultsAndDiscussion.RemarksOnResults?has_content>
			<para>Remarks:</para><para role="indent"><@com.picklist study.ResultsAndDiscussion.RemarksOnResults/></para>
		</#if>
	</#compress>
</#macro>

<#macro results_toxicityReproductionOther study>
	<#compress>
		<#if study.ResultsAndDiscussion.EffectLevels.Efflevel?has_content>
			<para>Effect levels:</para>
				<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
		</#if>

		<#if study.ResultsAndDiscussion.ObservedEffects.ObservedEffects?has_content>
			<para>
				Observed effects:</para>
				<para role="indent"><@com.text study.ResultsAndDiscussion.ObservedEffects.ObservedEffects/></para>
		</#if>
	</#compress>
</#macro>

<#macro results_toxicityReproduction study>
	<#compress>

		<#--P0-->
		<#local p0=study.ResultsAndDiscussion.ResultsOfExaminationsParentalGeneration/>

		<#if p0.GeneralToxicityP0?has_content || p0.ReproductiveFunctionPerformanceP0?has_content || p0.DetailsOnResultsP0.DetailsOnResults?has_content ||
		p0.EffectLevelsP0?has_content || p0.TargetSystemOrganToxicityP0?has_content>

			<para><emphasis role="bold">P0 (first parental generation)</emphasis></para>

			<#if p0.GeneralToxicityP0?has_content>
				<para>General toxicity:
					<@examinationsSection p0.GeneralToxicityP0/>
				</para>
			</#if>

			<#if p0.ReproductiveFunctionPerformanceP0?has_content>
				<para>Reproductive function / performance:
					<@examinationsSection p0.ReproductiveFunctionPerformanceP0/>
				</para>
			</#if>

			<#if p0.DetailsOnResultsP0.DetailsOnResults?has_content>
				<para>Details:
					<@com.text p0.DetailsOnResultsP0.DetailsOnResults/>
				</para>
			</#if>

			<#if p0.EffectLevelsP0.Efflevel?has_content>
				<para>
					Effect levels:
					<@EffectLevelsPoList studyandsummaryCom.orderByKeyResult(p0.EffectLevelsP0.Efflevel)/>
				</para>
			</#if>

			<#if p0.TargetSystemOrganToxicityP0.TargetSystemOrganToxicity?has_content>
				<para>
					Target system / organ toxicity:
					<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(p0.TargetSystemOrganToxicityP0.TargetSystemOrganToxicity)/>
				</para>
			</#if>
		</#if>

		<#--P1-->
		<#local p1=study.ResultsAndDiscussion.ResultsP1SecondParentalGeneration/>

		<#if p1.GeneralToxicityP1?has_content || p1.ReproductiveFunctionPerformanceP1?has_content || p1.DetailsOnResultsP1.DetailsOnResults?has_content ||
		p1.EffectLevelsP1?has_content || p1.TargetSystemOrganToxicityP1?has_content>

			<para><emphasis role="bold">P1 (second parental generation)</emphasis></para>

			<#if p1.GeneralToxicityP1?has_content>
				<para>General toxicity:
					<@examinationsSection p1.GeneralToxicityP1/>
				</para>
			</#if>

			<#if p1.ReproductiveFunctionPerformanceP1?has_content>
				<para>Reproductive function / performance:
					<@examinationsSection p1.ReproductiveFunctionPerformanceP1/>
				</para>
			</#if>

			<#if p1.DetailsOnResultsP1.DetailsOnResults?has_content>
				<para>Details:
					<@com.text p1.DetailsOnResultsP1.DetailsOnResults/>
				</para>
			</#if>

			<#if p1.EffectLevelsP1.Efflevel?has_content>
				<para>
					Effect levels:
					<@SecondparentalGenerationP1List studyandsummaryCom.orderByKeyResult(p1.EffectLevelsP1.Efflevel)/>
				</para>
			</#if>

			<#if p1.TargetSystemOrganToxicityP1.TargetSystemOrganToxicity?has_content>
				<para>
					Target system / organ toxicity:
					<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(p1.TargetSystemOrganToxicityP1.TargetSystemOrganToxicity)/>
				</para>
			</#if>
		</#if>

		<#--F1-->
		<#local f1=study.ResultsAndDiscussion.ResultsOfExaminationsOffspring/>

		<#if f1.GeneralToxicityF1?has_content || f1.DevelopmentalNeurotoxicityF1?has_content || f1.DevelopmentalImmunotoxicityF1?has_content ||
		f1.DetailsOnResultsF1.DetailsOnResults?has_content ||	f1.EffectLevelsF1?has_content || f1.TargetSystemOrganToxicityF1?has_content>

			<para><emphasis role="bold">F1 generation</emphasis></para>

			<#if f1.GeneralToxicityF1?has_content>
				<para>General toxicity:
					<@examinationsSection f1.GeneralToxicityF1/>
				</para>
			</#if>

			<#if f1.DevelopmentalNeurotoxicityF1?has_content>
				<para>Developmental neurotoxicity:
					<@examinationsSection f1.DevelopmentalNeurotoxicityF1/>
				</para>
			</#if>

			<#if f1.DevelopmentalImmunotoxicityF1?has_content>
				<para>Developmental immunotoxicity:
					<@examinationsSection f1.DevelopmentalImmunotoxicityF1/>
				</para>
			</#if>

			<#if f1.DetailsOnResultsF1.DetailsOnResults?has_content>
				<para>Details:
					<@com.text f1.DetailsOnResultsF1.DetailsOnResults/>
				</para>
			</#if>

			<#if f1.EffectLevelsF1.Efflevel?has_content>
				<para>
					Effect levels:
					<@FgenerationList studyandsummaryCom.orderByKeyResult(f1.EffectLevelsF1.Efflevel)/>
				</para>
			</#if>

			<#if f1.TargetSystemOrganToxicityF1.TargetSystemOrganToxicity?has_content>
				<para>
					Target system / organ toxicity:
					<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(f1.TargetSystemOrganToxicityF1.TargetSystemOrganToxicity)/>
				</para>
			</#if>
		</#if>

		<#--F2-->
		<#local f2=study.ResultsAndDiscussion.ResultsF2Generation/>

		<#if f2.GeneralToxicityF2?has_content || f2.DevelopmentalNeurotoxicityOfF1Generation?has_content || f2.DevelopmentalImmunotoxicityOfF1Generation?has_content ||
		f2.DetailsOnResultsF2.DetailsOnResults || f2.EffectLevelsF2?has_content || f2.TargetSystemOrganToxicityF2?has_content>

			<para><emphasis role="bold">F2 generation</emphasis></para>

			<#if f2.GeneralToxicityF2?has_content>
				<para>General toxicity:
					<@examinationsSection f2.GeneralToxicityF2/>
				</para>
			</#if>

			<#if f2.DevelopmentalNeurotoxicityOfF1Generation?has_content>
				<para>Developmental neurotoxicity:
					<@examinationsSection f2.DevelopmentalNeurotoxicityOfF1Generation/>
				</para>
			</#if>

			<#if f2.DevelopmentalImmunotoxicityOfF1Generation?has_content>
				<para>Developmental immunotoxicity:
					<@examinationsSection f2.DevelopmentalImmunotoxicityOfF1Generation/>
				</para>
			</#if>

			<#if f2.DetailsOnResultsF2.DetailsOnResults?has_content>
				<para>Details:
					<@com.text f2.DetailsOnResultsF2.DetailsOnResults/>
				</para>
			</#if>

			<#if f2.EffectLevelsF2.Efflevel?has_content>
				<para>
					Effect levels:
					<@FgenerationList studyandsummaryCom.orderByKeyResult(f2.EffectLevelsF2.Efflevel)/>
				</para>
			</#if>

			<#if f2.TargetSystemOrganToxicityF2.TargetSystemOrganToxicity?has_content>
				<para>
					Target system / organ toxicity:
					<@TargetSystemOrganToxforEffectLevelsList studyandsummaryCom.orderByKeyResult(f2.TargetSystemOrganToxicityF2.TargetSystemOrganToxicity)/>
				</para>
			</#if>
		</#if>

		<#--Overall-->
		<#if study.ResultsAndDiscussion.ReproductiveToxicity.ReproductiveToxicity?has_content>
			<para><emphasis role="bold">Overall reproductive toxicity:</emphasis></para>
			<para>
				<@OverallReproductiveToxicityList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.ReproductiveToxicity.ReproductiveToxicity)/>
			</para>
		</#if>
	</#compress>
</#macro>

<#macro results_developmentalToxicity study>
	<#compress>

		<#-- Maternal-->
		<#local maternal=study.ResultsAndDiscussion.ResultsMaternalAnimals/>
		<#if maternal.GeneralToxicityMaternalAnimals?has_content || maternal.MaternalDevelopmentalToxicity?has_content ||
		maternal.EffectLevelsMaternalAnimals.Efflevel?has_content || maternal.MaternalAbnormalities.MaternalAbnormalities?has_content>
			<para><emphasis role="bold">Maternal animals</emphasis></para>
			<#if maternal.GeneralToxicityMaternalAnimals?has_content>
				<para>
					General toxicity:
					<@examinationsSection path=maternal.GeneralToxicityMaternalAnimals exclude=["DetailsOnResults"]/>
					<#if maternal.GeneralToxicityMaternalAnimals.DetailsOnResults?has_content>
						<para role="indent">Details: <@com.text maternal.GeneralToxicityMaternalAnimals.DetailsOnResults/></para>
					</#if>
				</para>
			</#if>

			<#if maternal.MaternalDevelopmentalToxicity?has_content>
				<para>
					Maternal developmental toxicity:
					<@examinationsSection path=maternal.MaternalDevelopmentalToxicity exclude=["ResultsDetailsMaternal"]/>
					<#if maternal.MaternalDevelopmentalToxicity.ResultsDetailsMaternal?has_content>
						<para role="indent">Details: <@com.text maternal.MaternalDevelopmentalToxicity.ResultsDetailsMaternal/></para>
					</#if>
				</para>
			</#if>

			<#if maternal.EffectLevelsMaternalAnimals.Efflevel?has_content>
				<para>Effect levels:
					<@EffectLevelsMatAbnormalitiesList studyandsummaryCom.orderByKeyResult(maternal.EffectLevelsMaternalAnimals.Efflevel)/>
				</para>
			</#if>

			<#if maternal.MaternalAbnormalities.MaternalAbnormalities?has_content>
				<para>Maternal abnormalities:
					<@MatAbnormalitiesList studyandsummaryCom.orderByKeyResult(maternal.MaternalAbnormalities.MaternalAbnormalities)/>
				</para>
			</#if>
		</#if>

		<#-- Fetuses-->
		<#local fetuses=study.ResultsAndDiscussion.ResultsFetuses/>
		<#if fetuses?has_content>
		<#--		This path doesn't seem correctly assigned-->
			<para><emphasis role="bold">Fetuses:</emphasis></para>

			<#if fetuses?has_content>
				<para>
					General toxicity:
					<@examinationsSection path=fetuses exclude=["ResultsDetailsDevelop", "EffectLevelsFetuses", "FetalAbnormalities"]/>
					<#if fetuses.ResultsDetailsDevelop?has_content>
						<para role="indent">Details: <@com.text fetuses.ResultsDetailsDevelop/></para>
					</#if>
				</para>
			</#if>

			<para>Effect levels:
				<@EffectLevelsFetusesList studyandsummaryCom.orderByKeyResult(fetuses.EffectLevelsFetuses.Efflevel)/>
			</para>

			<para>Fetal abnormalities:
				<@FetalAbnormalitiesList studyandsummaryCom.orderByKeyResult(fetuses.FetalAbnormalities.FetalAbnormalities)/>
			</para>
		</#if>

		<#-- Overall-->
		<#if study.ResultsAndDiscussion.DevelopmentalToxicity.DevelopmentalToxicity?has_content>
			<para><emphasis role="bold">Overall developmental toxicity:</emphasis></para>

			<para>
				<@OverallDevToxList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.DevelopmentalToxicity.DevelopmentalToxicity)/>
			</para>
		</#if>
	</#compress>
</#macro>

<#--new-->
<#macro results_phototoxicity study>
	<#compress>

		<#if study.ResultsAndDiscussion.Results?has_content || study.ResultsAndDiscussion.RemarksOnResult?has_content>
			<para>
				Results:
				<para role="indent"><@com.text study.ResultsAndDiscussion.Results/></para>
				<#if study.ResultsAndDiscussion.RemarksOnResult?has_content>
					<para role="indent">Remarks: <@com.picklist study.ResultsAndDiscussion.RemarksOnResult/></para>
				</#if>

			</para>
		</#if>

		<#if study.ResultsAndDiscussion.ResultsReferenceSubstance?has_content>
			<para>
				Results with reference substance (positive control): <para role="indent"><@com.text study.ResultsAndDiscussion.ResultsReferenceSubstance/></para>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.StatisticsErrorEstimates?has_content>
			<para>
				Statistics: <para role="indent"><@com.text study.ResultsAndDiscussion.StatisticsErrorEstimates/></para>
			</para>
		</#if>

	</#compress>
</#macro>

<#--livestock-->
<#macro results_effectsLivestock study>
	<#compress>

		<#--hashmap to get text content from field name-->
		<#local livestockField2Text={"ObservClinSigns" : "Clinical signs and mortality: ",
		"ObservBodyweight" :"Body weight and weight gain: ",
		"ObservFoodConsum" : "Food consumption and compound intake: ",
		"ObservWaterConsum" :"Water consumption and compound intake: ",
		"ObservHaematol" : "Haematology: ",
		"ObservClinChem" :"Clinical chemistry: ",
		"ObservUrin" : "Urinalysis: ",
		"ObservGrpathol" :"Gross pathology and organ weights: ",
		"ObservHistopathol":"Histopathology: "}

		/>

		<#--iterate over the children, but need the actual value of the text in IUCLID section-->
		<para>
			<#list study.ResultsAndDiscussion?children as child>
				<#if child?node_type=="picklist_single">
					<para>${livestockField2Text[child?node_name]}<@com.picklist child/></para>
				</#if>
			</#list>
		</para>

		<#if study.ResultsAndDiscussion.ResultsDetails?has_content>
			<para>
				Details: <para role="indent"><@com.text study.ResultsAndDiscussion.ResultsDetails/></para>
			</para>
		</#if>

	</#compress>
</#macro>

<#--endocrine-->
<#macro results_endocrineDisrupterMammalianScreening study>
	<#compress>
		<#if study.ResultsAndDiscussion.EndocrineDisruptingPotential?has_content>
			<para>Endocrine disrupting potential: <para role="indent"><@com.picklist study.ResultsAndDiscussion.EndocrineDisruptingPotential/></para></para>
		</#if>

		<#if study.ResultsAndDiscussion.MaximumToleratedDoseLevelExceeded?has_content>
			<para>Maximum tolerated dose level exceeded: <para role="indent"><@com.picklist study.ResultsAndDiscussion.MaximumToleratedDoseLevelExceeded/></para></para>
		</#if>

		<#-- Examinations-->
		<#local exam=study.ResultsAndDiscussion.ResultsOfExaminations/>
		<#if exam?has_content>
			<para>
				Examinations:
				<@examinationsSection path=exam exclude=["DetailsOnResults"]/>
				<#if exam.DetailsOnResults?has_content>
					<para role="indent">Details: <@com.text exam.DetailsOnResults/></para>
				</#if>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.EffectLevels.Efflevel?has_content>
			<para>Effect levels:
				<@EffectLevelsExtendedList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.EffectLevels.Efflevel)/>
			</para>
		</#if>

	</#compress>
</#macro>

<#macro results_healthSurvExposureEpidemiological study>
	<#compress>
		<#if study.ResultsAndDiscussion.Results?has_content>
			<para>Results: <para role="indent"><@com.text study.ResultsAndDiscussion.Results/></para></para>
		</#if>

		<#--only for epidemiological data-->
		<#if study.ResultsAndDiscussion.hasElement("ConfoundingFactors") && study.ResultsAndDiscussion.ConfoundingFactors?has_content>
			<para>Confounding factors: <para role="indent"><@com.text study.ResultsAndDiscussion.ConfoundingFactors/></para></para>
		</#if>
		<#if study.ResultsAndDiscussion.hasElement("StrengthsWeaknesses") && study.ResultsAndDiscussion.StrengthsWeaknesses?has_content>
			<para>Strengths and weaknesses: <para role="indent"><@com.text study.ResultsAndDiscussion.StrengthsWeaknesses/></para></para>
		</#if>

	</#compress>
</#macro>

<#macro results_directObs study>
	<#compress>
		<#if study.ResultsAndDiscussion.hasElement("ClinicalSigns") && study.ResultsAndDiscussion.ClinicalSigns?has_content>
			<para>Clinical signs: <para role="indent"><@com.text study.ResultsAndDiscussion.ClinicalSigns/></para></para>
		</#if>

		<#if study.ResultsAndDiscussion.RsExaminations?has_content>
			<para>Results of examinations: <para role="indent"><@com.text study.ResultsAndDiscussion.RsExaminations/></para></para>
		</#if>

		<#if study.ResultsAndDiscussion.hasElement("EffectivityMedicalTreatment") && study.ResultsAndDiscussion.EffectivityMedicalTreatment?has_content>
			<para>Effectivity of medical treatment: <para role="indent"><@com.text study.ResultsAndDiscussion.EffectivityMedicalTreatment/></para></para>
		</#if>

		<#if study.ResultsAndDiscussion.hasElement("Outcome") && study.ResultsAndDiscussion.Outcome?has_content>
			<para>Outcome of incidence: <para role="indent"><@com.text study.ResultsAndDiscussion.Outcome/></para></para>
		</#if>
	</#compress>
</#macro>

<#macro results_dermalAbsorption study>
	<#compress>
		<#if study.ResultsAndDiscussion.SignsSymptomsToxicity?has_content || study.ResultsAndDiscussion.DermalIrritation?has_content>
			<para>Toxicity:
				<#if study.ResultsAndDiscussion.SignsSymptomsToxicity?has_content>
					<para role="indent">Signs and symptoms: <@com.picklist study.ResultsAndDiscussion.SignsSymptomsToxicity/>.</para>
				</#if>
				<#if study.ResultsAndDiscussion.DermalIrritation?has_content>
					<para role="indent">Dermal irritation: <@com.picklist study.ResultsAndDiscussion.DermalIrritation/>.</para>
				</#if>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.AbsorptionMatrices?has_content>
			<para>Absorption in different matrices:
				<para role="indent"><@com.text study.ResultsAndDiscussion.AbsorptionMatrices/>.</para>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.TotalRecovery?has_content>
			<para>Total recovery:
				<para role="indent"><@com.text study.ResultsAndDiscussion.TotalRecovery/>.</para>
			</para>
		</#if>

		<#if study.ResultsAndDiscussion.Absorption?has_content>
			<para>Percutaneous absorption rate: <@PercutaneousAbsorptionRateList studyandsummaryCom.orderByKeyResult(study.ResultsAndDiscussion.Absorption)/></para>
		</#if>

		<#if study.ResultsAndDiscussion.ConversionFactor?has_content>
			<para>Conversion factor human vs. animal skin:
				<para role="indent"><@com.text study.ResultsAndDiscussion.ConversionFactor/>.</para>
			</para>
		</#if>
	</#compress>
</#macro>

<#macro results_cellCulture study>
	<#compress>
		<#if study.ResultsAndDiscussion.CytopathicEffects?has_content>
			<para>Cytopathic effects: <@com.picklist study.ResultsAndDiscussion.CytopathicEffects/></para>
		</#if>

		<#if study.ResultsAndDiscussion.TCID50?has_content>
			<para>TCID50:<@com.quantity study.ResultsAndDiscussion.TCID50/></para>
		</#if>

		<#if study.ResultsAndDiscussion.ResultsOfAssays?has_content>
			<para>Results of assays:</para>
			<para><@resultsOfAssaysList study.ResultsAndDiscussion.ResultsOfAssays/></para>
		</#if>

		<#if study.ResultsAndDiscussion.Statistics?has_content>
			<para>Statistics: <para role="indent"><@com.text study.ResultsAndDiscussion.Statistics/></para></para>
		</#if>


	</#compress>
</#macro>

<#--3. New whole studies: intermediate effects
	NOTE: maybe it could be included in general macros for Eappendix but it's quite different -->
<#macro intermediateEffectsStudies _subject>
	<#compress>

		<#local resultStudyList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "IntermediateEffects") />

		<#-- Study results-->
		<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Studies</emphasis></para>
		<@com.emptyLine/>

		<#if !resultStudyList?has_content>
			No relevant individual studies available.
		<#else>

			<#--NOTE: change the name displayed e.g. with a hash mapping document name to name to display. Also for long-term tox this will be wrong.-->
			${resultStudyList?size} individual <#if resultStudyList?size==1>study<#else>studies</#if> for intermediate effects <#if resultStudyList?size==1>is<#else>are</#if> summarised below:

			<#list resultStudyList as study>

				<sect4 xml:id="${study.documentKey.uuid!}" label="/${study_index+1}" role="NotInToc"><title  role="HEAD-5" >${study.name}</title>

					<#--1. Header-->
					<para><emphasis role="HEAD-WoutNo">1. Information on the study</emphasis></para>

					<#local referenceLinksList=study.DataSource.Reference/>
					<#if referenceLinksList?has_content>
						<#local referenceList = []/>
						<#list referenceLinksList as referenceLink>
							<#local reference = iuclid.getDocumentForKey(referenceLink)/>
							<#local referenceList = referenceList + [reference] />
						</#list>
						<#local referenceList = iuclid.sortByField(referenceList, "GeneralInfo.LiteratureType", ["study report", "other company data", "publication", "review article or handbook", "other:"]) />
						<#local reference = referenceList[0]/>
					<#else>
					<#--Create empty reference hash-->
						<#local reference = {'GeneralInfo': {'LiteratureType':"", 'Author':"", 'ReferenceYear':"", 'Name':"", 'ReportNo':"", 'StudyIdentifiers':""}}/>
					</#if>

					<table border="1">
						<title> </title>
						<col width="35%" />
						<col width="65%" />
						<tbody>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Data point:</emphasis></th>
							<td>intermediate effects: <@com.picklist study.AdministrativeData.StudyResultType/></td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Report type: </emphasis></th>
							<td>
								<#if reference.GeneralInfo.LiteratureType?has_content><@com.picklist reference.GeneralInfo.LiteratureType/></#if>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Report author: </emphasis></th>
							<td>
								<@com.text reference.GeneralInfo.Author/>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Report year: </emphasis></th>
							<td><@com.number reference.GeneralInfo.ReferenceYear/></td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Report title: </emphasis></th>
							<td><@com.text reference.GeneralInfo.Name/></td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Report No: </emphasis></th>
							<td><@com.text reference.GeneralInfo.ReportNo/></td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">NoS Id: </emphasis></th>
							<td>
								<#local NoSId=""/>
								<#if reference.GeneralInfo.StudyIdentifiers?has_content>
									<#list reference.GeneralInfo.StudyIdentifiers as studyId>
										<#if studyId.Remarks?matches(".*NOTIF.*STUD.*", "i") || studyId.Remarks?matches(".*NOS.*", "i")>
											<#if studyId.StudyID?has_content>
												<#local NoSId = studyId.StudyID/>
											<#else>
												<#local NoSId>NA - justification: <@com.text studyId.Remarks/></#local>
											</#if>
											<#break>
										</#if>
									</#list>
								</#if>

								<#if NoSId?has_content>
									${NoSId}
								</#if>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Document No: </emphasis></th>
							<td><#local docUrl=iuclid.webUrl.documentView(study.documentKey) />
								<ulink url="${docUrl}"><@com.text study.documentKey.uuid/></ulink>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Guidelines followed in study: </emphasis></th>
							<td><@com.picklist study.MaterialsAndMethods.MethodUsed.Qualifier/> <@com.picklist study.MaterialsAndMethods.MethodUsed.MethodUsed/>
								<?linebreak?><@com.text study.MaterialsAndMethods.MethodUsed.PrincipleOfTheMethod/>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Deviations from current test guideline: </emphasis></th>
							<td>
								<#local deviations><@com.picklist study.MaterialsAndMethods.MethodUsed.Deviations/></#local>
								<#if deviations?starts_with('yes')>${deviations}</#if>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Previous evaluation: </emphasis></th>
							<td>
								<#--Check in change log: if uuid found, then "Yes:" and append status (concatenated); else "No"
									(NOTE: probably part of this can go to a macro/function elsewhere)-->
								<#local changeLogFlag="no"/>

								<#local changeLogStatusList=[]/>

								<#local changeLogs = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "ChangeLog") />
								<#list changeLogs as changeLog>
									<#list changeLog.ChangeLog.ChangeLogEntries as changeLogEntry>
										<#local changeLogDoc=iuclid.getDocumentForKey(changeLogEntry.LinkToDocument)/>

										<#if changeLogDoc?has_content>
											<#if study.documentKey.uuid==changeLogDoc.documentKey.uuid>
												<#local changeLogStatus><@com.picklist changeLogEntry.Status/></#local>
												<#if changeLogStatus?has_content>
													<#if !(changeLogStatus?starts_with("new"))>
														<#local changeLogFlag="yes"/>
													</#if>
													<#local changeLogStatusList = changeLogStatusList + [changeLogStatus]/>
												</#if>
											</#if>
										</#if>
									</#list>
								</#list>

								${changeLogFlag}<#if changeLogStatusList?has_content> (${changeLogStatusList?join(", ")})</#if>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">GLP/Officially recognised testing facilities: </emphasis></th>
							<td><@com.picklist study.MaterialsAndMethods.MethodUsed.GLPCompliance/>
								<?linebreak?>
								<#if study.MaterialsAndMethods.MethodUsed.OtherQualityFollowed?has_content>
									other quality assurance: <@com.picklist study.MaterialsAndMethods.MethodUsed.OtherQualityFollowed/>
								</#if>
							</td>
						</tr>
						<tr>
							<th><?dbfo bgcolor="#d3d3d3" ?><emphasis role="bold">Acceptability/Reliability: </emphasis></th>
							<td><@com.picklist study.AdministrativeData.Reliability/>
								<#if study.AdministrativeData.RationalReliability?has_content>
									: <@com.picklist study.AdministrativeData.RationalReliability/>
								</#if>
							</td>
						</tr>
						</tbody>
					</table>
					<@com.emptyLine/>

					<para><emphasis role="HEAD-WoutNo"> 2. Full summary of the study according to OECD format </emphasis></para>

					<#-- 2. Materials and methods-->
					<para><emphasis role="bold">a) Materials and methods</emphasis></para>
					<@methods_intermediateEffects study true/>
					<@com.emptyLine/>
					<@intermediateEffectIdentification study/>
					<@com.emptyLine/>

					<#--3.Results-->
					<para><emphasis role="bold">b) Results</emphasis></para>
					<@results_intermediateEffects study true/>
					<@com.emptyLine/>

					<#--4.Assessment and conclusion-->
					<#local assess= study.ApplicantSSummaryAndConclusion/>
					<para><emphasis role="HEAD-WoutNo">3. Assessment and conclusion </emphasis> </para>
					<#--					<@com.emptyLine/>-->
					<#--					<para><emphasis role="bold">a) Assessment and conclusion by applicant:</emphasis></para>-->

					<#if assess.ExecutiveSummary.ExecutiveSummary?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="bold">Executive summary:</emphasis>
							<@com.richText assess.ExecutiveSummary.ExecutiveSummary/>
						</para>
					</#if>

					<@com.emptyLine/>
					<para><emphasis role="bold">Interpretation of results:</emphasis></para>

					<#if assess.InterpretationOfResultsObservations.TypeOfResult?has_content>
						<para role="indent">Type of result: <@com.picklist assess.InterpretationOfResultsObservations.TypeOfResult/></para>
					</#if>
					<#if assess.InterpretationOfResultsObservations.EffectConcentrationChoice?has_content>
						<para role="indent">Effect concentration: <@com.picklist assess.InterpretationOfResultsObservations.EffectConcentrationChoice/>
						<#if assess.InterpretationOfResultsObservations.Concentration?has_content>
							= <@com.range assess.InterpretationOfResultsObservations.Concentration/>
						</#if>
						</para>
					</#if>
					<#if assess.InterpretationOfResultsObservations.Remarks?has_content>
						<para role="indent">Remarks: <@com.text assess.InterpretationOfResultsObservations.Remarks/></para>
					</#if>


					<#if  assess.InterpretationOfResultsObservations.OverallResults?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="bold">Conclusion:</emphasis>
							<@com.text  assess.InterpretationOfResultsObservations.OverallResults/>
						</para>
					</#if>

					<#--					<@com.emptyLine/>-->

					<#--					<para><emphasis role="bold">b) Assessment and conclusion by RMS:</emphasis></para>-->

				</sect4>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro results_intermediateEffects study printRemarks=false>
	<#compress>

		<#list study.ResultsAndDiscussion.TestResults.TestResults as child>
			<#if child_has_next || (child_index>0)><para><emphasis role="underline">Result #${child_index+1}</emphasis></para></#if>

			<para role="indent">
				<#if child.ConcentrationSelection?has_content><#local concSel><@com.picklist child.ConcentrationSelection/></#local>${concSel?cap_first}</#if>
				<#if child.ConcentrationRangeTested?has_content>
					: <@com.range child.ConcentrationRangeTested/>
				</#if>
			</para>

			<#if child.NumberOfReplicatesAndOutliers?has_content>
				<para role="indent">Number of replicates and outliers: <@com.text child.NumberOfReplicatesAndOutliers/></para>
			</#if>

			<#if child.ParameterAndResult?has_content>
				<para role="indent">Parameter and result:</para>
				<#list child.ParameterAndResult as param>
					<para role="indent2">
						<@com.picklist param.Parameter/> = <@com.quantity param.ParameterResult/>
					</para>
				</#list>
			</#if>

			<#if child.OtherObservation?has_content>
				<para role="indent">Other observations:</para>
				<#list child.OtherObservation as obs>
					<para role="indent2">
						<@com.picklist obs.Observation/>
						<#if obs.Concentration?has_content> - <@com.range obs.Concentration/></#if>
					</para>
				</#list>
			</#if>

			<#if child.ResultsForTheTestMaterial?has_content>
				<para role="indent">Results for the test material: <@com.picklist child.ResultsForTheTestMaterial/></para>
			</#if>

			<#if child.AcceptanceOfResults?has_content>
				<para role="indent">Acceptance: <@com.picklistMultiple child.AcceptanceOfResults/></para>
			</#if>

			<#if child.RemarksOnResults?has_content>
				<para role="indent">Remarks: <@com.text child.RemarksOnResults/></para>
			</#if>

		</#list>

		<#--2. Other information including tables (to include?) : doesn't exist here-->

		<#--3. Remarks on results-->
		<#if printRemarks>
			<#if study.OverallRemarksAttachments.RemarksOnResults?has_content>
				<para>Overall remarks:</para><para role="indent"><@com.richText study.OverallRemarksAttachments.RemarksOnResults/></para>
			</#if>
		</#if>
	</#compress>
</#macro>

<#macro methods_intermediateEffects study printTestMat=false>
	<#compress>

	    <#-- 1. Test material-->
		<#if printTestMat>
			<para>
				<emphasis role="bold">Test material:</emphasis>
				<para role="indent"><@studyandsummaryCom.testMaterialInformation study.MaterialsAndMethods.TestMaterials.TestMaterialInformation/></para>

				<#if study.MaterialsAndMethods.TestMaterials.SpecificDetailsOnTestMaterialUsedForTheStudy?has_content>
					<para role="indent">
						Specific details: <@com.text study.MaterialsAndMethods.TestMaterials.SpecificDetailsOnTestMaterialUsedForTheStudy/>
					</para>
				</#if>
			</para>
		</#if>

		<#-- 2. Test system-->
		<para>
			<emphasis role="bold">Test system:</emphasis>

			<#local sys=study.MaterialsAndMethods.TestSystem/>
			<#if sys.TestSystemType?has_content>
				<para role="indent">Type: <@com.picklist sys.TestSystemType/>.</para>
			</#if>
			<#if sys.TestSystemIdentity?has_content>
				<para role="indent">Identity: <@com.picklist sys.TestSystemIdentity/>.</para>
			</#if>
			<#if sys.GeneticModOfSystem?has_content>
				<para role="indent">Genetic modification: <@com.picklist sys.GeneticModOfSystem/>.</para>
			</#if>
			<#if sys.TestSystemDetails?has_content>
				<para role="indent">Details: <@com.text sys.TestSystemDetails/>.</para>
			</#if>
			<#if sys.MetabolicCompetence?has_content>
				<para role="indent">Metabolic competence: <@com.picklist sys.MetabolicCompetence/>.</para>
			</#if>
		</para>

	<#-- 3. Detection method -->
		<para>
			<emphasis role="bold">Detection method:</emphasis>
			<#local det=study.MaterialsAndMethods.DetectionMethod/>
			<para role="indent">
				<#if det.DetectionMethodUsed?has_content>
					<@com.picklist det.DetectionMethodUsed/>
				</#if>
				<#if det.DetailsOnDetectionMethod?has_content>
					: <@com.text det.DetailsOnDetectionMethod/>
				</#if>
				.
			</para>
		</para>

	<#-- 4. Test design -->
		<#local des=study.MaterialsAndMethods.TestDesign/>
		<para>
			<emphasis role="bold">Study design:</emphasis>

			<para role="indent">
				Test material preparation:

				<#if des.TestMaterialPreparation.ConcentrationSelection?has_content>
					<para role="indent2">Concentration selection: <@com.picklist des.TestMaterialPreparation.ConcentrationSelection/>.</para>
				</#if>
				<#if des.TestMaterialPreparation.Vehicle?has_content>
					<para role="indent2">Vehicle / solvent: <@com.picklist des.TestMaterialPreparation.Vehicle/>.</para>
				</#if>
				<#if des.TestMaterialPreparation.DilutionStepsDoseIntervals?has_content>
					<para role="indent2">Dilution steps / dose intervals: <@com.text des.TestMaterialPreparation.DilutionStepsDoseIntervals/>.</para>
				</#if>

			</para>

			<para role="indent">
				Control and reference items:
				<#if des.ControlAndReferenceItems.ControlsReferenceItemsUsed?has_content>
					<@com.picklist des.ControlAndReferenceItems.ControlsReferenceItemsUsed/>.
				</#if>
				<#if des.ControlAndReferenceItems.ControlsReferenceSubstances?has_content>
					<#list des.ControlAndReferenceItems.ControlsReferenceSubstances as ref>
						<para role="indent2">
							<#if ref.TypeOfControls?has_content><@com.picklist ref.TypeOfControls/></#if>
							<#if ref.ControlOrReferenceItemsUsed?has_content>: <@com.picklist ref.ControlOrReferenceItemsUsed/></#if>
							<#if ref.Remarks?has_content> (<@com.text ref.Remarks/>)</#if>
						</para>
					</#list>
				</#if>
			</para>

			<para role="indent">
				Experimental conditions:
				<#if des.ExperimentalConditions.NumberOfReplicates?has_content>
					<para role="indent2">No of replicates: <@com.text des.ExperimentalConditions.NumberOfReplicates/>.</para>
				</#if>
				<#if des.ExperimentalConditions.ExperimentalConditions?has_content>
					<para role="indent2">Conditions:<@com.text des.ExperimentalConditions.ExperimentalConditions/>.</para>
				</#if>
				<#if des.ExperimentalConditions.AdditionalAnalysis?has_content>
					<para role="indent2">Additional analysis: <@com.picklist des.ExperimentalConditions.AdditionalAnalysis/>.</para>
				</#if>
			</para>

			<para role="indent">
				Data analysis:
				<#if des.DataAnalysis.AcceptanceCriteria?has_content>
					<para role="indent2">Acceptance criteria: <@com.text des.DataAnalysis.AcceptanceCriteria/>.</para>
				</#if>
				<#if des.DataAnalysis.DataCalculationAndStatistics?has_content>
					<para role="indent2">Data calculation and statistics:<@com.text des.DataAnalysis.DataCalculationAndStatistics/>.</para>
				</#if>
				<#if des.DataAnalysis.EvaluationDataInterpretationCriteria?has_content>
					<para role="indent2">Evaluation / data interpretation criteria: <@com.text des.DataAnalysis.EvaluationDataInterpretationCriteria/>.</para>
				</#if>
			</para>
		</para>

	</#compress>
</#macro>


<#macro intermediateEffectIdentification study>
	<#compress>

		<para><emphasis role="bold">Effect identification:</emphasis></para>

		<#if study.EffectIdentification.Details?has_content>
			<para role="indent">P/A/O:<?linebreak?>

				<#list study.EffectIdentification.Details as pao>
					<para role="indent2">
					<#if pao.Process?has_content>
						Process: <@com.picklist pao.Process/>.
					</#if>
					<#if pao.Object?has_content>
						Object: <@com.picklist pao.Object/>.
					</#if>
					<#if pao.EffectAction?has_content>
						Action: <@com.picklist pao.EffectAction/>.
					</#if>
					</para>
				</#list>
			</para>
		</#if>

		<#if study.EffectIdentification.EffectDetails?has_content>
			<para role="indent">Details: <@com.text  study.EffectIdentification.EffectDetails/></para>
		</#if>

		<#if study.EffectIdentification.Context?has_content>
			<para role="indent">Context:<?linebreak?>

				<#list study.EffectIdentification.Context as ctx>
					<para role="indent2">
						<#if ctx.System?has_content>
							System: <@com.picklist ctx.System/>.
						</#if>
						<#if ctx.Organ?has_content>
							Organ: <@com.picklistMultiple ctx.Organ/>.
						</#if>
						<#if ctx.Remarks?has_content>
							(<@com.text ctx.Remarks/>).
						</#if>
					</para>
				</#list>
			</para>
		</#if>
	</#compress>
</#macro>

<#--4. Results summaries-->

<#macro toxRefValuesTable summary>

	<#local toxRefPath2ValMap = {"AcceptableOperatorExposureLevel":"Aoel", "AcceptableDailyIntake":"Adi", "AcuteReferenceDose":"Arfd", "AcuteAcceptableOperatorExposureLevel":"Aaoel"}/>

	<table border="1">
		<tbody>

		<tr>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Reference Value</emphasis></th>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Route</emphasis></th>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Uncertainty factor (UF)</emphasis></th>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Dose descriptor</emphasis></th>
			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Justification</emphasis></th>
		</tr>

		<#list summary.HumanHealthHazardCharacteristics?children as child>
			<#local toxRef=toxRefPath2ValMap[child?node_name]/>

			<#if child[toxRef]?has_content || child.NoAllocated >
				<tr>
					<td>
						${toxRef?upper_case}
						<#if child.NoAllocated>
							: Not allocated
						<#else>
							= <@com.quantity child[toxRef]/>
						</#if>
					</td>
					<td>
						<@com.picklistMultiple child.StudyRetained/>
					</td>
					<td>
						<#local route><@com.picklist child.RouteOfOriginalStudy/></#local>
						${route}
						<#if child.hasElement("OralAbsorption") && route?matches(".*oral.*") && child.OralAbsorption?has_content>
							(<@com.number child.OralAbsorption/>%)
						</#if>
					</td>
					<td>
						<@com.text child.OverallUncertainty/>
						<#if child.JustificationOverallUf?has_content>
							- <@com.text child.JustificationOverallUf/>
						</#if>
					</td>
					<td>
						<@com.picklist child.DoseDescriptorStartingPoint/>
						<#if child.field8204?has_content> = <@com.quantity child.field8204/></#if>
					</td>
					<td>
						<#if child.NoAllocated><@com.text child.Justification/></#if>
						<@com.richText child.JustificationAndComments/>
					</td>

				</tr>
			</#if>
		</#list>
		</tbody></table>
</#macro>

<#--Endocrine disrupting properties-->
<#macro endocrineDisruptingPropertiesTable summary>
	<#compress>

	<#--ED assessment-->
		<#local isFirst=true/>
		<#list summary.EdAssessment?children as child>

		<#--Assessment type-->
			<#local assessmentType><#compress>
				<#if child?node_name?contains("Humans")>human
				<#elseif child?node_name?contains("NonTarget")>non-target organisms
				</#if>
			</#compress></#local>

			<#local assessmentType><#compress>
				${assessmentType}
				<#if child?node_name?contains("Tmodality")>(T-modality)
				<#elseif child?node_name?contains("Easmodality")>(EAS-modality)
				</#if>
			</#compress></#local>

		<#--Lines of evidence-->
			<#local evPath=child.AssessmentLinesOfEvidence/>
			<#local evidence><#compress>
				<#if evPath.hasElement("SufficientInvestigationT") && evPath.SufficientInvestigationT?has_content>
					<para>T-mediated parameters sufficiently investigated: <@com.picklist evPath.SufficientInvestigationT/></para>
				<#elseif evPath.hasElement("SufficientInvestigationEas") && evPath.SufficientInvestigationEas?has_content>
					<para>EAS-mediated parameters sufficiently investigated: <@com.picklist evPath.SufficientInvestigationEas/></para>
				</#if>

				<#if evPath.HasEndocrineActivityBeenSufficientlyInvestigated?has_content>
					<para>Endocrine activity sufficiently investigated: <@com.picklist evPath.HasEndocrineActivityBeenSufficientlyInvestigated/></para>
				</#if>

				<#if evPath.SelectionOfRelevantScenario?has_content>
					<para><@com.picklist evPath.SelectionOfRelevantScenario/></para>
				</#if>

				<#if evPath.EvidenceAdverseEffects?has_content>
					<para>Adverse effects: <@com.richText evPath.EvidenceAdverseEffects/></para>
				</#if>

				<#if evPath.EvidenceEndocrineActivity?has_content>
					<para>Endocrine activity: <@com.richText evPath.EvidenceEndocrineActivity/></para>
				</#if>

				<#if evPath.WoeAdversityEndocrineActivity?has_content>
					<para>WoE: <@com.richText evPath.WoeAdversityEndocrineActivity/></para>
				</#if>
			</#compress></#local>

		<#--MoA-->
			<#local MoA><#compress>
				<#if child.MoaAnalysis.PostulatedMoa?has_content>
					<para>Postulated MoA:<?linebreak?>
						<#list child.MoaAnalysis.PostulatedMoa?children as moa>
							<para role="indent">
								<#if moa.PostulatedMoa?has_content>
									<@com.text moa.PostulatedMoa/>
								</#if>
								<#if moa.EventType?has_content>
									: <@com.text moa.EventType/>
								</#if>
								<#if moa.EventDescription?has_content>
									- <@com.text moa.EventDescription/><?linebreak?>
								</#if>
								<#if moa.SupportingEvidence?has_content>
									Evidence: <@com.text moa.SupportingEvidence/><?linebreak?>
								</#if>
								<#if moa.RelevantRecords?has_content>
									Study record(s):
									<#list moa.RelevantRecords as studyReferenceLinkedToSummary>
										<#local studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
										<command  linkend="${studyReference.documentKey.uuid!}">
											<@com.text studyReference.name/>
										</command>
										<#if studyReferenceLinkedToSummary_has_next> | </#if>
									</#list>
								</#if>
							</para>
						</#list>
					</para>
				</#if>

				<#if child.MoaAnalysis.EmpiricalSupport?has_content>
					<para>Empirical support: <@com.richText child.MoaAnalysis.EmpiricalSupport/></para>
				</#if>

				<#if child.MoaAnalysis.ConclusionOnMoa?has_content>
					<para>Conclusion: <@com.richText child.MoaAnalysis.ConclusionOnMoa/></para>
				</#if>
			</#compress></#local>

		<#--Uncertainties-->
			<#local uncert><#compress>
				<#if child.UncertaintyAnalysis.UncertaintyAnalysis?has_content>
					<para>Uncertainty analysis:<?linebreak?>
						<#list child.UncertaintyAnalysis.UncertaintyAnalysis?children as unc>
							<para role="indent">
								<#if unc.IdentifiedUncertainties?has_content>
									<@com.text unc.IdentifiedUncertainties/>
								</#if>
								<#if unc.Justification?has_content>
									<@com.text unc.Justification/> -
								</#if>
							</para>
						</#list>
					</para>
				</#if>
			</#compress></#local>

		<#--print if content-->
			<#if uncert?has_content || MoA?has_content || evidence?has_content>
				<#if isFirst>
				<#--					<para><emphasis role="bold">ED assessment:</emphasis></para>-->
					<table border="1">
					<tbody>

					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment type</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Lines of evidence</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">MoA</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Uncertainty</emphasis></th>
						<#--			<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Conclusion</emphasis></th>-->
					</tr>
					<#local isFirst=false/>
				</#if>

				<tr>
					<td>${assessmentType}</td>
					<td>${evidence}</td>
					<td>${MoA}</td>
					<td>${uncert}</td>
				</tr>

			</#if>

		</#list>
		<#if !isFirst></tbody></table></#if>

	<#--Conclusion-->
		<#local conclusion><#compress>
			<#if summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentHumans.CriteriaForHumansMet?has_content>
				<para role="indent">ED criteria for humans met:<@com.picklist summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentHumans.CriteriaForHumansMet/></para>
			</#if>
			<#if summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.AdverseEffectRelevantForMammals?has_content>
				<para role="indent">Adverse effect relevant for wild mammals: <@com.picklist summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.AdverseEffectRelevantForMammals/></para>
			</#if>

			<#if summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.EdCriteriaMammalsMet?has_content>
				<para role="indent">ED criteria for wild mammals met: <@com.picklist summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.EdCriteriaMammalsMet/></para>
			</#if>

			<#if summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.ImpactOnOtherOrganisms?has_content>
				<para role="indent">ED criteria for non-target organisms other than mammals met: <@com.picklist summary.OverallConclusionEdAssessment.OverallConclusionEdAssessmentNonTargetOrganisms.ImpactOnOtherOrganisms/></para>
			</#if>
		</#compress></#local>
		<#if conclusion?has_content>
		<#--			<para><emphasis role="bold">Conclusion:</emphasis></para>-->
			Conclusion:<?linebreak?>
			${conclusion}
		</#if>
	</#compress>
</#macro>

<#macro nonDietaryExpoSummary summary>

	<#if summary.DescriptionOfUse.Uses?has_content>
		<para><emphasis role="bold">Uses and exposure:</emphasis></para>

		<#list summary.DescriptionOfUse.Uses as use>

			<#if use_has_next><para role="indent"><emphasis role="underline">SUMMARY #${use_index+1}</emphasis></para></#if>

			<para role="indent">Use: <@com.richText use.UseDescription/></para>

			<para role="indent">Exposure scenarios:</para>
			<table border="1">
				<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Operator</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Worker</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Bystander / resident</emphasis></th>
				</tr>
				<tr>
					<td>
						<@com.richText use.ExposureScenarios.OperatorExposure.OperatorExposure/>
					</td>
					<td>
						<@com.richText use.ExposureScenarios.WorkerExposure.WorkerExposure/>
					</td>
					<td>
						<@com.richText use.ExposureScenarios.BystanderResidentExposure.BystanderResidentExposure/>
					</td>
				</tr>
				</tbody>
			</table>
		</#list>
	</#if>
</#macro>

<#macro dermalAbsorptionSummary summary>
	<#compress>

		<#local csa=summary.KeyValueCsa>

		<para>
			<#if csa.Endpoint?has_content>
				Endpoint: <@com.picklist csa.Endpoint/>
			</#if>
			<#if csa.TypeOfInformation?has_content>
				- <@com.picklist csa.TypeOfInformation/>
			</#if>
			<#if csa.Justification?has_content>
				(<@com.text csa.Justification/>)
			</#if>
			.
		</para>

		<para>
			<#if csa.Species?has_content>
				Species: <@com.picklistMultiple csa.Species/>.
			</#if>
		</para>

		<para>
			<#if csa.Results?has_content>
				Results:
				<#list csa.Results as res>
					<para role="indent2">
						<@com.number res.Concentration/><@com.picklist res.Parameter/>
						<#if res.Absorption?has_content> - absorption: <@com.range res.Absorption/></#if>
					</para>
				</#list>
			</#if>
		</para>
	</#compress>
</#macro>

<#macro endpointBlock endpointPath>
	<#compress>
		<#if endpointPath.hasElement("EffectLevelUnit")>
			<#if endpointPath.EffectLevelUnit?has_content>
				<#if endpointPath.EffectLevelUnit?node_type=="picklist_single">
					<@com.picklist endpointPath.EffectLevelUnit/>:
				<#else>
					<@com.picklistMultiple endpointPath.EffectLevelUnit/>:
				</#if>

				<#if endpointPath.EffectLevelValue?node_type=="quantity">
					<@com.quantity endpointPath.EffectLevelValue/>
				<#else>
					<@com.range endpointPath.EffectLevelValue/>
				</#if>

				<?linebreak?>

				<#if endpointPath.hasElement("PhysicalForm") && endpointPath.PhysicalForm?has_content>
					(<@com.value endpointPath.PhysicalForm/>)<?linebreak?>
				</#if>
			</#if>
		</#if>

		<#if endpointPath.EndpointConclusion?has_content >
			<@com.picklist endpointPath.EndpointConclusion/>

			<#if endpointPath.hasElement("System") &&  endpointPath.System?has_content>
				: <@com.picklist endpointPath.System/>
			</#if>
			<#if endpointPath.hasElement("Organ") &&  endpointPath.Organ?has_content >
				-  <@com.picklistMultiple endpointPath.Organ/>
			</#if>
			<?linebreak?>
		</#if>

		<#-- Some cases (sensitisation) has additional information. NOTE: included outside of block-->
		<#--		<#if endpointPath.hasElement("AdditionalInformation") && endpointPath.AdditionalInformation?has_content>-->
		<#--			<para><@com.richText endpointPath.AdditionalInformation/></para>-->
		<#--		</#if>-->

	</#compress>
</#macro>

<#macro detailedEndpointName child name>
	<#if child?node_name!="EndpointConclusion" && !child?node_name?contains("Record")>
		${child?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}
	<#else>
		${name}
	</#if>

	<#--Add more details if exist: species, duration-->
	<#if child.hasElement("TestType") && child.TestType?has_content>
		| <@com.picklist child.TestType />
		<#if child.hasElement("ExperimentalExposureTimePerWeek") && child.ExperimentalExposureTimePerWeek?has_content>
			(<@com.number child.ExperimentalExposureTimePerWeek /> h/w)
		</#if>
	</#if>
	<#if child.hasElement("Species") && child.Species?has_content>
		| <@com.picklist picklistValue=child.Species printDescription=false printRemarks=false/>
	</#if>
</#macro>

<#function isEndpointsBlock path>
	<#if path?node_type=="block">
		<#if path?node_name=="EndpointConclusion">
			<#return true/>
		<#else>
			<#list path?children as child>
				<#if child?node_name=="EndpointConclusion">
					<#return true/>
				</#if>
			</#list>
		</#if>
	</#if>
	<#return false/>
</#function>

<#function getSummarySeq summary>
	<#local mySeq=[]/>

	<#if summary.hasElement("KeyValueForChemicalSafetyAssessment")>
		<#local csaPath=summary["KeyValueForChemicalSafetyAssessment"]>
	<#else>
	<#--NOTE: for cases like phototox-->
		<#local csaPath=summary>
	</#if>

	<#list csaPath?children as csaField>


		<#--Name (higher-level)-->
		<#local propName>
			${csaField?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}
		</#local>

		<#if csaField?node_type=="block">

			<#--Endpoints-->
			<#local links=""/>
			<#local endpoint=""/>
			<#list csaField?children as child>

				<#--Links-->
				<#if child?node_name=="LinkToRelevantStudyRecords" || child?node_name=="RelevantRecords">
					<#local links><#compress>
						<#if child.StudyNameType?has_content>
							<#list child.StudyNameType as studyReferenceLinkedToSummary>
								<#local studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
								<para>
									<command  linkend="${studyReference.documentKey.uuid!}">
										<@com.text studyReference.name/>
									</command>
								</para>
							</#list>
						</#if>
					</#compress></#local>
				</#if>

				<#--Endpoints block-->
				<#--case with simple block-->
				<#if isEndpointsBlock(child)>

					<#--Name (lower-level)-->
					<#local propName><@detailedEndpointName child propName/></#local>

					<#--Endpoints-->
					<#local endpoint><#compress><@endpointBlock child/>
					</#compress></#local>

					<#--append-->
					<#if links?has_content || endpoint?has_content>
						<#local mySeq = mySeq + [{'name': propName, "links" : links!, "endpoint":endpoint}]/>
					</#if>

				<#--case with repeatable blocks-->
				<#elseif child?children??>
					<#list child?children as gChildSeq>
						<#if gChildSeq?is_sequence>
							<#list gChildSeq as gChild>
								<#if gChild?is_node && isEndpointsBlock(gChild)>
								<#--Name (lower-level)-->
									<#local propName><@detailedEndpointName gChild propName/></#local>

								<#--Endpoints-->
									<#local endpoint><#compress><@endpointBlock gChild/></#compress></#local>

								<#--append-->
									<#if links?has_content || endpoint?has_content>
										<#local mySeq = mySeq + [{'name': propName, "links" : links!, "endpoint":endpoint}]/>
									</#if>
								</#if>
							</#list>
						</#if>
					</#list>
				</#if>
			</#list>
		</#if>
	</#list>

	<#return mySeq/>

</#function>

<#macro getSummaryFromHash hash>
	<#compress>
		<table border="1">
			<tbody valign="middle">
			<tr>
				<th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
				<th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Studies</emphasis></th>
				<th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA</emphasis></th>
			</tr>

			<#list hash?keys?sort as key>
				<#local seq = hash[key]/>
				<#local usespan = true />
				<#list seq as item>
					<tr>
						<#if usespan>
							<td rowspan="${seq?size}">${key}</td>
							<#local usespan = false />
						</#if>
						<td>${item.links}</td>
						<td>${item.endpoint}</td>
					</tr>
				</#list>
			</#list>
			</tbody></table>
	</#compress>
</#macro>

<#--Macro for summaries in TOX-->
<#macro toxPPPsummary subject docSubTypes includeMetabolites=true merge=false>
	<#compress>

		<#local summaryDocToCSAMap = {
		"Toxicokinetics" : {"path" : "KeyValue",
		"values" : [{"type":"listValue", "field": "Bioaccumulation", "preText" : "Bioaccumulation potential: "},
		{"type":"value", "field": "AbsorptionOral", "preText": "Oral absorption rate: ", "postText":"%"},
		{"type":"value", "field": "AbsorptionDerm", "preText": "Dermal absorption rate: ", "postText":"%"},
		{"type":"value", "field": "AbsorptionInhal", "preText": "Inhalation absorption rate: ", "postText":"%"}]},
		"Phototoxicity" : {"path":"KeyValueCsa", "values":[{"type":"listValue", "field":"Results", "preText":"Results: "}]}
		}/>

	<#--Get all documents, from same or different type-->
		<#if !docSubTypes?is_sequence>
			<#local docSubTypes=[docSubTypes]/>
		</#if>

	<#--Ensure merge=false for non compatible summary types-->
		<#if docSubTypes?seq_contains("Toxicokinetics") ||
		docSubTypes?seq_contains("ToxRefValues") ||
		docSubTypes?seq_contains("EndocrineDisruptingPropertiesAssessmentPest") ||
		docSubTypes?seq_contains("NonDietaryExpo") ||
		docSubTypes?seq_contains("DermalAbsorption") >
			<#local merge=false>
		</#if>

	<#-- Get all entities (subject and metabolites, if they exist)-->
		<#local entities=[subject]/>
		<#if includeMetabolites && _metabolites?? && _metabolites?has_content>
			<#local entities = entities + _metabolites/>
		</#if>

	<#-- Get all summaries for each entity-->
		<#local entity2summaryHash = {}/>
		<#list entities as entity>
			<#local entitySummaryList=[]/>
			<#list docSubTypes as docSubType>
				<#if docSubType=="ToxRefValues" || docSubType=="EndocrineDisruptingPropertiesAssessmentPest" || docSubType=="NonDietaryExpo">
					<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "FLEXIBLE_SUMMARY", docSubType) />
				<#else>
					<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />
				</#if>
				<#local entitySummaryList = entitySummaryList + summaryList/>
			</#list>
			<#if entitySummaryList?has_content>
				<#if entity.documentType=="MIXTURE">
					<#local entityName=entity.MixtureName/>
				<#elseif entity.documentType=="SUBSTANCE">
					<#local entityName=entity.ChemicalName/>
				</#if>
				<#local entity2summaryHash = entity2summaryHash + { entityName : entitySummaryList}/>
			</#if>
		</#list>

	<#--Iterate through summaries and create section lists for each entity-->
		<#list entity2summaryHash as entityName, allSummaryList>

			<#local keyInfo=[]/>
			<#local links=[]/>
			<#local endpointsHash={}/>
			<#local addInfo=[]/>
			<#local justification=[]/>
			<#local moa=[]/>

		<#--Need to iterate in every section, so that all Discussions, Key Information, Endpoints, etc appear together-->
			<#if allSummaryList?has_content>

				<#local printSummaryName = allSummaryList?size gt 1 />

				<#if entity2summaryHash?keys?seq_index_of(entityName)==0>
					<para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Summary</emphasis></para>
				</#if>

				<#if includeMetabolites && _metabolites?? && _metabolites?has_content && entityName!=subject.ChemicalName>
					<@com.emptyLine/>
					<para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityName}</emphasis> -----</emphasis></para>
					<@com.emptyLine/>
				</#if>

				<#list allSummaryList as summary>

					<#if (!merge) && printSummaryName>
						<para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para>
						<@com.emptyLine/>
					</#if>

				<#-- Key information-->
					<#if summary.documentSubType=="ToxicityToReproduction_EU_PPP" || summary.documentSubType=="GeneticToxicity">

						<#local summaryKeyInfo = []/>
						<#list summary.KeyValueForChemicalSafetyAssessment?children as csaEntry>
							<#if csaEntry?node_type=="block" && csaEntry.hasElement("DescriptionOfKeyInformation.KeyInfo")>
								<#if csaEntry.DescriptionOfKeyInformation.KeyInfo?has_content>
									<#local csaName>${csaEntry?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}</#local>
									<#local csaKeyInfo><para role="indent">
									<#-- <emphasis role="underline">${csaName}:</emphasis-->
										<@com.richText csaEntry.DescriptionOfKeyInformation.KeyInfo/>
										</para>
									</#local>
									<#local summaryKeyInfo = summaryKeyInfo + [csaKeyInfo]/>
								</#if>
							</#if>
						</#list>
						<#local summaryKeyInfo>${summaryKeyInfo?join("<?linebreak?>")}</#local>

					<#else>
						<#local summaryKeyInfo = ""/>

						<#local keyInfoPath><#compress>
							<#if summary.hasElement("DescriptionOfKeyInformation.KeyInfo")>
								summary.DescriptionOfKeyInformation.KeyInfo
							<#elseif summary.hasElement("KeyInformation.KeyInformation")>
								summary.KeyInformation.KeyInformation
							</#if>
						</#compress></#local>

						<#if keyInfoPath?eval?has_content>
							<#local summaryKeyInfo><para role="indent"><@com.richText keyInfoPath?eval/></para></#local>
						</#if>
					</#if>

					<#if summaryKeyInfo?has_content>
						<#if merge>
							<#local keyInfo = keyInfo + [summaryKeyInfo]/>
						<#else>
							<para><emphasis role="bold">Key information: </emphasis></para>${summaryKeyInfo}
						</#if>
					</#if>

				<#--Linked studies-->
					<#local summaryLinks=""/>
					<#if summary.hasElement("LinkToRelevantStudyRecord") && summary.LinkToRelevantStudyRecord.Link?has_content>
						<#local summaryLinks><#compress>
							<#list summary.LinkToRelevantStudyRecord.Link as studyReferenceLinkedToSummary>
								<#local studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
								<para role="indent">
									<command  linkend="${studyReference.documentKey.uuid!}">
										<@com.text studyReference.name/>
									</command>
								</para>
							</#list>
						</#compress></#local>
						<#if merge>
							<#local links = links + [summaryLinks]/>
						<#-- to check  :<#if resultFormat!="table">${links}</#if>-->
						<#else>
							<para><emphasis role="bold">Linked studies: </emphasis></para>${summaryLinks}
							<@com.emptyLine/>
						</#if>
					</#if>

				<#--CSA value:
                3 options: table format, flat format (use macro from physchem) or specific formats based on docSubType-->
					<#if summary.documentSubType=="ToxRefValues">
						<para><emphasis role="bold">Toxicological reference values: </emphasis></para>
						<@toxRefValuesTable summary/><@com.emptyLine/>

					<#elseif summary.documentSubType=="EndocrineDisruptingPropertiesAssessmentPest">
						<para><emphasis role="bold">ED assessment: </emphasis></para>
						<@endocrineDisruptingPropertiesTable summary/><@com.emptyLine/>

					<#elseif summary.documentSubType=="NonDietaryExpo">
						<@nonDietaryExpoSummary summary/><@com.emptyLine/>

					<#elseif summary.documentSubType=="DermalAbsorption">
						<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
						<para role="indent">
							<@dermalAbsorptionSummary summary/>
							<@com.emptyLine/>
						</para>

					<#elseif summary.documentSubType=="Toxicokinetics" || (summary.documentSubType=="Phototoxicity" && !(merge))>
						<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
						<para role="indent">
							<@valueForCSA summary summaryDocToCSAMap[summary.documentSubType]/>
							<@com.emptyLine/>
						</para>

					<#else>

						<#if !merge><#local endpointsHash={}/></#if>

					<#--Get sequence of hashes and populate hash-->
						<#if summary.documentSubType=="Phototoxicity">
						<#--special case for Phototox-->
							<#local photoEndpoint><@com.picklist summary.KeyValueCsa.Results/></#local>
							<#local photoLinks = summaryLinks?replace("\\|", "<\\?linebreak\\?>", "r")/>
							<#local photoLinks = photoLinks?replace('role="indent"', '')/>
							<#local summarySeq = [{"name":"Phototoxicity", "links": photoLinks, "endpoint": photoEndpoint}]/>
						<#elseif summary.documentSubType=="SpecificInvestigationsOtherStudies">
							<#local summarySeq = [{"name":"Intraperitoneal/subcutaneous single dose", "links":links?replace("\\|", "<\\?linebreak\\?>", "r"), "endpoint": ""}]/>
						<#else>
							<#local summarySeq = getSummarySeq(summary)/>
						</#if>

						<#list summarySeq as seqEntry>
							<#if endpointsHash[seqEntry["name"]]??>
								<#local newSeqEntry = endpointsHash[seqEntry["name"]] + [seqEntry]/>
								<#local endpointsHash = endpointsHash + {seqEntry["name"]:newSeqEntry}/>
							<#else>
								<#local endpointsHash = endpointsHash + {seqEntry["name"]:[seqEntry]}/>
							</#if>
						</#list>


						<#if !merge && endpointsHash?has_content>
							<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
							<@getSummaryFromHash endpointsHash/><@com.emptyLine/>
						</#if>

					</#if>

				<#--  MoA: to do -->
					<#local summaryMoA=""/>
					<#if summary.hasElement("KeyValueForChemicalSafetyAssessment.MoAHumanRelevanceFramework.MoAHumanRelevanceFramework") && summary.Discussion.Discussion?has_content>
						<#local summaryMoA><para role="indent"><@com.richText summary.KeyValueForChemicalSafetyAssessment.MoAHumanRelevanceFramework.MoAHumanRelevanceFramework/></para></#local>
					<#elseif summary.hasElement("KeyValueForChemicalSafetyAssessment.MoAAnalysisHumanRelevanceFramework.MoAAnalysisHumanRelevanceFramework")>
						<#local summaryMoA><para role="indent"><@com.richText summary.KeyValueForChemicalSafetyAssessment.MoAAnalysisHumanRelevanceFramework.MoAAnalysisHumanRelevanceFramework/></para></#local>
					</#if>
					<#if summaryMoA?has_content>
						<#if merge>
							<#local moa = moa + [summaryMoA]/>
						<#else>
							<para><emphasis role="bold">Mode of Action Analysis / Human Relevance Framework: </emphasis></para>${summaryMoA}
						</#if>
					</#if>


				<#--Discussion-->
					<#if summary.hasElement("Discussion.Discussion") && summary.Discussion.Discussion?has_content>
						<#local summaryDiscussion><para role="indent"><@com.richText summary.Discussion.Discussion/></para></#local>
						<#if merge>
							<#local addInfo = addInfo + [summaryDiscussion]/>
						<#else>
							<para><emphasis role="bold">Additional information: </emphasis></para>${summaryDiscussion}
						</#if>
					</#if>

				<#--Additional Info-->
					<#local summaryAddInfo = ""/>

					<#if summary.documentSubType=="ToxicityToReproduction_EU_PPP" || summary.documentSubType=="Sensitisation">

						<#local summaryAddInfo = []/>
						<#list summary.KeyValueForChemicalSafetyAssessment?children as csaEntry>
							<#if csaEntry?node_type=="block">
								<#local addInfoPath><#compress>
									<#if csaEntry.hasElement("EndpointConclusion.AdditionalInformation")>
										csaEntry.EndpointConclusion.AdditionalInformation
									<#elseif csaEntry.hasElement("AdditionalInformation.AdditionalInfo")>
										csaEntry.AdditionalInformation.AdditionalInfo
									</#if>
								</#compress></#local>
								<#if addInfoPath?has_content && addInfoPath?eval?has_content>
									<#local csaName>${csaEntry?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}:</#local>
									<#local csaAddInfo><para role="indent">
									<#--  <emphasis role="underline">${csaName}</emphasis> -->
										<@com.richText addInfoPath?eval/></para>
									</#local>
									<#local summaryAddInfo = summaryAddInfo + [csaAddInfo]/>
								</#if>
							</#if>
						</#list>
						<#local summaryAddInfo>${summaryAddInfo?join("<?linebreak?>")}</#local>

					<#elseif summary.hasElement("AdditionalInformation.AdditionalInfo") && summary.AdditionalInformation.AdditionalInfo?has_content>

						<#local summaryAddInfo><para role="indent"><@com.richText summary.AdditionalInformation.AdditionalInfo/></para></#local>
					</#if>

					<#if summaryAddInfo?has_content>
						<#if merge>
							<#local addInfo =  addInfo + [summaryAddInfo]/>
						<#else>
							<para><emphasis role="bold">Additional information: </emphasis></para>${summaryAddInfo}
						</#if>
					</#if>

				<#--Justification-->
					<#if summary.hasElement("JustificationForClassificationOrNonClassification") && summary.JustificationForClassificationOrNonClassification?has_content>

						<#local summaryJustification><#compress>
							<#list summary.JustificationForClassificationOrNonClassification?children as just>
								<#if just?has_content>
									<para role="indent">
										<#if just_has_next>${just?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first}:</#if>
										<@com.richText just/>
									</para>
								</#if>
							</#list>
						</#compress></#local>
						<#if merge>
							<#local justification =  justification + [summaryJustification]/>
						<#else>
							<para><emphasis role="bold">Justification for classification or non-classification:</emphasis></para>${summaryJustification}
						</#if>
					</#if>
				</#list>

				<#if merge>
					<#if keyInfo?has_content>
						<para><emphasis role="bold">Key information: </emphasis></para>
						${keyInfo?join("")}
						<@com.emptyLine/>
					</#if>

					<#if endpointsHash?has_content>
						<para><emphasis role="bold">Key values for chemical safety assessment: </emphasis></para>
						<@getSummaryFromHash endpointsHash/>
						<@com.emptyLine/>
					</#if>

					<#if moa?has_content>
						<para><emphasis role="bold">Mode of Action Analysis / Human Relevance Framework:</emphasis></para>
						${moa?join("")}
						<@com.emptyLine/>
					</#if>

					<#if addInfo?has_content>
						<para><emphasis role="bold">Additional information:</emphasis></para>
						${addInfo?join("")}
						<@com.emptyLine/>
					</#if>

				<#--                    <#if discussion?has_content>-->
				<#--                        <para><emphasis role="bold">Discussion:</emphasis></para>-->
				<#--                        ${discussion?join("")}-->
				<#--                        <@com.emptyLine/>-->
				<#--                    </#if>-->

					<#if justification?has_content>
						<para><emphasis role="bold">Justification for classification or non classification:</emphasis></para>
						${justification?join("")}
						<@com.emptyLine/>
					</#if>
				</#if>

			</#if>
		</#list>
	</#compress>
</#macro>

<#macro valueForCSA summary propertyData>
	<#compress>
		<#if propertyData["values"]?has_content>
			<#list propertyData["values"] as value>

				<#local valuePath = "summary." + propertyData["path"] + "." + value["field"] />
				<#local val = valuePath?eval />
				<#if val?has_content>
					<para>
					<#-- preText -->
					${value["preText"]!}

					<#-- value
					NOTE: the "type" field in the hashMap could be omitted and just use node_type for each case
					e.g. picklist_single, picklist_multi...-->
					<#if value["type"]=='listValue'>
						<@com.picklist val />
					<#elseif value["type"]=='mListValue'>
						<@com.picklistMultiple  val />
					<#elseif value["type"]=='value'>
						<#if (val?node_type)=="decimal">
							<@com.number val />
						<#elseif (val?node_type)=="quantity">
							<@com.quantity val />
						<#elseif (val?node_type)=="range">
							<@com.range val />
						</#if>
					</#if>

					<#-- postText -->
					${value["postText"]!}

					<#-- atValuePath -->
					<#if value["atField"]?has_content>
						<#local atValuePath = "summary." + propertyData["path"] + "." + value["atField"] />
						<#local atVal = atValuePath?eval />
						<#if atVal?has_content>
							at <@com.quantity atVal />
						</#if>
					</#if>
					</para>
				</#if>
<#--				<#if value_has_next>-->
<#--					<?linebreak?>-->
<#--				</#if>-->
			</#list>
		</#if>
	</#compress>
</#macro>