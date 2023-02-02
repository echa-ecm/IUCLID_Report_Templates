<!-- Common macros and functions for endpoint studies and summaries that could be reused in any template based on IUCLID6 data -->

<#-- Macros to initialize and get assessment entity information -->

<#-- Variable to hold the list of assessment entities -->
<#assign assessmentEntities = [] />

<#-- Variable that flags wheather assessment entities exist or not -->
<#assign assessmentEntitiesExist = false />

<#-- Initialize assessmentEntities list with the different type of assessment entities: RegisteredSubstanceAsSuch, SpecificCompositionOfTheRegisteredSubstance, GroupOfConstituentInTheRegisteredSubstance, TransformationProductOfTheRegisteredSubstance-->
<#macro initAssessmentEntities substance>
	<#local aeList = iuclid.getSectionDocumentsForParentKey(substance.documentKey, "ASSESSMENT_ENTITY", "RegisteredSubstanceAsSuch") />
	<#assign assessmentEntities = assessmentEntities + aeList/>
	
	<#local aeList = iuclid.getSectionDocumentsForParentKey(substance.documentKey, "ASSESSMENT_ENTITY", "SpecificCompositionOfTheRegisteredSubstance") />
	<#assign assessmentEntities = assessmentEntities + aeList/>
	
	<#local aeList = iuclid.getSectionDocumentsForParentKey(substance.documentKey, "ASSESSMENT_ENTITY", "GroupOfConstituentInTheRegisteredSubstance") />
	<#assign assessmentEntities = assessmentEntities + aeList/>
	
	<#local aeList = iuclid.getSectionDocumentsForParentKey(substance.documentKey, "ASSESSMENT_ENTITY", "TransformationProductOfTheRegisteredSubstance") />
	<#assign assessmentEntities = assessmentEntities + aeList/>
	
	<#assign assessmentEntitiesExist = assessmentEntities?size gt 0 />
</#macro>

<#function getAssessmentEntitiesLinkedToSummary summary>
	<#local aeList = [] />
	<#list assessmentEntities as ae>
		<#local linkedSummaryList = ae.EndpointSummariesList />
		<#if linkedSummaryList?has_content>
			<#list linkedSummaryList as blockItem>
				<#local summaryList = blockItem.Name />
				<#if summaryList?has_content>
					<#list summaryList as sumKey>
						<#if summary.documentKey == sumKey>
							<#local aeList = aeList + [ae] />
						</#if>
					</#list>
				</#if>
			</#list>
		</#if>
	</#list>
	<#return aeList />
</#function>

<#-- Macros to print study records and populate resultStudyList, dataWaivingStudyList, testingProposalStudyList -->

<#macro dataWaiving dataWaivingStudyList endpoint printHeader=true>
	<#if dataWaivingStudyList?has_content>
		<#if printHeader>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Data waiving</emphasis></para>
		</#if>
		<#list dataWaivingStudyList as study>
			<@dataWaivingRecord study endpoint/>
		</#list>
	</#if>
</#macro>

<#macro dataWaivingRecord study endpoint>
	<#if study?has_content>

		<#if pppRelevant??>
			<para><emphasis role="bold"><@com.text study.name/></emphasis>:</para>
			<para xml:id="${study.documentKey.uuid!}" role="indent"><emphasis role="bold">Information requirement: </emphasis>
			 	<#if study.AdministrativeData.Endpoint?has_content>
			 		<@com.value study.AdministrativeData.Endpoint/>
			 	<#else>
			 		${endpoint!}
				</#if>
			</para>
		<#else>
			<para><emphasis role="bold">Information requirement: </emphasis>${endpoint!}</para>
		</#if>

		<para role="indent">
			<emphasis role="bold">Reason: </emphasis>
			<@com.value study.AdministrativeData.DataWaiving/>
		</para>
		<para role="indent">
			<emphasis role="bold">Justification:</emphasis>
			<@com.picklistMultiple study.AdministrativeData.DataWaivingJustification/>
		</para>
	</#if>
</#macro>

<#macro testingProposal testingProposalStudyList endpoint printHeader=true printEndpointField=false>
	<#if testingProposalStudyList?has_content>
		<#if printHeader>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Testing proposal</emphasis></para>
		</#if>
		<#list testingProposalStudyList as study>
			<@testingProposalRecord study endpoint printEndpointField/>
		</#list>
	</#if>
</#macro>

<#macro testingProposalRecord study endpoint printEndpointField=false>
	<#if study?has_content>

		<@com.emptyLine/>
		<#if pppRelevant??>
			<para xml:id="${study.documentKey.uuid!}"><emphasis role="bold">Information requirement: </emphasis>
				<#if study.AdministrativeData.Endpoint?has_content>
					<@com.value study.AdministrativeData.Endpoint/>
				<#else>
					${endpoint!}
				</#if>
			</para>
		<#else>
			<para><emphasis role="bold">Information requirement:</emphasis> ${endpoint!}
			<#if printEndpointField>
				<#if endpoint?has_content>(</#if>
				<@com.value study.AdministrativeData.Endpoint/>
				<#if endpoint?has_content>)</#if>
			</#if>
			</para>
		</#if>

		<para role="indent">
			<emphasis role="bold">Justification for testing proposal:</emphasis>
			<@com.text study.AdministrativeData.JustificationForTypeOfInformation/>
		</para>
		<para role="indent">
			<emphasis role="bold">Proposed test guideline:</emphasis>
			<@guidelineList study.MaterialsAndMethods.Guideline/>
		</para>
		
		<#if study.hasElement("MaterialsAndMethods.StudyType") && study.MaterialsAndMethods.StudyType?has_content>
			<para role="indent">
				<emphasis role="bold">Planned study type:</emphasis>
				<@com.value study.MaterialsAndMethods.StudyType/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.MethodType") && study.MaterialsAndMethods.MethodType?has_content>
			<para role="indent">
				Type of method:
				<@com.value study.MaterialsAndMethods.MethodType/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.DetailsOnMethods") && study.MaterialsAndMethods.StudyDesign.DetailsOnMethods?has_content>
			<para role="indent">
				Details on methods:
				<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnMethods/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.InoculumOrTestSystem") && study.MaterialsAndMethods.StudyDesign.InoculumOrTestSystem?has_content>
			<para role="indent">
				Test system:
				<@com.value study.MaterialsAndMethods.StudyDesign.InoculumOrTestSystem/>
				(<@com.value study.MaterialsAndMethods.StudyDesign.OxygenConditions/>)
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSurfaceWater") && study.MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSurfaceWater?has_content>
			<para role="indent">
				Source and properties of surface water:
				<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSurfaceWater/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSediment") && study.MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSediment?has_content>
			<para role="indent">
				Source and properties of sediment:
				<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnSourceAndPropertiesOfSediment/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.DetailsOnStudyDesign") && study.MaterialsAndMethods.StudyDesign.DetailsOnStudyDesign?has_content>
			<para role="indent">
				Study design:
				<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnStudyDesign/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.DetailsOnExperimentalConditions") && study.MaterialsAndMethods.StudyDesign.DetailsOnExperimentalConditions?has_content>
			<para role="indent">
				Study design:
				<@com.text study.MaterialsAndMethods.StudyDesign.DetailsOnExperimentalConditions/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies") && study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies?has_content>
			<para role="indent">
				Species:
				<@com.value study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
				<#if study.hasElement("MaterialsAndMethods.StudyDesign.WaterMediaType") && study.MaterialsAndMethods.StudyDesign.WaterMediaType?has_content>
					(<@com.value study.MaterialsAndMethods.StudyDesign.WaterMediaType/>)
				</#if>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.RouteOfExposure") && study.MaterialsAndMethods.StudyDesign.RouteOfExposure?has_content>
			<para role="indent">
				Compartment / route:
				<@com.value study.MaterialsAndMethods.StudyDesign.RouteOfExposure/> (<@com.value study.MaterialsAndMethods.StudyDesign.WaterMediaType/>)
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.TestType") && study.MaterialsAndMethods.StudyDesign.TestType?has_content>
			<para role="indent">
				Test type:
				<@com.value study.MaterialsAndMethods.StudyDesign.TestType/>
			</para>
		</#if>
		
		<para role="indent">
			<emphasis role="bold">Principles of method if other than guideline:</emphasis>
			<?linebreak?>
			<@com.text study.MaterialsAndMethods.MethodNoGuideline/>
		</para>
		<para role="indent">
			<emphasis role="bold">Planned study period:</emphasis>
			<@com.text study.AdministrativeData.StudyPeriod/>
		</para>
		<para role="indent">
			<emphasis role="bold">Test material:</emphasis>
			<@testMaterialInformation study.MaterialsAndMethods.TestMaterials.TestMaterialInformation/>
		</para>
	</#if>
</#macro>

<#-- Macro to get guideline and qualifier information from endpoint study records (OHTs) -->
<#macro guidelineList guidelineRepeatableBlock>
<#compress>
	<#if guidelineRepeatableBlock?has_content>
		<#list guidelineRepeatableBlock as blockItem>
			<#local Qualifier><@com.value blockItem.Qualifier/></#local>
			<#local Guideline><@com.value blockItem.Guideline/></#local>
			<#if Qualifier?has_content>${Qualifier}</#if>
			<#if Guideline?has_content>${Guideline}</#if>
			<#if blockItem_has_next>; </#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#-- Macro and variable to hold the list of Test Material Information documents in the order of appearance. A document should appear only once in this list -->
<#assign testMaterialInformations = [] />

<#macro testMaterialInformation documentKey>
<#compress>
	<#if documentKey?has_content>
		<#local testMaterial = iuclid.getDocumentForKey(documentKey) />
		<#if testMaterial?has_content>
			
			<#if csrRelevant??>		
			<#assign testMaterialInformations = com.addDocumentToSequence(testMaterial, testMaterialInformations) />
			<#else>
				<#assign testMaterialInformations = com.addDocumentToSequenceAsUnique(testMaterial, testMaterialInformations) />
			</#if>

			<@com.text testMaterial.Name/>,
			<#if testMaterial.Composition.OtherCharacteristics.TestMaterialForm?has_content>
			<?linebreak?>
			Form: <@com.value testMaterial.Composition.OtherCharacteristics.TestMaterialForm/>
			</#if> 
			
			<#--pppRelevant only -->
			<#if pppRelevant??>
				<#if testMaterial.Composition.CompositionPurityOtherInformation?has_content>
					<?linebreak?>
					Composition / purity: <@com.value testMaterial.Composition.CompositionPurityOtherInformation/>
				</#if>
			</#if>
			
			(full information in <command linkend="${testMaterial.documentKey.uuid!}">
			<#if pppRelevant??>Annex - Test materials<#else>Annex II</#if></command>).

		</#if>
	<#else>
		
	</#if>
</#compress>
</#macro>

<#-- Macro for populating the justification for type of information found in endpoint study records (OHTs) -->
<#macro tableRowForJustificationForTypeOfInformation study>
<#compress>
	<#if study?has_content && study.AdministrativeData.JustificationForTypeOfInformation?has_content>
		<tr>
			<td colspan="3">
				Justification for type of information:
				<@com.text study.AdministrativeData.JustificationForTypeOfInformation/>
			</td>
		</tr>
	</#if>
</#compress>
</#macro>

<#-- Macros to print study results column of study tables -->

<#macro studyRemarksColumn study>
	<para>
		<@com.value study.AdministrativeData.Reliability/>
	</para>
	<para>
		<@com.value study.AdministrativeData.PurposeFlag/>
	</para>
	<para>
		<@com.value study.AdministrativeData.StudyResultType/>
	</para>
	<para>
	<@com.emptyLine/>
		<emphasis role="bold">Test material</emphasis>
		<?linebreak?>
		<#if !(study.MaterialsAndMethods.TestMaterials.TestMaterialInformation)?has_content && !(study.MaterialsAndMethods.TestMaterials.AdditionalTestMaterialInformation)?has_content>
			Information not provided in IUCLID
			<#else>
				<!-- main test material information -->
				<@testMaterialInformation study.MaterialsAndMethods.TestMaterials.TestMaterialInformation/>
				<!-- additional test material information -->
				<#assign additionalTestMaterials = study.MaterialsAndMethods.TestMaterials.AdditionalTestMaterialInformation/>
				<#list additionalTestMaterials as additionalTestMaterial>
					<#if additionalTestMaterial?has_content>
					<para><@testMaterialInformation additionalTestMaterial/></para>
					</#if>
				</#list>
		</#if>
	</para>
	<para>
	<@com.emptyLine/>
		<emphasis role="bold">Reference</emphasis>
		<?linebreak?>
		<@literatureReferenceList study.DataSource.Reference/>
	</para>
</#macro>

<#-- Macro and Variable to hold the list of references in the order of appearance. A reference document should appear only once in this list -->
<#assign literatureReferences = [] />

<#macro literatureReferenceList multipleReferenceValue>
<#compress>
	<#if multipleReferenceValue?has_content>
		<#list multipleReferenceValue as item>
			<#local reference = iuclid.getDocumentForKey(item) />
			<#if reference?has_content>

				<#if csrRelevant??>
				<#assign literatureReferences = com.addDocumentToSequence(reference, literatureReferences) />
					<#else>
					<#assign literatureReferences = com.addDocumentToSequenceAsUnique(reference, literatureReferences) />
				</#if>
				
				<command linkend="${reference.documentKey.uuid!}">
					<@com.text reference.GeneralInfo.Author/> <#if reference.GeneralInfo.ReferenceYear?has_content>${reference.GeneralInfo.ReferenceYear?string["0"]}</#if>
				</command>
				<?linebreak?>
			</#if>
		</#list>
	</#if>
</#compress>
</#macro>

<#-- Macros to print endpoint summary information: summary name, linked assessment entities and additional information of the endpoint summary  -->
<#macro endpointSummary summary valueForCsaText="" path="" printName=false>
	<#if printName>
		<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
	</#if>

	<@summaryKeyInformation summary/>

	<#if valueForCsaText?has_content>
		<@com.emptyLine/>
		<para>
			<emphasis role="bold">Value used for CSA:</emphasis>
			<?linebreak?>
			${valueForCsaText}
		</para>
	</#if>
	
	<@relevantStudies summary path/>	
	
	<@assessmentEntitiesList summary />
	
	<@summaryAdditionalInformation summary/>
</#macro>

<#macro assessmentEntitiesList summary>
<#if assessmentEntitiesExist>
	<#assign aeList = getAssessmentEntitiesLinkedToSummary(summary)/>
	<#if aeList?has_content>
		<para>
			<emphasis role="bold">Assessment entity linked:</emphasis>
			<#list aeList as ae>
				<emphasis role="bold"><@com.text ae.AssessmentEntityName/></emphasis>. 
					View the assessment entity table in chapter 1.3 <command linkend="${ae.documentKey.uuid!}">here</command>
				<#if ae_has_next>;<para></para></#if>
			</#list>
		</para>
	</#if>
</#if>
</#macro>

<#-- Macro to get relevant studies linked to a summary -->
<#macro relevantStudies summary path>

<#local docDefId = summary.documentType +"."+ summary.documentSubType/>

	<#-- generic linkes from endpoint summaries to endpoint study records -->					
	
	<#if !(docDefId=="ENDPOINT_SUMMARY.AcuteToxicity" || docDefId=="ENDPOINT_SUMMARY.IrritationCorrosion" || docDefId=="ENDPOINT_SUMMARY.Sensitisation" ||
	docDefId=="ENDPOINT_SUMMARY.RepeatedDoseToxicity" || docDefId=="ENDPOINT_SUMMARY.GeneticToxicity" || docDefId=="ENDPOINT_SUMMARY.Carcinogenicity" ||
	docDefId=="ENDPOINT_SUMMARY.ToxicityToReproduction" || docDefId=="ENDPOINT_SUMMARY.Neurotoxicity" || docDefId=="ENDPOINT_SUMMARY.Immunotoxicity")>
		<#if summary?has_content>		
			<#if summary.LinkToRelevantStudyRecord.Link?has_content>
				<@com.emptyLine/>
				<#list summary.LinkToRelevantStudyRecord.Link as studyReferences>
					<#if studyReferences?has_content>
					<#assign studyLink = iuclid.getDocumentForKey(studyReferences) />
						<para>Relevant studies: <@com.text studyLink.name/></para>
					</#if>
				</#list>
			</#if>
		</#if>
		
	<#-- certain endpoint summaries that differentiate between linked studies and require a certain 'path' to be added -->
	<#else>
		<#local linkedRecord = ("summary.KeyValueForChemicalSafetyAssessment."+path+".LinkToRelevantStudyRecordS")?eval/>
		<#if 	linkedRecord?has_content>
			<#list linkedRecord as records>
				<#if records?has_content>
				<#local link = iuclid.getDocumentForKey(records) />
					<para>Relevant studies: <@com.text link.name/></para>
				</#if>
			</#list>
		</#if>		
	</#if>
</#macro>

<#function isStudyInformationDifferentPath summary>
<#if summary?has_content>							
<#local docDefId = summary.documentType +"."+ summary.documentSubType/>

 <#if !(docDefId=="ENDPOINT_SUMMARY.AcuteToxicity" || docDefId=="ENDPOINT_SUMMARY.IrritationCorrosion" || docDefId=="ENDPOINT_SUMMARY.Sensitisation" ||
 docDefId=="ENDPOINT_SUMMARY.RepeatedDoseToxicity" || docDefId=="ENDPOINT_SUMMARY.GeneticToxicity" || docDefId=="ENDPOINT_SUMMARY.Carcinogenicity" ||
 docDefId=="ENDPOINT_SUMMARY.ToxicityToReproduction" || docDefId=="ENDPOINT_SUMMARY.Neurotoxicity" || docDefId=="ENDPOINT_SUMMARY.Immunotoxicity")>
	<#return false>
	<#else>
		<#return true>
	</#if>
</#if>
<#return false>
</#function>



<#-- Macros to print an endpoint summary's key information  -->
<#macro summaryKeyInformation summary>
	<#compress>
		<@com.emptyLine/>
		<#if summary.hasElement("KeyInformation.KeyInformation") && summary.KeyInformation.KeyInformation?has_content>
			<para>
				<emphasis role="underline">Key Information:</emphasis>
			    <@com.value summary.KeyInformation.KeyInformation/>
			</para>
			<#elseif summary.hasElement("KeyInformation") && summary.KeyInformation?has_content>
			<para>
				<emphasis role="underline">Key Information:</emphasis>
			    <@com.value summary.KeyInformation/>
			</para>
		</#if>
	</#compress>
</#macro>

<#-- Macros to print an endpoint summary's additional information (discussion only)  -->
<#macro summaryAdditionalInformation summary>
	<#compress>
		<@com.emptyLine/>
			<#--<para>-->
				<#if summary.Discussion.Discussion?has_content>
				<para>
					<emphasis role="underline">Additional information:</emphasis>
					<@com.richText summary.Discussion.Discussion/>
				</para>
				</#if>
			<#--</para>-->
	</#compress>
</#macro>

<#-- Variables for hyperlinking/populating Annex III -->

<#assign modeOfActionsOthersReproductiveTox = [] />
<#macro modeOfActionOtherReproductiveTox summary>
<#compress>	
	<#assign modeOfActionsOthersReproductiveTox = modeOfActionsOthersReproductiveTox + [summary] />
		<para>Detailed information on the Mode of Action is available in <command linkend="${summary.documentKey.uuid!}">Annex III.</command></para>
</#compress>
</#macro>

<#assign modeOfActionRepeatedDosesToxicity = [] />
<#macro modeOfActionRepeatedDoseToxicity summary>
<#compress>
	<#assign modeOfActionRepeatedDosesToxicity = modeOfActionRepeatedDosesToxicity + [summary] />
		<para>Detailed information on the Mode of Action is available in <command linkend="${summary.documentKey.uuid!}">Annex III.</command></para>
</#compress>
</#macro>

<#assign modeOfActionsOthersGenetic = [] />
<#macro modeOfActionOtherGenetic summary>
<#compress>
	<#assign modeOfActionsOthersGenetic = modeOfActionsOthersGenetic + [summary]/>
		<para>Detailed information on the Mode of Action is available in <command linkend="${summary.documentKey.uuid!}">Annex III.</command></para>
</#compress>
</#macro>

<#assign modeOfActionsOthersCarcinogenicity = [] />
<#macro modeOfActionOtherCarcinogenicity summary>
<#compress>
	<#assign modeOfActionsOthersCarcinogenicity = modeOfActionsOthersCarcinogenicity + [summary]/>
		<para>Detailed information on the Mode of Action is available in <command linkend="${summary.documentKey.uuid!}">Annex III.</command></para>
</#compress>
</#macro>

<#-- Function to order test result repeatable block items according to KeyResult values. KeyResults should come first -->
<#function orderByKeyResult resultsRepeatableBlock>
	<#local orderedList = resultsRepeatableBlock />
	<#if resultsRepeatableBlock?has_content>
		<#local keyResultList = [] />
		<#local otherResultList = [] />
		<#list resultsRepeatableBlock as result>
			<#if isKeyResult(result) >
				<#local keyResultList = keyResultList + [result] />
			<#else/>
				<#local otherResultList = otherResultList + [result] />
			</#if>
		</#list>
		<#local orderedList = keyResultList + otherResultList />
	</#if>
	<#return orderedList />
</#function>

<#function isKeyResult resultBlockItem>
	<#if resultBlockItem?has_content && resultBlockItem.hasElement("KeyResult") && resultBlockItem.KeyResult >
		<#return true />
	</#if>
	<#return false />
</#function>