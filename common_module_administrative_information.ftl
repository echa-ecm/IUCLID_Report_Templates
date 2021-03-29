<!-- Legal entity information from a Legal entity  -->
<#macro basicLegalEntityInformation _subject>
<#compress>

<#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
<#if legalEntity?has_content>

	<#if legalEntity.GeneralInfo.LegalEntityName?has_content>
		<para><emphasis role="bold">Legal Entity name:</emphasis> <@com.text legalEntity.GeneralInfo.LegalEntityName /></para><?linebreak?>
	</#if>
	
	<#if legalEntity.GeneralInfo.LegalEntityType?has_content>
		<para><emphasis role="bold">Legal Entity type:</emphasis> <@com.picklist legalEntity.GeneralInfo.LegalEntityType /></para><?linebreak?>
	</#if>
	
	<#if legalEntity.GeneralInfo.OtherNames?has_content>
		<#list legalEntity.GeneralInfo.OtherNames as legalEntityOtherNames>
		<para><emphasis role="bold">Other names for legal entity:</emphasis> <@com.picklist legalEntityOtherNames.Name /></para>
		<#if legalEntityOtherNames_has_next><?linebreak?></#if>
		</#list>
	</#if>

</#if>
	
</#compress>
</#macro>

<!-- Contact information from a Legal entity -->
<#macro contactInfoOfLegalEntity _subject>
<#compress>

<#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
<#if legalEntity?has_content>
<@com.emptyLine/>
<table border="1">
	<title>Basic contact information of the Legal Entity</title>
	<col width="50%" />
	<col width="50%" />
	<tbody>

		<#if legalEntity.GeneralInfo.ContactAddress.Phone?has_content || legalEntity.GeneralInfo.ContactAddress.Email?has_content || legalEntity.GeneralInfo.ContactAddress.Address1?has_content || legalEntity.GeneralInfo.ContactAddress.Address2?has_content || legalEntity.GeneralInfo.ContactAddress.Postal?has_content || legalEntity.GeneralInfo.ContactAddress.Town?has_content || legalEntity.GeneralInfo.ContactAddress.Country?has_content>
			<tr>
				<td>
				<#if legalEntity.GeneralInfo.ContactAddress.Phone?has_content || legalEntity.GeneralInfo.ContactAddress.Email?has_content>
					Phone: <@com.text legalEntity.GeneralInfo.ContactAddress.Phone /><?linebreak?>
					E-mail: <@com.text legalEntity.GeneralInfo.ContactAddress.Email />
					
					<#else></#if>
				</td>
				<td>
				<#if legalEntity.GeneralInfo.ContactAddress.Address1?has_content || legalEntity.GeneralInfo.ContactAddress.Address2?has_content || legalEntity.GeneralInfo.ContactAddress.Postal?has_content || legalEntity.GeneralInfo.ContactAddress.Town?has_content || legalEntity.GeneralInfo.ContactAddress.Country?has_content>
				
					Address 1: <@com.text legalEntity.GeneralInfo.ContactAddress.Address1 /><?linebreak?>
					Address 2: <@com.text legalEntity.GeneralInfo.ContactAddress.Address2 /><?linebreak?>
					Postal code: <@com.text legalEntity.GeneralInfo.ContactAddress.Postal /><?linebreak?>
					Town: <@com.text legalEntity.GeneralInfo.ContactAddress.Town /><?linebreak?>
					Country: <@com.picklist legalEntity.GeneralInfo.ContactAddress.Country />
					
					<#else></#if>
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
<#else/>
</#if>

</#compress>
</#macro>

<!-- Contact persons information from main substance or mixture -->
<#macro contactPersonsInfoOfMainSubstanceOrMixture _subject>
<#compress>

<#if _subject.ContactPersons?has_content>

<@com.emptyLine/>
<table border="1">
	<title>Contact persons of the main entity (substance or mixture)</title>
	<col width="50%" />
	<col width="50%" />
	<tbody>
		<@tableOfContactPersons _subject.ContactPersons/>	
	</tbody>
</table>
<#else/>
</#if>

</#compress>
</#macro>

<!-- Contact persons information from Legal entity -->
<#macro contactPersonsInfoOfLegalEntity _subject>
<#compress>

<#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
<#if legalEntity?has_content>

<@com.emptyLine/>

<table border="1">
	<title>Contact persons of the Legal Entity</title>
	<col width="50%" />
	<col width="50%" />
	<tbody>					
		<@tableOfContactPersons legalEntity.ContactInfo.ContactPersons/>			
	</tbody>
</table>
<#else/>
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
					<#if contactPerson.GeneralInfo.LastName?has_content	|| contactPerson.GeneralInfo.FirstName?has_content || contactPerson.GeneralInfo.Organisation?has_content ||	contactPerson.GeneralInfo.Phone?has_content || contactPerson.GeneralInfo.Email?has_content>
						Last name: <@com.text contactPerson.GeneralInfo.LastName /><?linebreak?>
						First name: <@com.text contactPerson.GeneralInfo.FirstName /><?linebreak?>
						Organisation: <@com.text contactPerson.GeneralInfo.Organisation /><?linebreak?>
						Phone: <@com.text contactPerson.GeneralInfo.Phone /><?linebreak?>
						E-mail: <@com.text contactPerson.GeneralInfo.Email />
						<#else><td></td></#if>
					</td>
					<td>
					<#if contactPerson.GeneralInfo.Address1?has_content	|| contactPerson.GeneralInfo.Address2?has_content || contactPerson.GeneralInfo.Postal?has_content || contactPerson.GeneralInfo.Town?has_content || contactPerson.GeneralInfo.Country?has_content>	
						Address 1: <@com.text contactPerson.GeneralInfo.Address1 /><?linebreak?>
						Address 2: <@com.text contactPerson.GeneralInfo.Address2 /><?linebreak?>
						Postal code: <@com.text contactPerson.GeneralInfo.Postal /><?linebreak?>
						Town: <@com.text contactPerson.GeneralInfo.Town /><?linebreak?>
						Country: <@com.picklist contactPerson.GeneralInfo.Country />
						<#else><td></td></#if>
					</td>	
				</tr>
				
			<#else>
			<tr><?dbfo bgcolor="#bbbbbb"?>
				<td colspan="2">
					<para>Empty contact persons block</para>
				</td>
			</tr>
			</#if>
		
		<#else>
		</#if>
		
	</#list>
		
</#compress>
</#macro>