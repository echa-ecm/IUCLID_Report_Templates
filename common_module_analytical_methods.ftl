<#--Results-->
<#macro results_analyticalMethods study>
    <#compress>
        <#local res=study.ResultsAndDiscussion/>

        <#if res.RecoveryResultsAndCharacteristicsOfAnalyticalMethod?has_content>
            <para>Results using analytical method:</para>
            <para role="indent"><@com.text res.RecoveryResultsAndCharacteristicsOfAnalyticalMethod.RecoveryResults/></para>

            <#if res.RecoveryResultsAndCharacteristicsOfAnalyticalMethod.CharacteristicsOfAnalyticalMethod?has_content>
                <para role="indent">Characteristics of analytical method:
                        <@com.text res.RecoveryResultsAndCharacteristicsOfAnalyticalMethod.CharacteristicsOfAnalyticalMethod/>
                </para>
            </#if>
        </#if>


        <#if res.ResultsUsingEnforcementMethod?has_content>
            <para>Results using enforcement method:</para>
            <para role="indent"><@com.text res.ResultsUsingEnforcementMethod.RecoveryResults/></para>

            <#if res.ResultsUsingEnforcementMethod.CharacteristicsOfEnforcementMethod?has_content>
                <para role="indent">Characteristics of enforcement method:
                    <@com.text res.ResultsUsingEnforcementMethod.CharacteristicsOfEnforcementMethod/>
                </para>
            </#if>
        </#if>

        <#if res.IndependentLaboratoryValidation.IndependentLaboratoryValidation?has_content>
            <para>Independent laboratory validation:</para>
            <para role="indent"><@com.text res.IndependentLaboratoryValidation.IndependentLaboratoryValidation/></para>
        </#if>

    </#compress>
</#macro>

<#--Methods-->
<#macro analyticalMethodsMethod study>
    <#compress>

        <#--General-->
        <#if study.MaterialsAndMethods.OtherQualityAssurance?has_content>
            <para><emphasis role='bold'>Matrix / medium:</emphasis></para>
            <para><@com.picklistMultiple study.MaterialsAndMethods.OtherQualityAssurance/></para>
        </#if>

        <#--Analytical methods-->
        <#if study.MaterialsAndMethods.PrinciplesOfAnalyticalMethods?has_content>
            <para><emphasis role='bold'>Principles of analytical methods:</emphasis></para>
            <#local panmeth=study.MaterialsAndMethods.PrinciplesOfAnalyticalMethods/>
            <#if panmeth.InstrumentDetector?has_content>
                <para>Instrument / detector:</para>
                <para role="indent"><@com.picklistMultiple panmeth.InstrumentDetector/></para>
            </#if>
            <#if panmeth.DetailsOnAnalyticalMethod?has_content>
                <para>Details:</para>
                <para role="indent"><@com.text panmeth.DetailsOnAnalyticalMethod/></para>
            </#if>
        </#if>

        <#--Enforcement methods-->
        <#if study.MaterialsAndMethods.EnforcementMethodIfApplicable?has_content>
            <para><emphasis role='bold'>Enforcement method:</emphasis></para>
            <#local enmeth=study.MaterialsAndMethods.EnforcementMethodIfApplicable/>
            <#if enmeth.InstrumentDetectorForEnforcementMethod?has_content>
                <para>Instrument / detector:</para>
                <para role="indent"><@com.picklistMultiple enmeth.InstrumentDetectorForEnforcementMethod/></para>
            </#if>
            <#if enmeth.DetailsOnEnforcementMethod?has_content>
                <para>Details:</para>
                <para role="indent"><@com.text enmeth.DetailsOnEnforcementMethod/></para>
            </#if>
        </#if>

        <#--Confirmatory methods-->
        <#if study.MaterialsAndMethods.ConfirmatoryMethodIfApplicable?has_content>
            <para><emphasis role='bold'>Confirmatory method:</emphasis></para>
            <#local conmeth=study.MaterialsAndMethods.ConfirmatoryMethodIfApplicable/>
            <#if conmeth.InstrumentDetectorForConfirmatoryMethod?has_content>
                <para>Instrument / detector:</para>
                <para role="indent"><@com.picklistMultiple conmeth.InstrumentDetectorForConfirmatoryMethod/></para>
            </#if>
            <#if conmeth.DetailsOnConfirmatoryMethod?has_content>
                <para>Details:</para>
                <para role="indent"><@com.text conmeth.DetailsOnConfirmatoryMethod/></para>
            </#if>
        </#if>
    </#compress>
</#macro>

<#--Summary-->
<#macro analyticalMethodsSummary _subject>
    <#compress>

        <#-- Get doc-->
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AnalyticalMethods") />

        <#-- Iterate-->
        <#if summaryList?has_content>
            <@com.emptyLine/>
            <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

            <#assign printSummaryName = summaryList?size gt 1 />

            <#list summaryList as summary>
                <@com.emptyLine/>

                <#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

                <#--Key Information-->
                <#if summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>
                    <para><@com.richText summary.KeyInformation.KeyInformation/></para>
                </#if>

                <#--Links-->
                <#if summary.LinkToRelevantStudyRecord.Link?has_content>
                    <para><emphasis role="bold">Link to relevant study records: </emphasis></para>
                    <para role="indent">
                        <#list summary.LinkToRelevantStudyRecord.Link as link>
                            <#if link?has_content>
                                <#local studyReference = iuclid.getDocumentForKey(link) />
                                <para><command  linkend="${studyReference.documentKey.uuid!}">
                                        <@com.text studyReference.name/>
                                    </command>
                                </para>
                            </#if>
                        </#list>
                    </para>
                </#if>

                <#--Discussion-->
                <#if summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>
                    <para><@com.richText summary.Discussion.Discussion/></para>
                </#if>

            </#list>
        </#if>
    </#compress>
</#macro>