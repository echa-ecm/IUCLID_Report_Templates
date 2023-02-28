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
			<#if study.AdministrativeData.StudyPeriodStartDate?has_content>
				Start date: <@com.value study.AdministrativeData.StudyPeriodStartDate/>
			</#if>
			<#if study.AdministrativeData.StudyPeriodEndDate?has_content>
				End date: <@com.value study.AdministrativeData.StudyPeriodEndDate/>
			</#if>
			<#if study.AdministrativeData.StudyPeriod?has_content>
				Remarks: <@com.value study.AdministrativeData.StudyPeriod/>
			</#if>
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
<#macro endpointSummary summary valueForCsaText="" docSubType="" printName=false>
	<#if printName>
		<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
	</#if>

	<@summaryKeyInformation summary/>
		
	<@assessmentEntitiesList summary />

	<#if docSubType=="Hydrolysis" || docSubType=="PhototransformationInAir" || docSubType=="PhototransformationInWater" || docSubType=="PhototransformationInSoil" || 
	docSubType=="BiodegradationInWaterScreeningTests" || docSubType=="BiodegradationInWaterAndSedimentSimulationTests" || docSubType=="BiodegradationInSoil" || docSubType=="Stability" || 
	docSubType=="Biodegradation" || docSubType=="AdsorptionDesorption" || docSubType=="HenrysLawConstant" || docSubType=="TransportAndDistribution" || 
	docSubType=="Bioaccumulation" || docSubType=="BioaccumulationAquaticSediment" || docSubType=="BioaccumulationTerrestrial">
	<@fateCSAtable summary/>
	<#else>
	<@ecotoxSummary _subject "${docSubType}"/>
	</#if>

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

<#macro ecotoxSummary doc docSubTypes>

    <#-- get the list of summaries-->
    <#if !docSubTypes?is_sequence>
		<#local docSubTypes=[docSubTypes]/>
	</#if>

    <#local allSummaryList=[]/>
    <#list docSubTypes as docSubType>
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(doc.documentKey, "ENDPOINT_SUMMARY", docSubType) />
        <#local allSummaryList=allSummaryList + summaryList/>
    </#list>

    <#-- print the table -->
    <@ecotoxCSAtable allSummaryList/>
</#macro>

<#--Macro for the basic summary table of ecotox CSA using info stored in a hashmap-->
<#macro ecotoxCSAtable summaryList>
	<#compress>

		<#-- if it's not list, convert to list -->
		<#if !summaryList?is_sequence>
			<#local summaryList=[summaryList]/>
		</#if>

		<#-- create a hash containing information from all summaries -->
		<#local endpointsHash = {}/>
		<#list summaryList as summary>
			<#local summaryCSAseq = getEcotoxCSASeq(summary)/>
			<#--  ${summaryCSAseq?join(":")}  -->
			<#list summaryCSAseq as seqEntry>
				<#if endpointsHash[seqEntry["name"]]??>
					<#local newSeqEntry = endpointsHash[seqEntry["name"]] + [seqEntry]/>
					<#local endpointsHash = endpointsHash + {seqEntry["name"]:newSeqEntry}/>
				<#else>
					<#local endpointsHash = endpointsHash + {seqEntry["name"]:[seqEntry]}/>
				</#if>
			</#list>
		</#list>

		<#-- parse the hash and create the table -->
		<#if endpointsHash?has_content>
			<table border="1">
				<tbody valign="middle">
				<tr align="center">
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Dose descriptor</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Effect level</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Linked studies</emphasis></th>
				</tr>

				<#list endpointsHash as key, seq>
					<#local usespan = true />
					<#list seq as item>
						<tr>
							<#if usespan>
								<td rowspan="${seq?size}">${key}</td>
								<#local usespan = false />
							</#if>
							<td>${item.descriptor}</td>
							<td>${item.effect}</td>
							<td>${item.links}</td>
						</tr>
					</#list>
				</#list>
				</tbody></table>
		</#if>
	</#compress>
</#macro>

<#--Function to crete a hashmap with CSA info from ecotox summaries-->
<#function getEcotoxCSASeq summary csaPath=['KeyValueForChemicalSafetyAssessment'] excludePath=['HigherTierTesting']>

	<#local mySeq=[]/>

	<#-- consider different path names, if not provided -->
	<#local csaBlock = getObjectFromPathOptions(summary, csaPath)/>
	
	<#-- iterate CSA blocks-->
	<#if csaBlock?has_content>

		<#list csaBlock?children as block>
			
			<#-- take the label of the field as test type -->
			<@iuclid.label for=block var="testType"/>

			<#-- process if the path is not to be excluded -->
			<#if !excludePath?seq_contains(block?node_name)>
			
				<#if block?node_type=="block">
					<#-- dose descriptor -->
					<#local doseDescriptor><#compress>
						<#if block.hasElement("DoseDescriptor")>
							<@com.value block.DoseDescriptor/>
						</#if>
					</#compress></#local>

					<#-- effect concentration -->
					<#local effConc><#compress>
						<#if block.hasElement("EffectConcentration")>
							<@com.value block.EffectConcentration/>
						</#if>
					</#compress></#local>

					<#-- links -->
					<#local links = ''/>
					<#local links = getSummaryLinks(block, ["Link", "LinkToRelevantStudyRecord"])/>
					
					
				<#-- special cases -->
				<#else>
					
					<#-- turn the name of the field into the dose descriptor and print the field as effect -->
					<#-- NOTE: this is the case of the bioconcentration documents -->
					<#local doseDescriptor>${testType}</#local>
					<#local effConc><@com.value block/></#local>
					
					<#-- make the endpoint the title of the document -->
					<@iuclid.label for=summary var="testType"/>

					<#-- if there are links to studies, repeat them in the table -->
					<#local links = getSummaryLinks(summary, ["LinkToRelevantStudyRecord.Link"])/>

				</#if>

				<#-- append -->
				<#if doseDescriptor?has_content || effConc?has_content || links?has_content>
					<#local mySeq = mySeq + [{'name': testType!, "links" : links!, "descriptor":doseDescriptor!, "effect":effConc!}]/>
				</#if>

			</#if>
		</#list>

		<#--special cases-->
		<#--  <#if csaPath.hasElement("EcTenLcTenNoecMarineWaterFish") && csaPath.EcTenLcTenNoecMarineWaterFish?has_content>
			<#local endpoint>EC10 / LC10 / NOEC: <@com.range csaPath.EcTenLcTenNoecMarineWaterFish/></#local>
			<#local mySeq = mySeq + [{'name': "Long-term toxicity to marine fish", "links" : generalLinks!, "endpoint":endpoint, "substance":"",
			"organisms":"Marine fish"}]/>
		</#if>  -->

	</#if>
	
	<#return mySeq/>

</#function>

<#-- fateCSAtable prints the information under the section Key Value for Chemical Safety Assessment of 
	harmonised Fate summaries in table format i.e. all summaries except the old EU_PPP summaries, Estimation of concentration
	summaries and Residue definition.

	The table has four columns:
	- Endpoint: name of the block, if exists, where CSA values are found; else name of document
	- Results: CSA value
	- Conditions: Temperature, Ph or other additional information related to the CSA value
	- Linked studies: Link to the study where the values have been derived
		NOTE: this coresponds to studies links in the block, or if this does not exist,
		studies linked in the generic section at the top of the document (in this latter case
		the same study might appear repeated for different endpoints / CSA values)

	If several summaries are provided, information is merged by endpoint.

	Inputs:
	- summaryList: single summary object or list of fate summaries objects
-->
<#macro fateCSAtable summaryList>
	<#compress>

		<#-- if it's not list, convert to list -->
		<#if !summaryList?is_sequence>
			<#local summaryList=[summaryList]/>
		</#if>

		<#-- create a hash containing information from all summaries -->
		<#local endpointsHash = {}/>
		<#list summaryList as summary>
			<#local summaryCSAseq = getFateCSASeq(summary)/>
			<#list summaryCSAseq as seqEntry>
				<#if endpointsHash[seqEntry["name"]]??>
					<#local newSeqEntry = endpointsHash[seqEntry["name"]] + [seqEntry]/>
					<#local endpointsHash = endpointsHash + {seqEntry["name"]:newSeqEntry}/>
				<#else>
					<#local endpointsHash = endpointsHash + {seqEntry["name"]:[seqEntry]}/>
				</#if>
			</#list>
		</#list>

		<#-- parse the hash and create the table -->
		<#if endpointsHash?has_content>
			<table border="1">
				<tbody valign="middle">
				<tr align="center">
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Results</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Conditions</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Linked studies</emphasis></th>
				</tr>

				<#list endpointsHash as key, seq>
					<#local usespan = true />
					<#list seq as item>
						<tr>
							<#if usespan>
								<td rowspan="${seq?size}">${key}</td>
								<#local usespan = false />
							</#if>
							<td>${item.results}</td>
							<td>${item.conditions}</td>
							<td>${item.links}</td>
						</tr>
					</#list>
				</#list>
				</tbody></table>
		</#if>
	</#compress>
</#macro>

<#-- getFateCSASeq extracts information on the CSA block of harmonised fate summaries into a list, to be used to print
	a table using the fateCSAtable macro.

	It uses a mapping hashmap of document subtypes. Each subtype is a list of hashmaps, each containing
	- 'path': general path of the CSA sub-section, if exists; else emtpy
	- 'results': path to the main CSA value 
	- 'conditions': path to pH, T, and other conditions related to the CSA value
	- 'type': if exists, it will be used to print the name of the CSA value, instead of using the label

	The function reads the hashmap and creates a lisy with the right output for results and conditions of each sub-section, printing
	the labels and the values of the different fields.

	Inputs:
	- summary: a summary document object
	- csaPath: list of strings for the paths to consider to extract the CSA block 
		NOTE: this path tends to be standard, but sometimes there might be deviations e,g, KeyValueForCsa, KeyValueCsa

	Returns:
	- mySeq: sequence of hashmaps containing the keys "name" (endpoint), "results", "conditions" and "links" ready to be printed
-->
<#function getFateCSASeq summary csaPath=['KeyValueForChemicalSafetyAssessment']>
	
	<#local mySeq=[]/>

	<#-- consider different path names, if not provided -->
	<#local csaBlock = getObjectFromPathOptions(summary, csaPath)/>
	

	<#-- Mapping of fate summaries to fields to map -->
	<#local summaryDocToCSAMap = {
								"BiodegradationInSoil": [{"path": "BiodegradationInSoilForExposureAssessment", 
															"result": ["HalflifeInSoil"], 
															"conditions": ["AtTheTemperatureOf", "PHCondition1"]},
														{"path": "BiodegradationInSoilForExposureAssessment", 
															"result": ["HalflifeInSoilPhDependent"], 
															"conditions": ["AtTheTemperatureOfPhDependent", "PHCondition2"]},
														{"path": "BiodegradationInSoilForPersistenceAssessment", 
															"result": ["DT50", "DT90"], 
															"conditions": ["TemperatureOfTheTestSystem"]},
														{"path": "RouteOfBiodegradation", "result": [], "conditions": []}
														],
								"HenrysLawConstant" : [{"path":'', "result": ["HenrysLawConstant"], "conditions":["AtTheTemperatureOf"]}],
								"PhototransformationInSoil" : [{"path":'', "result": ["HalflifeInSoil"], "conditions":[]}],
								"FieldStudies" : [{"path": "BiodegradationInSoilForExposureAssessment", 
													"result": ["DT50"], "conditions": ["AtTheTemperatureOf", "PHCondition1"]},
												{"path": "BiodegradationInSoilForExposureAssessment", 
													"result": ["DT50PhDependent"], "conditions": ["AtTheTemperatureOfPhDependent", "PHCondition2"]},
												{"path": "BiodegradationInSoilForPersistenceAssessment", 
													"result": ["DT50", "DT90"], 
													"conditions": ["TemperatureOfTheTestSystem"]},
												{"path": "RouteOfBiodegradation", 
													"result": [], 
													"conditions": []}],								
								"AdsorptionDesorption" : [{"path":'', "result": ["KocAt20Celsius"], "conditions":["AtTheTemperatureOf"]},							
															<#-- below: repeatable block -->
															{"path":'OtherAdsorptionCoefficients', "result":["TypeValue"], "type":"Type", "conditions":["AtTheTemperatureOf"]}],
								"Hydrolysis" : [{"path":'', "result": ["HalflifeForHydrolysis"], "conditions":["AtTheTemperatureOf"]}],
								"PhototransformationInWater" : [{"path":'', "result":["HalflifeInWater"], "conditions" : []}],
								"BiodegradationInWaterScreeningTests" : [{"path":'', "result":["BiodegradationInWater"], "conditions" : ["TypeOfWater"]}],
								"BiodegradationInWaterAndSedimentSimulationTests" :
											[{"path":'BiodegradationInFreshwater', "result":["DT50ForExposureAssessment"], "conditions" : ["AtTheTemperatureOfExpo"]},
											 {"path":'BiodegradationInFreshwater', "result":["DT50ForPersistenceAssessment", "DT90"], "conditions" : ["TemperatureOfTheTestSystem"]},
											 {"path":'BiodegradationInMarineWater', "result":["DT50"], "conditions" : ["AtTheTemperatureOf"]},
											 {"path":'BiodegradationInFreshwaterSediment', "result":["DT50ForExposureAssessment"], "conditions" : ["AtTheTemperatureOfExpo"]},
											 {"path":'BiodegradationInFreshwaterSediment', "result":["DT50ForPersistenceAssessment", "DT90"], "conditions" : ["TemperatureOfTheTestSystem"]},
											 {"path":'BiodegradationInMarineWaterSediment', "result":["DT50"], "conditions" : ["AtTheTemperatureOf"]},
											 {"path":'WholeSystem', "result":["DT50ForExposureAssessmentFreshwaterAndSediment"], "conditions" : ["AtTheTemperatureOfWholeSystem"]},
											 {"path":'WholeSystem', "result":["DT50ForPersistenceAssessmentFreshwaterAndSediment"], "conditions" : ["AtTheTemperatureOf"]},
											 {"path":'WholeSystem', "result":["DT50MarineWaterAndSediment"], "conditions" : ["AtTheTemperatureOfMarine"]},
											 {"path":'BiodegradationInSewageTreatmentPlant', "result":["DT50"], "conditions" : ["AtTheTemperatureOf"]},
											 {"path":'BiodegradationInSewageTreatmentPlant', "result":["Degradation"], "conditions" : ["AtTheTemperatureOfSewage"]},
											 {"path":'BiodegradationInSewerSystem', "result":["DT50"], "conditions" : ["AtTheTemperatureOf"]},
											 {"path":'RouteOfBiodegradation', "result":[], "conditions" : []}],
								"PhototransformationInAir" : [{"path":'', "result":["HalflifeInAir"], "conditions" : []},
																{"path":'', "result":["DegradationRateConstantWithOHRadicals"], "conditions" : []}]

	}/>

	<#--CSA-->
	<#if csaBlock?? && csaBlock?has_content && summaryDocToCSAMap?keys?seq_contains(summary.documentSubType)>

		<#list summaryDocToCSAMap[summary.documentSubType] as csaRow>

			<#-- get the path from the map, and take the label -->
			<#if csaRow['path']?has_content>
				<#local csaRowPath = "csaBlock." + csaRow['path']/>
				<#local csaRowPath = csaRowPath?eval/>
				<@iuclid.label for=csaRowPath var="endpoint"/>
			<#else>
				<#local csaRowPath = csaBlock/>
				<#local endpoint = summary.documentSubType/> <#-- NOTE: possible to adapt the document type for better reading -->
			</#if>	

			<#-- if the path is not a repeatable block, make it into a list, so that we can work with rep blocks -->
			<#if csaRowPath?node_type!="repeatable">
				<#local csaRowPath = [csaRowPath]/>
			</#if>
				
			<#list csaRowPath as csaRowPath_i>

				<#-- get the result value -->
				<#local results = []/>
				<#list csaRow['result'] as resultItem>
					<#local resultItemPath = "csaRowPath_i." + resultItem/>
					<#if resultItemPath?eval?has_content>
						<#local resultVal><@com.value resultItemPath?eval/></#local>
						<#if csaRow?keys?seq_contains('type') && csaRow['type']?has_content>
							<#local resultNamePath = "csaRowPath_i." + csaRow['type']/>
							<#local resultName><@com.value resultNamePath?eval/></#local>
						<#else>
							<@iuclid.label for=resultItemPath?eval var="resultName"/>
						</#if>
						<#local result>${resultName}: ${resultVal}</#local>
						<#local results = results + [result]/>
					</#if>
				</#list>

				<#-- get the conditions -->
				<#local conditions = []/>
				<#list csaRow['conditions'] as conditionItem>
					<#local conditionItemPath = "csaRowPath_i." + conditionItem/>
					<#if conditionItemPath?eval?has_content>
						<#local condVal><@com.value conditionItemPath?eval/></#local>
						<@iuclid.label for=conditionItemPath?eval var="condName"/>
						<#local condition>${condName}: ${condVal}</#local>
						<#local conditions = conditions + [condition]/>
					</#if>
				</#list>
			
				<#-- links:first try to get links within the block, else try outside of block -->
				<#local links = ''/>
				<#local links = getSummaryLinks(csaRowPath_i, ["Link", "LinkToRelevantStudyRecord", "LinkToRelevantStudyRecordS"])/>  
				<#if ! links?has_content>
					<#local links = getSummaryLinks(summary, ["LinkToRelevantStudyRecord.Link"])/>
				</#if>  
						
				

				<#-- append -->
				<#if results?has_content || conditions?has_content || links?has_content>
					<#local mySeq = mySeq + [{'name': endpoint!, "links" : links!, 
												"results":results?join("; "), "conditions":conditions?join("; ")}]/>
				</#if>

			</#list>
		</#list>
	</#if>

	<#return mySeq/>
</#function>

<#function getSummaryLinks summary paths role=''>  

	<#-- initialise output -->
	<#local pathValue = ''/>  

	<#-- iterate over possible paths and create full path when found -->
	<#local pathObject = getObjectFromPathOptions(summary, paths)/> 

	<#-- print path if found and has content-->
	<#if pathObject?has_content>
		<#local pathValue><para role="${role}"><@printLinks pathObject/></para></#local>
	</#if>

	<#return pathValue/>
</#function> 

<#function getObjectFromPathOptions document paths> 
	
	<#-- iterate over possible paths and create full path when found -->
	<#local pathObject = ''/>

	<#list paths as path>
		<#if document.hasElement(path)>
			<#local fullPath = 'document.' + path />
			<#local pathObject=fullPath?eval/>
		</#if>
	</#list>

	<#return pathObject/>

</#function>

<#macro printLinks path>
	
	<#list path as link>
		<#if link?has_content>
			<#local studyReference = iuclid.getDocumentForKey(link) />
			<para>
				<command  linkend="${studyReference.documentKey.uuid!}">
					<@com.text studyReference.name/>
				</command>
			</para>
		</#if>
	</#list>
</#macro> 

<#macro relevant summary>
<#local docDefId = summary.documentType +"."+ summary.documentSubType/>
<#if !(docDefId=="ENDPOINT_SUMMARY.AquaticToxicity" || docDefId=="ENDPOINT_SUMMARY.ToxicityOtherAquaOrganisms")>	

	<#local fullPath = ("summary." + "KeyValueForChemicalSafetyAssessment")/>
	<#local fullPath = fullPath?eval/>

	<#assign items = []/>

	<#list fullPath?children as child>
		<#if child?has_content>
				
			<#local valueType=child?node_type/>
			<@iuclid.label for=child var="descript"/>			
			
			${descript}

			<@tableRelevantStudies summary child valueType descript /> 

			<#else>No Endpoint Summary information available

		</#if>
	</#list>
</#if>
</#macro>

<#macro tableRelevantStudies summary child valueType descript>

<informaltable frame="all">
	<tgroup cols='3'>										
		<colspec width="33.3%" />
		<colspec width="33.3%" />
		<colspec width="33.3%" />
			<tbody>
		
				<#if valueType=="block">
				<row> 
					<entry>
						<#list child?children as child>
						<@iuclid.label for=child var="description"/>
									
							<#if child?has_content>	
							<#if description=="Link to relevant study record(s)">
								<#list child as linkedRecords>
									<#if linkedRecords?has_content>									         
										<@com.documentReference linkedRecords/>	
									</#if>
								</#list>	
							</#if>								
							</#if>
						</#list>
					</entry>
					<entry>
						<#list child?children as child>
						<@iuclid.label for=child var="description"/>											
							<#if child?has_content>										         
								<#if description=="Dose descriptor"> <@com.value child/>  </#if>
							</#if>
						</#list>
					</entry>
					<entry>
						<#list child?children as child>
						<@iuclid.label for=child var="description"/>
									
							<#if child?has_content>										         
								<#if description=="Effect concentration"> <@com.value child/> </#if>
							</#if>
						</#list>
					</entry>
								
				</row>
				</#if>
		</tbody>
	</tgroup>
</informaltable>
</#macro>

<#macro iterateHashMap summaryPathToDataMap summary>
<#local properties = summaryPathToDataMap?keys />
<#list properties as property>
		<#if property?has_content>
		<#-- Check whether the loaded document's type is the same as indicated in the current record of summaryPathToDataMap -->	
			<#if summary?has_content>
				<#local sectionReference = ("summary.KeyValueForChemicalSafetyAssessment." + summaryPathToDataMap[property].studyReferenceLink + ".LinkToRelevantStudyRecord")?eval  />
				
				<#if sectionReference?has_content>	
					<#list sectionReference as studyReferences>
						<#if studyReferences?has_content>
						<#assign studyLink = iuclid.getDocumentForKey(studyReferences) />
							<para>Relevant studies: <@com.text studyLink.name/></para>
						</#if>
					</#list>
				</#if>
			</#if>
		</#if>
		</#list>
</#macro>

<#-- Macro to get relevant studies linked to a summary -->
<#macro relevantStudies summary path>

<#local docDefId = summary.documentType +"."+ summary.documentSubType/>

	<#-- The #if condition below generally handles Summaries which have sub-sections which differentiate between linked studies, 
	leaving only generic links from endpoint summaries to endpoint study records -->
	<#if !(docDefId=="ENDPOINT_SUMMARY.AcuteToxicity" || docDefId=="ENDPOINT_SUMMARY.IrritationCorrosion" || docDefId=="ENDPOINT_SUMMARY.Sensitisation" ||
	docDefId=="ENDPOINT_SUMMARY.RepeatedDoseToxicity" || docDefId=="ENDPOINT_SUMMARY.GeneticToxicity" || docDefId=="ENDPOINT_SUMMARY.Carcinogenicity" ||
	docDefId=="ENDPOINT_SUMMARY.ToxicityToReproduction" || docDefId=="ENDPOINT_SUMMARY.Neurotoxicity" || docDefId=="ENDPOINT_SUMMARY.Immunotoxicity" ||
	docDefId=="ENDPOINT_SUMMARY.SedimentToxicity" || docDefId=="ENDPOINT_SUMMARY.ToxicityToSoilMacroorganismsExceptArthropods" || 
	docDefId=="ENDPOINT_SUMMARY.ToxicityToTerrestrialPlants" || docDefId=="ENDPOINT_SUMMARY.ToxicityToSoilMicroorganisms" || 
	docDefId=="ENDPOINT_SUMMARY.ToxicityToBirds" || docDefId=="ENDPOINT_SUMMARY.ToxicityToOtherAboveGroundOrganisms" || docDefId=="ENDPOINT_SUMMARY.ToxicityToAquaticAlgae" || 
	docDefId=="ENDPOINT_SUMMARY.ToxicityPlants" || docDefId=="ENDPOINT_SUMMARY.ToxicityMicroorganisms")>
		
		<#if summary?has_content>
			<#-- some summaries do ot have links to studies, the following #if condition takes care of these exceptions -->
			<#if !(docDefId=="ENDPOINT_SUMMARY.AquaticToxicity")>	
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
		'Summary' : {'docType' : '${summary.documentType}', 'docSubType' : '${summary.documentSubType}', 'studyReferenceLink' : 'KeyValueForChemicalSafetyAssessment.FreshwaterAlgaeShortTerm', 'sectionName' : 'Acute Toxicity oral', 'subCategoryRelevant' : 'Yes'}
		
		}/>

		<#list summaryPathToDataMap?keys as prop>
		<#-- Check whether the loaded document's type is the same as indicated in the current record of summaryPathToDataMap -->
		<#if summaryPathToDataMap[prop].docType == summary.documentType && summaryPathToDataMap[prop].docSubType == summary.documentSubType>
		<#if docDefId=="ENDPOINT_SUMMARY.ToxicityToAquaticAlgae">
			<#if summary?has_content>
					<#local sectionReference = summaryPathToDataMap[prop].studyReferenceLink />
					<#if sectionReference?has_content>
						<@com.emptyLine/>
						<#local studyRecordPath = "summary." + summaryPathToDataMap[prop].studyReferenceLink + ".LinkToRelevantStudyRecord" />
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