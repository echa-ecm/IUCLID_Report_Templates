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
			
			<#if ghsRelevant??><para></para>
			<#else>		
				<tr>
					<td>Producer of the plant protection product</td>				
					<td></td>					
				</tr>
			</#if>

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

<#assign referenceSubstancesInformation = [] />

<#macro referenceSubstanceData referenceSubstanceKey>
	<#compress>
		<#local refSubst = iuclid.getDocumentForKey(referenceSubstanceKey) />
		<#if refSubst?has_content>
			<#if pppRelevant??>
				<command linkend="${refSubst.documentKey.uuid!}"><@com.text refSubst.ReferenceSubstanceName/></command>
				<#assign referenceSubstancesInformation = com.addDocumentToSequenceAsUnique(refSubst, referenceSubstancesInformation) />
			<#else>
				<@com.text refSubst.GeneralInfo.ReferenceSubstanceName/>
				EC no.: <@com.inventoryECNumber refSubst.Inventory.InventoryEntry/>
			</#if>
		</#if>
	</#compress>
</#macro>

<#-------------PPP additions---------------->
<#macro productIdentity _subject includeTradeNames=true>
	<#compress>

		<para><emphasis role="underline">Name</emphasis>:
			<@mixtureName _subject/>
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

<#macro mixtureComposition _subject>
	<#compress>

		<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "MixtureComposition") />
		<#if !(recordList?has_content)>
			No relevant information available.
		<#else>

			<#list recordList as record>

				<para>
					<emphasis role="HEAD-WoutNo">
						<#if (recordList?size>1)>Composition #{record_index+1}:</#if>

						<#if record.GeneralInformation.Name?has_content><@com.text record.GeneralInformation.Name/><#else><@com.text record.name/></#if>
					</emphasis>
				</para>

				<#if record.GeneralInformation.TradeNames?has_content>
					<para><emphasis role="underline">Trade names:</emphasis> <@tradeNames _subject=_subject mixtureComposition=[record]/></para>
				</#if>

				<#if record.GeneralInformation.Description?has_content>
					<para><emphasis role="underline">Description:</emphasis></para>
					<para role="indent"><@com.text record.GeneralInformation.Description/></para>
				</#if>

				<#if record.GeneralInformation.FormulationType?has_content>
					<para><emphasis role="underline">Formulation type:</emphasis> <@com.picklistMultiple record.GeneralInformation.FormulationType/></para>
				</#if>


				<!-- Components -->
				<#assign itemList = record.Components.Components />
				<#if itemList?has_content>
					<@com.emptyLine/>
					<table border="1">
						<title>Components
							<#if record.GeneralInformation.Name?has_content>
								(<@com.text record.GeneralInformation.Name/>)</#if></title>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<tbody>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Constituent</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Function</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Typical concentration</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Concentration range</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
						</tr>
						<#list itemList as item>
							<tr>
								<td>
									<#--NOTE: this can be a substance, a reference substance or even a mixture-->
									<@componentId item.Reference/>
								</td>
								<td>
									<@com.picklist item.Function/>
								</td>
								<td>
									<@com.value item.TypicalConcentration/>
								</td>
								<td>
									<@com.range item.ConcentrationRange/>
								</td>
								<td>
									<#if item.SubstanceOfConcern><emphasis role="bold">Substance of concern</emphasis><?linebreak?></#if>
									<#if item.Gci><emphasis>Generic component identifier (CGI)</emphasis><?linebreak?></#if>
									<#if item.Icg><emphasis>Interchangeable component group (ICG)</emphasis><?linebreak?></#if>
									<#if item.Sfc><emphasis>Standard formula (SF) component</emphasis><?linebreak?></#if>
									<#if item.SubstanceGeneratedInSitu><emphasis>Substance generated in situ</emphasis><?linebreak?></#if>

									<@com.text item.Remarks/>
								</td>
							</tr>
						</#list>
						</tbody>
					</table>
				</#if>
				<@com.emptyLine/>
			</#list>
		</#if>

	</#compress>
</#macro>

<#--NOTE: to consider if this should be more detailed in case of mixtures/substances-->
<#macro componentId link>
	<#compress>
		<#if link?has_content>
			<#local component=iuclid.getDocumentForKey(link)/>
			<#if component?has_content>
				<#if component.documentType=="MIXTURE">
					mixture <@mixtureName component/>
				<#elseif component.documentType=="SUBSTANCE">
					substance <@com.substanceName component/>
					<#if component.ReferenceSubstance.ReferenceSubstance?has_content>
						(ref. <@componentId component.ReferenceSubstance.ReferenceSubstance/>)
					</#if>
				<#elseif component.documentType=="REFERENCE_SUBSTANCE">
					<@referenceSubstanceData link/>
				</#if>
			</#if>

		</#if>
	</#compress>
</#macro>

<#--This macro extracts the function from the ENDPOINT_STUDY_RECORD.EffectivenessAgainstTargetOrganisms of section 3.2-->
<#macro functionsOfMixture _subject>
	<#compress>

		<#local functionList=[]/>

		<#local recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_STUDY_RECORD", "EffectivenessAgainstTargetOrganisms") />
		<#if recordList?has_content>
			<#list recordList as record>
				<#if record.GeneralInformation.InformationOnIntendedUseAndApplication.FunctionAddressed?has_content>
					<#list record.GeneralInformation.InformationOnIntendedUseAndApplication.FunctionAddressed as functionEntry>
						<#local function><@com.picklist functionEntry/></#local>
						<#if !functionList?seq_contains(function)>
							<#local functionList=functionList + [function]/>
						</#if>
					</#list>
				</#if>
			</#list>
		</#if>

		<#if functionList?has_content>
			${functionList?join(", ")}
		<#else>
			No information on function available.
		</#if>
	</#compress>

</#macro>
<#--macros to be moved to macros_common_general.ftl-->

<#--This macro is the same as in substance_basic_information but with the "hasElement" clause-->
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
