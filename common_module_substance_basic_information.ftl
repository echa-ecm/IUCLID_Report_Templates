
<!-- Substance Name, Substance Identity, Other names of Substance -->
<#macro substanceIdentity _subject>
<#compress>

	<#if !csrRelevant??>
		<@com.substanceName _subject/>
		<@com.emptyLine/>	
	</#if>	
	
	<#assign referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		<#if referenceSubstance?has_content>
		<#if referenceSubstanceHasContent(referenceSubstance)>
		<@com.emptyLine/>
		<table border="1">
			<title>Substance identity</title>
			<col width="35%" />
			<col width="65%" />
			<tbody>
				<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC number:</emphasis></th>
					<td>						
						<@com.inventoryECNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>						
					</td>
				</tr>
				</#if>
				<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC name:</emphasis></th>
					<td>
						<@com.inventoryECName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
					</td>
				</tr>
				</#if>
				<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number (EC inventory):</emphasis></th>
					<td>
						<@com.inventoryECCasNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
					</td>
				</tr>
				</#if>
				<#if referenceSubstance?? && referenceSubstance.Inventory.CASNumber?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number:</emphasis></th>
						<td>
							<@com.casNumber com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
						</td>
					</tr>
				</#if>
				<#if referenceSubstance?? && referenceSubstance.Inventory.CASName?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS name:</emphasis></th>
						<td>
							<@com.casName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
				</#if>
				<#if referenceSubstance?? && referenceSubstance.IupacName?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">IUPAC name:</emphasis></th>
						<td>
							<@com.iupacName com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
				</#if>
				<#if referenceSubstance?? && referenceSubstance.Description?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description:</emphasis></th>
						<td>
							<@com.description com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
				</#if>
				<#if referenceSubstance?? && referenceSubstance.Synonyms.Synonyms?has_content>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Synonyms:</emphasis></th>
					<td>
						<@com.synonyms com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
					</td>
				</tr>
				</#if>
				<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularFormula?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular formula:</emphasis></th>
						<td>
							<@com.molecularFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
				</#if>
				<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular weight range:</emphasis></th>
						<td>
							<@com.molecularWeight com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
				</#if>
			</tbody>
		</table>
		<#else>
			<@com.emptyLine/>
			<table border="0">
				<title>Substance identity</title>
				<col width="100%" />
				<tbody><tr><td>No information available</td></tr></tbody>
			</table>
		</#if>
		
		<!-- Structural formula -->
		<@com.structuralFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
	
	</#if>
	
	<#if _subject.OtherNames?has_content>
		<para>Other identifiers:</para>
		<@com.otherIdentifiersList _subject.OtherNames/>
	</#if>
	
	<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.Remarks?has_content>
		<para><emphasis role="bold">Remarks:</emphasis></para>
		<para>
			<@com.molecularStructuralRemarks com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
			<@com.emptyLine/>
		</para>
	</#if>
	
</#compress>
</#macro>

<#function referenceSubstanceHasContent refSubstance>
	<#if refSubstance.Inventory?? && refSubstance.Inventory.InventoryEntry?has_content>
		<#return true>
	</#if>
	<#if refSubstance?? && (
		refSubstance.Inventory.CASNumber?has_content ||
		refSubstance.Inventory.CASName?has_content ||
		refSubstance.IupacName?has_content ||
		refSubstance.Description?has_content ||
		refSubstance.Synonyms.Synonyms?has_content)>
		<#return true>
	</#if>
	<#if refSubstance.MolecularStructuralInfo?? && (
		refSubstance.MolecularStructuralInfo.MolecularFormula?has_content ||
		refSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content)>
		<#return true>
	</#if>

	<#return false>
</#function>


<#function isNotRelevant notRelevant>
<#if notRelevant==csrRelevant>
	<#return false>
	<else>
		<#return true>
</#if>
	<#return false>
</#function>


<#macro otherIdentifiersList otherNamesRepeatableBlock>
<#compress>
	<#if otherNamesRepeatableBlock?has_content>
		<#list otherNamesRepeatableBlock as blockItem>
			<para>
				<@com.picklist blockItem.NameType/> <@com.text blockItem.Name/> 
				<#if blockItem.Relation?has_content>
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