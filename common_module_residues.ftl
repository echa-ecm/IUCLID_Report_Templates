<#--Methods-->
<#macro residuesMethod study>
    <#compress>
        <#--General-->
        <@com.children path=study.MaterialsAndMethods exclude=["Guideline", "MethodNoGuideline", "GLPComplianceStatement"]
                            titleEmphasis=true/>

        <#if study.documentSubType=="MetabolismInCrops" || study.documentSubType=="MetabolismInLivestock">
            <@com.emptyLine/>
			<para role="indent">[Add here the methods sections obtained with the render tool of MSS Composer]</para>

		<#else>

            <#--Test animals-->
            <#if study.MaterialsAndMethods.hasElement("TestAnimals") && study.MaterialsAndMethods.TestAnimals?has_content>
                <para><emphasis role='bold'>Test animals:</emphasis></para>
                <@com.children study.MaterialsAndMethods.TestAnimals/>
            </#if>

            <#--Admn/exposure-->
            <#if study.MaterialsAndMethods.hasElement("AdministrationExposure") && study.MaterialsAndMethods.AdministrationExposure?has_content>
                <para><emphasis role='bold'>Administration / exposure:</emphasis></para>
                <@com.children study.MaterialsAndMethods.AdministrationExposure/>
            </#if>

            <#--Study Design-->
            <#if study.MaterialsAndMethods.hasElement("StudyDesign") && study.MaterialsAndMethods.StudyDesign?has_content>
                <para><emphasis role='bold'>Study design:</emphasis></para>
                <@com.children study.MaterialsAndMethods.StudyDesign/>
            <#elseif study.MaterialsAndMethods.hasElement("FurtherDetailsOnStudyDesign") && study.MaterialsAndMethods.FurtherDetailsOnStudyDesign?has_content>
                <para><emphasis role='bold'>Study design:</emphasis></para>
                <@com.children study.MaterialsAndMethods.FurtherDetailsOnStudyDesign/>
            </#if>

            <#--Sampling and analytical methodology-->
            <#if study.MaterialsAndMethods.hasElement("SamplingAndAnalyticalMethodology") && study.MaterialsAndMethods.SamplingAndAnalyticalMethodology?has_content>
                <para><emphasis role='bold'>Sampling and analytical methodology:</emphasis></para>
                <@com.children study.MaterialsAndMethods.SamplingAndAnalyticalMethodology/>
            </#if>

            <#if study.documentSubType=="ResiduesInRotationalCrops">
                <#if study.MaterialsAndMethods.AnalyticalMethods.AnalyticalMethod?has_content>
                    <para><emphasis role='bold'>Analytical methods:</emphasis></para>
                    <para role="small"><@residuesInRotationalCropsAnalyticalMethodsTable study.MaterialsAndMethods.AnalyticalMethods.AnalyticalMethod/></para>
                </#if>
                <#if study.MaterialsAndMethods.StudyUsePattern?has_content>
                    <para><emphasis role='bold'>Analytical methods:</emphasis></para>
                    <para>[Please, provide this information as attachment (Excel file)]</para>
                </#if>
            </#if>
        </#if>
    </#compress>
</#macro>

<#--Results-->
<#macro results_stabilityOfResiduesInStoredCommod study>
    <#compress>

        <#if study.ResultsAndDiscussion.ResidueLevels?has_content>
            <para>Residue levels:</para>
            <para role="small"><@storageResidueLevelsTable study.ResultsAndDiscussion.ResidueLevels/></para>
        </#if>

        <#if study.ResultsAndDiscussion.StorageStability?has_content>
            <para>Storage stability of residues (sample integrity):</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.StorageStability/></para>
        </#if>

    </#compress>
</#macro>

<#macro results_residuesInLivestock study>
    <#compress>

        <#if study.ResultsAndDiscussion.ResidueData?has_content>
            <para>Residue data</para>
            <para role="small"><@feedingStudiesResidueDataTable study.ResultsAndDiscussion.ResidueData/></para>
        </#if>

        <@com.children path=study.ResultsAndDiscussion exclude=['ResidueData'] />

    </#compress>
</#macro>

<#macro results_natureResiduesInProcessedCommod study>
    <#compress>

        <#if study.ResultsAndDiscussion.TotalRadioactiveResiduesTRR?has_content>
            <para>Total radioactive residues (TRR):</para>
            <para role="small"><@totalRadioactiveResiduesTable study.ResultsAndDiscussion.TotalRadioactiveResiduesTRR/></para>
        </#if>

        <#if study.ResultsAndDiscussion.StorageStability?has_content>
            <para>Storage stability (sample integrity):</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.StorageStability/></para>
        </#if>

        <#if study.ResultsAndDiscussion.OtherDetailsOnTRRs?has_content>
            <para>Other details on TRRs:</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.OtherDetailsOnTRRs/></para>
        </#if>

<#--        NOTE: this is covered automatically-->
<#--        <#if study.ResultsAndDiscussion.MetabolicPathway?has_content>-->
<#--            <para>Metabolic pathway:</para>-->
<#--            <para role="indent"><@com.richText study.ResultsAndDiscussion.MetabolicPathway/></para>-->
<#--        </#if>-->

    </#compress>
</#macro>

<#macro results_residuesInRotationalCrops study>
    <#compress>

        <#if study.ResultsAndDiscussion.StorageStability?has_content>
            <para>Storage stability of residues (sample integrity):</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.StorageStability/></para>
        </#if>

        <#if study.ResultsAndDiscussion.SummaryOfRadioactiveResiduesInCrops.SamplingAndResidues?has_content>
            <para>Summary of residues:</para>
            <para role="small"><@samplingAndResiduesTable study.ResultsAndDiscussion.SummaryOfRadioactiveResiduesInCrops.SamplingAndResidues/></para>
            <#--        <#else>-->
            <para role="indent">[Copy/paste here the result tables reported in the Excel files eventually attached in the study record]</para>
        </#if>

    </#compress>
</#macro>

<#macro results_magnitudeResidInProcessedComm study>
    <#compress>

        <#if study.ResultsAndDiscussion.StorageStabilityOfResiduesSampleIntegrity?has_content>
            <para>Storage stability of residues (sample integrity):</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.StorageStabilityOfResiduesSampleIntegrity/></para>
        </#if>

        <#if study.ResultsAndDiscussion.ResiduesInRACPriorToProcessing.BulkRACSubSampleSampleNo?has_content>
            <para>Bulk RAC sub-sample sample no.:</para>
            <para role="small"><@residuesInRacPriorProcessingTable study.ResultsAndDiscussion.ResiduesInRACPriorToProcessing.BulkRACSubSampleSampleNo/></para>
            <#--        <#else>-->
            <para role="indent">[Copy/paste here the result tables reported in the Excel files eventually attached in the study record]</para>
        </#if>

        <#if study.ResultsAndDiscussion.ResiduesInProcessedFractionsPFAndAspiratedGrainFractionsAGF?has_content>
            <#local pfagf=study.ResultsAndDiscussion.ResiduesInProcessedFractionsPFAndAspiratedGrainFractionsAGF/>

            <para>Residues in processed fractions (PF) and aspirated grain fractions (AGF):</para>

            <#if pfagf.ProcessingInformation?has_content>
                <para role="indent">Processing information:</para>
                <para role="indent2"><@com.text pfagf.ProcessingInformation/></para>
            </#if>

            <#if pfagf.ProcessedFraction?has_content>
                <para role="indent">Processed fraction (PF) sample:</para>
                <para role="small"><@residuesInProcessedFractionTable pfagf.ProcessedFraction/></para>
            </#if>

            <#if pfagf.AspiratedGrainFractionsAGFSample?has_content>
                <para role="indent">Aspirated grain fractions (AGF sample):</para>
                <para role="small"><@residuesInAspiratedGrainFractionTable pfagf.AspiratedGrainFractionsAGFSample/></para>
            </#if>

            <#if pfagf.DistributionOfResidues?has_content>
                <para role="indent">Distribution of residues:</para>
                <para role="indent2"><@com.text pfagf.DistributionOfResidues/></para>
            </#if>
        </#if>

    </#compress>
</#macro>

<#macro results_migrationOfResidues study>
    <#compress>

        <#if study.ResultsAndDiscussion.MigrationIntoFoodOrFeedingstuffs?has_content>
            <para>Migration into food or feedingstuffs:</para>
            <para role="indent"><@migrationFoodFeedingstuffsList study.ResultsAndDiscussion.MigrationIntoFoodOrFeedingstuffs/></para>
        </#if>

        <#if study.ResultsAndDiscussion.TransformationProducts?has_content>
            <para>Transformation products:</para>
            <para role="indent"><@com.picklist study.ResultsAndDiscussion.TransformationProducts/></para>
        </#if>

        <#if study.ResultsAndDiscussion.IdentityTransformation?has_content>
            <para>Identity of transformation products:</para>
            <para role="indent"><@idTransformationProductsList study.ResultsAndDiscussion.IdentityTransformation/></para>
        </#if>

        <#if study.ResultsAndDiscussion.IndicationOfOrganolepticChanges?has_content>
            <para>Indication of organoleptic changes:</para>
            <para role="indent"><@com.picklist study.ResultsAndDiscussion.IndicationOfOrganolepticChanges/></para>
        </#if>

        <#if study.ResultsAndDiscussion.DetailsOnResults?has_content>
            <para>Details on results:</para>
            <para role="indent"><@com.text study.ResultsAndDiscussion.DetailsOnResults/></para>
        </#if>

    </#compress>
</#macro>

<#--Results lists-->
<#macro migrationFoodFeedingstuffsList block>
    <#compress>
        <#if block?has_content>
            <#list block as blockItem>
                <para role="indent">
                    <#if blockItem.TestNo?has_content>
                        <@com.picklist blockItem.TestNo/>.
                    </#if>

                    <#if blockItem.TestConditions?has_content>
                        Test conditions: <@com.text blockItem.TestConditions/>.
                    </#if>

                    <#if blockItem.Observation?has_content>
                        Observation: <@com.picklist blockItem.Observation/>.
                    </#if>
                </para>
            </#list>
        </#if>
    </#compress>
</#macro>

<#macro idTransformationProductsList block>
    <#compress>
        <#if block?has_content>
            <#list block as blockItem>
                <para role="indent">
                    <#if blockItem.No?has_content>
                        <@com.picklist blockItem.No/>:
                    </#if>

                    <#if blockItem.ReferenceSubstance?has_content>
                        <#local reference=iuclid.getDocumentForKey(blockItem.ReferenceSubstance)/>
                        <@com.text reference.ReferenceSubstanceName/>
                    </#if>

                </para>
            </#list>
        </#if>
    </#compress>
</#macro>

<#--    Results tables-->
<#macro storageResidueLevelsTable path>
    <#compress>

    <#--            Missing: -->
    <#--                method id for analyte MethodID (text)-->
    <#--                date of sample for commodity : DateOfSample (date)-->
    <#--                analysis sample ID and description: AnalysisSampleID (text) AnalysisSampleDescription (text)-->

        <table border="1">

            <col width="20%" />
            <col width="20%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%"/>


            <thead align="center" valign="middle">
                <tr>
                    <th><emphasis role="bold">Commodity</emphasis></th>
                    <th><emphasis role="bold">Analyte</emphasis></th>
                    <th><emphasis role="bold">Date of extraction / analysis</emphasis></th>
                    <th><emphasis role="bold">Residue level [mean]</emphasis></th>
                    <th><emphasis role="bold">Residue level (% of nominal spiking level) [mean]</emphasis></th>
                    <th><emphasis role="bold">Procedural recovery control (%) [mean]</emphasis></th>
                </tr>
            </thead>

            <tbody valign="middle">
            <#list path as residue>
                <#assign usespan = true />
                <tr>
                <td rowspan="${residue.AnalyteMeasured?size}">
                    <@com.picklist residue.TestCommodity/>
                    <#if residue.OtherDetailsOnTestCommodity?has_content>
                        (<@com.text residue.OtherDetailsOnTestCommodity/>)
                    </#if>
                    <#assign usespan=false/>
                </td>

                <#if residue.AnalyteMeasured?has_content>
                    <#list residue.AnalyteMeasured as analyte>

                        <#if analyte_index!=0><tr></#if>

                            <td>
                                <#if analyte.AnalyteIdentity?has_content>
                                    <#local reference=iuclid.getDocumentForKey(analyte.AnalyteIdentity)/>
                                    <@com.text reference.ReferenceSubstanceName/>
                                </#if>
                            </td>

                            <td>
                                <@com.text analyte.ExtractionDate/> / <@com.text analyte.AnalysisDate/>
                            </td>

                            <td>
                                <@com.range analyte.ResidueLevel/>
                                <#if analyte.MeanResidueLevel?has_content>
                                    [<@com.range analyte.MeanResidueLevel/>]
                                </#if>
                            </td>

                            <td>
                                <@com.range analyte.ResidueLevelOfNominalSpikingLevel/>
                                <#if analyte.MeanResidueLevelOfNominalSpikingLevel?has_content>
                                    [<@com.number analyte.MeanResidueLevelOfNominalSpikingLevel/>]
                                </#if>
                            </td>

                            <td>
                                <@com.range analyte.ProceduralRecoveryControl/>
                                <#if analyte.MeanProceduralRecoveryControl?has_content>
                                    [<@com.number analyte.MeanProceduralRecoveryControl/>]
                                </#if>
                            </td>
                        </tr>
                    </#list>
                <#else>
                    <td></td><td></td><td></td><td></td><td></td>
                    </tr>
                </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro feedingStudiesResidueDataTable path>
    <#compress>

        <table border="1">

            <col width="20%" />
            <col width="15%" />
            <col width="15%" />
            <col width="20%" />
            <col width="15%" />
            <col width="15%"/>


            <thead align="center" valign="middle">
            <tr>
                <th><emphasis role="bold">Matrix</emphasis></th>
                <th><emphasis role="bold">Feeding level</emphasis></th>
                <th><emphasis role="bold">Sampling time</emphasis></th>
                <th><emphasis role="bold">Analyte</emphasis></th>
                <th><emphasis role="bold">Residue level</emphasis></th>
                <th><emphasis role="bold">Total / mean</emphasis></th>
            </tr>
            </thead>

            <tbody valign="middle">
            <#list path as residue>

                <#assign usespan = true />

                <tr>
                    <td rowspan="${residue.ResidueLevels?size}">
                        <@com.picklist residue.MatrixTissueSampled/>
                    </td>
                    <td rowspan="${residue.ResidueLevels?size}">
                        <@com.text residue.DoseFeedingLevel/>
                    </td>
                    <td rowspan="${residue.ResidueLevels?size}">
                        <@com.text residue.SamplingTime/>
                    </td>

                    <#if residue.ResidueLevels?has_content>
                        <#list residue.ResidueLevels as analyte>

                            <#if analyte_index!=0><tr></#if>

                            <td>
                                <#if analyte.AnalyteIdentity?has_content>
                                    <#local reference=iuclid.getDocumentForKey(analyte.AnalyteIdentity)/>
                                    <@com.text reference.ReferenceSubstanceName/>
                                </#if>
                            </td>

                            <td>
                                <#if analyte.ResidueLevelMeasured?has_content>
                                    <@com.range analyte.ResidueLevelMeasured/> (measured)<?linebreak?>
                                </#if>
                                <#if analyte.ResidueLevelCalculated?has_content>
                                    <@com.range analyte.ResidueLevelCalculated/> (calculated)<?linebreak?>
                                </#if>
                                <#if analyte.ResidueLevelCorrected?has_content>
                                    <@com.range analyte.ResidueLevelCorrected/> (calculated and corrected)
                                </#if>
                            </td>

                            <#if usespan>
                                <td rowspan="${residue.ResidueLevels?size}">
                                    <@com.quantity residue.TotalMean/>
                                </td>
                                <#assign usespan=false>
                            </#if>

                            </tr>
                        </#list>
                    <#else>
                        <td></td>
                        <td></td>
                        <td rowspan="${residue.ResidueLevels?size}">
                            <@com.quantity residue.TotalMean/>
                        </td>
                        </tr>
                    </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro totalRadioactiveResiduesTable path>
    <#compress>


        <table border="1">

            <col width="35%" />
            <col width="35%" />
            <col width="15%" />
            <col width="15%" />


            <thead align="center" valign="middle">
                <tr>
                    <th><emphasis role="bold">Test conditions</emphasis></th>
                    <th><emphasis role="bold">TRR component</emphasis></th>
                    <th><emphasis role="bold">TRR concentration</emphasis></th>
                    <th><emphasis role="bold">TRR percentage</emphasis></th>
                </tr>
            </thead>

            <tbody valign="middle">

            <#list path as residue>

                <tr>

                    <td>
                        <#if residue.TestConditions?has_content>
                            <@com.text residue.TestConditions/>
                        </#if>
                    </td>

                    <td>
                        <#if residue.IdentityOfTRRComponent?has_content>
                            <#local reference=iuclid.getDocumentForKey(residue.IdentityOfTRRComponent)/>
                            <@com.text reference.ReferenceSubstanceName/>
                        </#if>
                    </td>

                    <td>
                        <#if residue.TRRConcentration?has_content>
                            <@com.range residue.TRRConcentration/>
                        </#if>
                    </td>

                    <td>
                        <#if residue.TRRPercentage?has_content>
                            <@com.range residue.TRRPercentage/>%
                        </#if>
                    </td>
                </tr>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>


<#macro samplingAndResiduesTable path>
    <#compress>

<#--        NOTE: many fields not considered-->
        <table border="1">

<#--            <col width="7%" />-->
<#--            <col width="15%" />-->
<#--            <col width="7%" />-->
<#--            <col width="7%" />-->
<#--            <col width="13%" />-->
<#--            <col width="10%"/>-->
<#--            <col width="7%" />-->
<#--            <col width="15%" />-->
<#--            <col width="12%" />-->
<#--            <col width="7%" />-->

            <col width="7%" />
            <col width="15%" />
            <col width="8%" />
            <col width="8%" />
            <col width="13%" />
            <col width="10%"/>
            <col width="16%" />
            <col width="14%" />
            <col width="9%" />

            <thead align="center" valign="middle">
                <tr>
                    <th rowspan="2"><emphasis role="bold">Trial ID</emphasis></th>
                    <th colspan="5"><emphasis role="bold">Sampling</emphasis></th>
                    <th colspan="2"><emphasis role="bold">Residue levels</emphasis> </th>
                    <th rowspan="2"><emphasis role="bold">Total / mean</emphasis></th>
                </tr>

                <tr>
                    <td><emphasis role="bold" >RAC</emphasis></td>
                    <td><emphasis role="bold" >Sample ID</emphasis></td>
                    <td><emphasis role="bold" >Date</emphasis></td>
                    <td><emphasis role="bold" >Timing</emphasis></td>
                    <td><emphasis role="bold" >Crop growth stage (BBCH)</emphasis></td>
<#--                    TODO methods when possible to retrieve section-->
<#--                    <td><emphasis role="bold" >Method ID</emphasis></td>-->
                    <td><emphasis role="bold" >Residue</emphasis></td>
                    <td><emphasis role="bold" >Level</emphasis></td>
                </tr>
            </thead>

            <tbody valign="middle">
            <#list path as sampling>
                <#assign usespan = true />
                <tr>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.text sampling.TrialIDNo/>
                    </td>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.picklist sampling.SampledMaterialCommodity/>
                        <#if sampling.SampledMaterialCommodityDescription?has_content>
                            (<@com.text sampling.SampledMaterialCommodityDescription/>)
                        </#if>
                    </td>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.text sampling.SamplingID/>
                    </td>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.text sampling.DateOfSampling/>
                    </td>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.picklist sampling.SamplingTiming/>
                    </td>
                    <td rowspan="${sampling.ResidueLevels?size}">
                        <@com.text sampling.GrowthStageCode/>
                        <#if sampling.GrowthStage?has_content>
                            (<@com.text sampling.GrowthStage/>)
                        </#if>
                    </td>
                    <#if sampling.ResidueLevels?has_content>
                        <#list sampling.ResidueLevels as analyte>
                            <#if analyte_index!=0><tr></#if>
<#--                                <td>-->
<#--                                    &lt;#&ndash; TODO: get section and name&ndash;&gt;-->
<#--                                    <@com.text analyte.MethodID/>-->
<#--                                </td>-->

                                <td>
                                    <#if analyte.AnalyteIdentity?has_content>
                                        <#local reference=iuclid.getDocumentForKey(analyte.AnalyteIdentity)/>
                                        <@com.text reference.ReferenceSubstanceName/>
                                    </#if>
                                </td>

                                <td>
                                    <#if analyte.ResidueLevelMeasured?has_content>
                                        <@com.range analyte.ResidueLevelMeasured/> (measured)<?linebreak?>
                                    </#if>
                                    <#if analyte.ResidueLevelCalculated?has_content>
                                        <@com.range analyte.ResidueLevelCalculated/> (calculated)<?linebreak?>
                                    </#if>
                                    <#if analyte.ResidueLevelCorrected?has_content>
                                        <@com.range analyte.ResidueLevelCorrected/> (calculated and corrected)
                                    </#if>
                                </td>
                                <#if usespan>
                                    <td rowspan="${sampling.ResidueLevels?size}">
                                        <@com.quantity sampling.TotalMean/>
                                    </td>
                                    <#assign usespan=false/>
                                </#if>
                            </tr>
                        </#list>
                    <#else>
                        <td></td><td></td>
<#--                        <td></td>-->
                        <td rowspan="${sampling.ResidueLevels?size}">
                            <@com.quantity sampling.TotalMean/>
                        </td>
                        </tr>
                    </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro residuesInRacPriorProcessingTable path>
    <#compress>

    <#--        NOTE: many fields not considered-->
        <table border="1">

            <col width="25%" />
            <col width="10%" />
            <col width="25%" />
            <col width="15%" />
            <col width="25%" />


            <thead align="center" valign="middle">

            <tr>
                <td><emphasis role="bold" >Sample</emphasis></td>
                <td><emphasis role="bold" >Date of sub-sample</emphasis></td>
                <td><emphasis role="bold" >Analyte</emphasis></td>
                <td><emphasis role="bold" >Method ID</emphasis></td>
                <td><emphasis role="bold" >Level</emphasis></td>
            </tr>
            </thead>

            <tbody valign="middle">
            <#list path as sampling>
                <#assign usespan = true />
                <tr>
                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.AnalysisSampleID/>
                    <#if sampling.AnalysisSampleID?has_content && sampling.AnalysisSampleDescription?has_content>: </#if>
                    <@com.text sampling.AnalysisSampleDescription/>
                </td>
                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.DateOfSubSample/>
                </td>

                <#if sampling.AnalyteMeasured?has_content>
                    <#list sampling.AnalyteMeasured as analyte>
                        <#if analyte_index!=0><tr></#if>

                        <@analyteMeasuredTable analyte/>

                        </tr>
                    </#list>
                <#else>
                    <td></td><td></td><td></td>
                    </tr>
                </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro residuesInProcessedFractionTable path>
    <#compress>

    <#--        NOTE: many fields not considered-->
        <table border="1">

            <col width="20%" />
            <col width="10%" />
            <col width="20%" />
            <col width="20%" />
            <col width="10%" />
            <col width="20%" />


            <thead align="center" valign="middle">


            <tr>
                <td><emphasis role="bold" >PF sample</emphasis></td>
                <td><emphasis role="bold" >Date of processing</emphasis></td>
                <td><emphasis role="bold" >Analysis sample</emphasis></td>
                <td><emphasis role="bold" >Analyte</emphasis></td>
                <td><emphasis role="bold" >Method ID</emphasis></td>
                <td><emphasis role="bold" >Level</emphasis></td>
            </tr>
            </thead>

            <tbody valign="middle">
            <#list path as sampling>
                <#assign usespan = true />
                <tr>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.picklist sampling.ProcessedFractionPFSample/>
                    <#if sampling.PFSampleNo?has_content>(No. <@com.text sampling.PFSampleNo/>)</#if>
                </td>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.DateOfProcessing/>
                </td>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.AnalysisSampleID/>
                    <#if sampling.AnalysisSampleID?has_content && sampling.AnalysisSampleDescription?has_content>: </#if>
                    <@com.text sampling.AnalysisSampleDescription/>
                </td>

                <#if sampling.AnalyteMeasured?has_content>
                    <#list sampling.AnalyteMeasured as analyte>
                        <#if analyte_index!=0><tr></#if>
                        <@analyteMeasuredTable analyte/>
                        </tr>
                    </#list>
                <#else>
                    <td></td><td></td><td></td>
                    </tr>
                </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro residuesInAspiratedGrainFractionTable path>
    <#compress>

    <#--        NOTE: many fields not considered-->
        <table border="1">

            <col width="20%" />
            <col width="10%" />
            <col width="20%" />
            <col width="20%" />
            <col width="10%" />
            <col width="20%" />


            <thead align="center" valign="middle">

            <tr>
                <td><emphasis role="bold" >AGF sample</emphasis></td>
                <td><emphasis role="bold" >Date of AGF sample</emphasis></td>
                <td><emphasis role="bold" >Analysis sample</emphasis></td>
                <td><emphasis role="bold" >Analyte</emphasis></td>
                <td><emphasis role="bold" >Method ID</emphasis></td>
                <td><emphasis role="bold" >Level</emphasis></td>
            </tr>
            </thead>

            <tbody valign="middle">
            <#list path as sampling>
                <#assign usespan = true />
                <tr>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.AGFAnalysisSample/>
                </td>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.DateOfAGFSample/>
                </td>

                <td rowspan="${sampling.AnalyteMeasured?size}">
                    <@com.text sampling.AnalysisSampleID/>
                </td>

                <#if sampling.AnalyteMeasured?has_content>
                    <#list sampling.AnalyteMeasured as analyte>
                        <#if analyte_index!=0><tr></#if>
                        <@analyteMeasuredTable analyte/>
                        </tr>
                    </#list>
                <#else>
                    <td></td><td></td><td></td>
                    </tr>
                </#if>
            </#list>

            </tbody>

        </table>

    </#compress>

</#macro>

<#macro analyteMeasuredTable analyte>
    <#compress>
        <td>
            <#if analyte.AnalyteIdentity?has_content>
                <#local reference=iuclid.getDocumentForKey(analyte.AnalyteIdentity)/>
                <@com.text reference.ReferenceSubstanceName/>
            </#if>
        </td>

        <td>
            <#-- TODO: get section and name-->
            <@com.text analyte.MethodID/>
        </td>

        <td>
            <#if analyte.ResidueLevelMeasured?has_content>
                <@com.range analyte.ResidueLevelMeasured/> (measured)<?linebreak?>
            </#if>
            <#if analyte.ResidueLevelCalculated?has_content>
                <@com.range analyte.ResidueLevelCalculated/> (calculated)<?linebreak?>
            </#if>
            <#if analyte.ResidueLevelCalculatedAndCorrected?has_content>
                <@com.range analyte.ResidueLevelCalculatedAndCorrected/> (calculated and corrected)
            </#if>
        </td>
    </#compress>
</#macro>

<#macro residuesInRotationalCropsAnalyticalMethodsTable path>
    <#compress>

        <table border="1">

            <col width="10%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%"/>
            <col width="15%" />

            <thead align="center" valign="middle">
                <tr>
                    <th><emphasis role="bold">Method ID</emphasis></th>
                    <th><emphasis role="bold">Document</emphasis></th>
                    <th><emphasis role="bold">Details</emphasis> </th>
                    <th><emphasis role="bold">Analyte</emphasis></th>
                    <th><emphasis role="bold">Sample</emphasis></th>
                    <th><emphasis role="bold">Fortification level</emphasis></th>
                    <th><emphasis role="bold">Recovery rate</emphasis></th>
                </tr>
            </thead>

            <tbody valign="middle">

            <#list path as method>

                <#--get the right rowspan-->
                <#assign rowspan = 0/>
                <#list method.CombinationsOfSubstanceAndSamplePortion as analyte>
                    <#assign fortSize=analyte.Fortification?size/>
                    <#if fortSize==0><#assign fortSize=1></#if>
                    <#assign rowspan = rowspan + fortSize/>
                </#list>
<#--                <#if rowspan==0><#assign rowspan=1></#if>-->

                <tr>
                <td rowspan="${rowspan}">
                    <@com.text method.MethodID/>
                </td>
                <td rowspan="${rowspan}">
                    <#local studyReference = iuclid.getDocumentForKey(method.RelatedInformation) />
                    <#if studyReference?has_content>
                        <command  linkend="${studyReference.documentKey.uuid!}">
                            <@com.text studyReference.name/>
                        </command>
                    </#if>
                </td>
                <td rowspan="${rowspan}">
                    <@com.text method.DetailsOnAnalyticalMethods/>
                </td>

                <#--iterate and print-->
                <#if method.CombinationsOfSubstanceAndSamplePortion?has_content>
                    <#list method.CombinationsOfSubstanceAndSamplePortion as analyte>

                        <#if analyte_index!=0><tr></#if>
                        <#assign rowspan2 = analyte.Fortification?size/>
<#--                        <#if rowspan2==0><#assign rowspan2=1></#if>-->

                        <td rowspan="${rowspan2}">
                            <#if analyte.AnalyteIdentity?has_content>
                                <#local reference=iuclid.getDocumentForKey(analyte.AnalyteIdentity)/>
                                <@com.text reference.ReferenceSubstanceName/>
                            </#if>
                        </td>
                        <td rowspan="${rowspan2}">
                            <@com.text analyte.AnalysedSamplePortionID/>
                            <#if analyte.AnalysedSamplePortionID?has_content && analyte.AnalysedSamplePortionDescription?has_content>: </#if>
                            <@com.text analyte.AnalysedSamplePortionDescription/>
                        </td>

                        <#if analyte.Fortification?has_content>
                            <#list analyte.Fortification as fort>

                                <#if fort_index!=0><tr></#if>

                                    <td>
                                        <@com.quantity fort.FortificationLevel/>
                                    </td>

                                    <td>
                                        <#if fort.Recovery?has_content><@com.number fort.Recovery/>%</#if>
                                    </td>

                                </tr>
                            </#list>
                        <#else>
                            <td></td>
                            <td></td>
                            </tr>
                        </#if>
                    </#list>
                <#else>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    </tr>
                </#if>
            </#list>
            </tbody>
        </table>
    </#compress>
</#macro>

<#--Summaries-->
<#macro residuesSummary subject docSubType selection=[]>
    <#compress>

        <#-- Get doc-->
<#--        <#if docSubType=="MRLProposal" || docSubType=="ExpectedExposure">-->
<#--            <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "FLEXIBLE_SUMMARY", docSubType) />-->
<#--        <#else>-->
<#--            <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />-->
<#--        </#if>-->
        <#local summaryList = getResiduesSummary(subject, docSubType, selection)/>

        <#-- Get metabolites-->
        <#if _metabolites?? && _metabolites?has_content>

            <#-- get a list of entities of same size as summaryList-->
            <#local entityList = []/>
            <#list summaryList as summary>
                <#local entityList = entityList + [subject.ChemicalName]/>
            </#list>

            <#-- add metabolites-->
            <#list _metabolites as metab>
                <#local metabSummaryList = getResiduesSummary(metab, docSubType, selection)/>
                <#if metabSummaryList?has_content>
                    <#local summaryList = summaryList + metabSummaryList/>
                    <#list metabSummaryList as metabSummary>
                        <#local entityList = entityList + [metab.ChemicalName]/>
                    </#list>
                </#if>
            </#list>
        </#if>

        <#-- Filter selection for metabolism and magnitude docs-->
<#--        <#assign summaryListFilt=[]/>-->
<#--        <#if docSubType=="MagnitudeResiduesPlants" && selection?has_content>-->
<#--            <#list summaryList as summary>-->
<#--                &lt;#&ndash; if it doesn't have specific content, add&ndash;&gt;-->
<#--                <#if !summary.KeyInformation.SummaryResiduesData?has_content>-->
<#--                    <#assign summaryListFilt = summaryListFilt + [summary] />-->
<#--                &lt;#&ndash; if it does, iterate and if it corresponds to selection, add&ndash;&gt;-->
<#--                <#else>-->
<#--                    <#list summary.KeyInformation.SummaryResiduesData as resData>-->
<#--                    <#local applicableTo><@com.picklistMultiple resData.ResultsApplicableTo/></#local>-->
<#--                    <#if !(applicableTo?has_content) || applicableTo?contains(selection)>-->
<#--                        <#assign summaryListFilt = summaryListFilt + [summary] />-->
<#--                        <#break>-->
<#--                    </#if>-->
<#--                    </#list>-->
<#--                </#if>-->
<#--            </#list>-->
<#--        <#elseif docSubType=="MetabolismPlants" && selection?has_content>-->
<#--            <#list summaryList as summary>-->
<#--                &lt;#&ndash; if it doesn't have specific content, or if it does and it corresponds to selection, add&ndash;&gt;-->
<#--                <#list selection as sel>-->
<#--                    <#if summary.KeyInformation[sel]?has_content ||-->
<#--                        (!summary.KeyInformation.PrimaryCrops?has_content && !summary.KeyInformation.RotationalCrops?has_content)>-->
<#--                        <#assign summaryListFilt = summaryListFilt + [summary] />-->
<#--                        <#break>-->
<#--                    </#if>-->
<#--                </#list>-->
<#--            </#list>-->
<#--        <#else>-->
<#--            <#assign summaryListFilt=summaryList/>-->
<#--        </#if>-->

        <#-- Iterate-->
<#--        <#if summaryListFilt?has_content>-->
        <#if summaryList?has_content>

            <@com.emptyLine/>
            <para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

<#--            <#local printSummaryName = summaryListFilt?size gt 1 />-->
            <#local printSummaryName = summaryList?size gt 1 />

<#--            <#list summaryListFilt as summary>-->
            <#list summaryList as summary>

                <@com.emptyLine/>

                <#if _metabolites?? && _metabolites?has_content &&
                    subject.ChemicalName!=entityList[summary_index] &&
                    entityList?seq_index_of(entityList[summary_index]) == summary_index>

                    <para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
                    <@com.emptyLine/>
                </#if>

                <#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

                <#--Key Information-->
                <#if summary.hasElement("KeyInformation") && summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>
                    <para><@com.richText summary.KeyInformation.KeyInformation/></para>

                    <#if docSubType=="ResiduesLivestock">
                        <para>[Copy/paste here the following tables as given by the Animal Model calculator: “Dietary burden table” and “MRL calculations table”.
                        Please also report the input values used for the animal burden calculations.]</para>
                    <#elseif docSubType=="MetabolismPlants">
                        <para>[Please, note that the full text of the end point summary on metabolism studies is reported here.
                                Please, keep only the text relevant for primary crops or rotational crops as corresponds.]</para>
                    <#elseif docSubType=="MagnitudeResiduesPlants" >
                        <para>[Please, note that the full text of the end point summary on magnitude of residues is reported here.
                                Please, keep only the text relevant for primary crops or rotational crops as corresponds.]</para>
                    </#if>
                </#if>

                <#--Results blocks (type dependent)-->
                <#if summary.documentSubType=="MetabolismPlants">
                    <#if (!(selection?has_content) || selection?seq_contains("PrimaryCrops")) && summary.KeyInformation.PrimaryCrops?has_content>
                        <para><@metabolismPlantsSummaryTable summary.KeyInformation.PrimaryCrops/></para>
                    </#if>
                    <#if (!(selection?has_content) || selection?seq_contains("RotationalCrops")) && summary.KeyInformation.RotationalCrops?has_content>
                        <para><@metabolismPlantsSummaryTable summary.KeyInformation.RotationalCrops/></para>
                    </#if>
                <#elseif summary.documentSubType=="StabilityResiduesCommodities">
                    <#if summary.KeyInformation.StorageStabilityPlant?has_content>
                        <para><emphasis role="bold">Storage stability - plants:</emphasis></para>
                        <para><@stabilityResiduesCommoditiesSummaryTable summary.KeyInformation.StorageStabilityPlant/></para>
                    </#if>
                    <#if summary.KeyInformation.StorageStabilityAnimal?has_content>
                        <para><emphasis role="bold">Storage stability - animals:</emphasis></para>
                        <para><@stabilityResiduesCommoditiesSummaryTable summary.KeyInformation.StorageStabilityAnimal/></para>
                    </#if>
                <#elseif summary.documentSubType=="MagnitudeResiduesPlants">
                    <#if summary.KeyInformation.SummaryResiduesData?has_content>
                        <para role="small"><@summaryResiduesDataSummaryTable summary.KeyInformation.SummaryResiduesData selection/></para>
                    </#if>
                <#elseif summary.documentSubType=="NatureMagnitudeResiduesProcessedCommodities">
                    <#if summary.KeyInformation.ResidueNatureProcessedCommodities?has_content>
                        <para><emphasis role="bold">Nature of residues in processed commodities:</emphasis></para>
                        <para><@natureResiduesProcessedCommoditiesSummaryTable summary.KeyInformation.ResidueNatureProcessedCommodities/></para>
                    </#if>
                    <#if summary.KeyInformation.ProcessingFactors?has_content>
                        <para><emphasis role="bold">Processing factors:</emphasis></para>
                        <para><@processingFactorsSummaryTable summary.KeyInformation.ProcessingFactors/></para>
                    </#if>
                <#elseif summary.documentSubType=='ResidueFood'>
                    <#if summary.KeyInformation.FoodFeedPlantOriginResidueRa?has_content || summary.KeyInformation.FoodFeeedPlantOriginMonitoring?has_content ||
                            summary.KeyInformation.AnimalFoodFeedPlantOriginRa?has_content || summary.KeyInformation.AnimalFoodFeedPlantOriginMonitoring?has_content >
                        <para><emphasis role="bold">Residue definitions:</emphasis></para>
                        <para role="small"><@residueDefinitionSummaryTable summary.KeyInformation/></para>
                    </#if>
                <#elseif summary.documentSubType=='MRLProposal'>
                    <#if summary.KeyInformation.MaximumResidueLevel?has_content>
                        <para><emphasis role="bold">Maximum residue levels:</emphasis></para>
                        <para role="small"><@mrlSummaryTable summary.KeyInformation.MaximumResidueLevel/></para>
                    </#if>

                 <#elseif summary.documentSubType=='ExpectedExposure'>
                    <#if summary.KeyInformation.ExposureDietarySources.field3689?has_content>
                        <para><emphasis role="bold">Exposure from dietary sources:</emphasis></para>
                        <para><@com.richText summary.KeyInformation.ExposureDietarySources.field3689/></para>
                    </#if>
                    <#if summary.KeyInformation.ExposureOtherSources.field4124?has_content>
                        <para><emphasis role="bold">Exposure from other sources (drinking water):</emphasis></para>
                        <para><@com.richText summary.KeyInformation.ExposureOtherSources.field4124/></para>
                    </#if>
                </#if>

                <#--Links-->
                <#if summary.hasElement("LinkToRelevantStudyRecord.Link") && summary.LinkToRelevantStudyRecord.Link?has_content>
                <para><emphasis role="bold">Link to relevant study records: </emphasis></para>
                <para role="indent">
                    <#list summary.LinkToRelevantStudyRecord.Link as link>
                        <#if link?has_content>
                            <#local studyReference = iuclid.getDocumentForKey(link) />
                            <para><command  linkend="${studyReference.documentKey.uuid!}">
                                <@com.text studyReference.name/>
                            </command>
                                </para>
<#--                            <#if link_has_next> | </#if>-->
                        </#if>
                    </#list>
                </para>
                </#if>

                <#--Discussion-->
                <#if summary.hasElement("Discussion") && summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>
                    <para><@com.richText summary.Discussion.Discussion/></para>

                     <#if docSubType=="MetabolismPlants">
                        <para>[Please, note that the full text of the end point summary on metabolism studies is reported here.
                                Please, keep only the text relevant for primary crops or rotational crops as corresponds.]</para>
                    <#elseif docSubType=="MagnitudeResiduesPlants" >
                        <para>[Please, note that the full text of the end point summary on magnitude of residues is reported here.
                                Please, keep only the text relevant for primary crops or rotational crops as corresponds.]</para>
                    </#if>
                </#if>

            </#list>
        </#if>
    </#compress>
</#macro>

<#function filterPrimaryOrRotationalCrops summaryList selection=[]>

    <#if summaryList?has_content && selection?has_content>

        <#local docSubType = summaryList[0].documentSubType/>
        <#local summaryListFilt=[]/>

        <#if docSubType=="MagnitudeResiduesPlants">
            <#list summaryList as summary>
                <#-- if it doesn't have specific content, add-->
                <#if !summary.KeyInformation.SummaryResiduesData?has_content>
                    <#local summaryListFilt = summaryListFilt + [summary] />
                <#-- if it does, iterate and if it corresponds to selection, add-->
                <#else>
                    <#list summary.KeyInformation.SummaryResiduesData as resData>
                        <#local applicableTo><@com.picklistMultiple resData.ResultsApplicableTo/></#local>
                        <#if !(applicableTo?has_content) || applicableTo?contains(selection)>
                            <#local summaryListFilt = summaryListFilt + [summary] />
                            <#break>
                        </#if>
                    </#list>
                </#if>
            </#list>

        <#elseif docSubType=="MetabolismPlants">
            <#list summaryList as summary>
            <#-- if it doesn't have specific content, or if it does and it corresponds to selection, add-->
                <#list selection as sel>
                    <#if summary.KeyInformation[sel]?has_content ||
                        (!summary.KeyInformation.PrimaryCrops?has_content && !summary.KeyInformation.RotationalCrops?has_content)>
                        <#local summaryListFilt = summaryListFilt + [summary] />
                        <#break>
                    </#if>
                </#list>
            </#list>
        </#if>

        <#return summaryListFilt/>

    <#else>
        <#return summaryList/>

    </#if>
</#function>

<#function getResiduesSummary subject docSubType selection>

    <#-- Get document-->
    <#if docSubType=="MRLProposal" || docSubType=="ExpectedExposure">
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "FLEXIBLE_SUMMARY", docSubType) />
    <#else>
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", docSubType) />
    </#if>

    <#-- Filter document-->
    <#if docSubType=="MagnitudeResiduesPlants" || docSubType=="MetabolismPlants">
        <#local summaryList = filterPrimaryOrRotationalCrops(summaryList, selection)/>
    </#if>

    <#return summaryList/>

</#function>

<#macro metabolismPlantsSummaryTable path>
    <#compress>

        <table border="1">

<#--        <col width="20%" />-->
<#--        <col width="20%" />-->
<#--        <col width="15%" />-->
<#--        <col width="15%" />-->
<#--        <col width="15%" />-->
<#--        <col width="15%"/>-->


        <thead align="center" valign="middle">
            <tr>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Studies</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Crop groups</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Commodity</emphasis></th>
                <#if path?node_name=="PrimaryCrops_list"><th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Treatment type</emphasis></th></#if>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Application rate</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?>
                    <emphasis role="bold">
                        <#if path?node_name=="PrimaryCrops_list">DAT
                        <#elseif path?node_name=="RotationalCrops_list">PBI
                        </#if>
                    </emphasis>
                </th>
                <#if path?node_name=="RotationalCrops_list"><th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th></#if>
            </tr>
        </thead>
        <tbody>
            <#list path as item>
                <tr>
                    <td>
                        <#list item.RelevantStudies as link>
                            <#local studyReference = iuclid.getDocumentForKey(link) />
                            <command  linkend="${studyReference.documentKey.uuid!}">
                                <@com.text studyReference.name/>
                            </command>
                            <#if link_has_next><?linebreak?></#if>
                        </#list>
                    </td>
                    <td><@com.picklist item.CropGroups/></td>
                    <td><@com.picklistMultiple item.Commodity/></td>
                    <#if item.hasElement("TreatmentType")>
                        <td><@com.picklistMultiple item.TreatmentType/></td>
                    </#if>
                    <td><@com.text item.ApplicationRate/></td>
                    <td>
                        <#if item.hasElement("Dat")>
                            <@com.text item.Dat/>
                        <#elseif item.hasElement("Pbi")>
                            <@com.text item.Pbi/>
                        </#if>
                    </td>
                    <#if item.hasElement("Remarks")>
                        <td><@com.text item.Remarks/></td>
                    </#if>
                </tr>
            </#list>
        </tbody>
        </table>


    </#compress>
</#macro>

<#macro stabilityResiduesCommoditiesSummaryTable path>
    <#compress>

        <table border="1">

                    <col width="10%" />
                    <col width="22%" />
                    <col width="22%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%"/>
                    <col width="20%"/>


            <thead align="center" valign="middle">
            <tr>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Category</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Commodity</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Substance(s)</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Temp.</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Tested period</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Stability period</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
            </tr>
            </thead>
            <tbody>
            <#list path as item>
                <tr>
                    <td><@com.picklist item.Category/></td>
                    <td><@com.picklistMultiple item.Commodity/></td>
                    <td>
                        <#list item.SubstanceS as link>
                            <#local substance = iuclid.getDocumentForKey(link) />
                            <@com.text substance.ChemicalName/>
                            <#if link_has_next><?linebreak?></#if>
                        </#list>
                    </td>
                    <td><#if item.Temperature?has_content><@com.number item.Temperature/>°C</#if></td>
                    <td><@com.quantity item.TestedPeriod/></td>
                    <td><@com.quantity item.DemonstratedStability/></td>
                    <td><@com.text item.Remarks/></td>
                </tr>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>

<#macro summaryResiduesDataSummaryTable path sel="">
    <#compress>

        <table border="1">

            <col width="20%" />
<#--            <col width="10%" />-->
            <col width="12%" />
            <col width="12%" />
            <col width="8%" />
            <col width="8%" />
            <col width="6%" />
            <col width="7%" />
            <col width="7%" />
            <col width="7%"/>
            <col width="13%"/>


<#--            <thead align="center" valign="middle">-->
            <tbody>
                <tr align="center" valign="middle">
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>
<#--                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">GAP</emphasis></th>-->
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Commodity for MRL</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Commodity used</emphasis></th>
                    <th colspan="3"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Residue levels</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">HRV</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">STMR</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">MRL</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
                </tr>
                <tr align="center" valign="middle">
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">RA</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">MO</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CF</emphasis></th>
                </tr>
<#--            </thead>-->
<#--            <tbody>-->
            <#list path as item>
                <#local applicableTo><@com.picklistMultiple item.ResultsApplicableTo/></#local>
                <#if !(sel?has_content) || applicableTo?contains(sel) || !(applicableTo?has_content)>
                    <tr>
                        <td>
                            <#list item.Link as link>
                                <#if link?has_content>
                                    <#local study = iuclid.getDocumentForKey(link) />
                                    <command  linkend="${study.documentKey.uuid!}">
                                        <@com.text study.name/>
                                    </command>
                                    <#if link_has_next> | </#if>
                                </#if>
                            </#list>
                        </td>
<#--                        <td>GAP link NA?</td>-->
                        <td><@com.picklistMultiple item.CommodityForMrl/></td>
                        <td><@com.picklistMultiple item.Commodity/></td>
                        <td><@com.text item.ResidueLevelsRiskAssessment/></td>
                        <td><@com.text item.ResidueLevelsMonitoring/></td>
                        <td><@com.number item.MeanConversionFactor/></td>
                        <td><@com.quantity item.HighestResidue/></td>
                        <td><@com.quantity item.Stmr/></td>
                        <td><@com.quantity item.MrlDerived/></td>
                        <td><@com.text item.Remarks/></td>
                    </tr>
                </#if>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>

<#macro processingFactorsSummaryTable path>
    <#compress>

        <table border="1">

            <col width="20%" />
            <col width="20%" />
            <col width="8%" />
            <col width="8%" />
            <col width="8%" />
            <col width="16%" />
            <col width="20%" />


            <thead align="center" valign="middle">
                <tr align="center" valign="middle">
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Raw Agricultural Commodity (RAC)</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Processed Commodity (PC)</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">No. trials</emphasis></th>
                    <th colspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Processing factor</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>
                </tr>
                <tr align="center" valign="middle">
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">MO</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">RA</emphasis></th>
                </tr>
            </thead>

            <tbody>
            <#list path as item>
                <tr>
                    <td><@com.picklist item.RawCommodity/></td>
                    <td><@com.picklist item.ProcessedCommodity/></td>
                    <td><@com.number item.NoTrials/></td>
                    <td><@com.number item.ProcessingFactorMo/></td>
                    <td><@com.number item.ProcessingFactorRa/></td>
                    <td><@com.text item.Remarks/></td>
                    <td>
                        <#list item.RelevantStudies as link>
                            <#if link?has_content>
                                <#local study = iuclid.getDocumentForKey(link) />
                                <para>
                                    <command  linkend="${study.documentKey.uuid!}">
                                        <@com.text study.name/>
                                    </command>
                                </para>
                            </#if>
                        </#list>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>

<#macro natureResiduesProcessedCommoditiesSummaryTable path>
    <#compress>

        <table border="1">

            <col width="40%" />
            <col width="30%" />
            <col width="30%" />

            <thead align="center" valign="middle">
                <tr>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Conditions</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Stable</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Study</emphasis></th>
                </tr>
            </thead>

            <tbody>
            <#list path as item>
                <tr>
                    <td><@com.picklistMultiple item.Conditions/></td>
                    <td><@com.picklist item.Stable/></td>
                    <td>
                        <#list item.RelevantStudies as link>
                            <#if link?has_content>
                                <#local study = iuclid.getDocumentForKey(link) />
                                <para>
                                    <command  linkend="${study.documentKey.uuid!}">
                                        <@com.text study.name/>
                                    </command>
                                </para>
                            </#if>
                        </#list>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>

<#macro residueDefinitionSummaryTable path>
    <#compress>

        <table border="1">

            <col width="18%" />
            <col width="14%" />
            <col width="18%" />
            <col width="18%" />
            <col width="14%" />
            <col width="18%" />

            <thead align="center" valign="middle">
            <tr>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Endpoint</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Group</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Residue definition</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Residue components</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Provisional RD?</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Other information</emphasis></th>
            </tr>
            </thead>

            <tbody valign="middle">
            <#local endpoints={"FoodFeeedPlantOriginMonitoring":"Plant residue definition for monitoring (RD-MO)",
                                "FoodFeedPlantOriginResidueRa":"Plant residue definition for risk assessment (RD-RA)",
                                "AnimalFoodFeedPlantOriginMonitoring":"Animal residue definition for monitoring (RD-MO)",
                                "AnimalFoodFeedPlantOriginRa":"Animal residue definition for risk assessment (RD-RA)"
            }/>
            <#list endpoints?keys as endpoint>
                <#local endpointName=endpoints[endpoint]/>
                <#if path[endpoint]?has_content>
                    <#local endpointSize=path[endpoint]?size/>
                    <#assign usespan=true>
                    <#list path[endpoint] as item>
                        <tr>
                            <#if usespan>
                                <td rowspan="${endpointSize}">${endpointName}</td>
                                <#assign usespan=false>
                            </#if>
                            <td>
                                <#if item.hasElement("CropGroup") && item.CropGroup?has_content>
                                    <para>Crop: <@com.picklistMultiple item.CropGroup/></para>
                                </#if>
                                <#if item.hasElement("MetabolismGroup") && item.MetabolismGroup?has_content>
                                    <para>Metabolism: <@com.picklistMultiple item.MetabolismGroup/></para>
                                </#if>
                                <#if item.hasElement("TreatmentType") && item.TreatmentType?has_content>
                                    <para>Treatment: <@com.picklistMultiple item.TreatmentType/></para>
                                </#if>
                                <#if item.hasElement("Animal") && item.Animal?has_content>
                                    <para>Animal: <@com.picklist item.Animal/></para>
                                </#if>
                                <#if item.hasElement("Commodity") && item.Commodity?has_content>
                                    <para>Commodity: <@com.picklistMultiple item.Commodity/></para>
                                </#if>
                            </td>
                            <td>
                                <#if item.hasElement("ResidueDefinitionMonitoring") && item.ResidueDefinitionMonitoring?has_content>
                                    <para><@com.text item.ResidueDefinitionMonitoring/></para>
                                </#if>
                                <#if item.hasElement("ResidueDefinitionRisk") && item.ResidueDefinitionRisk?has_content>
                                    <para><@com.text item.ResidueDefinitionRisk/></para>
                                </#if>
                                <#if item.hasElement("ResidueDefinitionRiskAssessment") && item.ResidueDefinitionRiskAssessment?has_content>
                                    <para><@com.text item.ResidueDefinitionRiskAssessment/></para>
                                </#if>
                            </td>
                            <td>
                                <#if item.hasElement("ResidueDefinitionRiskComp")>
                                    <#local compPath=item.ResidueDefinitionRiskComp/>
                                <#elseif item.hasElement("ResidueDefinitionMonitoringComp")>
                                    <#local compPath=item.ResidueDefinitionMonitoringComp/>
                                <#elseif item.hasElement("ResidueDefinitionRiskAssessmentComponents")>
                                    <#local compPath=item.ResidueDefinitionRiskAssessmentComponents/>
                                </#if>

                                <#list compPath as link>
                                    <#if link?has_content>
                                        <#local comp = iuclid.getDocumentForKey(link) />
                                        <para>
                                            <@com.text comp.ChemicalName/>
                                        </para>
                                    </#if>
                                </#list>
                            </td>
                            <td>
                                <@com.picklist item.Provisional/>
                                <#--<#if prov=="yes">Y<#elseif prov=="no">N</#if>-->
                                <#--                                    <#if prov?starts_with("yes")>-->
                                <#--                                        <para>${prov?replace("^yes", "provisional", "r")}</para>-->
                                <#--                                    </#if>-->
                            </td>
                            <td>
                                <#if item.hasElement("MonitoringResidueDefinitionLoq") && item.MonitoringResidueDefinitionLoq?has_content>
                                    <para>LOQ: <@com.number item.MonitoringResidueDefinitionLoq/>mg/kg</para>
                                </#if>
                                <#if item.hasElement("ValidatedMethod") && item.ValidatedMethod && item.LinkToValidatedMethod?has_content>
                                    <para>Validated method:
                                        <#local method = iuclid.getDocumentForKey(item.LinkToValidatedMethod) />
                                        <command linkend="${method.documentKey.uuid!}">
                                            <@com.text method.name/>
                                        </command>
                                    </para>
                                </#if>
                                <#if item.Remarks?has_content>
                                    <para><@com.text item.Remarks/></para>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                </#if>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>

<#macro mrlSummaryTable path>
    <#compress>

        <table border="1">

            <col width="20%" />
            <col width="20%" />
            <col width="10%" />
            <col width="20%" />
            <col width="18%" />
            <col width="12%" />

            <thead align="center" valign="middle">
            <tr>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Commodity</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Residue definition monitoring</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">MRL proposal</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Rationale</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Critical GAP</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Comments</emphasis></th>
            </tr>
            </thead>

            <tbody valign="middle">

            <#list path as item>
                <tr>
                    <td><@com.picklistMultiple item.Commodity/></td>
                    <td><@com.text item.ResidueDefinitionMonitoring/></td>
                    <td>
                        <@com.quantity item.MrlProposal/>
                        <#if item.MrlLoq><?linebreak?>(at LOQ)</#if>
                    </td>
                    <td><@com.picklist item.RationaleForMrl/></td>
                    <td>
                        <#list item.CriticalGap as link>
                            <#if link?has_content>
                                <#local gap = iuclid.getDocumentForKey(link) />
                                <para>
                                    <command linkend="${gap.documentKey.uuid!}">
                                        <@com.text gap.name/>
                                    </command>
                                </para>
                            </#if>
                        </#list>
                    </td>
                    <td> </td>
                </tr>
            </#list>
            </tbody>
        </table>

    </#compress>
</#macro>
