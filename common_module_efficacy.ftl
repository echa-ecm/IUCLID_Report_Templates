<#--Results-->
<#macro results_efficacyData study>
    <#compress>

        <#if study.ResultsAndDiscussion.EfficacyPerformanceAssessment?has_content>
            <para>Efficacy / performance assessment:</para>
            <para role="indent"><@efficacyList study.ResultsAndDiscussion.EfficacyPerformanceAssessment/></para>
        </#if>

        <#if study.ResultsAndDiscussion.MinimumEffectiveDose?has_content>
            <para>Minimum effective dose:</para>
            <para role="indent"><@efficacyList study.ResultsAndDiscussion.MinimumEffectiveDose/></para>
        </#if>

        <#if study.ResultsAndDiscussion.ResultsOnDetails?has_content>
            <para>Details on results: </para>
            <para role="indent"><@com.value study.ResultsAndDiscussion.ResultsOnDetails/></para>
        </#if>

        <#if study.ResultsAndDiscussion.ObservedLimitationsOnEfficacy?has_content>
            <#local lim=study.ResultsAndDiscussion.ObservedLimitationsOnEfficacy/>

            <#if lim.IndicationOfResistance?has_content || lim.DetailsOnDevelopmentOfResistance?has_content>
                <para>Details on results: <@com.value lim.IndicationOfResistance/></para>
                <#if lim.DetailsOnDevelopmentOfResistance?has_content><para role="indent"><@com.value lim.DetailsOnDevelopmentOfResistance/></para></#if>
            </#if>

            <#if lim.UndesirableOrUnintendedSideEffects?has_content || lim.DetailsOnUndesirableOrUnintendedSideEffects?has_content>
                <para>Undesirable or unintended side effects: <@com.value lim.UndesirableOrUnintendedSideEffects/></para>
                <#if lim.DetailsOnUndesirableOrUnintendedSideEffects?has_content><para role="indent"><@com.value lim.DetailsOnUndesirableOrUnintendedSideEffects/></para></#if>
            </#if>

            <#if lim.OtherLimitationsObserved?has_content>
                <para>Other limitations observed:</para>
                <para role="indent"><@com.value lim.OtherLimitationsObserved/></para>
            </#if>

            <#if lim.CompatibilityInPlantProtectionProgrammes?has_content>
                <para>Compatibility with plant protection programmes:</para>
                <para role="indent"><@com.value lim.CompatibilityInPlantProtectionProgrammes/></para>
            </#if>
            
            <#if lim.RelevanceOfStudyResults?has_content>
                <para>Relevance of study results:</para>
                <para role="indent"><@com.value lim.RelevanceOfStudyResults/></para>
            </#if>
        </#if>
    </#compress>
</#macro>

<#--Results lists-->
<#macro efficacyList block>
    <#compress>
        <#if block?has_content>
            <#list block as blockItem>
                <para role="indent">
                    <#if blockItem.hasElement("EfficacyParameter") && blockItem.EfficacyParameter?has_content>
                        <@com.value blockItem.EfficacyParameter/>:
                    </#if>

                    <#if blockItem.hasElement("Efficacy") && blockItem.Efficacy?has_content>
                        <@com.value blockItem.Efficacy/>
                    </#if>

                    <#if blockItem.hasElement("MinimumEffectiveDose") && blockItem.MinimumEffectiveDose?has_content>
                        <@com.value blockItem.MinimumEffectiveDose/>
                    </#if>

                    <#if blockItem.TimeToProduceEffect?has_content>
                        at <@com.value blockItem.TimeToProduceEffect/>
                    </#if>

                    <#if blockItem.Treatment?has_content>
                        . Treatment: <@com.value blockItem.Treatment/>
                    </#if>

                    <#if blockItem.InterferingSubstances?has_content>
                        . Interfering substances: <@com.value blockItem.InterferingSubstances/>
                    </#if>

                    <#if blockItem.RemarksOnResults?has_content>
                        (<@com.value blockItem.RemarksOnResults/>)
                    </#if>
                </para>
            </#list>
        </#if>
    </#compress>
</#macro>

<#macro testTargetOrganismsList block>
    <#compress>
        <#if block?has_content>
            <#list block as blockItem>
                <para role="indent">

                    <#local pestSci><@com.value blockItem.ScientificName/></#local>
                    <#local pestCom><@com.value blockItem.CommonName/></#local>

                    ${pestCom}
                    <#if pestCom?has_content && pestSci?has_content>[</#if>
                    ${pestSci}
                    <#if pestCom?has_content && pestSci?has_content>]</#if>

                    <#if blockItem.DevelopmentalStage?has_content>
                        (<@com.value blockItem.DevelopmentalStage/>)
                    </#if>

                    <#if blockItem.DevelopmentalStageOfTargetPlant?has_content>
                        - developmental stage of target plant: <@com.value blockItem.DevelopmentalStageOfTargetPlant/>)
                    </#if>

                </para>
            </#list>
        </#if>
    </#compress>
</#macro>

<#--Methods-->
<#macro efficacyMethod study>
    <#compress>

        <#--Pest target orgs controlled-->
        <#if study.MaterialsAndMethods.PestTargetOrganismsToBeControlled?has_content>
            <para><emphasis role='bold'>Pest target organisms to be controlled:</emphasis></para>

            <#if study.MaterialsAndMethods.PestTargetOrganismsToBeControlled.TestTargetOrganisms?has_content>
                <para role="indent"><@testTargetOrganismsList study.MaterialsAndMethods.PestTargetOrganismsToBeControlled.TestTargetOrganisms/></para>
            </#if>

            <#if study.MaterialsAndMethods.PestTargetOrganismsToBeControlled.DetailsOnTestTargetOrganisms?has_content>
                <para><@com.text study.MaterialsAndMethods.PestTargetOrganismsToBeControlled.DetailsOnTestTargetOrganisms/></para>
            </#if>

        </#if>

        <#--Orgs protected-->
        <#if study.MaterialsAndMethods.ProductsMaterialsOrganismsOrObjectsToBeProtectedUnderStudy?has_content>
            <para><emphasis role='bold'>Products (materials), organisms or objects to be protected / under study:</emphasis></para>
            <para><@com.text study.MaterialsAndMethods.ProductsMaterialsOrganismsOrObjectsToBeProtectedUnderStudy.OrganismsToBeProtectedOrTreatedMaterials/> </para>
        </#if>

        <#--Study design-->
        <#if study.MaterialsAndMethods.StudyDesign?has_content>
            <para><emphasis role='bold'>Study design:</emphasis></para>
            <@com.children study.MaterialsAndMethods.StudyDesign/>
        </#if>

    </#compress>
</#macro>

<#--Basic info-->
<#macro basicinfo study>
    <#compress>
        <#if study.Background.BackgroundInformation?has_content>
            <para>Background information:</para>
            <para role="indent"><@com.value study.Background.BackgroundInformation/></para>
        </#if>

        <#if study.Background.ObjectiveLabelClaimAddressed?has_content>
            <para>Objective / Label claim addressed:</para>
            <para role="indent"><@com.value study.Background.ObjectiveLabelClaimAddressed/></para>
        </#if>

         <#if study.Background.SourceOfInformationTypeOfStudy?has_content>
            <para>Source of information / type of study:</para>
            <para role="indent"><@com.value study.Background.SourceOfInformationTypeOfStudy/></para>
        </#if>

    </#compress>
</#macro>

<#--Summaries-->
<#macro efficacySummary _subject docSubType>
    <#compress>

    <#-- Get doc-->
    <#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />

    <#-- Iterate-->
    <#if summaryList?has_content>
        <@com.emptyLine/>
        
        <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

        <#-- Set flag to print indexes if there is more than 1 summary -->
        <#assign printSummaryIndex = summaryList?size gt 1 />

        <#list summaryList as summary>
            <@com.emptyLine/>

            <#-- get url -->
            <#local summaryUrl=iuclid.webUrl.documentView(summary.documentKey) />

            <para><emphasis role="bold"><#if printSummaryIndex>#${summary_index+1}: </#if><ulink url="${summaryUrl}"><@com.text summary.name/></ulink></emphasis></para>

            <#--Key Information-->
            <#if summary.KeyInformation.KeyInformation?has_content>
                <para><emphasis role="bold">Key information: </emphasis></para>
                <para style="background-color:#f7f7f7" ><@com.value summary.KeyInformation.KeyInformation/></para>
            </#if>

            <#--Discussion-->
            <#if summary.Discussion.Discussion?has_content>
                <para><emphasis role="bold">Discussion:</emphasis></para>
                <para  style="background-color:#f7f7f7" ><@com.value summary.Discussion.Discussion/></para>
            </#if>
        </#list>
    </#if>
    </#compress>
</#macro>