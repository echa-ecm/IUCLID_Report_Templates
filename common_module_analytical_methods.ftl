<#--  RESULTS  -->
<#macro results_analyticalMethods study>
    <#compress>
        <#--  Store analytical method labels and paths in hash  -->
        <#local resultsHash = { "Results using analytical (primary) method" : study.ResultsAndDiscussion.RecoveryResultsAndCharacteristicsOfAnalyticalMethod,
                                "Results using enforcement method" : study.ResultsAndDiscussion.ResultsUsingEnforcementMethod,
                                "Results using confirmatory method" : study.ResultsAndDiscussion.ResultsUsingConfirmatoryMethodIfApplicable,
                                "Independent Laboratory Validation - ILV" : study.ResultsAndDiscussion.IndependentLaboratoryValidation } />

        <#--  Iterate over resultsHash  -->
        <#list resultsHash as label, path>
            <#if path?has_content>
                <#--  Print results label  -->
                <para><emphasis role="strong">${label}</emphasis></para>

                <#--  Print recovery results table  -->
                <para role="small"><@printRecoveryTable path /></para>

                <#--  Print repeatability results table  -->
                <para role="small"><@printRepeatabilityTable path /></para>

                <#--  Print LOQ/LOD results table  -->
                <para role="small"><@printLOQLODTable path /></para>

                <#--  Print calibration results table  -->
                <para role="small"><@printCalibrationTable path /></para>
            </#if>
        </#list>
    </#compress>
</#macro>

<#--  RECOVERY TABLE  -->
<#macro printRecoveryTable resultsPath footnotes=true >
    <#local recovery = resultsPath.Recovery />

    <#if recovery?has_content>
        <#--  CREATE TABLE  -->
        <table border="1">
            <#--  Assign title  -->
            <title>Recovery</title>

            <#--  Set columns width  -->
            <col width="21%"/>
            <col width="17%"/>
            <col width="9%"/>
            <col width="14%"/>
            <col width="11%"/>
            <col width="10%"/>
            <col width="10%"/>
            <col width="8%"/>
            
            <#--  Define table header  -->
            <thead align="center" valign="middle">
                <tr><?dbfo bgcolor="#FBDDA6" ?>
                    <th>
                        <emphasis role="bold">
                            Analyte
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Matrix
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            MRM/ m/z
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Fortification level
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Nb replicates
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Range recovery (%)
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Mean recovery (%)
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            RSD (%)
                        </emphasis>
                    </th>
                </tr>
            </thead>
            
            <#--  Define table body  -->
            <tbody valign="middle">
                <#--  Initialize the counter that keeps track of the remarks index  -->
                <#local remarksCounter = 0 />

                <#--  Iterate over recovery block  -->
                <#list recovery as row>
                    <tr>
                        <#--  Analyte column  -->
                        <td>
                            <#local analyte = iuclid.getDocumentForKey(row.Analyte) />

                            <#if analyte?has_content>
                                <#local analyteUrl=iuclid.webUrl.entityView(analyte.documentKey)/>

                                <ulink url="${analyteUrl}"><@com.value analyte.ReferenceSubstanceName /></ulink>
                            <#else>
                                N/A
                            </#if>

                            <#if footnotes && row.Remarks?has_content>
                                <#local remarksCounter++ />

                                <superscript><emphasis>(${remarksCounter})</emphasis></superscript>
                            </#if>
                        </td>

                        <#--  Matrix cell  -->
                        <td>
                            <#if row.Matrix?has_content>
                                <@com.text row.Matrix />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  MRM/ m/z cell  -->
                        <td>
                            <#if row.MRMMZ?has_content>
                                <@com.range row.MRMMZ />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Fortification level (mg/kg) cell  -->
                        <td>
                            <#if row.FortificationLevel?has_content>
                                <@com.quantity row.FortificationLevel />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Nb replicates cell  -->
                        <td>
                            <#if row.NumberReplicates?has_content>
                                <@com.number row.NumberReplicates />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Range recovery (%) cell  -->
                        <td>
                            <#if row.RangeRecovery?has_content>
                                <@com.range row.RangeRecovery />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Mean recovery (%) cell  -->
                        <td>
                            <#if row.MeanRecovery?has_content>
                                <@com.range row.MeanRecovery />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  RSD (%) cell  -->
                        <td>
                            <#if row.RSDr?has_content>
                                <@com.number row.RSDr />
                            <#else>
                                N/A
                            </#if>
                        </td>
                    </tr>
                </#list>
            </tbody>
        </table>

        <#if footnotes>
            <para role="small">
                <emphasis>
                    <@printRemarksFromTable recovery />
                </emphasis>
            </para>
        </#if>
    </#if>

    <#--  Print additional details on recovery results section  -->
    <#if resultsPath.hasElement("RecoveryResults") && resultsPath.RecoveryResults?has_content>
        <para>Details:</para>

        <para role="indent">
            <@com.text resultsPath.RecoveryResults />
        </para>
    </#if>
</#macro>

<#--  REPEATABILITY TABLE  -->
<#macro printRepeatabilityTable resultsPath footnotes=true >
    <#local repeatability = resultsPath.Repeatability />

    <#if repeatability?has_content>
        <#--  CREATE TABLE  -->
        <table border="1">
            <#--  Assign title  -->
            <title>Repeatability</title>

            <#--  Set columns width  -->
            <col width="29%"/>
            <col width="22%"/>
            <col width="12%"/>
            <col width="10%"/>
            <col width="9%"/>
            <col width="9%"/>
            <col width="9%"/>
            
            <#--  Define table header  -->
            <thead align="center" valign="middle">
                <tr><?dbfo bgcolor="#FBDDA6" ?>
                    <th>
                        <emphasis role="bold">
                            Analyte
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Matrix
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Nb replicates
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Mean content
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            RSD
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            RSDr
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Horrat value
                        </emphasis>
                    </th>
                </tr>
            </thead>
            
            <#--  Define table body  -->
            <tbody valign="middle">
                <#--  Initialize the counter that keeps track of the remarks index  -->
                <#local remarksCounter = 0 />

                <#--  Iterate over recovery block  -->
                <#list repeatability as row>
                    <tr>
                        <#--  Analyte column  -->
                        <td>
                            <#local analyte = iuclid.getDocumentForKey(row.Analyte) />

                            <#if analyte?has_content>
                                <#local analyteUrl=iuclid.webUrl.entityView(analyte.documentKey)/>

                                <ulink url="${analyteUrl}"><@com.value analyte.ReferenceSubstanceName /></ulink>
                            <#else>
                                N/A
                            </#if>

                            <#if footnotes && row.Remarks?has_content>
                                <#local remarksCounter++ />

                                <superscript><emphasis>(${remarksCounter})</emphasis></superscript>
                            </#if>
                        </td>

                        <#--  Matrix cell  -->
                        <td>
                            <#if row.Matrix?has_content>
                                <@com.text row.Matrix />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Nb replicates cell  -->
                        <td>
                            <#if row.NumberReplicates?has_content>
                                <@com.number row.NumberReplicates />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Mean content cell  -->
                        <td>
                            <#if row.MeanContent?has_content>
                                <@com.number row.MeanContent />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  RSD (%) cell  -->
                        <td>
                            <#if row.RSDr?has_content>
                                <@com.number row.RSD />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  RSDr (%) cell  -->
                        <td>
                            <#if row.RSDr?has_content>
                                <@com.number row.RSDr />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Horrat value cell  -->
                        <td>
                            <#if row.HorratValue?has_content>
                                <@com.number row.HorratValue />
                            <#else>
                                N/A
                            </#if>
                        </td>
                    </tr>
                </#list>
            </tbody>
        </table>

        <#if footnotes>
            <para role="small">
                <emphasis>
                    <@printRemarksFromTable repeatability />
                </emphasis>
            </para>
        </#if>
    </#if>
</#macro>

<#--  LOQ/LOD TABLE  -->
<#macro printLOQLODTable resultsPath footnotes=true>
    <#local LOQLOD = resultsPath.LOQLOD />

    <#if LOQLOD?has_content>
        <#--  CREATE TABLE  -->
        <table border="1">
            <#--  Assign title  -->
            <title>LOQ/LOD</title>

            <#--  Set columns width  -->
            <col width="34%"/>
            <col width="34%"/>
            <col width="16%"/>
            <col width="16%"/>

            <#--  Define table header  -->
            <thead align="center" valign="middle">
                <tr><?dbfo bgcolor="#FBDDA6" ?>
                    <th>
                        <emphasis role="bold">
                            Analyte
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Matrix
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            LOQ
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            LOD
                        </emphasis>
                    </th>
                </tr>
            </thead>
            
            <#--  Define table body  -->
            <tbody valign="middle">
                <#--  Initialize the counter that keeps track of the remarks index  -->
                <#local remarksCounter = 0 />

                <#--  Iterate over recovery block  -->
                <#list LOQLOD as row>
                    <tr>
                        <#--  Analyte column  -->
                        <td>
                            <#local analyte = iuclid.getDocumentForKey(row.Analyte) />

                            <#if analyte?has_content>
                                <#local analyteUrl=iuclid.webUrl.entityView(analyte.documentKey)/>

                                <ulink url="${analyteUrl}"><@com.value analyte.ReferenceSubstanceName /></ulink>
                            <#else>
                                N/A
                            </#if>

                            <#if footnotes && row.Remarks?has_content>
                                <#local remarksCounter++ />

                                <superscript><emphasis>(${remarksCounter})</emphasis></superscript>
                            </#if>
                        </td>

                        <#--  Matrix cell  -->
                        <td>
                            <#if row.Matrix?has_content>
                                <@com.text row.Matrix />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  LOQ cell  -->
                        <td>
                            <#if row.LimitOfQuantification?has_content>
                                <@com.quantity row.LimitOfQuantification />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  LOD cell  -->
                        <td>
                            <#if row.LimitOfDetection?has_content>
                                <@com.quantity row.LimitOfDetection />
                            <#else>
                                N/A
                            </#if>
                        </td>
                    </tr>
                </#list>
            </tbody>
        </table>

        <#if footnotes>
            <para role="small">
                <emphasis>
                    <@printRemarksFromTable LOQLOD />
                </emphasis>
            </para>
        </#if>
    </#if>
</#macro>

<#--  CALIBRATION TABLE  -->
<#macro printCalibrationTable resultsPath footnotes=true>
    <#local calibration = resultsPath.Calibration />

    <#if calibration?has_content>
        <#--  CREATE TABLE  -->
        <table border="1">
            <#--  Assign title  -->
            <title>Calibration</title>

            <#--  Set columns width  -->
            <col width="17%"/>
            <col width="14%"/>
            <col width="11%"/>
            <col width="11%"/>
            <col width="12%"/>
            <col width="13%"/>
            <col width="12%"/>
            <col width="10%"/>

            <#--  Define table header  -->
            <thead align="center" valign="middle">
                <tr><?dbfo bgcolor="#FBDDA6" ?>
                    <th>
                        <emphasis role="bold">
                            Analyte
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Matrix
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Matrix matched standards
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            MRM/ m/z
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Calibration range
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Calibration equation
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Correlation coefficient
                        </emphasis>
                    </th>
                    <th>
                        <emphasis role="bold">
                            Nb replicates
                        </emphasis>
                    </th>
                </tr>
            </thead>
            
            <#--  Define table body  -->
            <tbody valign="middle">
                <#--  Initialize the counter that keeps track of the remarks index  -->
                <#local remarksCounter = 0 />

                <#--  Iterate over recovery block  -->
                <#list calibration as row>
                    <tr>
                        <#--  Analyte column  -->
                        <td>
                            <#local analyte = iuclid.getDocumentForKey(row.Analyte) />

                            <#if analyte?has_content>
                                <#local analyteUrl=iuclid.webUrl.entityView(analyte.documentKey)/>

                                <ulink url="${analyteUrl}"><@com.value analyte.ReferenceSubstanceName /></ulink>
                            <#else>
                                N/A
                            </#if>

                            <#if footnotes && row.Remarks?has_content>
                                <#local remarksCounter++ />

                                <superscript><emphasis>(${remarksCounter})</emphasis></superscript>
                            </#if>
                        </td>

                        <#--  Matrix cell  -->
                        <td>
                            <#if row.Matrix?has_content>
                                <@com.text row.Matrix />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Matrix matched standards cell  -->
                        <td>
                            <#if row.Standards?has_content>
                                <@com.picklistMultiple row.Standards />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  MRM/ m/z cell  -->
                        <td>
                            <#if row.MRMMZ?has_content>
                                <@com.range row.MRMMZ />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Calibration range cell  -->
                        <td>
                            <#if row.CalibrationRange?has_content>
                                <@com.range row.CalibrationRange />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Calibration equation cell  -->
                        <td>
                            <#if row.CalibrationEquation?has_content>
                                <@com.text row.CalibrationEquation />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Correlation coefficient (r) cell  -->
                        <td>
                            <#if row.CorrelationCoefficientR?has_content>
                                r: <@com.number row.CorrelationCoefficientR />
                            <#elseif row.CorrelationCoefficientR2?has_content>
                                r2: <@com.number row.CorrelationCoefficientR2 />
                            <#else>
                                N/A
                            </#if>
                        </td>

                        <#--  Nb replicates cell  -->
                        <td>
                            <#if row.NumberReplicates?has_content>
                                <@com.number row.NumberReplicates />
                            <#else>
                                N/A
                            </#if>
                        </td>
                    </tr>
                </#list>
            </tbody>
        </table>

        <#if footnotes>
            <para role="small">
                <emphasis>
                    <@printRemarksFromTable calibration />
                </emphasis>
            </para>
        </#if>
    </#if>
</#macro>

<#--  This macro retrieves the remarks field from an IUCLID table (taken as an argument) and prints the results as footnotes  -->
<#macro printRemarksFromTable tablePath>
    <#--  Initialize the counter that keeps track of the remarks index  -->
    <#local remarksCounter = 0 />

    <#--  Iterate over the table  -->
    <#list tablePath as row>
        <#if row.Remarks?has_content>
            <#local remarksCounter++ />

            <#--  Print remarks  -->
            <superscript>(${remarksCounter})</superscript><@com.value row.Remarks />

            <#--  Add empty line  -->
            <#if row?has_next>
                <@com.emptyLine/>
            </#if>
        </#if>
    </#list>
</#macro>


<#--  METHODS  -->
<#macro analyticalMethodsMethod study>
    <#compress>
        <#--  General  -->
        <#if study.MaterialsAndMethods.MatrixMedium?has_content>
            <para><emphasis role='bold'>Matrix / medium:</emphasis></para>
            <para role="indent"><@com.picklistMultiple study.MaterialsAndMethods.MatrixMedium/></para>
        </#if>

        <#--  Store analytical method labels and paths in hash  -->
        <#local methodsHash = { "Principles of analytical methods" : study.MaterialsAndMethods.PrinciplesOfAnalyticalMethods,
                                "Enforcement method" : study.MaterialsAndMethods.EnforcementMethodIfApplicable,
                                "Confirmatory method" : study.MaterialsAndMethods.ConfirmatoryMethodIfApplicable,
                                "Independent Laboratory Validation - ILV" : study.MaterialsAndMethods.IndependentLaboratoryValidationILVIfApplicable } />

        <#--  Iterate over methodsHash hash to print corresponding tables  -->
        <#list methodsHash as label, path>
            <@analyticalMethodsTables methodPath=path title=label />
        </#list>
    </#compress>
</#macro>

<#--  PRINCIPLES OF ANALYTICAL METHODS, ENFORCEMEMT METHOD, CONFIRMATORY METHOD AND ILV TABLES  -->
<#macro analyticalMethodsTables methodPath title>
    <#compress>
        <#if methodPath?has_content>
            <#--  CREATE TABLE  -->
            <table border="1">
                <#--  Assign title  -->
                <title>${title}</title>

                <#--  Set columns width  -->
                <col width="25%"/>
                <col width="25%"/>
                <col width="25%"/>
                <col width="25%"/>
                
                <#--  Define table header  -->
                <thead align="center" valign="middle">
                    <tr><?dbfo bgcolor="#FBDDA6" ?>
                        <th>
                            <emphasis role="bold">
                                Instrument / detector
                                <#if title?matches("Enforcement method")>
                                    for enforcement method
                                <#elseif title?matches("Confirmatory method")>
                                    for confirmatory method
                                </#if>
                            </emphasis>
                        </th>
                        <th>
                            <emphasis role="bold">
                                Residue method
                            </emphasis>
                        </th>
                        <th>
                            <emphasis role="bold">
                                Extraction and clean-up
                            </emphasis>
                        </th>
                        <th>
                            <emphasis role="bold">
                                <#if !title?matches("Confirmatory method")>
                                    Flow diagram
                                <#else>
                                    Suitability of the method for confirmation
                                </#if>
                            </emphasis>
                        </th>
                    </tr>
                </thead>
                
                <#--  Define table body  -->
                <tbody>
                    <tr valign="middle">
                        <#--  Instrument / detector cell  -->
                        <td>
                            <#if title?matches("Enforcement method")>
                                <@com.picklistMultiple methodPath.InstrumentDetectorForEnforcementMethod />
                            <#elseif title?matches("Confirmatory method")>
                                <@com.picklistMultiple methodPath.InstrumentDetectorForConfirmatoryMethod />
                            <#else>
                                <@com.picklistMultiple methodPath.InstrumentDetector />
                            </#if>
                        </td>

                        <#--  Residue method cell  -->
                        <td>
                            <@com.picklist methodPath.ResidueMethod/>
                        </td>

                        <#--  Extraction and clean-up cell  -->
                        <td>
                            <@com.picklist methodPath.ExtractionAndCleanUp/>
                        </td>

                        <#--  Flow diagram/Suitability of the method for confirmation cell  -->
                        <td>
                            <#if title?matches("Confirmatory method")>
                                <@com.picklistMultiple methodPath.SuitabilityOfTheMethodForConfirmation />
                            <#else>
                                <#if methodPath.FlowDiagram?has_content>
                                    <#local attachment = iuclid.getMetadataForAttachment(methodPath.FlowDiagram) />

                                    <#if attachment.isImage>
                                        <#if attachment.exceedsLimit(10000000)>
                                            <para><emphasis>Image size is too big (${attachment.size} bytes) and cannot be displayed!</emphasis></para>
                                        <#elseif !iuclid.imageMimeTypeSupported(attachment.mediaType) >
                                            <para><emphasis>Image type (${attachment.mediaType}) is not yet supported!</emphasis></para>
                                        <#else>
                                            <mediaobject>
                                                <imageobject>
                                                    <imagedata width="80%" scalefit="1" align="center" fileref="data:${attachment.mediaType};base64,${iuclid.getContentForAttachment(methodPath.FlowDiagram)}" />
                                                </imageobject>
                                            </mediaobject>
                                        </#if>
                                    </#if>
                                <#else>
                                    N/A
                                </#if>
                            </#if>
                        </td>
                    </tr>
                </tbody>
            </table>

            <#--  Add further details text below table  -->
            <para>Details:</para>

            <para role="indent">
                <#if title?matches("Principles of analytical methods")>
                    <#if methodPath.DetailsOnAnalyticalMethod?has_content>
                        <@com.text methodPath.DetailsOnAnalyticalMethod />
                    <#else>
                        No data available
                    </#if>
                <#elseif title?matches("Enforcement method")>
                    <#if methodPath.DetailsOnEnforcementMethod?has_content>
                        <@com.text methodPath.DetailsOnEnforcementMethod />
                    <#else>
                        No data available
                    </#if>
                <#elseif title?matches("Confirmatory method")>
                    <#if methodPath.DetailsOnConfirmatoryMethod?has_content>
                        <@com.text methodPath.DetailsOnConfirmatoryMethod />
                    <#else>
                        No data available
                    </#if>
                <#elseif title?matches("Independent Laboratory Validation - ILV")>
                    <#if methodPath.DetailsOnILV?has_content>
                        <@com.text methodPath.DetailsOnILV />
                    <#else>
                        No data available
                    </#if>
                </#if>
            </para>
        </#if>
    </#compress>
</#macro>


<#--  SUMMARY  -->
<#macro analyticalMethodsSummary subject includeMetabolites=true>
    <#compress>
        <#--  Get doc  -->
        <#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "AnalyticalMethods") />
        <#if includeMetabolites && _metabolites??>

            <#--  Get list of entities of same size as summaryList  -->
            <#assign entityList = []/>
            <#list summaryList as summary>
                <#assign entityList = entityList + [subject.ChemicalName]/>
            </#list>

            <#--  Add metabolites  -->
            <#list _metabolites as metab>
                <#local metabSummaryList = iuclid.getSectionDocumentsForParentKey(metab.documentKey, "ENDPOINT_SUMMARY", "AnalyticalMethods") />
                <#if metabSummaryList?has_content>
                    <#local summaryList = summaryList + metabSummaryList/>
                    <#list metabSummaryList as metabSummary>
                        <#local entityList = entityList + [metab.ChemicalName]/>
                    </#list>
                </#if>
            </#list>
        </#if>

        <#--  Iterate  -->
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

                <#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>

                <#--  Key Information  -->
                <#if summary.KeyInformation.KeyInformation?has_content>
                    <para><emphasis role="bold">Key information: </emphasis></para>

                    <para><@com.richText summary.KeyInformation.KeyInformation/></para>
                </#if>

                <#--  Links  -->
                <#if summary.LinkToRelevantStudyRecord.Link?has_content>
                    <para><emphasis role="bold">Link to relevant study records: </emphasis></para>

                    <para role="indent">
                        <#list summary.LinkToRelevantStudyRecord.Link as link>
                            <#if link?has_content>
                                <#local studyReference = iuclid.getDocumentForKey(link) />

                                <para>
                                    <command  linkend="${studyReference.documentKey.uuid!}">
                                        <@com.text studyReference.name/>
                                    </command>
                                </para>
                            </#if>
                        </#list>
                    </para>
                </#if>

                <#--  Discussion  -->
                <#if summary.Discussion.Discussion?has_content>
                    <para><emphasis role="bold">Discussion:</emphasis></para>

                    <para><@com.richText summary.Discussion.Discussion/></para>
                </#if>
            </#list>
        </#if>
    </#compress>
</#macro>