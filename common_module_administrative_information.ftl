<!-- Legal entity information from a Legal entity  -->
<#macro basicLegalEntityInformation _subject legalEntity="">
	<#compress>

		<#if !legalEntity?has_content><#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/></#if>
		<#if legalEntity?has_content>

			<#if legalEntity.GeneralInfo.LegalEntityName?has_content>
				<para><emphasis role="bold">Legal Entity name:</emphasis> <@com.text legalEntity.GeneralInfo.LegalEntityName /></para><?linebreak?>
			</#if>
	
			<#if legalEntity.GeneralInfo.LegalEntityType?has_content>
				<para><emphasis role="bold">Legal Entity type:</emphasis> <@com.picklist legalEntity.GeneralInfo.LegalEntityType /></para><?linebreak?>
			</#if>

			<#if legalEntity.GeneralInfo.OtherNames?has_content>
				<para><emphasis role="bold">Other names for legal entity:</emphasis>
				<#list legalEntity.GeneralInfo.OtherNames as legalEntityOtherNames>
					<@com.text legalEntityOtherNames.Name />
					<#if legalEntityOtherNames_has_next><#if pppRelevant??>,<#else><?linebreak?></#if></#if>
				</#list>
				</para>
			</#if>

		</#if>
	
	</#compress>
</#macro>

<!-- Contact information from a Legal entity or Site -->
<#macro contactInfoOfLegalEntity _subject contactPath="" title="Basic contact information of the Legal Entity">
	<#compress>

		<#if !contactPath?has_content>
			<#local legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
			<#if legalEntity?has_content><#local contactPath = legalEntity.GeneralInfo/></#if>
		</#if>

		<#if (legalEntity?? && legalEntity?has_content) || contactPath?has_content>

			<#local contactPath = contactPath.ContactAddress/>

			<@com.emptyLine/>
			<table border="1">
				<title>${title}</title>
				<col width="50%" />
				<col width="50%" />
				<tbody>

					<#if contactPath.Phone?has_content || contactPath.Email?has_content || contactPath.Address1?has_content ||
							contactPath.Address2?has_content || contactPath.Postal?has_content || contactPath.Town?has_content ||
							contactPath.Country?has_content>
						<tr>
							<td>
								<#if contactPath.Phone?has_content || contactPath.Email?has_content>
									Phone: <@com.text contactPath.Phone /><?linebreak?>
									E-mail: <@com.text contactPath.Email />
								</#if>
							</td>
							<td>
								<#if contactPath.Address1?has_content || contactPath.Address2?has_content || contactPath.Postal?has_content ||
										contactPath.Town?has_content || contactPath.Country?has_content>
									Address 1: <@com.text contactPath.Address1 /><?linebreak?>
									Address 2: <@com.text contactPath.Address2 /><?linebreak?>
									Postal code: <@com.text contactPath.Postal /><?linebreak?>
									Town: <@com.text contactPath.Town /><?linebreak?>
									Country: <@com.picklist contactPath.Country />
								</#if>
							</td>
						</tr>
					<#else>
						<tr colspan="2">
							<td>
								<para>No contact information provided</para>
							</td>
						</tr>
					</#if>
				</tbody>
			</table>
		<#else>
		</#if>
	</#compress>
</#macro>

<!-- Contact persons information from main substance or mixture -->
<#macro contactPersonsInfoOfMainSubstanceOrMixture _subject title="Contact persons of the main entity (substance or mixture)">
	<#compress>

		<#if _subject.ContactPersons?has_content>

			<@com.emptyLine/>
			<table border="1">
				<title>${title}</title>
				<col width="50%" />
				<col width="50%" />
				<tbody>
					<@tableOfContactPersons _subject.ContactPersons/>
				</tbody>
			</table>
		</#if>
	</#compress>
</#macro>

<!-- Contact persons information from Legal entity -->
<#macro contactPersonsInfoOfLegalEntity _subject legalEntity="" title="Contact persons of the Legal Entity">
	<#compress>

		<#if !legalEntity?has_content><#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/></#if>
		<#if legalEntity?has_content>

			<@com.emptyLine/>

			<table border="1">
				<title>${title}</title>
				<col width="50%" />
				<col width="50%" />
				<tbody>
					<@tableOfContactPersons legalEntity.ContactInfo.ContactPersons/>
				</tbody>
			</table>
		</#if>
		
	</#compress>
</#macro>

<!-- Contact persons main table -->
<#macro tableOfContactPersons contactBlock>
	<#compress>

		<#list contactBlock as contactPersons>

			<#if contactPersons?has_content>
				<#local contactPerson = iuclid.getDocumentForKey(contactPersons.ContactPerson)/>
				<#if contactPerson?has_content>
					<#if contactPerson.GeneralInfo.ContactType?has_content>
						<tr>
							<td colspan="2">
								Contact type: <@com.picklist contactPerson.GeneralInfo.ContactType/>
							</td>
						</tr>
						<#else>
						<tr>
							<td colspan="2"></td>
						</tr>
					</#if>

					<tr>
						<td>
							<#if contactPerson.GeneralInfo.LastName?has_content	|| contactPerson.GeneralInfo.FirstName?has_content ||
								contactPerson.GeneralInfo.Organisation?has_content ||	contactPerson.GeneralInfo.Phone?has_content ||
								contactPerson.GeneralInfo.Email?has_content>
								Last name: <@com.text contactPerson.GeneralInfo.LastName /><?linebreak?>
								First name: <@com.text contactPerson.GeneralInfo.FirstName /><?linebreak?>
								Organisation: <@com.text contactPerson.GeneralInfo.Organisation /><?linebreak?>
								Phone: <@com.text contactPerson.GeneralInfo.Phone /><?linebreak?>
								E-mail: <@com.text contactPerson.GeneralInfo.Email />
							</#if>
						</td>
						<td>
							<#if contactPerson.GeneralInfo.Address1?has_content	|| contactPerson.GeneralInfo.Address2?has_content ||
								contactPerson.GeneralInfo.Postal?has_content || contactPerson.GeneralInfo.Town?has_content || contactPerson.GeneralInfo.Country?has_content>
								Address 1: <@com.text contactPerson.GeneralInfo.Address1 /><?linebreak?>
								Address 2: <@com.text contactPerson.GeneralInfo.Address2 /><?linebreak?>
								Postal code: <@com.text contactPerson.GeneralInfo.Postal /><?linebreak?>
								Town: <@com.text contactPerson.GeneralInfo.Town /><?linebreak?>
								Country: <@com.picklist contactPerson.GeneralInfo.Country />
							</#if>
						</td>
					</tr>

				<#else>
				<tr><?dbfo bgcolor="#bbbbbb"?>
					<td colspan="2">
						<para>Empty contact persons block</para>
					</td>
				</tr>
				</#if>

			</#if>

		</#list>
		
	</#compress>
</#macro>


<#-----------------------PPP additions--------------------------------------------->
<#macro applicant _subject>
	<#compress>

		<#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
		<#if legalEntity?has_content>
			<para><emphasis role="underline">Information of the applicant (legal entity):</emphasis></para>
			<@legalEntityInfo legalEntity/>
			<@roleInSupplyChain _subject/>
		<#else>
<#--			NOTE: for some reason with the substance the path _subject.OwnerLegalEntity seems empty!-->
			<para>No information of applicant available.</para>
		</#if>

		<#if _subject.ContactPersons?has_content>
			<@com.emptyLine/>
			<para><emphasis role="underline">Contact persons:</emphasis></para>
			<@contactPersonsInfoOfMainSubstanceOrMixture _subject "Contact persons (${_subject.documentType?lower_case})"/>
		</#if>
	</#compress>
</#macro>

<#macro legalEntityInfo legalEntity>
	<#compress>
		<@basicLegalEntityInformation _subject legalEntity/>
	<#-- NOTE: missing IDENTIFIERS section-->

		<#if legalEntity.GeneralInfo.ContactAddress?has_content>
			<@contactInfoOfLegalEntity _subject legalEntity.GeneralInfo/>
		</#if>

		<#if legalEntity.ContactInfo.ContactPersons?has_content>
			<@contactPersonsInfoOfLegalEntity _subject legalEntity "Contact persons (legal entity)"/>
		</#if>
	</#compress>
</#macro>

<#macro roleInSupplyChain _subject>
	<#compress>
		<#if _subject.RoleInSupplyChain?has_content>
			<#local rolePath=_subject.RoleInSupplyChain/>
			<#local roles=[]/>
			<#list rolePath?children as child>
				<#if child?node_type=="boolean" && child>
					<#local childName>${child?node_name?replace("([A-Z]{1})", " $1", "r")?lower_case}</#local>
					<#local roles=roles+[childName]/>
				</#if>
			</#list>
<#--			<#if rolePath.Manufacturer><#local roles=roles+["manufacturer"]/></#if>-->
<#--			<#if rolePath.Importer><#local roles=roles+["importer"]/></#if>-->
<#--			<#if rolePath.OnlyRepresentative><#local roles=roles+["only representative"]/></#if>-->
<#--			<#if rolePath.DownstreamUser><#local roles=roles+["downstream user"]/></#if>-->

			<#if roles?has_content>
				<#local roles=roles?join(", ")/>
				<para><emphasis role="bold">Role in the supply chain: </emphasis>${roles}</para>
			</#if>
		</#if>
	</#compress>
</#macro>

<#macro producer _subject>
	<#compress>

		<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "Suppliers") />

		<#if !(recordList?has_content)>
			No relevant information on producers available.
		<#else>
			<#list recordList as record>

				<#if (recordList?size>1) ><para><emphasis role="HEAD-WoutNo">Producer #${record_index+1}</emphasis></para></#if>

				<#-- Producer-->
				<#local legalEntity = iuclid.getDocumentForKey(record.ManufacturerImportForm.LegalEntity)/>
				<#if legalEntity?has_content>
					<para><emphasis role="underline">Producer's details:</emphasis></para>

					<@legalEntityInfo legalEntity/>

					<#if record.ManufacturerImportForm.Remarks?has_content>
						<para><emphasis role="bold">Remarks: </emphasis><@com.text record.ManufacturerImportForm.Remarks/></para>
					</#if>
				</#if>

				<#if record.OnlyRepresentationInfo.ImporterEntries?has_content>
					<@com.emptyLine/>
					<para><emphasis role="underline">Other importers:</emphasis></para>

					<#list record.OnlyRepresentationInfo.ImporterEntries as leEntry>
						<#if (record.OnlyRepresentationInfo.ImporterEntries?size>1) >Importer #${leEntry_index+1}:</#if>

						<#local leImporter = iuclid.getDocumentForKey(leEntry.LegalEntity)/>
						<#if leImporter?has_content>
							<#--NOTE: maybe better to show less info for these cases-->
							<@legalEntityInfo leImporter/>
						</#if>
					</#list>
				</#if>
				<@com.emptyLine/>
			</#list>
		</#if>

	</#compress>
</#macro>


<#macro manufacturingPlant _subject>
	<#compress>

		<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "Sites") />

		<#if !(recordList?has_content)>
			No relevant information on manufacturing plants available.
		<#else>
			<#list recordList as record>

				<#if (recordList?size>1) ><para><emphasis role="HEAD-WoutNo">Manufacturing plant #${record_index+1}</emphasis></para></#if>

				<#--Mixture/Product-->
				<#if _subject.documentType=="MIXTURE" && record.RelatedMixtureProduct.SpecifyToWhichMixtureProductSItApplies?has_content>
					<para>Applicable to mixture/product:
						<#local product=iuclid.getDocumentForKey(record.RelatedMixtureProduct.SpecifyToWhichMixtureProductSItApplies)/>
						<@mixtureName _subject/>
					</para>
					<@com.emptyLine/>
				</#if>

				<#--Site-->
				<#local site = iuclid.getDocumentForKey(record.ReferenceSite)/>
				<#if site?has_content>

					<@siteInfo site/>

					<#if record.Remarks?has_content>
						<para><emphasis role="bold">Remarks: </emphasis><@com.text record.Remarks/></para>
					</#if>
				</#if>

				<@com.emptyLine/>
			</#list>
		</#if>

	</#compress>
</#macro>

<#macro siteInfo site>
	<#compress>

		<#if site.GeneralInfo.SiteName?has_content>
			<para><emphasis role="bold">Site name:</emphasis> <@com.text site.GeneralInfo.SiteName /></para><?linebreak?>
		</#if>

		<#if site.GeneralInfo.OwnerLegalEntity?has_content>
			<#local legalEntity = iuclid.getDocumentForKey(site.GeneralInfo.OwnerLegalEntity)/>
			<#if legalEntity?has_content>
				<para>
					<emphasis role="bold">Legal entity owner:</emphasis>
					<@com.picklist legalEntity.GeneralInfo.LegalEntityName />
					<#if legalEntity.GeneralInfo.LegalEntityType?has_content>
						<@com.picklist legalEntity.GeneralInfo.LegalEntityType/>
					</#if>
				</para>
				<?linebreak?>
			</#if>
		</#if>

		<#if site.GeneralInfo.ExternalSystemIdentifiers?has_content>
			<para><emphasis role="bold">Other IT system identifiers:</emphasis>
				<#list site.GeneralInfo.ExternalSystemIdentifiers as otherId>
					<@com.text otherId.ExternalSystemDesignator/>: <@com.text otherId.Id/>
					<#if otherId_has_next>,</#if>
				</#list>
			</para>
		</#if>

		<#if site.ContactAddress?has_content>
			<@contactInfoOfLegalEntity _subject site "Contact info of site"/>
		</#if>

	</#compress>
</#macro>

<#macro producerDevCodeNos _subject>
	<#compress>

		<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "Identifiers") />

		<#if !(recordList?has_content)>
			No relevant information on producer's development code numbers available.
		<#else>
			<#list recordList as record>

				<#if (recordList?size>1) ><para><emphasis role="HEAD-WoutNo">Development code numbers #${record_index+1}</emphasis></para></#if>

				<#--Regulatory programme identifiers-->
				<#if record.RegulatoryProgrammeIdentifiers.RegulatoryProgrammeIdentifiers?has_content>
					<para><emphasis role="underline">Regulatory programme identifiers:</emphasis></para>
					<@regProgIdsList record.RegulatoryProgrammeIdentifiers.RegulatoryProgrammeIdentifiers "indent"/>
					<@com.emptyLine/>
				</#if>

				<#--Other IT system identifiers-->
				<#if record.ExternalSystemIdentifiers.ExternalSystemIdentifiers?has_content>
					<para><emphasis role="underline">Other IT system identifiers:</emphasis></para>
					<@itSystemIdsList record.ExternalSystemIdentifiers.ExternalSystemIdentifiers "indent"/>
					<@com.emptyLine/>
				</#if>

			</#list>
		</#if>

	</#compress>
</#macro>

<#macro regProgIdsList path role="">
	<#compress>
		<#if path?has_content>
			<#list path as item>
				<para role="${role}">
					<@com.picklist item.RegulatoryProgramme/>: <@com.text item.Id/>
					<#if item.Remarks?has_content>(<@com.text item.Remarks/>)</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro itSystemIdsList path role="">
	<#compress>
		<#if path?has_content>
			<#list path as item>
				<para role="${role}">
					<@com.text item.ExternalSystemDesignator/>: <@com.text item.Id/>
					<#if item.Remarks?has_content>(<@com.text item.Remarks/>)</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--Macros to move to macros_common_general-->
<#macro mixtureName _subject>
	<#compress>
		<#if _subject.documentType=="MIXTURE">

			<#assign docUrl=iuclid.webUrl.entityView(_subject.documentKey)/>
			<#if docUrl?has_content>
				<ulink url="${docUrl}"><@com.text _subject.MixtureName/></ulink>
			<#else>
				<@com.text _subject.MixtureName/>
			</#if>
		</#if>
	</#compress>
</#macro>

