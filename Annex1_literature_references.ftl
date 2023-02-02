<!-- REFERENCES -->

<#list com.removeDocumentDuplicates(studyandsummaryCom.literatureReferences) as reference>
	<para xml:id="${reference.documentKey.uuid!}">
		<@com.text reference.GeneralInfo.Author/> <#if reference.GeneralInfo.ReferenceYear?has_content>${reference.GeneralInfo.ReferenceYear?string["0"]}</#if>:
		<@com.text reference.GeneralInfo.Name/> <#if reference.GeneralInfo.LiteratureType?has_content>(<@com.picklist reference.GeneralInfo.LiteratureType/>),</#if> 
		<#if reference.GeneralInfo.Source?has_content><@com.text reference.GeneralInfo.Source/>.</#if>
		<#if reference.GeneralInfo.TestLab?has_content>Testing laboratory: <@com.text reference.GeneralInfo.TestLab/>,</#if>
		<#if reference.GeneralInfo.ReportNo?has_content>Report no: <@com.text reference.GeneralInfo.ReportNo/>.</#if>
		<#if reference.GeneralInfo.CompanyOwner?has_content>Owner company; <@com.text reference.GeneralInfo.CompanyOwner/>,</#if>
		<#if reference.GeneralInfo.CompanyOwnerStudyNo?has_content>Study number: <@com.text reference.GeneralInfo.CompanyOwnerStudyNo/>,</#if>  
		
		<#if reference.GeneralInfo.ReportDate?has_content>
		Report date: <@com.text reference.GeneralInfo.ReportDate/>
		</#if>
	</para>
	<@com.emptyLine/>
</#list>
