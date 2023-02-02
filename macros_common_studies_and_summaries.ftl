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
			 		<@com.picklist study.AdministrativeData.Endpoint/>
			 	<#else>
			 		${endpoint!}
				</#if>
			</para>
		<#else>
			<para><emphasis role="bold">Information requirement: </emphasis>${endpoint!}</para>
		</#if>

		<para role="indent">
			<emphasis role="bold">Reason: </emphasis>
			<@com.picklist study.AdministrativeData.DataWaiving/>
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
					<@com.picklist study.AdministrativeData.Endpoint/>
				<#else>
					${endpoint!}
				</#if>
			</para>
		<#else>
			<para><emphasis role="bold">Information requirement:</emphasis> ${endpoint!}
			<#if printEndpointField>
				<#if endpoint?has_content>(</#if>
				<@com.picklist study.AdministrativeData.Endpoint/>
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
				<@com.picklist study.MaterialsAndMethods.StudyType/>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.MethodType") && study.MaterialsAndMethods.MethodType?has_content>
			<para role="indent">
				Type of method:
				<@com.picklist study.MaterialsAndMethods.MethodType/>
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
				<@com.picklist study.MaterialsAndMethods.StudyDesign.InoculumOrTestSystem/>
				(<@com.picklist study.MaterialsAndMethods.StudyDesign.OxygenConditions/>)
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
				<@com.picklist study.MaterialsAndMethods.TestOrganisms.TestOrganismsSpecies/>
				<#if study.hasElement("MaterialsAndMethods.StudyDesign.WaterMediaType") && study.MaterialsAndMethods.StudyDesign.WaterMediaType?has_content>
					(<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>)
				</#if>
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.RouteOfExposure") && study.MaterialsAndMethods.StudyDesign.RouteOfExposure?has_content>
			<para role="indent">
				Compartment / route:
				<@com.picklist study.MaterialsAndMethods.StudyDesign.RouteOfExposure/> (<@com.picklist study.MaterialsAndMethods.StudyDesign.WaterMediaType/>)
			</para>
		</#if>
		<#if study.hasElement("MaterialsAndMethods.StudyDesign.TestType") && study.MaterialsAndMethods.StudyDesign.TestType?has_content>
			<para role="indent">
				Test type:
				<@com.picklist study.MaterialsAndMethods.StudyDesign.TestType/>
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
			<#local Qualifier><@com.picklist blockItem.Qualifier/></#local>
			<#local Guideline><@com.picklist blockItem.Guideline/></#local>
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
			Form: <@com.picklist testMaterial.Composition.OtherCharacteristics.TestMaterialForm/>
			</#if> 
			
			<#--pppRelevant only -->
			<#if pppRelevant??>
				<#if testMaterial.Composition.CompositionPurityOtherInformation?has_content>
					<?linebreak?>
					Composition / purity: <@com.picklist testMaterial.Composition.CompositionPurityOtherInformation/>
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
		<@com.picklist study.AdministrativeData.Reliability/>
	</para>
	<para>
		<@com.picklist study.AdministrativeData.PurposeFlag/>
	</para>
	<para>
		<@com.picklist study.AdministrativeData.StudyResultType/>
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
<#macro endpointSummary summary valueForCsaText="" printName=false>
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
	
	<@relevantStudies summary/>	
	
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
<#macro relevantStudies summary>
							
	<#if isStudyInformationDifferentPath(summary)>
		<#if summary?has_content>
			<#if isStudyInformationAvailable(summary)>			
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
		</#if>
		
		<#else>
		<#assign summaryPathToDataMap = {
		'Acute Toxicity oral' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'AcuteToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.AcuteToxicityViaOralRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Acute Toxicity oral', 'subCategoryRelevant' : 'Yes'},
		 'Acute Toxicity inhalation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'AcuteToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.AcuteToxicityViaInhalationRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Acute Toxicity inhalation', 'subCategoryRelevant' : 'Yes'},
		 'Acute Toxicity dermal' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'AcuteToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.AcuteToxicityViaDermalRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Acute Toxicity dermal', 'subCategoryRelevant' : 'Yes'},
		 'Irritation / corrosion (skin)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'IrritationCorrosion', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.SkinIrritationCorrosion.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Irritation / corrosion (skin)', 'subCategoryRelevant' : 'Yes'},
		 'Irritation / corrosion (eye)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'IrritationCorrosion', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EyeRespirationIrritation.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Irritation / corrosion (eye)', 'subCategoryRelevant' : 'Yes'},
		 'Skin sensitisation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Sensitisation', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.SkinSensitisation.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Skin sensitisation', 'subCategoryRelevant' : 'Yes'},
		 'Respiratory sensitisation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Sensitisation', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RespiratorySensitisation.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Respiratory sensitisation', 'subCategoryRelevant' : 'Yes'},
		 'Repeated dose oral' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'RepeatedDoseToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityViaOralRouteSystemicEffects.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Repeated dose oral', 'subCategoryRelevant' : 'Yes'},
		 'Repeated dose inhalation (systemic)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'RepeatedDoseToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationSystemicEffects.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Repeated dose inhalation (systemic)', 'subCategoryRelevant' : 'Yes'},
		 'Repeated dose inhalation (local)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'RepeatedDoseToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityInhalationLocalEffects.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Repeated dose inhalation (local)', 'subCategoryRelevant' : 'Yes'},
		 'Repeated dose dermal (systemic)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'RepeatedDoseToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalSystemicEffects.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Repeated dose dermal (systemic)', 'subCategoryRelevant' : 'Yes'},
		 'Repeated dose dermal (local)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'RepeatedDoseToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.RepeatedDoseToxicityDermalLocalEffects.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Repeated dose dermal (local)', 'subCategoryRelevant' : 'Yes'},
		 'Genetic toxicity (in vitro)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'GeneticToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.GeneticToxicityInVitro.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Genetic toxicity (in vitro)', 'subCategoryRelevant' : 'Yes'},
		 'Genetic toxicity (in vivo)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'GeneticToxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.GeneticToxicityInVivo.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Genetic toxicity (in vivo)', 'subCategoryRelevant' : 'Yes'},
		 'Carcinogenicity oral' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Carcinogenicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.CarcinogenicityViaOralRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Carcinogenicity oral', 'subCategoryRelevant' : 'Yes'},
		 'Carcinogenicity inhalation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Carcinogenicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.CarcinogenicityViaInhalationRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Carcinogenicity inhalation', 'subCategoryRelevant' : 'Yes'},
		 'Carcinogenicity dermal' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Carcinogenicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.CarcinogenicityViaDermalRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Carcinogenicity dermal', 'subCategoryRelevant' : 'Yes'},
		 'Toxicity to reproduction (fertility)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'ToxicityToReproduction', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectsOnFertility.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Toxicity to reproduction (fertility)', 'subCategoryRelevant' : 'Yes'},
		 'Toxicity to reproduction (developmental)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'ToxicityToReproduction', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectsOnDevelopmentalToxicity.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Toxicity to reproduction (developmental)', 'subCategoryRelevant' : 'Yes'},
		 'Toxicity to reproduction (other studies)' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'ToxicityToReproduction', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.ToxicityToReproductionOtherStudies.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Toxicity to reproduction (other studies)', 'subCategoryRelevant' : 'Yes'},
		 'Neurotoxicity oral' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Neurotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaOralRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Neurotoxicity oral', 'subCategoryRelevant' : 'Yes'},
		 'Neurotoxicity inhalation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Neurotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaInhalationRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Neurotoxicity inhalation', 'subCategoryRelevant' : 'Yes'},
		 'Neurotoxicity dermal' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Neurotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnNeurotoxicityViaDermalRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Neurotoxicity dermal', 'subCategoryRelevant' : 'Yes'},
		 'Immunotoxicity oral' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Immunotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaOralRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Immunotoxicity oral', 'subCategoryRelevant' : 'Yes'},
		 'Immunotoxicity inhalation' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Immunotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaInhalationRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Immunotoxicity inhalation', 'subCategoryRelevant' : 'Yes'},
		 'Immunotoxicity dermal' : {'docType' : 'ENDPOINT_SUMMARY', 'docSubType' : 'Immunotoxicity', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.EffectOnImmunotoxicityViaDermalRoute.LinkToRelevantStudyRecords.StudyNameType', 'sectionName' : 'Immunotoxicity dermal', 'subCategoryRelevant' : 'Yes'} 
		 }/>
		 
		<#list summaryPathToDataMap?keys as prop>
		<#-- Check whether the loaded document's type is the same as indicated in the current record of summaryPathToDataMap -->
		<#if summaryPathToDataMap[prop].docType == summary.documentType && summaryPathToDataMap[prop].docSubType == summary.documentSubType>
			<#if summary?has_content>
					<#local sectionReference = summaryPathToDataMap[prop].studyReferenceLink />
					<#if sectionReference?has_content>
						<@com.emptyLine/>
						<#local studyRecordPath = "summary." + summaryPathToDataMap[prop].studyReferenceLink />
						<#local study = studyRecordPath?eval />	
						<#list study as studyReferences>
							<#if studyReferences?has_content>
							<#assign studyLink = iuclid.getDocumentForKey(studyReferences) />
								<para>Relevant studies: <@com.text studyLink.name/></para>
							</#if>
						</#list>
					</#if>
			</#if>
		</#if>
		</#list>
		
	</#if>
</#macro>

<#function isStudyInformationDifferentPath summary>
<#if summary?has_content>							
<#local docDefId = summary.documentType +"."+ summary.documentSubType/>

 <#if !(docDefId=="ENDPOINT_SUMMARY.AcuteToxicity" || docDefId=="ENDPOINT_SUMMARY.IrritationCorrosion" || docDefId=="ENDPOINT_SUMMARY.Sensitisation" ||
 docDefId=="ENDPOINT_SUMMARY.RepeatedDoseToxicity" || docDefId=="ENDPOINT_SUMMARY.GeneticToxicity" || docDefId=="ENDPOINT_SUMMARY.Carcinogenicity" ||
 docDefId=="ENDPOINT_SUMMARY.ToxicityToReproduction" || docDefId=="ENDPOINT_SUMMARY.Neurotoxicity" || docDefId=="ENDPOINT_SUMMARY.Immunotoxicity")>
	<#return true>
	<#else>
		<#return false>
	</#if>
</#if>
<#return false>
</#function>

<#function isStudyInformationAvailable summary>
<#if summary?has_content>							
<#local docDefId = summary.documentType +"."+ summary.documentSubType/>
<#if docDefId=="ENDPOINT_SUMMARY.EcotoxicologicalInformation" || docDefId=="ENDPOINT_SUMMARY.DataTox" || docDefId=="ENDPOINT_SUMMARY.AquaticToxicity" || docDefId=="ENDPOINT_SUMMARY.ExposureRelatedObservationsHumans" || docDefId=="ENDPOINT_SUMMARY.ToxicEffectsLivestockPets" || docDefId=="ENDPOINT_SUMMARY.AdditionalToxicologicalInformation" || docDefId=="ENDPOINT_SUMMARY.PhysicalChemicalProperties" || docDefId=="ENDPOINT_SUMMARY.EnvironmentalFateAndPathways" || docDefId=="ENDPOINT_SUMMARY.AdditionalInformationOnEnvironmentalFateAndBehaviour" || docDefId=="ENDPOINT_SUMMARY.TerrestrialToxicity" || docDefId=="ENDPOINT_SUMMARY.ResiduesInFoodAndFeedingstuffs" || docDefId=="ENDPOINT_SUMMARY.EffectivenessAgainstTargetOrganisms" || docDefId=="ENDPOINT_SUMMARY.Stability" || docDefId=="ENDPOINT_SUMMARY.Biodegradation" || docDefId=="ENDPOINT_SUMMARY.TransportAndDistribution" || docDefId=="ENDPOINT_SUMMARY.Bioaccumulation"><!--new from stability to change in assessment entity report-->
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
		<#if summary.KeyInformation.KeyInformation?has_content>
			<para>
				<emphasis role="underline">Key Information:</emphasis>
			    <@com.richText summary.KeyInformation.KeyInformation/>
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