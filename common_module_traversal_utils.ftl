<#----------------------------------------------->
<#-- Main macros for the traversal approach    -->
<#----------------------------------------------->

<#-- traversal initiates the traversal approach.

     General description: The algorithm iterates a number of times specified by the maxLoop variable.
     In each iteration:
        i)   the traverseEntity macro is applied to each entity in the list of entity keys to be traversed
        ii)  each traversed entity key is added to the list of traversed entity keys
        iii) new entities found in the process (by the subsequent macros) are added to the list to be traversed in
              the next iteration.
     If there are no new entitites to be traversed, the process ends; otherwise it loops until maxLoop is reached.

     Inputs:
     - startEntity: first ENTITY to be traversed, usually the subject of the dossier e.g. entity.root
     - maxLoop: maximum NUMBER of interations
-->
<#macro traversal startEntity=entity.root maxLoop=8 >

    <#-- Initialise the three main lists to store entity keys -->
    <#assign traversedEntityKeyList = []/> <#-- stores keys already traversed -->
    <#assign toTraverseEntityKeyList = []/> <#-- stores keys to be traversed in the current iteration -->
    <#assign toTraverseEntityKeyList_next = [startEntity.documentKey]/> <#-- stores keys to be traversed in the next iteration -->

    <#-- Start loop -->
    <#list 1..maxLoop as x>

        <#-- Stop looping if there is nothing to traverse -->
        <#if !(toTraverseEntityKeyList_next?has_content)>
            <#break>
        </#if>

        <#-- Restart lists -->
        <#assign toTraverseEntityKeyList=toTraverseEntityKeyList_next/>
        <#assign toTraverseEntityKeyList_next=[]/>

        <#-- Traverse each entity from the list of keys to be traversed -->
        <#list toTraverseEntityKeyList as entityItemKey>

            <#assign entityItem = iuclid.getDocumentForKey(entityItemKey)/>

            <#assign traversedEntityKeyList = traversedEntityKeyList + [entityItemKey]/>

            <@traverseEntity entityItem />

        </#list>

    </#list>

</#macro>

<#-- traverseEntity triggers the traversal approach based on the type of entity,
        either simple or composite (SUBSTANCE, MIXTURE, or TEMPLATE).

     Inputs:
     - entityDoc: ENTITY to be traversed
-->
<#macro traverseEntity entityDoc>
    <#if isCompositeEntityDocument(entityDoc)>
        <@traverseCompositeEntity entityDoc />
    <#else>
        <@traverseSimpleEntity entityDoc />
    </#if>
</#macro>

<#-- traverseSimpleEntity triggers directly the traverseDoc macro on a simple entity.

     Inputs:
     - entityDoc: ENTITY to be traversed
-->
<#macro traverseSimpleEntity entityDoc>
    <@traverseDoc entityDoc entityDoc "" entityDoc 0 />
</#macro>

<#-- traverseCompositeEntity retrieves the table of contents of a composite entity and triggers the
        traverseToc macro.

     Inputs:
     - entityDoc: ENTITY to be traversed
-->
<#macro traverseCompositeEntity entityDoc>
    <#local tableOfContents=iuclid.localizeTreeFor(entityDoc.documentType, entityDoc.submissionType, entityDoc.documentKey, getInheritedTemplates(entityDoc), getRelatedCategories(entityDoc), getRelatedMixtures(entityDoc))>
    <@traverseToc tableOfContents entityDoc 0 />
</#macro>

<#-- traverseToc loops recursively over all the sections and subsections in a table of contents, and
        triggers the traverseDoc macro for each document found.

     Inputs:
     - sectionNode: NODE of the table of contents of a composite entity (initialy the root node, then all the children)
     - entityDocument: composite ENTITY that is being traversed
     - level: NUMBER (index) indicating the node level being traversed (initially 0 = root)
        (NOTE: at the moment this parameter is not really used)
-->
<#macro traverseToc sectionNode entityDocument level=0>
    <#if sectionNode?has_content>
        <#-- iterate through the section documents under this section if there are any -->
        <#if sectionNode.content?has_content>
            <#list sectionNode.content as doc>
                <#-- traverse through the document's blocks and fields aka elements -->
                <@traverseDoc doc doc sectionNode entityDocument 0 />
            </#list>
        </#if>
        <#-- iterate through the child sections of the node and do a recursive call -->
        <#if sectionNode?children?has_content>
            <#list sectionNode?children as child>
                <@traverseToc child entityDocument level+1 />
            </#list>
        </#if>
    </#if>
</#macro>

<#-- traverseDoc loops recursively over all the elements in a document, and
        i) triggers, for each element, the main macro call that will generate the output of the traversal approach.
        ii) calls the addIfReferenceToEntityNode macro in order to add new entities linked in the document to the list
            of entities to be traversed by the algorithm.

     Inputs:
     - docElementNode: NODE (element) of the document being traversed (initialy root = the document itself, then all the children)
     - sectionDoc: DOCUMENT being traversed
     - sectionNode: NODE of the table of contents where the document being traversed is found
     - entityDocument: ENTITY that the table of contents belongs to
     - level: NUMBER (index) indicating the document element level being traversed (initially 0 = root)
-->
<#macro traverseDoc docElementNode sectionDoc sectionNode entityDocument level>

    <#if docElementNode?has_content>
        <#-- Call the main macro to generate output: this depends on each specific report
        and needs to be specified as a global variable in the main ftl for the report-->
        <@mainMacroCall?interpret/>

        <#-- If the element is a link to an entity or any of the children is, add to list of entities to traverse -->
        <@addIfReferenceToEntityNode docElementNode/>
        <#if docElementNode?children?has_content>
            <#list docElementNode?children as child>
                <@traverseDoc child sectionDoc sectionNode entityDocument level+1/>
            </#list>
        </#if>
    </#if>
</#macro>

<#-- addIfReferenceToEntityNode checks if a node of a document is of type "document reference" and calls the macro
        addIfEntityNode if it is.

     Inputs:
     - docElementNode: NODE (element) of the document being traversed (initialy root = the document itself, then all the children)
-->
<#macro addIfReferenceToEntityNode docElementNode>

    <#-- If node is a single document reference, then call the function addIfEntityNode -->
    <#if docElementNode?node_type == "document_reference">
        <@addIfEntityNode docElementNode/>

    <#-- If node is a multiple document reference, then call the function addIfEntityNode for each child -->
    <#elseif docElementNode?node_type == "document_references">
        <#list docElementNode as item>
            <@addIfEntityNode item/>
        </#list>

    </#if>
</#macro>

<#-- addIfEntityNode checks if a document linked in an document reference field is an entity and adds it to the list
        of entity keys to be traversed provided that
        i) it has not yet been traversed,
        ii) it is not going to be traversed in this iteration, and
        iii) it has not already been included for traversing in the next iteration


     Inputs:
     - docKey: KEY of the document linked in the reference field
-->
<#macro addIfEntityNode docKey>
    <#local doc = iuclid.getDocumentForKey(docKey) />

    <#if doc?has_content && isEntityDocument(doc) &&
    !(traversedEntityKeyList?seq_contains(doc.documentKey))  &&
    !(toTraverseEntityKeyList?seq_contains(doc.documentKey)) &&
    !(toTraverseEntityKeyList_next?seq_contains(doc.documentKey))>

        <#assign toTraverseEntityKeyList_next = toTraverseEntityKeyList_next + [docKey]/>
    </#if>

</#macro>

<#------------------------------------------------>
<#-- Additional functions, macros and variables -->
<#------------------------------------------------>
<#-- List of IUCLID's entity types -->
<#assign entityTypes = ["SUBSTANCE", "MIXTURE", "TEMPLATE", "ANNOTATION", "ARTICLE", "CATEGORY", "CONTACT", "LEGAL_ENTITY", "LITERATURE", "REFERENCE_SUBSTANCE", "SITE", "TEST_MATERIAL_INFORMATION"]>

<#-- Returns true if doc is a IUCLID entity -->
<#function isEntityDocument doc>
    <#return entityTypes?seq_contains(doc.documentType)>
</#function>

<#-- List of IUCLID's composite entity types -->
<#assign compositeEntityTypes = ["SUBSTANCE", "MIXTURE", "TEMPLATE"]>

<#-- Returns true if doc is a IUCLID composite entity -->
<#function isCompositeEntityDocument doc>
    <#return compositeEntityTypes?seq_contains(doc.documentType)>
</#function>

<#-- NOTE: from here on, unclear when these are used -->
<#-- Prints the textToken nr number of times -->
    <#-- IS THIS USED?-->
<#function getIndentationText nr textToken = "-">
    <#local indentText = "">
    <#list 1..nr as x>
        <#local indentText = indentText + textToken>
    </#list>
    <#return indentText>
</#function>

<#function getInheritedTemplates entityDoc>
<#--
<#if !(mode?has_content && mode == "PUBLISHING") && entityDoc.documentType == "SUBSTANCE">
  <#return entityDoc.inherited>
</#if>
-->
    <#return []>
</#function>

<#function getRelatedCategories entityDoc>
    <#if !(mode?has_content && mode == "PUBLISHING")>
        <#local params={"key": [entityDoc.documentKey]}>
        <#return iuclid.query("iuclid6.SubstanceRelatedCategories", params, 0, 100)>
    </#if>
    <#return []>
</#function>

<#function getRelatedMixtures entityDoc>
<#--
<#if !(mode?has_content && mode == "PUBLISHING")>
  <#local params={"key": [entityDoc.documentKey]}>
  <#return iuclid.query("iuclid6.SubstanceRelatedMixtures", params, 0, 100)>
</#if>
 -->
    <#return []>
</#function>

<#-- Function that recieves a text value as input and return a new string escaped for .csv file (comma separated value)
  It replaces in the text every quotes (") character with two quotes ("")
  It puts the text into a "<text>" format -->
<#function escapeCsvText textValue>
    <#if !(textValue?has_content)>
    <#-- Return "" -->
        <#return "\"\"">
    </#if>
    <#local newValue = textValue?replace("\"", "\"\"")>
    <#return "\""+ newValue + "\"">
</#function>

<#-- Macro that prints the textValue in a csv escaped format -->
<#macro csvValue textValue>
    <#compress>
        ${escapeCsvText(textValue)}
    </#compress>
</#macro>

<#function getDocumentUrl document>
    <#local generatedUrl = iuclid.webUrl.entityView(document.documentKey) />
    <#if generatedUrl?has_content>
    <#-- Get the base URL part -->
        <#local generatedUrl = generatedUrl?keep_before("/iuclid6-web") />
    </#if>
    <#return generatedUrl + "/iuclid6-web/?key=" + document.documentKey>
</#function>

<#function getPicklistFieldAsText picklistValue includeDescription=false locale="en">
    <#if !picklistValue?has_content>
        <#return ""/>
    </#if>
    <#local localizedPhrase = iuclid.localizedPhraseDefinitionFor(picklistValue.code, locale) />
    <#if !localizedPhrase?has_content>
        <#return ""/>
    </#if>
    <#local displayText = localizedPhrase.text />
    <#if localizedPhrase.open && picklistValue.otherText?has_content>
        <#local displayText = displayText + " " + picklistValue.otherText />
    </#if>
    <#if includeDescription && localizedPhrase.description?has_content>
        <#local displayText = displayText + " [" + localizedPhrase.description + "]" />
    </#if>
    <#return displayText>
</#function>

<#function getPhraseCodeValue phraseCode includeDescription=false locale="en">
    <#local displayText = "" />
    <#local localizedPhrase = iuclid.localizedPhraseDefinitionFor(phraseCode, locale) />
    <#if localizedPhrase?has_content>
        <#local displayText = localizedPhrase.text />
        <#if includeDescription && localizedPhrase.description?has_content>
            <#local displayText = displayText + " [" + localizedPhrase.description + "]" />
        </#if>
    </#if>
    <#return displayText>
</#function>

<#function getTextForConfidentialityLegislations confidentialityLegislations>
    <#if !confidentialityLegislations?has_content>
        <#return "">
    </#if>
    <#local displayText = "" />
    <#list confidentialityLegislations as legislation>
        <#local legText = getPhraseCodeValue(legislation.code) />
        <#if legislation.otherText?has_content>
            <#local legText = legText + " " + legislation.otherText />
        </#if>
        <#local displayText = displayText + legText + "; " />
    </#list>
    <#return displayText>
</#function>

<#------------------------------------------------>
<#-- DEPRECATED: only used in old traversal     -->
<#------------------------------------------------>
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

<#-- Gets a docSequence list of documents and a docKeyList list of keys. Returns a new list of documents that contain only those document whose keys did not appear in docKeyList -->
<#function removeDocumentWitKey docSequence docKeyList>
    <#if !(docSequence?has_content && docKeyList?has_content)>
        <#return docSequence>
    </#if>
    <#local newSequence = []>
    <#list docSequence as doc>
        <#if !(docKeyList?seq_contains(doc.documentKey))>
            <#local newSequence = newSequence + [doc]>
        </#if>
    </#list>
    <#return newSequence>
</#function>

<#-- Function to check if the docElementNode element node is a reference field and remember referenced entities
   for later traversal
   toTravereseList - a list with already identified entity documents for traversal
   traveresedKeyList - a list with document keys already traversed
   returns a new version of the toTravereseList -->
<#function checkAndRememberReferencedEntity docElementNode toTravereseList traveresedKeyList>
    <#if docElementNode?node_type == "document_reference">
        <#return checkAndRememberEntityKey(docElementNode, toTravereseList, traveresedKeyList) />
    </#if>
    <#if docElementNode?node_type == "document_references">
        <#local newToTraverseList = toTravereseList>
        <#list docElementNode as item>
            <#local newToTraverseList = checkAndRememberEntityKey(item, newToTraverseList, traveresedKeyList) />
        </#list>
        <#return newToTraverseList />
    </#if>
    <#return toTravereseList>
</#function>

<#-- Function to check whether the docKey is a refrence to an entity document and if it was not traversed yet,
  remember it for later traversal by returning a new list based on toTravereseEntityList
  toTravereseList - a list with already identified entity documents for traversal
  traveresedKeyList - a list with document keys already traversed
  returns a new version of the toTravereseList -->
<#function checkAndRememberEntityKey docKey toTravereseList traveresedKeyList>
    <#local doc = iuclid.getDocumentForKey(docKey) />
    <#if doc?has_content && isEntityDocument(doc) && !(traveresedKeyList?seq_contains(doc.documentKey))>
        <#return addDocumentToSequenceAsUnique(doc, toTravereseList)>
    </#if>
    <#return toTravereseList>
</#function>