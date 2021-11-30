
<!-- Substance Name, Substance Identity, Other names of Substance -->
<#--NOTE: this macro should be reviewed in order to better align PPP and other applications-->
<#macro substanceIdentity _subject>
	<#compress>
	<@com.emptyLine />

		<#if !csrRelevant?? && !pppRelevant?? && !ghsRelevant??>
			<@com.substanceName _subject/>
			<@com.emptyLine/>
		<#elseif pppRelevant??>
			<@substanceInfo _subject/>
		</#if>

		<#local referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		<#if referenceSubstance?has_content>
		<#compress>
				<#if pppRelevant??><para><emphasis role="underline">Names and identifiers of reference substance</emphasis>: </para></#if>
				<@referenceSubstanceInfo referenceSubstance/>
			<#if !pppRelevant??>
				<!-- Structural formula -->
				<@com.structuralFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
			</#if>
		</#compress>
		</#if>

		<#if !pppRelevant??>
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
		</#if>
	</#compress>
</#macro>

<#--NOTE: this function should be improved...-->
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
	<#else>
		<#return true>
	</#if>
	<#return false>
</#function>

<#--NOTE: this macro is repeated. Modifications to be included in macros_common_general.ftl-->
<#macro otherIdentifiersList otherNamesRepeatableBlock role="">
	<#compress>
		<#if otherNamesRepeatableBlock?has_content>
			<#list otherNamesRepeatableBlock as blockItem>
				<para role="${role}">
					<@com.picklist blockItem.NameType/>: <@com.text blockItem.Name/>
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

<#macro substanceInfo substance>

	<para><emphasis role="underline">Name</emphasis>: <@com.substanceName substance/></para>

	<#if substance.PublicName?has_content>
		<para><emphasis role="underline">Public name</emphasis>: <@com.text substance.PublicName/></para>
	</#if>

	<#if substance.OtherNames?has_content>
		<para><emphasis role="underline">Other identifiers:</emphasis></para>
		<@otherIdentifiersList substance.OtherNames 'indent'/>
	</#if>

	<#if substance.TypeOfSubstance?has_content>
		<para>
			<emphasis role="underline">Type of substance:</emphasis>
			<#if substance.TypeOfSubstance.Composition?has_content>
				<@com.picklist substance.TypeOfSubstance.Composition/><#if substance.TypeOfSubstance.Origin?has_content>, </#if>
			</#if>
			<#if substance.TypeOfSubstance.Origin?has_content>
				<@com.picklist substance.TypeOfSubstance.Origin/>
			</#if>
		</para>
	</#if>
</#macro>

<#macro referenceSubstanceInfo referenceSubstance includeMolecularInfo=true title='Substance identity'>
	<#compress>
		<#if referenceSubstanceHasContent(referenceSubstance)>
			<@com.emptyLine/>
			<table border="1">
				<title>${title}</title>
				<col width="35%" />
				<col width="65%" />
				<tbody>
					<#if pppRelevant?? && referenceSubstance.ReferenceSubstanceName?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Name:</emphasis></th>
							<td>
								<@com.text referenceSubstance.ReferenceSubstanceName/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.IupacName?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">IUPAC name:</emphasis></th>
							<td>
								<@com.iupacName referenceSubstance/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.Description?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description:</emphasis></th>
							<td>
								<@com.description referenceSubstance/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.Synonyms.Synonyms?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Synonyms:</emphasis></th>
							<td>
								<@synonyms referenceSubstance/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.Inventory?? && referenceSubstance.Inventory.InventoryEntry?has_content>
						<#local inventoryECNumber><@com.inventoryECNumber referenceSubstance/></#local>
						<#local inventoryECName><@com.inventoryECName referenceSubstance/></#local>
						<#local inventoryECCasNumber><@com.inventoryECCasNumber referenceSubstance/></#local>

						<#if inventoryECNumber?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC number:</emphasis></th>
								<td>
									${inventoryECNumber}
								</td>
							</tr>
						</#if>
						<#if inventoryECName?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">EC name:</emphasis></th>
								<td>
									${inventoryECName}
								</td>
							</tr>
						</#if>
						<#if inventoryECCasNumber?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number (EC inventory):</emphasis></th>
								<td>
									${inventoryECCasNumber}
								</td>
							</tr>
						</#if>
					</#if>
					<#if referenceSubstance.Inventory.CASNumber?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS number:</emphasis></th>
							<td>
								<@com.casNumber referenceSubstance />
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.Inventory.CASName?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">CAS name:</emphasis></th>
							<td>
								<@com.casName referenceSubstance/>
							</td>
						</tr>
					</#if>
					<#if includeMolecularInfo>
						<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularFormula?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular formula:</emphasis></th>
								<td>
									<@com.molecularFormula referenceSubstance/>
								</td>
							</tr>
						</#if>
						<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular weight:</emphasis></th>
								<td>
									<@com.molecularWeight referenceSubstance/>
								</td>
							</tr>
						</#if>
						<#if pppRelevant??>
							<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.SmilesNotation?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">SMILES:</emphasis></th>
									<td>
										<@com.smilesNotation referenceSubstance/>
									</td>
								</tr>
							</#if>
							<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.InChl?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">InChI:</emphasis></th>
									<td>
										<@com.inchi referenceSubstance/>
									</td>
								</tr>
							</#if>
							<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.StructuralFormula?has_content>
								<tr>
									<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Structural formula:</emphasis></th>
									<td>
										<@com.structuralFormula referenceSubstanceID=referenceSubstance imageWidthPerc=100 printTitle=false/>
									</td>
								</tr>
							</#if>
						</#if>
					</#if>
				</tbody>
			</table>

		<#else>
			<@com.emptyLine/>
			<table border="0">
				<title>${title}</title>
				<col width="100%" />
				<tbody><tr><td>No information available</td></tr></tbody>
			</table>
		</#if>
	</#compress>
</#macro>

<#macro molecularAndStructuralInfo _subject>
	<#compress>

		<#assign referenceSubstance = iuclid.getDocumentForKey(_subject.ReferenceSubstance.ReferenceSubstance) />
		<#if referenceSubstance?has_content && referenceSubstance.MolecularStructuralInfo?has_content>
			<table border="1">
				<title>Molecular and structural information of the substance</title>
				<col width="35%" />
				<col width="65%" />
				<tbody>
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
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Molecular weight:</emphasis></th>
							<td>
								<@com.molecularWeight com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.SmilesNotation?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">SMILES:</emphasis></th>
							<td>
								<@com.smilesNotation com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.InChl?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">InChI:</emphasis></th>
							<td>
								<@com.inchi com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.StructuralFormula?has_content>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Structural formula:</emphasis></th>
							<td>
								<@com.structuralFormula com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) 100 false/>
							</td>
						</tr>
					</#if>
				</tbody>
			</table>

			<#if referenceSubstance.MolecularStructuralInfo?? && referenceSubstance.MolecularStructuralInfo.Remarks?has_content>
				<para><emphasis role="bold">Remarks:</emphasis></para>
				<para>
					<@com.molecularStructuralRemarks com.getReferenceSubstanceKey(_subject.ReferenceSubstance.ReferenceSubstance) />
				</para>
			</#if>
		<#else>
			<table border="0">
				<title>Molecular and structural information of the substance</title>
				<col width="100%" />
				<tbody><tr><td>No information available</td></tr></tbody>
			</table>
		</#if>
	</#compress>
</#macro>

<#--Macro still to be merged with macros_common_general-->
<#macro synonyms referenceSubstanceID>
	<#compress>

		<#if referenceSubstanceID?has_content && referenceSubstanceID.Synonyms.Synonyms?has_content>

			<#if !pppRelevant??><para>Synonyms</para></#if>
			<#list referenceSubstanceID.Synonyms.Synonyms as synonyms>
				<#if synonyms?has_content>

					<para>
						<#if synonyms.Identifier?has_content>
							<#if !csrRelevant?? && !pppRelevant??>Synonym identifier:</#if>
							<@com.picklist synonyms.Identifier/><#if csrRelevant?? && !pppRelevant??>:</#if>
						</#if>

						<#if synonyms.Name?has_content>
							<#if !csrRelevant?? && !pppRelevant??>Synonym name/identity:</#if> <@com.text synonyms.Name/>
						</#if>

						<#if pppRelevant??>
							<#if synonyms.Remarks?has_content>
								(<@com.text synonyms.Remarks/>)
							</#if>
						</#if>
					</para>

					<#if synonyms.Remarks?has_content>
						<#if !csrRelevant?? && !pppRelevant??>
							<para>Synonym remarks: <@com.text synonyms.Remarks/></para>
						</#if>
					</#if>

					<#if synonyms_has_next><?linebreak?></#if>

				<#else>
					No synonyms provided
				</#if>
			</#list>
		</#if>

	</#compress>
</#macro>