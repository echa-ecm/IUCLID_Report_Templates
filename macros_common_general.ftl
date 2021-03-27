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
	'relevant' : 'ppp',
	'relevant' : 'par',
	'relevant' : 'dar',
	'relevant' : 'rar',
	'relevant' : 'generic'
} />

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
		${numberValue?string["0.###"]}
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

<#macro picklist picklistValue locale="en" printOtherPhrase=false>
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
			<#if localizedPhrase.description?has_content>
				[${localizedPhrase.description}]
			</#if>
		</#if>
		<#if picklistValue.remarks?has_content>
			- ${picklistValue.remarks}
		</#if>
		<#lt>
	</#escape>
</#compress>
</#macro>

<#macro picklistMultiple picklistMultipleValue>
<#compress>
	<#if picklistMultipleValue?has_content>
		<#list picklistMultipleValue as item>
			<@picklist item/>
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

<#macro structuralFormula referenceSubstanceID>
<#compress>
<#if referenceSubstanceID?has_content>
	<#local attachmentKey = referenceSubstanceID.MolecularStructuralInfo.StructuralFormula />
	<#if attachmentKey?has_content>
		<#local structuralFormula = iuclid.getMetadataForAttachment(attachmentKey) />
		<#if structuralFormula?has_content && structuralFormula.isImage>
			<para><emphasis role="bold"></emphasis></para>
			<#if structuralFormula.exceedsLimit(10000000)>
				<para><emphasis role="bold">Image size is too big (${structuralFormula.size} bytes) and cannot be displayed!</emphasis></para>
			<#elseif !iuclid.imageMimeTypeSupported(structuralFormula.mediaType) />
				<para><emphasis role="bold">Image type (${structuralFormula.mediaType}) is not yet supported!</emphasis></para>
			<#else/>
				<figure><title>
				<#if structuralFormula?has_content>
				<#local attachName><@com.text structuralFormula.filename/></#local>${attachName}
				</#if>
				</title>
					<mediaobject>
						<imageobject>
							<imagedata width="31%" scalefit="1" fileref="data:${structuralFormula.mediaType};base64,${iuclid.getContentForAttachment(attachmentKey)}" />
						</imageobject>
					</mediaobject>										
				</figure>
			</#if>
		</#if>
	<#else/>
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
<#macro otherIdentifiersList otherNamesRepeatableBlock>
<#compress>
	<#if otherNamesRepeatableBlock?has_content>
		<#list otherNamesRepeatableBlock as blockItem>
			<para>
				<@com.picklist blockItem.NameType/> <@com.text blockItem.Name/> 
				<#if blockItem.Relation?has_content>
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

<#function inboundReferences key>
    <#local params={"key": [key]}>
    <#return iuclid.query("web.ReferencingQuery", params, 0, 100)>
</#function>