<#macro literatureData _subject>
    <#compress>

        <#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "LiteratureSearch") />

        <#if !recordList?has_content>
		    No relevant information available.

            <@com.emptyLine/>

	    <#else>
		    <@com.emptyLine/>

            <#list recordList as record>

                <sect3 label="/${record_index+1}" role="NotInToc">

                    <title><#if (recordList?size>1)>#{record_index+1}: </#if><@com.text record.name/></title>

                    <@com.emptyLine/>

                    <para><emphasis role="bold">Summary of literature search</emphasis></para>

                        <#if record.RelevantStudies.KeyInformationDesc?has_content>
                            <para><emphasis role="underline">Description of key information:</emphasis></para>
                            <para role="indent"><@com.richText record.RelevantStudies.KeyInformationDesc/></para>
                        </#if>

                        <#if record.RelevantStudies.SearchSummary?has_content>
                            <para><emphasis role="underline">Overall summary:</emphasis></para>
                            <para role="indent"><@com.richText record.RelevantStudies.SearchSummary/></para>
                        </#if>

                        <#if record.RelevantStudies.LiteratureReference?has_content>
                            <para><emphasis role="underline">Literature references:</emphasis></para>

                            <#list record.RelevantStudies.LiteratureReference as referenceLink>
                                <para role="indent">
                                    <@referenceData referenceLink/>
                                </para>
                            </#list>
                        </#if>

                    <@com.emptyLine/>

                    <para><emphasis role="bold">Search strategy</emphasis></para>
                    <#if record.SearchStrategy.DatabasesUsed?has_content>
                        <para role="small"><@searchStrategyTable record.SearchStrategy.DatabasesUsed /></para>
                    </#if>

                    <@com.emptyLine/>

                    <para><emphasis role="bold">Evaluation of the review</emphasis></para>

                    <para><emphasis role="underline">Number of records:</emphasis></para>
                    <para role="small"><@evaluationReview record/></para>

                    <#if record.EvaluationOfTheReview.ExcludedPublications?has_content>
                        <para><emphasis role="underline">Publications excluded from the risk assessment:</emphasis></para>
                        <para role="small"><@excludedPublicationsTable record.EvaluationOfTheReview.ExcludedPublications/></para>
                    </#if>

                    <#if record.AdditionalInformation.AdditionalInfo?has_content>
                        <@com.emptyLine/>
                        <para><emphasis role="bold">Additional information</emphasis></para>
                        <para><@com.richText record.AdditionalInformation.AdditionalInfo/></para>
                    </#if>
                </sect3>
            </#list>
        </#if>
    </#compress>

</#macro>

<#macro referenceData referenceLink>
    <#compress>
        <#if referenceLink?has_content>
            <#local ref = iuclid.getDocumentForKey(referenceLink)/>
            <#if ref?has_content>
                <@com.text ref.GeneralInfo.Name/>, <@com.text ref.GeneralInfo.Author/>, <@com.text ref.GeneralInfo.ReferenceYear/>
                <#if ref.GeneralInfo.ReportNo?has_content>
                    (No: <@com.text ref.GeneralInfo.ReportNo/>)
                </#if>
            </#if>
        </#if>
    </#compress>
</#macro>

<#macro evaluationReview record>
    <#compress>
        <table border="1">
        <title> </title>
        <col width="14%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="13%" />
        <col width="13%" />

        <thead valign="middle" align="center">
        <tr>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Retrieved</emphasis></th>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">After duplicate removal</emphasis></th>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">After rapid assessment</emphasis></th>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">After detailed assessment</emphasis></th>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Reliable</emphasis></th>
            <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Evaluated</emphasis></th>
        </tr>
        </thead>

        <tbody>
            <tr>
                <td><@com.number record.EvaluationOfTheReview.RecordsRetrieved/></td>
                <td><@com.number record.EvaluationOfTheReview.NoAfterDuplicates/></td>
                <td><@com.number record.EvaluationOfTheReview.NoRapidAssessment/></td>
                <td><@com.number record.EvaluationOfTheReview.NoDetailAssessment/></td>
                <td><@com.number record.EvaluationOfTheReview.ReliableStudies/></td>
                <td><@com.number record.EvaluationOfTheReview.EvaluatedStudies/></td>
            </tr>
        </tbody>
        </table>
    </#compress>
</#macro>

<#macro searchStrategyList block>
    <#compress>
        <#if block?has_content>
            <#list block as item>
                <para role="indent">

                    #${item_index+1}: <@com.picklist item.SearchService/>
                    <#if item.Date?has_content>on <@com.text item.Date/></#if>

                    <#if item.TimeWindow?has_content>
                        <para role="indent2">- time window: <@com.text item.TimeWindow/></para>
                    </#if>
                    <#if item.Strings?has_content>
                        <para role="indent2">- search string(s): <@com.text item.Strings/></para>
                    </#if>
                    <#if item.Filters?has_content>
                        <para role="indent2">- filters: <@com.picklist item.Filters/></para>
                    </#if>
                    <#if item.Limits?has_content>
                        <para role="indent2">- limits: <@com.picklist item.Limits/></para>
                    </#if>

                    <para role="indent2">
                        - results: <@com.number item.NoHits/> hits retrieved
                        <#if item.NoHitsRefinement?has_content>-<@com.number item.NoHitsRefinement/> after refinement</#if>
                        <#if item.NoHitsDuplicate?has_content>-<@com.number item.NoHitsDuplicate/> after duplicate removal</#if>
                    </para>

                </para>
            </#list>
        </#if>
    </#compress>
</#macro>

<#macro excludedPublicationsTable refList>
    <#compress>
        <table border="1">
            <title> </title>


            <thead valign="middle" align="center">
            <tr>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Literature reference</emphasis></th>
                <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Exclusion reason</emphasis></th>
            </tr>
            </thead>

            <tbody>

            <#list refList as referenceEntry>
                <tr>
                    <td>
                        <#if referenceEntry.LitReference?has_content>
                            <#list referenceEntry.LitReference as ref>
                                <para role="indent"><@referenceData ref/></para>
                            </#list>
                        </#if>
                    </td>
                    <td>
                        <@com.text referenceEntry.ExclusionReason/>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>
    </#compress>
</#macro>

<#macro searchStrategyTable block>
    <#compress>
        <table border="1">
            <title> </title>

            <col width="20%" />
            <col width="10%" />
            <col width="45%" />
            <col width="25%" />

            <#--            <col width="7%" />-->
<#--            <col width="7%" />-->
<#--            <col width="7%" />-->


            <thead valign="middle" align="center">
                <tr>
<#--                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Database</emphasis></th>-->
<#--                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Date</emphasis></th>-->
<#--                    <th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Search criteria</emphasis></th>-->
<#--                    <th colspan="3"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hits</emphasis></th>-->
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Database</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Date</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Search criteria</emphasis></th>
                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hits</emphasis></th>
                </tr>
<#--                <tr>-->
<#--                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Total</emphasis></th>-->
<#--                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">After refinement</emphasis></th>-->
<#--                    <th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">After duplicate removal</emphasis></th>-->
<#--                </tr>-->
            </thead>

            <tbody valign="middle">

            <#list block as item>
                <tr>
                    <td><@com.picklist item.SearchService/></td>
                    <td><@com.text item.Date/></td>
                    <td>
                        <#if item.TimeWindow?has_content>
                            <para>Time window: <@com.text item.TimeWindow/></para>
                        </#if>
                        <#if item.Strings?has_content>
                            <para>Search string(s): <@com.text item.Strings/></para>
                        </#if>
                        <#if item.Filters?has_content>
                            <para>Filters: <@com.picklist item.Filters/></para>
                        </#if>
                        <#if item.Limits?has_content>
                            <para>Limits: <@com.picklist item.Limits/></para>
                        </#if>
                    </td>
<#--                    <td><@com.number item.NoHits/></td>-->
<#--                    <td><@com.number item.NoHitsRefinement/></td>-->
<#--                    <td><@com.number item.NoHitsDuplicate/></td>-->
                    <td>
                        <para>Total: <@com.number item.NoHits/></para>
                        <para>After refinement: <@com.number item.NoHitsRefinement/></para>
                        <para>After duplicate removal: <@com.number item.NoHitsDuplicate/></para>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>
    </#compress>
</#macro>