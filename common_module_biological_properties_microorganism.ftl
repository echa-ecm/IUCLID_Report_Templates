<#-- This FTL contains macros to output content in documents related with microbial pesticides, namely:
        - FLEXIBLE_RECORD.BioPropertiesMicro (Document M (a.s.) - section 2 for microbial PPP)
        - ENDPOINT_STUDY_RECORD.EffectivenessAgainstTargetOrganisms (Document M (a.s. and product) - section 3)
        - ENDPOINT_SUMMARY.EffectivenessAgainstTargetOrganisms (Document M (a.s. and product) - section 3)
        - ENDPOINT_STUDY_RECORD.ToxicityToOtherAboveGroundOrganisms (Document M (a.s.) - section 2 for microbial PPP)
        - ENDPOINT_SUMMARY.ToxicityToOtherAboveGroundOrganisms (Document M (a.s.) - section 2 for microbial PPP)
-->     

<#-- BioPropMicroSection outputs sections of the FLEXIBLE_RECORD.BioPropertiesMicro document, 
    based on the path provided. It iterates over the children of the provided path and prints the label
    and the content.
    
    It should be used for L2 sections (L3 in case of subsections of General information on the microorganism).

    Inputs:
    - path: str containing the path in the document FLEXIBLE_RECORD.BioPropertiesMicro
    - exclude: list containing paths to exclude from the output e.g. Reference
-->
<#macro BioPropMicroSection path exclude=[]>

    <#compress>

        <#-- list of paths to exclude from the output: it is the reference block plus additional ones from the macro call -->
        <#local exclude = exclude + ["Reference", "DataAccess", "DataProtectionClaimed"]/>
        
        <#-- get doc and iterate -->
        <#local docs=iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "BioPropertiesMicro")/>
        <#list docs as doc>
            
            <#-- print name of document if more than 1
                NOTE: probably more than one document should NOT be allowed
            -->
            <#local docUrl=iuclid.webUrl.documentView(doc.documentKey) />
            <#if (docs?size>1)><para><emphasis role="underline">#${doc_index+1}: <ulink url="${docUrl}"><@com.text doc.name/></ulink></emphasis></para></#if>
			
            <#-- get the path -->
            <#local path="doc."+path/>
			<#local docPath=path?eval/>
            
            <#-- iterate through the path elements -->
            <#list docPath?children as child>  

                <#-- print only if not in the list of paths to exclude-->
                <#if !exclude?seq_contains(child?node_name) && child?has_content>
                    
                    <#-- get the label -->
                    <@iuclid.label for=child var="fieldLabel"/>

                    <#-- consider special cases 
                        - literature search block
                        - phylogenetic tree
                    -->
                    <#if child?node_name == "SupportingLiteratureSearchesIfRelevant_list">

                        <para>${fieldLabel}:</para>
                        <@LitSearchBlock child/>
                    
                    <#elseif child?node_name == "PhylogenicTree">
                        
                        <para>${fieldLabel}:</para>

                        <#local illustration = iuclid.getMetadataForAttachment(child) />
                        <#if illustration?has_content && illustration.isImage>
                            <#if illustration.exceedsLimit(10000000)>
                                <para><emphasis>Image size is too big (${illustration.size} bytes) and cannot be displayed!</emphasis></para>
                            <#elseif !iuclid.imageMimeTypeSupported(illustration.mediaType) >
                                <para><emphasis>Image type (${illustration.mediaType}) is not yet supported!</emphasis></para>
                            <#else>
                                <figure>
                                    <title><@com.text illustration.filename/></title>
                                    <mediaobject>
                                        <imageobject>
                                            <imagedata width="70%" scalefit="1" fileref="data:${illustration.mediaType};base64,${iuclid.getContentForAttachment(child)}" />
                                        </imageobject>
                                    </mediaobject>
                                </figure>
                            </#if>
                        </#if>

                    <#else>
                        <#-- print (with grey background in the case of rich text) -->
                        <#if child?node_type == "multilingual_text_html"><para style="background-color:#f7f7f7"><#else><para></#if>
                            <#if fieldLabel?has_content>${fieldLabel}:</#if>
                            <#-- print the content -->
                            <@com.value child 'literal'/>
                        </para>
                    </#if>

                </#if>
            </#list>
			
            <#-- print the reference -->
            <#if docPath.hasElement("Reference") && docPath.Reference?has_content>
            	<para>Reference(s):</para>
            	<#list docPath.Reference as refKey>
	            	<#local ref = iuclid.getDocumentForKey(refKey) />
	            	<#local refUrl=iuclid.webUrl.documentView(ref.documentKey) />
	            	<para role="indent">
	            		<ulink url="${refUrl}">
	            			<@com.value ref.GeneralInfo.Name/>,
							<#if ref.GeneralInfo.Author?has_content><@com.value ref.GeneralInfo.Author/>,</#if>							
							<@com.value ref.GeneralInfo.ReferenceYear/>	      
							<#if ref.GeneralInfo.ReportNo?has_content>(Report No: <@com.value ref.GeneralInfo.ReportNo/>)</#if>
							<#if ref.GeneralInfo.LiteratureType?has_content>[<@com.value ref.GeneralInfo.LiteratureType/>]</#if>    
	            		</ulink>      		
	            	</para>
           		</#list>
           		
            </#if>
                  
	        <@com.emptyLine/>

        </#list>
    </#compress>
</#macro>

<#--BLOCKS-->

<#-- LitSearchBlock outputs the literature search repeatable block from the FLEXIBLE_RECORD.BioPropertiesMicro document.
    
    Inputs:
    - litBlock: field object from the document FLEXIBLE_RECORD.BioPropertiesMicro 
-->
<#macro LitSearchBlock litBlock>

    <#list litBlock as litsearch>

        <#local litsearchDoc=iuclid.getDocumentForKey(litsearch.LiteratureSearch)/>
        <#local docUrl=iuclid.webUrl.documentView(litsearchDoc.documentKey)/>

        <para role='indent'><ulink url="${docUrl}"><@com.text litsearchDoc.name/></ulink><#if litsearch.Remarks?has_content>: <@com.value litsearch.Remarks/></#if></para>

    </#list>
</#macro>

<#-- generalInfo_effectivenessTargetOrg outputs the general information section of the ENDPOINT_STUDY_RECORD.EffectivenessAgainstTargetOrganisms
    document.
    The structure of the output follows the ToC of the microbial PPP a.s.
    
    Inputs:
    - study: document of type ENDPOINT_STUDY_RECORD.EffectivenessAgainstTargetOrganisms
    -->
<#macro generalInfo_effectivenessTargetOrg study>

    <#local gen=study.GeneralInformation/>

    <#--  3.1 Use of the active substance-->
    <#if gen.BackgroundInformation?has_content>
        <para><emphasis role="bold">Background</emphasis></para>
        <para role="indent"><@com.value gen.BackgroundInformation 'literal'/></para>
    </#if>

    <#--  3.2 Function (including also product type...) -->
    <#local use=gen.InformationOnIntendedUseAndApplication/>
    <#if use.FunctionAddressed?has_content || use.ProductType?has_content>
        <para><emphasis role="bold">Function</emphasis></para>

        <#if use.FunctionAddressed?has_content>
            <para role="indent"><@com.value use.FunctionAddressed 'literal'/></para>
        </#if>

        <#if use.ProductType?has_content>
            <para role="indent">Product type: <@com.value use.ProductType 'literal'/></para>
        </#if>
    </#if>

    <#--  3.3 Effects on harmful organisms -->
    <#local eff=gen.GeneralInformationOnEffectiveness/>

    <#if eff.EffectsOnTargetOrganisms?has_content>
        <para><emphasis role="bold">Effects on harmful organisms</emphasis></para>
        <para role="indent"><@com.value eff.EffectsOnTargetOrganisms 'literal'/></para>
    </#if>

    <#--  3.4 Field of use envisaged -->
    <#if use.FieldOfUseEnvisagedUser?has_content>
        <para><emphasis role="bold">Field of use envisaged</emphasis></para>
        <para role="indent"><@com.value use.FieldOfUseEnvisagedUser 'literal'/></para>
    </#if>

    <#--  3.5 Harmful organisms controlled and crops or products protected or treated -->
    <#if gen.PestTargetOrganismsToBeControlled?has_content || gen.ProductsOrganismsOrObjectsToBeProtectedUnderStudy?has_content>

        <para><emphasis role="bold">Harmful organisms controlled and crops or products protected or treated</emphasis></para>

        <#if gen.PestTargetOrganismsToBeControlled.TargetOrganisms?has_content>
            <para role="indent"><emphasis role="underline">List of target organisms:</emphasis></para>
            <@targetOrganismsList gen.PestTargetOrganismsToBeControlled.TargetOrganisms "indent2"/>
            <@com.emptyLine/>
        </#if>

        <#if gen.ProductsOrganismsOrObjectsToBeProtectedUnderStudy.OrganismsToBeProtectedOrTreatedMaterials?has_content>
            <para role="indent"><emphasis role="underline">Crops or products protected or treated:</emphasis></para>
            <para role="indent2"><@com.value gen.ProductsOrganismsOrObjectsToBeProtectedUnderStudy.OrganismsToBeProtectedOrTreatedMaterials 'literal'/></para>
        </#if>
    </#if>

    <#--  3.6 Mode of action -->
    <#if eff.ModeAction?has_content || eff.DetailsOnModeOfAction?has_content>

        <para><emphasis role="bold">Mode of action</emphasis></para>

        <para role="indent"><@com.value eff.ModeAction 'literal'/></para>
        <#if eff.DetailsOnModeOfAction?has_content>
            <para role="indent"><@com.value eff.DetailsOnModeOfAction 'literal'/></para>
        </#if>
    </#if>

    <#--  3.7 Information on the occurrence or possible occurrence of the development of resistance, and appropriate management strategies -->
    <#if eff.PossibleOccurrenceOfResistance?has_content ||
            eff.ManagementStrategiesToAvoidResistance?has_content ||
            eff.AnyOtherKnownLimitationsAndManagementStrategies?has_content>

        <para><emphasis role="bold">Information on the occurrence or possible occurrence of the development of resistance, and appropriate management strategies</emphasis></para>

        <#if eff.PossibleOccurrenceOfResistance?has_content>
            <para role="indent"><@com.value eff.PossibleOccurrenceOfResistance 'literal'/></para>
        </#if>

        <#if eff.ManagementStrategiesToAvoidResistance?has_content>
            <para role="indent"><@com.value eff.ManagementStrategiesToAvoidResistance 'literal'/></para>
        </#if>

        <#if eff.AnyOtherKnownLimitationsAndManagementStrategies?has_content>
            <para role="indent"><@com.value eff.AnyOtherKnownLimitationsAndManagementStrategies 'literal'/></para>
        </#if>
    </#if>

    <#-- Method of application -->
    <#if gen.InformationOnApplicationOfProduct?has_content>
        <para><emphasis role="bold">Information on application of the product</emphasis></para>
        <para role="indent">Method of application: <@com.value gen.InformationOnApplicationOfProduct.MethodOfApplication 'literal'/></para>
        <#if gen.InformationOnApplicationOfProduct.DetailsOnApplication?has_content>
            <para role="indent"><@com.value gen.InformationOnApplicationOfProduct.DetailsOnApplication 'literal'/></para>
        </#if>
    </#if>
</#macro>

<#-- targetOrganismsList outputs the target organisms repeatable block from the ENDPOINT_STUDY_RECORD.EffectivenessAgainstTargetOrganisms document.
    
    Inputs:
    - targetOrganismsRepeatableBlock: field object from the document FLEXIBLE_RECORD.BioPropertiesMicro 
    - role: type of indentation e.g. 'indent', 'indent2'
-->
<#macro targetOrganismsList targetOrganismsRepeatableBlock role="indent">
    <#compress>
        <#if targetOrganismsRepeatableBlock?has_content>
            <#list  targetOrganismsRepeatableBlock as blockItem>
                <#if blockItem.ScientificName?has_content || blockItem.CommonName?has_content || blockItem.DevelopmentalStage?has_content || blockItem.DevelopmentalStageOfTargetPlant?has_content>
                    <para role="${role}">
                        <#if blockItem.ScientificName?has_content>
                            <@com.picklist blockItem.ScientificName/>
                            <#if blockItem.CommonName?has_content>
                                (<@com.picklist blockItem.CommonName/>)
                            </#if>
                        <#elseif blockItem.CommonName?has_content>
                            <@com.picklist blockItem.CommonName/>
                        </#if>

                        <#if blockItem.DevelopmentalStage?has_content>
                            <?linebreak?>- Developmental stage of target pest: <@com.picklist blockItem.DevelopmentalStage/>
                        </#if>

                        <#if blockItem.DevelopmentalStageOfTargetPlant?has_content>
                            <?linebreak?>- Developmental stage of target plant: <@com.picklistMultiple blockItem.DevelopmentalStageOfTargetPlant/>
                        </#if>
                    </para>
                </#if>
            </#list>
        </#if>
    </#compress>
</#macro>

<#-- effectList outputs the Effect concentrations block from the ENDPOINT_STUDY_RECORD.ToxicityToOtherAboveGroundOrganisms.
    NOTE: this has changed in April 2023 but not yet implemented! New fields were added:
    - *.EffectConcentrations.SlopeOfTheCurve
    - *.EffectConcentrations.LifeStage

    Inputs:
    - effectConcRepeatableBlock: path object of the block
-->
<#macro effectList effectConcRepeatableBlock>
    <#compress>
        <#if effectConcRepeatableBlock?has_content>
            <#list effectConcRepeatableBlock as blockItem>
                <#if blockItem.Endpoint?has_content || blockItem.Duration?has_content
                || blockItem.EffectConc?has_content || blockItem.ConcBasedOn?has_content
                || blockItem.NominalMeasured?has_content || blockItem.BasisForEffect?has_content
                || blockItem.RemarksOnResults?has_content>
                    <para role="indent">
                        <#if blockItem.Endpoint?has_content>
                            <@com.picklist blockItem.Endpoint/>
                        </#if>

                        <#if blockItem.Duration?has_content>
                            (<@com.quantity blockItem.Duration/>):
                        </#if>

                        <#if blockItem.EffectConc?has_content>
                            <@com.range blockItem.EffectConc/>
                        </#if>

                        <#if blockItem.ConcBasedOn?has_content>
                            <@com.picklist blockItem.ConcBasedOn/>
                        </#if>

                        <#if blockItem.NominalMeasured?has_content>
                            (<@com.picklist blockItem.NominalMeasured/>)
                        </#if>

                        <#if blockItem.BasisForEffect?has_content>
                            based on: <@com.picklist blockItem.BasisForEffect/>
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



<#-- methods_toxicityAboveGroundOrg outputs the methods section from the ENDPOINT_STUDY_RECORD.ToxicityToOtherAboveGroundOrganisms.
        NOTE: this has changed in April 2023 but not yet implemented! New fields were added
        NOTE2: is this macro used in any report?

    Inputs:
    - study
-->
<#macro methods_toxicityAboveGroundOrg study>
    <#local met=study.MaterialsAndMethods/>

    <#local sa=met.SamplingAndAnalysis/>
    <#if sa?has_content>
        <para><emphasis role="bold">Sampling and analysis:</emphasis></para>
        <#if sa.AnalyticalMonitoring?has_content>
            <para role="indent">Analytical monitoring: <@com.picklist sa.AnalyticalMonitoring/></para>
        </#if>
        <#if sa.DetailsOnSampling?has_content>
            <para role="indent">Sampling: <@com.text sa.DetailsOnSampling 'literal'/></para>
        </#if>
        <#if sa.DetailsOnAnalyticalMethods?has_content>
            <para role="indent">Analytical methods: <@com.text sa.DetailsOnAnalyticalMethods 'literal'/></para>
        </#if>
    </#if>

    <#local ts=met.TestSubstrate/>
    <#if ts?has_content>
        <para><emphasis role="bold">Test substrate:</emphasis></para>
        <#if ts.Vehicle?has_content>
            <para role="indent">Vehicle: <@com.picklist ts.Vehicle/></para>
        </#if>
        <#if ts.DetailsOnPreparationAndApplicationOfTestSubstrate?has_content>
            <para role="indent">Preparation and application of test substrate: <@com.text ts.DetailsOnPreparationAndApplicationOfTestSubstrate 'literal'/></para>
        </#if>
    </#if>

    <#local to=met.TestOrganisms/>
    <#if to?has_content>
        <para><emphasis role="bold">Test organisms:</emphasis></para>
        <#if to.TestOrganismsSpecies?has_content>
            <para role="indent">Species: <@com.picklist to.TestOrganismsSpecies/></para>
        </#if>
        <#if to.DetailsOnTestOrganisms?has_content>
            <para role="indent"><@com.text to.DetailsOnTestOrganisms 'literal'/></para>
        </#if>
        
    </#if>

    <#local sd=met.StudyDesign/>
    <#if sd?has_content>
        <para><emphasis role="bold">Study design:</emphasis></para>
        <#if sd.StudyType?has_content>
            <para role="indent">Study type: <@com.picklist sd.StudyType/></para>
        </#if>
        <#if sd.LimitTest?has_content>
            <para role="indent">Limit test: <@com.picklist sd.LimitTest/></para>
        </#if>
        <#if sd.TotalExposureDuration?has_content>
            <para role="indent">Exposure duration: <@com.quantity sd.TotalExposureDuration/></para>
        </#if>
        <#if sd.Remarks?has_content>
            <para role="indent">Remarks:<@com.text sd.Remarks 'literal'/></para>
        </#if>
        <#if sd.PostExposureObservationPeriod?has_content>
            <para role="indent">Post exposure observation period:<@com.text sd.PostExposureObservationPeriod 'literal'/></para>
        </#if>
        
    </#if>

    <#local tc=met.TestConditions/>
    <#if tc?has_content>
        <para><emphasis role="bold">Test conditions:</emphasis></para>
        <#if tc.TestTemperature?has_content>
            <para role="indent">Temperature:<@com.text tc.TestTemperature 'literal'/></para>
        </#if>
        <#if tc.Humidity?has_content>
            <para role="indent">Humidity:<@com.text tc.Humidity 'literal'/></para>
        </#if>
        <#if tc.PhotoperiodAndLighting?has_content>
            <para role="indent">Photoperiod and lighting:<@com.text tc.PhotoperiodAndLighting 'literal'/></para>
        </#if>
        <#if tc.NominalAndMeasuredConcentrations?has_content>
            <para role="indent">Nominal and measured concentrations:<@com.text tc.NominalAndMeasuredConcentrations 'literal'/></para>
        </#if>
        <#if tc.ReferenceSubstancePositiveControl?has_content>
            <para role="indent">Reference substance (positive control):<@com.picklist tc.ReferenceSubstancePositiveControl/></para>
        </#if>
        <#if tc.DetailsOnTestConditions?has_content>
            <para role="indent">Other:<@com.text tc.DetailsOnTestConditions 'literal'/></para>
        </#if>
        
    </#if>

</#macro>


<#--SUMMARIES-->

<#-- effectivenessTargetOrgSummary prints the summary for ENDPOINT_SUMMARY.EffectivenessAgainstTargetOrganisms
    
    Inputs:
    - subject: ENTITY where document is found
    - includeMetabolites: bool; if true, the summary in metabolite datasets will also be output
        This requires the global variable _metabolites to exist and have content.
        It is applicable for reports on the active substance (where metabolite studies should be also listed)	
-->
<#macro effectivenessTargetOrgSummary subject includeMetabolites=true >
    <#compress>

        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY",  "EffectivenessAgainstTargetOrganisms") />

        <#-- if includeMetabolites is true and the global variable _metabolites exists, add metabolites summary if exists -->
        <#if includeMetabolites && _metabolites??>

            <#-- create a list of entities of same size as summaryList, so that the summary can be matched
            by index to the entity that it belongs to -->
            <#assign entityList = []/>
            <#list summaryList as summary>
                <#assign entityList = entityList + [subject.ChemicalName]/>
            </#list>

            <#-- add metabolites-->
            <#list _metabolites as metab>
                <#local metabSummaryList = iuclid.getSectionDocumentsForParentKey(metab.documentKey, "ENDPOINT_SUMMARY",  "EffectivenessAgainstTargetOrganisms") />
                <#if metabSummaryList?has_content>
                    <#local summaryList = summaryList + metabSummaryList/>
                    <#list metabSummaryList as metabSummary>
                        <#local entityList = entityList + [metab.ChemicalName]/>
                    </#list>
                </#if>
            </#list>
        </#if>

        <#-- print always Summary, and if no content, print message -->
        <@com.emptyLine/>
        <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>
        <#if !summaryList?has_content>
            <@com.emptyLine/>
            <para>No summary information available for this section.</para>
            <@com.emptyLine/>
        </#if>

        <#-- if there is content, print each summary -->
        <#if summaryList?has_content>
            <#local printSummaryIndex = summaryList?size gt 1 />
            
            <#list summaryList as summary>
                
                <@com.emptyLine/>

                <#-- check if it's a metabolite, and if so print the identity of metabolite first (only for the first appearance) -->
                <#if includeMetabolites && _metabolites??
                    && subject.documentType=="SUBSTANCE"
                    && subject.ChemicalName!=entityList[summary_index]
                    && entityList?seq_index_of(entityList[summary_index]) == summary_index >
                    <para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
                    <@com.emptyLine/>
                </#if>

                <#-- get url -->
                <#local summaryUrl=iuclid.webUrl.documentView(summary.documentKey) />

                <para><emphasis role="bold"><#if printSummaryIndex>#${summary_index+1}: </#if><ulink url="${summaryUrl}"><@com.text summary.name/></ulink></emphasis></para>

                <#--Key Information-->
                <#if summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>
                    <para><para style="background-color:#f7f7f7" ><@com.value summary.KeyInformation.KeyInformation/></para></para>
                </#if>

                <#--Discussion-->
                <#if summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>
                    <para><para  style="background-color:#f7f7f7" ><@com.value summary.Discussion.Discussion/></para></para>
                </#if>

            </#list>
        </#if>

    </#compress>
</#macro>

<#-- toxicityToOtherAboveGroundOrganismsSummary prints the summary for ENDPOINT_SUMMARY.ToxicityToOtherAboveGroundOrganisms
    
    Inputs:
    - subject: ENTITY where document is found
    - includeMetabolites: bool; if true, the summary in metabolite datasets will also be output
        This requires the global variable _metabolites to exist and have content.
        It is applicable for reports on the active substance (where metabolite studies should be also listed)	
-->
<#macro toxicityToOtherAboveGroundOrganismsSummary subject includeMetabolites=true>
    <#compress>
		
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToOtherAboveGroundOrganisms") />
        
        <#-- if includeMetabolites is true and the global variable _metabolites exists, add metabolites summary if exists -->
        <#if includeMetabolites && _metabolites??>

            <#-- create a list of entities of same size as summaryList, so that the summary can be matched
            by index to the entity that it belongs to -->
            <#assign entityList = []/>
            <#list summaryList as summary>
                <#assign entityList = entityList + [subject.ChemicalName]/>
            </#list>

            <#-- add metabolites-->
            <#list _metabolites as metab>
                <#local metabSummaryList = iuclid.getSectionDocumentsForParentKey(metab.documentKey, "ENDPOINT_SUMMARY", "ToxicityToOtherAboveGroundOrganisms") />
                <#if metabSummaryList?has_content>
                    <#local summaryList = summaryList + metabSummaryList/>
                    <#list metabSummaryList as metabSummary>
                        <#local entityList = entityList + [metab.ChemicalName]/>
                    </#list>
                </#if>
            </#list>
        </#if>

         <#-- print always Summary, and if no content, print message -->
        <@com.emptyLine/>
        <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>
        <#if !summaryList?has_content>
            <@com.emptyLine/>
            <para>No summary information available for this section.</para>
            <@com.emptyLine/>
        </#if>

        <#-- if there is content, print each summary -->
        <#if summaryList?has_content>
            
            <#local printSummaryIndex = summaryList?size gt 1 />

            <#list summaryList as summary>
                
                <@com.emptyLine/>
                
                <#-- check if it's a metabolite, and if so print the identity of metabolite first (only for the first appearance) -->
                <#if includeMetabolites && _metabolites??
                    && subject.documentType=="SUBSTANCE"
                    && subject.ChemicalName!=entityList[summary_index]
                    && entityList?seq_index_of(entityList[summary_index]) == summary_index>
                    <para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
                    <@com.emptyLine/>
                </#if>
                
                <#-- get url -->
                <#local summaryUrl=iuclid.webUrl.documentView(summary.documentKey) />

                <para><emphasis role="bold"><#if printSummaryIndex>#${summary_index+1}: </#if><ulink url="${summaryUrl}"><@com.text summary.name/></ulink></emphasis></para>

                <#-- Key Information -->
                <#if summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>
                    <para><para style="background-color:#f7f7f7" ><@com.value summary.KeyInformation.KeyInformation/></para></para>
                </#if>

                <#-- Key value (new in April 2023)-->
                <#if summary.KeyValueForChemicalSafetyAssessment?has_content>
                    <para><emphasis role="bold">Key value for CSA: </emphasis></para>
                    <@toxicityToOtherAboveGroundOrganismsSummaryTable summary/>
                </#if>

                <#--Discussion-->
                <#if summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>
                    <para><para  style="background-color:#f7f7f7" ><@com.value summary.Discussion.Discussion/></para></para>
                </#if>
                
            </#list>
        </#if>

    </#compress>
</#macro>

<#-- toxicityToOtherAboveGroundOrganismsSummaryTable prints the section of key value for chemical safety assessment
    of the ENDPOINT_SUMMARY.ToxicityToOtherAboveGroundOrganisms in table format.
    
    Inputs:
    - csaBlock: path object of the section 
-->
<#macro toxicityToOtherAboveGroundOrganismsSummaryTable summary>
    <#compress>
        
        <#-- table for the first two sections -->
        <table border="1">
			
            <tbody valign="middle">
			
            <tr>
				<th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
                <th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Descriptor and value</emphasis></th>
				<th align="center"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Studies</emphasis></th>
			</tr>

            <#list summary.KeyValueForChemicalSafetyAssessment?children as endpointEntry>

                <#-- exclude the higher tier since the structure is very different -->
                <#if endpointEntry?node_name != "HigherTierTesting">

                    <tr>

                        <td>
                            <@iuclid.label for=endpointEntry var="fieldLabel"/>
                            ${fieldLabel}
                        </td>

                        <td>
                            <#if endpointEntry.DoseDescriptor?has_content>
                                <@com.value endpointEntry.DoseDescriptor/> = 
                            </#if>
                            <#if endpointEntry.EffectConcentration?has_content>
                                <@com.value endpointEntry.EffectConcentration/>
                            </#if>
                        </td>

                        <td>

                            <#if endpointEntry.LinkToRelevantStudyRecordS?has_content>
                                <#list endpointEntry.LinkToRelevantStudyRecordS as link>
                                    <#local study = iuclid.getDocumentForKey(link) />
                                    <para>
                                        <command linkend="${study.documentKey.uuid!}">
                                            <@com.text study.name/>
                                        </command>
                                    </para>
                                </#list>
                            </#if>  
                        </td>
                    </tr>

                </#if>
            </#list>
        </tbody>
        </table>

        <#-- higher tier testing -->
        <#if csaBlock.HigherTierTesting?has_content>

            <para><emphasis role='underline'>Higher tier testing: </emphasis></para>

            <#-- rich text field -->
            <#if csaBlock.HigherTierTesting.KeyInformationFromHigherTierTesting?has_content>
                <para role='indent'><para  style="background-color:#f7f7f7" ><@com.value csaBlock.HigherTierTesting.KeyInformationFromHigherTierTesting/></para></para>
            </#if>

            <#-- link studies (same code as above) -->
            <#if csaBlock.HigherTierTesting.LinkToRelevantStudyRecordS?has_content>

                <para role='indent'>Linked studies:</para>
                <#list csaBlock.HigherTierTesting.LinkToRelevantStudyRecordS as link>
                    <#local study = iuclid.getDocumentForKey(link) />
                    <para role='indent2'>
                        <command linkend="${study.documentKey.uuid!}">
                            <@com.text study.name/>
                        </command>
                    </para>
                </#list>
            </#if>

        </#if>
    </#compress>
</#macro>

