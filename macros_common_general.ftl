<!-- Common macros and functions that could be reused in any template based on IUCLID6 data -->

<#--It initializes the following variables:
	* _dossierHeader (:DossierHashModel) //The header document of a proper or 'raw' dossier, can be empty
	* _subject (:DocumentHashModel) //The dossier subject document or, if not in a dossier context, the root document, never empty
-->
<#macro initializeMainVariables>
	<#if (dossier.header)?has_content>
		<#global "_dossierHeader"=dossier.header + {"Name": dossier.header.name}/>
		<#global "_subject"=dossier.subject.root />
	<#elseif rootDocument.documentType=="DOSSIER">
		<#global "_dossierHeader"=rootDocument + {"Name": rootDocument.name}/>
		<#global "_subject"=iuclid.getDocumentForKey(rootDocument.subjectKey) />
	<#elseif isProject((entity.root)!)>
        <#local "_header"=getProjectDossierHeader(entity)/>
		<#global "_dossierHeader"=_header + { "subjectKey":entity.root.RelatedEntity, "subjectType": entity.root.documentType, "submissionTypeVersion": "", "submittingLegalEntityKey": "", "submissionRemarks":_header.Remarks }/>
		<#global "_subject"=iuclid.getDocumentForKey(entity.root.RelatedEntity) />
	<#else>
		<#global "_subject"=rootDocument />
	</#if>
</#macro>

<#-- Initialize the following variables to include or exclude information for the CSR, PAR, DAR, RAR -->

<#global relevance = {
	'relevant' : 'csr',
	'relevant' : 'nzEPAclassification',
	'relevant' : 'ppp',
	'relevant' : 'par',
	'relevant' : 'dar',
	'relevant' : 'rar',
	'relevant' : 'svhc',	
	'relevant' : 'ghs'
	
} />


<#macro initiateRelevanceGHS relevance>
	
	<#global ghsRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign ghsRelevant>
				<#if prop=="ghs">
				</#if>
			</#assign>			
		</#if>
	</#list>
</#macro>


<#macro initiateRelevanceSVHC relevance>
	
	<#global svhcRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign svhcRelevant>
				<#if prop=="svhc">
				</#if>
			</#assign>			
		</#if>
	</#list>
</#macro>

<#macro initiateRelevanceNZ relevance>
	
	<#global nzEPArelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign nzEPArelevant>
				<#if prop=="nzEPAclassification">
				</#if>
			</#assign>			
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceForCSR relevance>
	
	<#global csrRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign csrRelevant><#if prop=="csr"></#if></#assign>			
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceForPPP relevance>
	
	<#global pppRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign pppRelevant><#if prop=="ppp"></#if></#assign>			
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceForPAR relevance>
	
	<#global parRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign parRelevant><#if prop=="par"></#if></#assign>		
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceForDAR relevance>
	
	<#global darRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign darRelevant><#if prop=="dar"></#if></#assign>			
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceForRAR relevance>
	
	<#global rarRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign rarRelevant><#if prop=="rar"></#if></#assign>
		</#if>
	</#list>
</#macro>

<#macro initiRelevanceGenericReports relevance>
	
	<#global genericRelevant = [] />	
		
	<#list relevance?keys as prop>
		<#if prop?has_content>
			<#assign genericRelevant><#if prop=="generic"></#if></#assign>			
		</#if>
	</#list>
</#macro>

<#function isProject doc="">
	<#if doc?has_content && doc.documentType=="CUSTOM_ENTITY" && doc.documentSubType=="IuclidWebProject">
		<#return true/>
	</#if>
	<#return false/>
</#function>

<#function getProjectDossierHeader project>
	<#list entity.sections("CUSTOM_SECTION.IuclidWebCreateDossier") as settings>
		<#return iuclid.getDocumentForKey(settings.Header)/>
	</#list>
</#function>

<#macro documentReference documentKey>
<#compress>
	<#if documentKey?has_content>
		<#local document = iuclid.getDocumentForKey(documentKey) />
		<#if document?has_content>
			<#escape x as x?html>
			${document.name}
			</#escape>
		<#else>
			${documentKey}
		</#if>
	</#if>
</#compress>
</#macro>

<#macro documentReferenceMultiple documentReferenceMultipleValue>
<#compress>
	<#if documentReferenceMultipleValue?has_content>
		<#list documentReferenceMultipleValue as item>
			<@documentReference item/>
			<#if item_has_next>; </#if>
		</#list>
	</#if>
</#compress>
</#macro>

<#macro text textValue="">
<#compress>
	<#if textValue?has_content>
		<#escape x as x?html>
		${textValue}
		</#escape>
  	</#if>
</#compress>
</#macro>

<#macro number numberValue>
<#compress>
	<#if numberValue?has_content>
		${numberValue?string["0.#########"]}
  	</#if>
</#compress>
</#macro>

<#macro richText richTextValue>
<#compress>
	<#if richTextValue?has_content>
		${iuclid.convertHtmlToDocBook(richTextValue)}
  	</#if>
</#compress>
</#macro>

<#macro picklist picklistValue locale="en" printOtherPhrase=false printDescription=true printRemarks=true>
	<#compress>
		<#escape x as x?html>
			<#local localizedPhrase = iuclid.localizedPhraseDefinitionFor(picklistValue.code, locale) />
			<#if localizedPhrase?has_content>

				<#if !localizedPhrase.open || !(localizedPhrase.text?matches("other:")) || printOtherPhrase>
					${localizedPhrase.text} <#t>
				</#if>

				<#if localizedPhrase.open && picklistValue.otherText?has_content>
					${picklistValue.otherText}<#t>
				</#if>

				<#if printDescription && localizedPhrase.description?has_content>
					[${localizedPhrase.description}]
				</#if>
			</#if>

			<#if printRemarks && picklistValue.remarks?has_content>
				- ${picklistValue.remarks}
			</#if>
			<#lt>

		</#escape>
	</#compress>
</#macro>

<#macro picklistMultiple picklistMultipleValue locale="en" printOtherPhrase=false printDescription=true printRemarks=true>
<#compress>
	<#if picklistMultipleValue?has_content>
		<#list picklistMultipleValue as item>
			<@picklist item locale printOtherPhrase printDescription printRemarks/>
			<#if item_has_next>; </#if>
		</#list>
	</#if>
</#compress>
</#macro>

<#macro range rangeValue locale="en">
<#compress>
	<#if rangeValue?has_content>
		<#escape x as x?html>
			<#if rangeValue.lower.value?has_content>
				${rangeValue.lower.qualifier!}<@number rangeValue.lower.value/>
			</#if>
			<#if rangeValue.lower.value?has_content && rangeValue.upper.value?has_content>-</#if>
			<#if rangeValue.upper.value?has_content>
				${rangeValue.upper.qualifier!}<@number rangeValue.upper.value/>
			</#if>
		</#escape>
		<#if rangeValue.unit?has_content>
			<@picklist rangeValue.unit locale/>
		</#if>
  	</#if>
</#compress>
</#macro>


<#macro quantity quantityValue locale="en">
<#compress>
	<#if quantityValue?has_content>
		<@number quantityValue.value!/>
		<#if quantityValue.value?has_content && quantityValue.unit?has_content>
			<@picklist quantityValue.unit locale/>
		</#if>
  	</#if>
</#compress>
</#macro>

<!-- Reference substance identifiers -->
<!-- Inventory identifiers found as part of a reference substance -->
<#macro inventoryECNumber referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
	<#if referenceSubstanceID.Inventory.InventoryEntry?has_content>
		<#list referenceSubstanceID.Inventory.InventoryEntry as item>
			<#if item.inventoryCode == 'EC'>
				<@com.text item.numberInInventory/>
				<#break>
			</#if>
		</#list>
	</#if>
	</#if>
</#compress>
</#macro>

<#macro inventoryECName referenceSubstanceID>
	<#compress>
		<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.Inventory.InventoryEntry?has_content>
			<#list referenceSubstanceID.Inventory.InventoryEntry as item>
				<#if item.inventoryCode == 'EC'>
					<@iuclid.inventory entry=item var="inventoryEntry" />
					<#if inventoryEntry??>
						<@com.text inventoryEntry.name/>
					</#if>
					<#break>
				</#if>
			</#list>
		</#if>
		</#if>
	</#compress>
</#macro>

<#macro inventoryECCasNumber referenceSubstanceID>
	<#compress>
		<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.Inventory.InventoryEntry?has_content>
			<#list referenceSubstanceID.Inventory.InventoryEntry as item>
				<#if item.inventoryCode == 'EC'>
					<@iuclid.inventory entry=item var="inventoryEntry" />
					<#if inventoryEntry??>
						<@com.text inventoryEntry.casNumber/>
					</#if>
					<#break>
				</#if>
			</#list>
		</#if>
		</#if>
	</#compress>
</#macro>

<!-- Reference substance identifiers proper -->
<#macro referenceSubstanceName referenceSubstanceID>
<#compress>
		<#if referenceSubstanceID?has_content>
			<#if referenceSubstanceID.ReferenceSubstanceName?has_content>
			<@com.text referenceSubstanceID.ReferenceSubstanceName/>
				<#else>No Reference name provided
			</#if>
		</#if>		
</#compress>
</#macro>

<#macro referenceSubstanceFlags referenceSubstanceID>
<#compress>			
	<#local justificationPath = DataProtection + ".justification" />
	<#local justification = justificationPath?eval />
		<#if justification?has_content>
		<@com.text justification />
		</#if>
	<#local confidentialityPath = DataProtection + ".confidentiality" />
	<#local confidentiality = confidentialityPath?eval />
		<#if confidentiality?has_content>
		<@com.picklist confidentiality />
		</#if>			
</#compress>
</#macro>			
						
<#macro casNumber referenceSubstanceID>
<#compress>
		<#if referenceSubstanceID?has_content>
			<#if referenceSubstanceID.Inventory.CASNumber?has_content>
			<@com.text referenceSubstanceID.Inventory.CASNumber/>
				<#else>No CAS number provided
			</#if>
		</#if>		
</#compress>
</#macro>	

<#macro casName referenceSubstanceID>
<#compress>
		<#if referenceSubstanceID?has_content>
			<#if referenceSubstanceID.Inventory.CASName?has_content>
			<@com.text referenceSubstanceID.Inventory.CASName/>
				<#else>No CAS name provided
			</#if>
		</#if>		
</#compress>
</#macro>	

<#macro synonyms referenceSubstanceID>
<#compress>

<#if referenceSubstanceID?has_content && referenceSubstanceID.Synonyms.Synonyms?has_content>

<para>Synonyms</para>
	<#list referenceSubstanceID.Synonyms.Synonyms as synonyms>
		<#if synonyms?has_content>
		
			<para>
				<#if synonyms.Identifier?has_content>
					<#if !csrRelevant??>Synonym identifier:</#if>
					<@com.picklist synonyms.Identifier/><#if csrRelevant??>:</#if>
				</#if>
				
				<#if synonyms.Name?has_content>
					<#if !csrRelevant??>Synonym name/identity:</#if> <@com.text synonyms.Name/>
				</#if>
			</para>			
			
			<#if synonyms.Remarks?has_content>
				<#if !csrRelevant??>
					<para>Synonym remarks: <@com.text synonyms.Remarks/></para>
				</#if>
			</#if>
			
			<#if synonyms_has_next><?linebreak?></#if>
			
			<#else>
				No synonyms provided
		</#if>
	</#list>
</#if>
	
</#compress>
</#macro>

<#macro casNumber referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.Inventory.CASNumber?has_content>
		<@com.text referenceSubstanceID.Inventory.CASNumber/>
			<#else>No CAS number provided
		</#if>
	</#if>		
</#compress>
</#macro>

<#macro description referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.Description?has_content>
		<@com.text referenceSubstanceID.Description/>
			<#else>No Description provided
		</#if>
	</#if>		
</#compress>
</#macro>

<#macro iupacName referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.IupacName?has_content>								
			<@com.text referenceSubstanceID.IupacName/>
			<#else>No IUPAC name provided
		</#if>
	</#if>
</#compress>
</#macro>

<#macro molecularFormula referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.MolecularStructuralInfo.MolecularFormula?has_content>
			<@com.text referenceSubstanceID.MolecularStructuralInfo.MolecularFormula />
			<#else>No Molecular Formula Name provided
		</#if>
	</#if>
</#compress>
</#macro>

<#macro molecularWeight referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.MolecularStructuralInfo.MolecularWeightRange?has_content>
			<@com.range referenceSubstanceID.MolecularStructuralInfo.MolecularWeightRange />	
			<#else>No Molecular Weight Name provided
		</#if>
	</#if>
</#compress>
</#macro>

<#macro molecularStructuralRemarks referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.MolecularStructuralInfo.Remarks?has_content>
			<@com.text referenceSubstanceID.MolecularStructuralInfo.Remarks />	
			<#else>No Molecular Structural remarks provided
		</#if>
	</#if>
</#compress>
</#macro>

<#macro smilesNotation referenceSubstanceID>
<#compress>
	<#if referenceSubstanceID?has_content>
		<#if referenceSubstanceID.MolecularStructuralInfo.SmilesNotation?has_content>
			<@com.text referenceSubstanceID.MolecularStructuralInfo.SmilesNotation />	
			<#else>No SMILES notation provided
		</#if>
	</#if>
</#compress>
</#macro>

<#macro inchi referenceSubstanceID>
	<#compress>
		<#if referenceSubstanceID?has_content>
			<#if referenceSubstanceID.MolecularStructuralInfo.InChl?has_content>
				<@com.text referenceSubstanceID.MolecularStructuralInfo.InChl />
			<#else>No inchi notation provided
			</#if>
		</#if>
	</#compress>
</#macro>

<#macro chemicalStructureFiles referenceSubstanceID>
<#compress>
<#if referenceSubstanceID?has_content>
	<#list referenceSubstanceID.MolecularStructuralInfo.ChemicalStructureFiles as chemicalStructure>
		<#if chemicalStructure?has_content>
			<#assign attachmentData = iuclid.getMetadataForAttachment(chemicalStructure.StructureFile) />
			<#if attachmentData?has_content>
				<#escape x as x?html>${attachmentData.filename}</#escape>
			</#if>			
			<para>
				Remarks on structure file: <@com.text chemicalStructure.RemarksChemStruct />
			</para>			
				<#else>No Chemical structure files provided
		</#if>
	</#list>
</#if>
</#compress>
</#macro>

<#macro structuralFormula referenceSubstanceID imageWidthPerc=31 printTitle=true>
	<#compress>
		<#if referenceSubstanceID?has_content>
			<#local attachmentKey = referenceSubstanceID.MolecularStructuralInfo.StructuralFormula />
			<#if attachmentKey?has_content>
				<#local structuralFormula = iuclid.getMetadataForAttachment(attachmentKey) />
				<#if structuralFormula?has_content && structuralFormula.isImage>
					<#if structuralFormula.exceedsLimit(10000000)>
						<para><emphasis role="bold">Image size is too big (${structuralFormula.size} bytes) and cannot be displayed!</emphasis></para>
					<#elseif !iuclid.imageMimeTypeSupported(structuralFormula.mediaType) >
						<para><emphasis role="bold">Image type (${structuralFormula.mediaType}) is not yet supported!</emphasis></para>
					<#else>
						<figure>
							<#if printTitle>
								<title>
									<#local attachName><@com.text structuralFormula.filename/></#local>${attachName}
								</title>
							</#if>
							<mediaobject>
								<imageobject>
									<imagedata width="${imageWidthPerc}%" scalefit="1" fileref="data:${structuralFormula.mediaType};base64,${iuclid.getContentForAttachment(attachmentKey)}" />
								</imageobject>
							</mediaobject>
						</figure>
					</#if>
				</#if>
			<#else>
				<emphasis>No structural formula image attached to the Reference substance of the Active substance</emphasis>
			</#if>
		</#if>
	</#compress>
</#macro>
										
<#function getReferenceSubstanceKey key>
<#assign refSubst = iuclid.getDocumentForKey(key)/>
<#if !(refSubst?has_content)>
	<#return [] >
	<#else>
	<#return refSubst>
</#if>
<#return refSubst>
</#function>

<!-- other identifiers in a Substance or mixture -->
<#macro otherIdentifiersList otherNamesRepeatableBlock role="">
<#compress>
	<#if otherNamesRepeatableBlock?has_content>
		<#list otherNamesRepeatableBlock as blockItem>
			<para role="${role}">
				<@com.picklist blockItem.NameType/>: <@com.text blockItem.Name/>
				<#if blockItem.hasElement('Relation') && blockItem.Relation?has_content>
					(<@com.picklist blockItem.Relation/>)
				</#if>
				<@com.picklistMultiple blockItem.Country/> 
				<#if blockItem.Remarks?has_content>
					(<@com.text blockItem.Remarks/>)
				</#if><#if blockItem_has_next><@com.emptyLine/></#if>		
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#function picklistValueMatchesPhrases picklistValue phrases locale="en">
	<#if !(picklistValue?has_content)>
		<#return false />
	</#if>
    <#if picklistValue.code?has_content>
        <#local picklistPhrase = iuclid.localizedPhraseDefinitionFor(picklistValue.code, locale) />
    <#else>
        <#return false />
    </#if>
    <#list phrases as phrase>
        <#if picklistPhrase.text?matches(phrase)>
            <#return true />
        </#if>
    </#list>
    <#return false />
</#function>

<#function picklistMultipleValueMatchesPhrases picklistMultipleValue phrases locale="en">
	<#if !(picklistMultipleValue?has_content)>
		<#return false />
	</#if>
	<#list picklistMultipleValue as item>
		<#if picklistValueMatchesPhrases(item, phrases, locale)>
			<#return true />
		</#if>
	</#list>
	<#return false />
</#function>

<#function isPicklistEmptyOrOther picklistValue>
	<#if !(picklistValue?has_content)>
		<#return true />
	</#if>
	<#if picklistValueMatchesPhrases(picklistValue, ["other:"])>
		<#return true />
	</#if>
	<#return false />
</#function>

<#macro emptyLine>
	<para>&#x200B;</para>
</#macro>


<#function addDocumentToSequenceAsUnique document sequence>
	<#if !(document?has_content)>
		<#return sequence>
	</#if>
	<#list sequence as doc>
		<#if document.documentKey == doc.documentKey>
			<#return sequence>
		</#if>
	</#list>
	<#return sequence + [document]>
</#function>

<#function getReportSubject rootDocument>
	<#if rootDocument.documentType == 'DOSSIER'>
		<#local dossierSubject = iuclid.getDocumentForKey(rootDocument.subjectKey) />
		<#return dossierSubject>
	</#if>
	<#return rootDocument>
</#function>

<#function getDossierHeader rootDocument>
	<#if rootDocument.documentType == 'DOSSIER'>
		<#return rootDocument>
	</#if>
	<#-- else, return nothing -->
</#function>

<#macro metadataBlock left_header_text="" central_header_text="" right_header_text="" left_footer_text="" central_footer_text="" right_footer_text="">
<#escape x as x?html>
<meta:params xmlns:meta="http://echa.europa.eu/schemas/reporting/metadata">
	<meta:param meta:name="left.header.text">${left_header_text}</meta:param>
	<meta:param meta:name="central.header.text">${central_header_text}</meta:param>
	<meta:param meta:name="right.header.text">${right_header_text}</meta:param>
	<meta:param meta:name="left.footer.text">${getLeftFooterText(left_footer_text)}</meta:param>
	<meta:param meta:name="central.footer.text">${central_footer_text}</meta:param>
	<meta:param meta:name="right.footer.text">${right_footer_text}</meta:param>
</meta:params>
</#escape>
</#macro>

<#function getLeftFooterText left_footer_text>
	<#if left_footer_text?has_content>
		<#return left_footer_text>
	</#if>
	<#local default_left_footer_text_date = .now?string[" dd/MM/yyyy "] />
	<#local default_left_footer_text_version = " Generated by IUCLID 6 " + iuclid6Version />
	<#return default_left_footer_text_version + default_left_footer_text_date>
</#function>

<#function countIf sequence predicate>
	<#local counter = 0 />
	<#list sequence as item>
		<#if predicate(item)>
			<#local counter = counter + 1 />
		</#if>
	</#list>
	<#return counter>
</#function>

<#function relatedCategories substanceKey>
    <#local params={"key": [substanceKey]}>
    <#return iuclid.query("iuclid6.SubstanceRelatedCategories", params, 0, 100)>
</#function>

<#-- Macros regarding substance name -->
<#macro substanceName _subject>
<#compress>
	<#if _subject.documentType=="SUBSTANCE">
		<#if _subject.ReferenceSubstance.ReferenceSubstance?has_content> 
			<#local referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		</#if>
		<#if referenceSubstance?has_content>
			<#assign docUrl=iuclid.webUrl.entityView(_subject.documentKey)/>
			<#if docUrl?has_content>
				<ulink url="${docUrl}"><@referenceSubstanceName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/></ulink>
					<#else>
				<@referenceSubstanceName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
			</#if>
		<#else>		
			<#assign docUrl=iuclid.webUrl.entityView(_subject.documentKey)/>
			<#if docUrl?has_content>
				<ulink url="${docUrl}"><@com.text _subject.ChemicalName/></ulink>
					<#else>
				<@com.text _subject.ChemicalName/>
			</#if>
		</#if> 
	</#if>
</#compress>
</#macro>

<#--Macro to print the mixture name of a mixture with hyperlink to the specific MIXTURE document
	(similar behaviour to macro "substanceName"
-->
<#macro mixtureName _subject>
	<#compress>
		<#if _subject.documentType=="MIXTURE">

			<#assign docUrl=iuclid.webUrl.entityView(_subject.documentKey)/>
			<#if docUrl?has_content>
				<ulink url="${docUrl}"><@com.text _subject.MixtureName/></ulink>
			<#else>
				<@com.text _subject.MixtureName/>
			</#if>
		</#if>
	</#compress>
</#macro>

<#-- Function to get inbound references for a key -->
<#-- Function to get inbound references for a key -->
<#function inboundReferences key>
    <#local params={"key": [key], "exclude": ["CUSTOM_ENTITY,CUSTOM_SECTION"]}>
    <#return iuclid.query("web.ReferencingQuery", params, 0, 100)>
</#function>

<#--Macro to print any value type of a field-->
<#macro value valuePath>
	<#compress>
		<#assign valueType=valuePath?node_type/>

		<#if valueType=="range">
			<@com.range valuePath/>
		<#elseif valueType=="picklist_single">
			<@com.picklist  valuePath/>
		<#elseif valueType=="picklist_multi">
			<@com.picklistMultiple valuePath/>
		<#elseif valueType=="quantity">
			<@com.quantity valuePath/>
		<#elseif valueType=="decimal" || valueType=="integer">
			<@com.number valuePath/>
		<#elseif valueType?contains("text_html")>
			<@com.richText valuePath/>
		<#elseif valueType?contains("text")>
			<@com.text valuePath/>
		<#elseif valueType=="date">
			<@com.text valuePath/>
		<#elseif valueType=="boolean">
			<#if valuePath>Y<#else>N</#if>
		<#else>
			value type ${valueType} not supported!
		</#if>
		<#--NOTE: other types: address, document_reference, document_references, data_protection, inventory, attachment, attachments, section_types, repeatable-->
	</#compress>
</#macro>

<#--Macro to interatively print all children fields of an element-->
<#macro children path exclude=[] titleEmphasis=false role1="" role2="indent">
	<#compress>
		<#list path?children as child>
			<#if child?node_type!="repeatable" && child?node_type!="block" && !(exclude?seq_contains(child?node_name)) && child?has_content>
				<#local childName=child?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case?cap_first/>
				<#local childType=child?node_type/>
				<#local childValue><@value child/></#local>

				<para role="${role1}">
					<#if titleEmphasis><emphasis role="bold"></#if>
						${childName}:
						<#--<@iuclid.label for=child var="fieldLabel"/>:-->
						<#if titleEmphasis></emphasis></#if>

					<#if (childValue?length > 75)>
						<para role="${role2}">${childValue}</para>
					<#else>
						${childValue}
					</#if>
				</para>

			</#if>
		</#list>
	</#compress>
</#macro>

<!--Function to get a list of all SUBSTANCE / MIXTURE components from the MixtureComposition records of a mixture.
	The function is by default recursive: in case of MIXTURE components, it also checks its compositions. If recursivity
	is not wanted, indicate "recursive=false".
	If a type is specified, only components flagged with such specific function are retrieved
-->
<#function getComponents mixture type="" recursive=true getRefSubstances=false getSubstanceConstituents=false>

	<#local documentTypes=['MIXTURE', 'SUBSTANCE']/>
	<#if getRefSubstances><#local documentTypes=documentTypes+['REFERENCE_SUBSTANCE']/></#if>

	<#local componentsList = [] />

	<#local compositionList = iuclid.getSectionDocumentsForParentKey(mixture.documentKey, "FLEXIBLE_RECORD", "MixtureComposition") />

	<#list compositionList as composition>
		<#local componentList = composition.Components.Components />
		<#list componentList as component>
			<#if component.Reference?has_content>
				<#if type=="" || isComponentType(component, type)>
					<#local substance = iuclid.getDocumentForKey(component.Reference)/>
					<#if substance?has_content && documentTypes?seq_contains(substance.documentType)>
						<#local componentsList = addDocumentToSequenceAsUnique(substance, componentsList)/>

						<#-- if substance and getSubstanceConstituents is true, get constituents of substance -->
						<#if substance.documentType=="SUBSTANCE" && getSubstanceConstituents && getRefSubstances>
							<#local componentsList = componentsList + getConstituents(substance)/>
						</#if>

						<#-- if mixture and recursive is true, call function again-->
						<#if substance.documentType=="MIXTURE" && recursive>
							<#local componentsList = componentsList + getComponents(substance, type, recursive, getRefSubstances, getSubstanceConstituents)/>
						</#if>
					</#if>

				</#if>
			</#if>
		</#list>
	</#list>

	<#return componentsList />
</#function>

<#--Function to check if a component from a mixture composition documents is of a certain function e.g. 'active substance'-->
<#function isComponentType component type>
	<#return component.Function?has_content && com.picklistValueMatchesPhrases(component.Function, [type]) />
</#function>

<!--Function to get a list of all SUBSTANCE constituents from the SubstanceComposition records of a substance.
	Type can be specified to retrieve Constituents, Additives and/or Impurities.
-->
<#function getConstituents substance type=['Constituents', 'Additives', 'Impurities']>

	<#local constituentsList = [] />

	<#local compositionList = iuclid.getSectionDocumentsForParentKey(substance.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />

	<#list compositionList as composition>

		<#list type as tp>

			<#local path='composition.'+tp+'.'+tp>

			<#list path?eval as constituent>

				<#if constituent.ReferenceSubstance?has_content>
					<#local substance = iuclid.getDocumentForKey(constituent.ReferenceSubstance)/>
					<#local constituentsList = addDocumentToSequenceAsUnique(substance, constituentsList)/>
				</#if>
			</#list>
		</#list>
	</#list>

	<#return constituentsList />
</#function>

<#--Function to retrieve all metabolites from the Metabolites records of a mixture.
	If an active substance is provided and checkParent=true, then the function only retrieves metabolites for which the parent
	is the active substance.
-->
<#function getMetabolites mixture activeSubstance="" checkParent=false>

	<#local metabolitesList = [] />

	<#local compositionList = iuclid.getSectionDocumentsForParentKey(mixture.documentKey, "FLEXIBLE_SUMMARY", "Metabolites") />

	<#list compositionList as composition>

		<#if checkParent && activeSubstance?has_content>
			<#if !isParentMetabolitesSubstance(composition, activeSubstance)>
				<#continue>
			</#if>
		</#if>

		<#local metaboliteList = composition.ListMetabolites.Metabolites />
		<#list metaboliteList as metabolite>
			<#if metabolite.LinkMetaboliteDataset?has_content>
				<#local substance = iuclid.getDocumentForKey(metabolite.LinkMetaboliteDataset)/>
				<#if substance?has_content && substance.documentType=="SUBSTANCE">
					<#local metabolitesList = addDocumentToSequenceAsUnique(substance, metabolitesList)/>
				</#if>
			</#if>
		</#list>
	</#list>

	<#return metabolitesList />
</#function>

<#--Function to check if a metabolites composition record has a specific SUBSTANCE as parent, either by checking the
	substance dataset or the reference substance within it.
-->
<#function isParentMetabolitesSubstance metabComp substance>

	<#local parentLink=metabComp.MetabolitesInfo.ParentOfMetabolites/>

	<#if parentLink?has_content>
		<#local parent=iuclid.getDocumentForKey(parentLink)/>

		<#local subReference=iuclid.getDocumentForKey(substance.ReferenceSubstance.ReferenceSubstance)/>

		<#if (parent.documentType=="SUBSTANCE" && parent.documentKey.uuid==substance.documentKey.uuid) ||
			(parent.documentType=="REFERENCE_SUBSTANCE" && parent.documentKey.uuid==subReference.documentKey.uuid)>
			<#return true>
		</#if>
	</#if>

	<#return false>
</#function>

<#--Function to retrieve all products datasets in the Other representative products section of a PPP mixture.
-->
<#function getOtherRepresentativeProducts mixture>

	<#local otherProdsSummaries=iuclid.getSectionDocumentsForParentKey(mixture.documentKey, "FLEXIBLE_SUMMARY", "OtherRepresentativeProducts") />
	<#local otherProds=[]/>

	<#list otherProdsSummaries as otherProdSummary>
		<#if otherProdSummary.OtherRepresentativeProductS?has_content>
			<#list otherProdSummary.OtherRepresentativeProductS as prodLink>
				<#local prod=iuclid.getDocumentForKey(prodLink)/>
				<#if prod?has_content>
					<#local otherProds = com.addDocumentToSequenceAsUnique(prod, otherProds)/>
				</#if>
			</#list>
		</#if>
	</#list>
	<#return otherProds/>
</#function>

