<!-- Basic information on the product, including high level compositional information -->
<#macro productInformation _subject>
<#compress>
		
	<#if _subject.MixtureName?has_content><para>Name of the product: <@com.text _subject.MixtureName/></para></#if>
	
	<#assign document = _subject />					
	<#if document?has_content>
	<#list document.OtherNames as otherIdentifierItem>
		<#if otherIdentifierItem?has_content>			
			<#if otherIdentifierItem.NameType?has_content>Name type: <@com.picklist otherIdentifierItem.NameType /></#if>
			<#if otherIdentifierItem.Name?has_content>(<@com.text otherIdentifierItem.Name />)</#if>
			<#if otherIdentifierItem_has_next><?linebreak?></#if>
			<#else> No synonyms given
		</#if>
	</#list>
	</#if>

	<table border="1">
		<title>Product information</title>
		
		<col width="50%" />
		<col width="50%" />
					
		<tbody>
			<tr>
				<th><?dbfo bgcolor="#EEEEEE"?>Applicant</th>
				
				<#assign legalEntity = iuclid.getDocumentForKey(_subject.OwnerLegalEntity)/>
					<#if legalEntity?has_content>
						<th>						
							<@keyAdministrativeInformation.contactPersonsInfoOfLegalEntity _subject />									
						</th>
					<#else><th>No Legal Entity details provided</th>							
					</#if>
			</tr>
			
			<tr>
				<td>Producer of the plant protection product</td>				
				<td></td>					
			</tr>
			
			<tr><?dbfo bgcolor="#EEEEEE"?>
				<td colspan="2">Quantitative and qualitative information on the composition of the plant protection product</td> 
			</tr>
			
			<#assign mixtureComposition = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "MixtureComposition") />			
			<#if mixtureComposition?has_content>
			<#list mixtureComposition as mixtureCompositions>
				<#if mixtureCompositions?has_content>
					
					<#if mixtureCompositions.GeneralInformation.Name?has_content>
						<tr>
							<td><?dbfo bgcolor="#dbd68e"?>Composition name</td>
							<td><@com.text mixtureCompositions.GeneralInformation.Name /></td>
						</tr>
					</#if>
					
					<#if mixtureCompositions.GeneralInformation.FormulationType?has_content>
					<tr>
						<td>Formulation</td>
						<td><@com.picklistMultiple mixtureCompositions.GeneralInformation.FormulationType /></td>					
					</tr>
					</#if>
					
					<tr>
						<td>Functions (components and additives of product)</td>
						<td><@functionsOfProductComposition mixtureCompositions/></td>					
					</tr>
					
				</#if>
			</#list>
			</#if>
										
		</tbody>
			
	</table>
	
</#compress>
</#macro>
	

<!-- Macros and functions -->
<#macro contactInfoLegalEntity legalEntity>
<#compress>
<#if legalEntity.ContactInfo.ContactAddress.ContactAddress.phone?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.email?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.street1?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.street2?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.zipcode?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.city?has_content || legalEntity.ContactInfo.ContactAddress.ContactAddress.country?has_content>

	<#if legalEntity.GeneralInfo.LegalEntityName?has_content>
	Legal Entity name: <@com.text legalEntity.GeneralInfo.LegalEntityName /><?linebreak?>
	</#if>
	<#if legalEntity.GeneralInfo.LegalEntityType?has_content>
	Legal Entity type: <@com.picklist legalEntity.GeneralInfo.LegalEntityType /><?linebreak?>
	</#if>
	Phone: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.phone /><?linebreak?>
	E-mail: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.email /><?linebreak?>

	Address line 1: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.street1 /><?linebreak?>
	Address line 2: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.street2 /><?linebreak?>
	Postal code: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.zipcode /><?linebreak?>
	Town: <@com.text legalEntity.ContactInfo.ContactAddress.ContactAddress.city /><?linebreak?>
	Country: <@com.picklist legalEntity.ContactInfo.ContactAddress.ContactAddress.country />
	
	<#else>
		<para>No contact information provided</para>	
</#if>
</#compress>
</#macro>	

<#macro functionsOfProductComposition mixtureCompositions>
<#compress>
	<#if mixtureCompositions?has_content>
	<#local componentListComponents = mixtureCompositions.Components.Components/>
		
		<#list componentListComponents as components>
			<#if components.Function?has_content>
			<para><phrase role="#566b4c"><@com.picklist components.Function /></phrase>
			<#if components.Reference?has_content> (for component: <@com.documentReference components.Reference />)</#if></para>
			</#if><#if components_has_next><?linebreak?></#if>
		</#list>
		<#else>
	</#if>
</#compress>
</#macro>

<#macro referenceSubstanceData referenceSubstanceKey>
<#compress>
	<#local refSubst = iuclid.getDocumentForKey(referenceSubstanceKey) />
	<#if refSubst?has_content>
		<@com.text refSubst.GeneralInfo.ReferenceSubstanceName/>
		EC no.: <@com.inventoryECNumber refSubst.Inventory.InventoryEntry/>
  	</#if>
</#compress>
</#macro>


<#-------------PPP additions---------------->
<#macro productIdentity _subject includeTradeNames=true>
	<#compress>

		<#assign docUrl=iuclid.webUrl.entityView(_subject.documentKey)/>
		<para><emphasis role="underline">Name</emphasis>:
			<#if docUrl?has_content>
				<ulink url="${docUrl}"><@com.text _subject.MixtureName/></ulink>
			<#else>
				<@com.text _subject.MixtureName/>
			</#if>
		</para>


		<#if _subject.PublicName?has_content>
			<para><emphasis role="underline">Public name</emphasis>: <@com.text _subject.PublicName/></para>
		</#if>

		<#if _subject.OtherNames?has_content>
			<para><emphasis role="underline">Other identifiers:</emphasis></para>
			<@otherIdentifiersList _subject.OtherNames 'indent'/>
		</#if>

		<#if includeTradeNames>
			<para><emphasis role="underline">Trade names:</emphasis></para>
			<@tradeNames _subject/>
		</#if>

	</#compress>
</#macro>

<#macro tradeNames _subject mixtureComposition=[]>
	<#compress>

		<#if !mixtureComposition?has_content>
			<#local mixtureComposition = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "MixtureComposition") />
		</#if>

		<#if mixtureComposition?has_content>
			<#list mixtureComposition as mixtureComp>
				<#if (mixtureComposition?size>1)><para><emphasis role="bold">Product #{mixtureComp_index+1} - <@com.text mixtureComp.GeneralInformation.Name/></emphasis></para></#if>

				<#if mixtureComp.GeneralInformation.TradeNames?has_content>
					<#list mixtureComp.GeneralInformation.TradeNames as tradeName>
						<para role="indent">
							<@com.text tradeName.TradeName/>
							<#if tradeName.Country?has_content>(<@com.picklistMultiple tradeName.Country/>)</#if>
						</para>
					</#list>
				<#else>
					<para role="indent">No trade names available for this product.</para>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#--macros to be moved to macros_common_general.ftl-->
<#--This macro is the same as in substance_basic_information-->
<#macro otherIdentifiersList otherNamesRepeatableBlock role="">
	<#compress>
		<#if otherNamesRepeatableBlock?has_content>
			<#list otherNamesRepeatableBlock as blockItem>
				<para role="${role}">
					<@com.picklist blockItem.NameType/>: <@com.text blockItem.Name/>
					<#if blockItem.hasElement('Relation') && blockItem.Relation?has_content>
						(<@com.picklist blockItem.Relation/>)
					</#if>
					<@com.picklistMultiple blockItem.Country/>
					<#if blockItem.Remarks?has_content>
						(<@com.text blockItem.Remarks/>)
					</#if>
				</para>
			</#list>
		</#if>
	</#compress>
</#macro>
