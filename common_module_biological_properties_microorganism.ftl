<#--MACRO to get specific sections from BioPropertiesMicro document-->
<#macro BioPropMicroSection path>

    <#compress>

        <#local docs=iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "BioPropertiesMicro")/>

        <#local path="doc."+path/>
        <#list docs as doc>
            <para>
                <#if (docs?size>1) ><emphasis role="underline">#${doc_index+1}: ${doc.name}</emphasis><?linebreak?></#if>

                <#if path?eval?node_type=="multilingual_text_html">
                    <@com.richText path?eval/>
                <#else>
                    <@com.text path?eval/>
                </#if>

            </para>
        </#list>
    </#compress>
</#macro>

<#--BLOCKS-->
<#macro targetOrganismsList targetOrganismsRepeatableBlock>
    <#compress>
        <#if targetOrganismsRepeatableBlock?has_content>
            <#list  targetOrganismsRepeatableBlock as blockItem>
                <#if blockItem.ScientificName?has_content || blockItem.CommonName?has_content || blockItem.DevelopmentalStage?has_content || blockItem.DevelopmentalStageOfTargetPlant?has_content>
                    <para role="indent">
                        <#if blockItem.ScientificName?has_content>
                            <@com.picklist blockItem.ScientificName/>
                            <#if blockItem.CommonName?has_content>
                                (<@com.picklist blockItem.CommonName/>)
                            </#if>
                            .
                        <#elseif blockItem.CommonName?has_content>
                            <@com.picklist blockItem.CommonName/>.
                        </#if>

                        <#if blockItem.DevelopmentalStage?has_content>
                            <?linebreak?>Developmental stage of target pest: <@com.picklist blockItem.DevelopmentalStage/>.
                        </#if>

                        <#if blockItem.DevelopmentalStageOfTargetPlant?has_content>
                            <?linebreak?>Developmental stage of target plant: <@com.picklistMultiple blockItem.DevelopmentalStageOfTargetPlant/>.
                        </#if>
                    </para>
                </#if>
            </#list>
        </#if>
    </#compress>
</#macro>


<#macro effectList effectConcRepeatableBlock study>
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

<#--GENERAL INFO SECTION-->
<#macro generalInfo_effectivenessTargetOrg study>

    <#local gen=study.GeneralInformation/>

    <#if gen.BackgroundInformation?has_content>
        <para><emphasis role="bold">Background information:</emphasis></para>
        <para role="indent"><@com.text gen.BackgroundInformation/></para>
    </#if>

    <#if gen.PestTargetOrganismsToBeControlled.TargetOrganisms?has_content>
        <para><emphasis role="bold">Pest / target organisms to be controlled:</emphasis></para>
        <para role="indent">
            <@targetOrganismsList gen.PestTargetOrganismsToBeControlled.TargetOrganisms/>
        </para>
    </#if>

    <#if gen.ProductsOrganismsOrObjectsToBeProtectedUnderStudy.OrganismsToBeProtectedOrTreatedMaterials?has_content>
        <para><emphasis role="bold">Organisms (to be protected) or treated materials:</emphasis></para>
        <para role="indent"><@com.text gen.ProductsOrganismsOrObjectsToBeProtectedUnderStudy.OrganismsToBeProtectedOrTreatedMaterials/></para>
    </#if>

    <#if gen.InformationOnIntendedUseAndApplication?has_content>
        <#local use=gen.InformationOnIntendedUseAndApplication/>
        <para><emphasis role="bold">Information on intended use and applications:</emphasis></para>
        <#if use.FunctionAddressed?has_content>
            <para>Function addressed: <@com.picklistMultiple use.FunctionAddressed/></para>
        </#if>
        <#if use.ProductType?has_content>
            <para>Product type: <@com.picklist use.ProductType/></para>
        </#if>
        <#if use.ProductType?has_content>
            <para>Field of use envisaged / user: <@com.text use.FieldOfUseEnvisagedUser/></para>
        </#if>
    </#if>

    <#if gen.InformationOnApplicationOfBiocidalProduct?has_content>
        <para><emphasis role="bold">Information on application of biocidal product:</emphasis></para>
        <#if gen.InformationOnApplicationOfBiocidalProduct.MethodOfApplication?has_content>
            <para>Method of application: <@com.picklistMultiple gen.InformationOnApplicationOfBiocidalProduct.MethodOfApplication/>
                <#if gen.InformationOnApplicationOfBiocidalProduct.DetailsOnApplication?has_content>
                    <span role="indent"><@com.text gen.InformationOnApplicationOfBiocidalProduct.DetailsOnApplication/></span>
                </#if>
            </para>
        </#if>
    </#if>

    <#if gen.GeneralInformationOnEffectiveness?has_content>
        <para><emphasis role="bold">General information on effectiveness:</emphasis></para>
        <#local eff=gen.GeneralInformationOnEffectiveness/>

        <#if eff.EffectsOnTargetOrganisms?has_content>
            <para>Effects on target organisms:</para>
            <para role="indent"><@com.text eff.EffectsOnTargetOrganisms/></para>
        </#if>

        <#if eff.ModeAction?has_content>
            <para>Mode of action:</para>
            <para role="indent"><@com.picklist eff.ModeAction/>
                <#if eff.DetailsOnModeOfAction?has_content>: <@com.text eff.DetailsOnModeOfAction/></#if></para>
        </#if>

        <#if eff.PossibleOccurrenceOfResistance?has_content>
            <para>Ocurrence of resistance:</para>
            <para role="indent"><@com.text eff.PossibleOccurrenceOfResistance/></para>
        </#if>

        <#if eff.ManagementStrategiesToAvoidResistance?has_content>
            <para>Management strategies to avoid resistance:</para>
            <para role="indent"><@com.text eff.ManagementStrategiesToAvoidResistance/></para>
        </#if>
        <#if eff.AnyOtherKnownLimitationsAndManagementStrategies?has_content>
            <para>Other known limitations and management strategies:</para>
            <para role="indent"><@com.text eff.AnyOtherKnownLimitationsAndManagementStrategies/></para>
        </#if>
    </#if>

</#macro>

<#--METHODS-->
<#macro methods_toxicityAboveGroundOrg study>
    <#local met=study.MaterialsAndMethods/>

    <#local sa=met.SamplingAndAnalysis/>
    <#if sa?has_content>
        <para>
        <emphasis role="bold">Sampling and analysis:</emphasis><?linebreak?>
            <#if sa.AnalyticalMonitoring?has_content>
                <para role="indent">Analytical monitoring: <@com.picklist sa.AnalyticalMonitoring/></para>
            </#if>
            <#if sa.DetailsOnSampling?has_content>
                <para role="indent">Sampling: <@com.text sa.DetailsOnSampling/></para>
            </#if>
            <#if sa.DetailsOnAnalyticalMethods?has_content>
                <para role="indent">Analytical methods: <@com.text sa.DetailsOnAnalyticalMethods/></para>
            </#if>
        </para>
    </#if>

    <#local ts=met.TestSubstrate/>
    <#if ts?has_content>
        <para>
            <emphasis role="bold">Test substrate:</emphasis><?linebreak?>
            <#if ts.Vehicle?has_content>
                <para role="indent">Vehicle: <@com.picklist ts.Vehicle/></para>
            </#if>
            <#if ts.DetailsOnPreparationAndApplicationOfTestSubstrate?has_content>
                <para role="indent">Preparation and application of test substrate: <@com.text ts.DetailsOnPreparationAndApplicationOfTestSubstrate/></para>
            </#if>
        </para>
    </#if>

    <#local to=met.TestOrganisms/>
    <#if to?has_content>
        <para>
            <emphasis role="bold">Test organisms:</emphasis><?linebreak?>
            <#if to.TestOrganismsSpecies?has_content>
                <para role="indent">Species: <@com.picklist to.TestOrganismsSpecies/></para>
            </#if>
            <#if to.DetailsOnTestOrganisms?has_content>
                <para role="indent"><@com.text to.DetailsOnTestOrganisms/></para>
            </#if>
        </para>
    </#if>

    <#local sd=met.StudyDesign/>
    <#if sd?has_content>
        <para>
            <emphasis role="bold">Study design:</emphasis><?linebreak?>
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
                <para role="indent">Remarks:<@com.text sd.Remarks/></para>
            </#if>
            <#if sd.PostExposureObservationPeriod?has_content>
                <para role="indent">Post exposure observation period:<@com.text sd.PostExposureObservationPeriod/></para>
            </#if>
        </para>
    </#if>

    <#local tc=met.TestConditions/>
    <#if tc?has_content>
        <para>
            <emphasis role="bold">Test conditions:</emphasis><?linebreak?>

            <#if tc.TestTemperature?has_content>
                <para role="indent">Temperature:<@com.text tc.TestTemperature/></para>
            </#if>
            <#if tc.Humidity?has_content>
                <para role="indent">Humidity:<@com.text tc.Humidity/></para>
            </#if>
            <#if tc.PhotoperiodAndLighting?has_content>
                <para role="indent">Photoperiod and lighting:<@com.text tc.PhotoperiodAndLighting/></para>
            </#if>
            <#if tc.NominalAndMeasuredConcentrations?has_content>
                <para role="indent">Nominal and measured concentrations:<@com.text tc.NominalAndMeasuredConcentrations/></para>
            </#if>
            <#if tc.ReferenceSubstancePositiveControl?has_content>
                <para role="indent">Reference substance (positive control):<@com.picklist tc.ReferenceSubstancePositiveControl/></para>
            </#if>
            <#if tc.DetailsOnTestConditions?has_content>
                <para role="indent">Other:<@com.text tc.DetailsOnTestConditions/></para>
            </#if>
        </para>
    </#if>

</#macro>


<#--SUMMARIES-->
<#macro effectivenessTargetOrgSummary subject includeMetabolites=true >
    <#compress>

        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY",  "EffectivenessAgainstTargetOrganisms") />

        <#if includeMetabolites && _metabolites??>

            <#-- get a list of entities of same size as summaryList-->
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

        <#if summaryList?has_content>
            <@com.emptyLine/>
            <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>
        </#if>

        <#if summaryList?has_content>
            <#assign printSummaryName = summaryList?size gt 1 />
            <#list summaryList as summary>
                <@com.emptyLine/>
                <#if includeMetabolites && _metabolites??
                    && subject.documentType=="SUBSTANCE"
                    && subject.ChemicalName!=entityList[summary_index]
                    && entityList?seq_index_of(entityList[summary_index]) == summary_index>
                    <para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
                    <@com.emptyLine/>
                </#if>
                <@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
            </#list>
        </#if>

    </#compress>
</#macro>

<#macro toxicityToOtherAboveGroundOrganismsSummary subject includeMetabolites=true>
    <#compress>

        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", "ToxicityToOtherAboveGroundOrganisms") />
        <#if includeMetabolites && _metabolites??>

            <#-- get a list of entities of same size as summaryList-->
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

        <#if summaryList?has_content>
            <@com.emptyLine/>
            <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

            <#assign printSummaryName = summaryList?size gt 1 />

            <#list summaryList as summary>
                <@com.emptyLine/>
                <#if includeMetabolites && _metabolites??
                    && subject.documentType=="SUBSTANCE"
                    && subject.ChemicalName!=entityList[summary_index]
                    && entityList?seq_index_of(entityList[summary_index]) == summary_index>
                    <para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
                    <@com.emptyLine/>
                </#if>

                <#if printSummaryName><para><emphasis role="bold"><@com.text summary.name/></emphasis></para></#if>

                <#if summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>
                    <para role="indent"><@com.richText summary.KeyInformation.KeyInformation/></para>
                </#if>

                <#if summary.LinkToRelevantStudyRecord.Link?has_content>
                    <para ><emphasis role="bold">Linked studies: </emphasis></para>
                    <para role="indent">
                        <#list summary.LinkToRelevantStudyRecord.Link as studyReferenceLinkedToSummary>
                            <#local studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
                            <command  linkend="${studyReference.documentKey.uuid!}">
                                <@com.text studyReference.name/>
                            </command>

                            <#if studyReferenceLinkedToSummary_has_next> | </#if>
                        </#list>
                    </para>
                </#if>

                <#if summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForMammals?has_content ||
                    summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForMammals?has_content>
                    <para><emphasis role="bold">Value for CSA: </emphasis></para>
                    <para role="indent">Short-term EC50 or LC50 for mammals: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.ShortTermEc50OrLc50ForMammals/></para>
                    <para role="indent">Long-term EC10/LC10 or NOEC for mammals: <@com.quantity summary.KeyValueForChemicalSafetyAssessment.LongTermEc10Lc10OrNoecForMammals/></para>
                </#if>

                <#if summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>
                    <para role="indent"><@com.richText summary.Discussion.Discussion/></para>
                </#if>

            <#--                could use but links do not have hyperlink-->
            <#--                <@studyandsummaryCom.endpointSummary summary valueForCsaTextToxicityToOtherAboveGroundOrganisms printSummaryName/>-->
            </#list>
        </#if>

    </#compress>
</#macro>
