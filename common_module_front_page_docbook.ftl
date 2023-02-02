<#macro getFrontPage subject dossierHeader title ch="" cf="" lh="" rh="" lf="" rf="">

    <#-- Make left footer the date and version -->
    <#if lf=="">
        <#local lf = .now?string["dd/MM/yyyy"] + " - IUCLID 6 " + iuclid6Version!/>
    </#if>

    <#-- Make central footer the name of root (could be name of dossier instead) -->
    <#if cf=="">
        <#local cf = com.getReportSubject(rootDocument).name?html />
    </#if>

    <#-- Make central header equal to title -->
    <#if ch=="">
        <#local ch = title/>
    </#if>

    <info>

        <title>${title}</title>

        <subtitle>
            <@com.emptyLine/>

            <#assign docUrl=iuclid.webUrl.entityView(subject.documentKey)/>
            <#if subject.documentType=="MIXTURE">Mixture: <ulink url="${docUrl}"><@com.text subject.MixtureName/></ulink>
            <#elseif subject.documentType=="SUBSTANCE">Substance: <ulink url="${docUrl}"><@com.text subject.ChemicalName/></ulink>
            </#if>
        </subtitle>

        <cover>
            <para role="cover.rule"/>

            <#if dossierHeader?has_content>
                <para>
                    <emphasis role="bold">Dossier details:</emphasis>
                    <para role="indent">
                        <itemizedlist>
                            <listitem>Dossier name: <#assign dossierUrl=iuclid.webUrl.entityView(dossierHeader.documentKey)/><ulink url="${dossierUrl}"><@com.text dossierHeader.name /></ulink></listitem>
                            <listitem>Dossier UUID: ${com.sanitizeUUID(dossierHeader.subjectKey)}</listitem>
                            <listitem>Dossier submission remarks: <@com.text dossierHeader.remarks /></listitem>
                            <listitem>Dossier creation date and time: <@com.text dossierHeader.creationDate /></listitem>
                            <listitem>Submission type: <@com.text dossierHeader.submissionType /></listitem>
                            <#assign submittingLegalEntity = iuclid.getDocumentForKey(dossierHeader.submittingLegalEntityKey) />
                            <#if submittingLegalEntity?has_content>
                                <listitem>Submitting legal entity:
                                    <@com.text submittingLegalEntity.GeneralInfo.LegalEntityName/>
                                </listitem>
                            </#if>
                            <#assign ownerLegalEntity = iuclid.getDocumentForKey(subject.OwnerLegalEntity) />
                            <#if ownerLegalEntity?has_content && ((!submittingLegalEntity?has_content) || (ownerLegalEntity.documentKey!=submittingLegalEntity.documentKey))>
                                <listitem>Owner legal entity: <@com.text ownerLegalEntity.GeneralInfo.LegalEntityName/></listitem>
                            </#if>
                        </itemizedlist>
                    </para>
                </para>
            </#if>

        </cover>

        <@com.metadataBlock lh ch rh lf cf rf />

    </info>
</#macro>