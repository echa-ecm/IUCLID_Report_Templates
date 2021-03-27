<!-- Active substance identity derived from the Mixture/Product component and based on Function 'active substance' -->
<#macro activeSubstanceIdentity activeSubstances>
<#compress>
			
		<!-- Active substance **ID from ref substance -->
		<#assign referenceSubstance = iuclid.getDocumentForKey(activeSubstances.ReferenceSubstance.ReferenceSubstance) />			
		<#if referenceSubstance?has_content>
			<@com.emptyLine/>
			<table border="1">
				<title>Active substance identity</title>
				<col width="35%" />
				<col width="65%" />
				<tbody>
					<#if referenceSubstance.Inventory?has_content && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">EC number</emphasis></th>
						<td>						
							<@com.inventoryECNumber com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)
							 />							
						</td>
					</tr>
					</#if>
					<#if referenceSubstance.Inventory?has_content && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">EC name</emphasis></th>
						<td>
							<@com.inventoryECName com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)
							 />
						</td>
					</tr>
					</#if>
					<#if referenceSubstance.Inventory?has_content && referenceSubstance.Inventory.InventoryEntry?has_content>
					<tr>
						<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">CAS number (EC inventory)</emphasis></th>
						<td>
							<@com.inventoryECCasNumber com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)
							 />
						</td>
					</tr>
					</#if>
					<#if referenceSubstance?has_content && referenceSubstance.Inventory.CASNumber?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">CAS number</emphasis></th>
							<td>
								<@com.casNumber com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance) />
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?has_content && referenceSubstance.Inventory.CASName?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">CAS name</emphasis></th>
							<td>
								<@com.casName com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?has_content && referenceSubstance.IupacName?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">IUPAC name</emphasis></th>
							<td>
								<@com.iupacName com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if activeSubstances.OtherNames?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Other identifiers</emphasis></th>
							<td>
								<@com.otherIdentifiersList activeSubstances.OtherNames/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?has_content && referenceSubstance.Description?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Description</emphasis></th>
							<td>
								<@com.description com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance?has_content && referenceSubstance.Synonyms?has_content>
					<tr>
						<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Synonyms</emphasis></th>
						<td>
							<@com.synonyms com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
						</td>
					</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?has_content && referenceSubstance.MolecularStructuralInfo.MolecularFormula?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Molecular formula</emphasis></th>
							<td>
								<@com.molecularFormula com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>
					<#if referenceSubstance.MolecularStructuralInfo?has_content && referenceSubstance.MolecularStructuralInfo.MolecularWeightRange?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Molecular weight range</emphasis></th>
							<td>
								<@com.molecularWeight com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance)/>
							</td>
						</tr>
					</#if>					
					<#if referenceSubstance.MolecularStructuralInfo.StructuralFormula?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Structural formula</emphasis></th>
							<td><@com.structuralFormula com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance) /></td>
						</tr>					
					</#if>
		
					<#if referenceSubstance.MolecularStructuralInfo.Remarks?has_content>
						<tr>
							<th><?dbfo bgcolor="#F0F0F0"?><emphasis role="bold">Remarks on molecular structure</emphasis></th>
							<td><@com.molecularStructuralRemarks com.getReferenceSubstanceKey(activeSubstances.ReferenceSubstance.ReferenceSubstance) /></td>	
						</tr>
					</#if>
				</tbody>
			</table>
			<#else>
				<@com.emptyLine/>
				<table border="0">
					<title>Active substance identity</title>
					<col width="100%" />
					<tbody><tr><td>No reference substance information provided for the Active substance</td></tr></tbody>
				</table>
		</#if>
</#compress>
</#macro>
		
<!-- Active substance composition derived from the Mixture/Product component and based on Function 'active substance' -->
<#macro activeSubstanceComposition activeSubstances>
<#compress>

		<#assign activeSubstanceComposition = iuclid.getSectionDocumentsForParentKey(activeSubstances.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />
		<#if activeSubstanceComposition?has_content>
		<#list activeSubstanceComposition as activeSubstanceCompositions>
		<#if activeSubstanceCompositions?has_content>
		
		<table border="1">
			<title>Composition of the Active Substance (<@com.text activeSubstanceCompositions.name/>)</title>			
			<col width="50%" />
			<col width="50%" />	
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#A9A9A9"?><para>Common name: <@com.text activeSubstances.ChemicalName /></para></th>
					
					<th><?dbfo bgcolor="#A9A9A9"?>
					<@com.synonyms referenceSubstance />
					</th>					
				</tr>
					
				<#if activeSubstanceCompositions.DegreeOfPurity.Purity?has_content>
					<tr>
						<td>
							<para>Degree of purity<#if activeSubstanceCompositions.GeneralInformation.Name?has_content> for <@com.text activeSubstanceCompositions.GeneralInformation.Name/><#else> for <@com.text activeSubstanceCompositions.name/></#if>
							</para>
						</td>
						
						<td><para><@com.range activeSubstanceCompositions.DegreeOfPurity.Purity/></para>
						</td>						
					</tr>
					<#else><tr>
					<td colspan="2"><emphasis>No degree of purity provided<#if activeSubstanceCompositions.GeneralInformation.Name?has_content> for <@com.text activeSubstanceCompositions.GeneralInformation.Name/><#else> for <@com.text activeSubstanceCompositions.name/></#if></emphasis></td>	</tr>
				</#if>
					
					<#assign constituentsList = activeSubstanceCompositions.Constituents.Constituents />
					<#if constituentsList?has_content>
					<#list constituentsList as constituents>
					<#if constituents?has_content>
						<tr><?dbfo bgcolor="#C0C0C0"?> 	
							<td colspan="2">Constituents<#if activeSubstanceCompositions.GeneralInformation.Name?has_content> for <emphasis role="bold"><@com.text activeSubstanceCompositions.GeneralInformation.Name /></emphasis></#if></td>
						</tr>
						
						<tr>
							<td>CAS number</td>
							<td><@com.casNumber com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>EC number</td>
							<td><@com.inventoryECNumber com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>IUPAC (CA name)</td>
							<td><@com.iupacName com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>CIPAC</td>
							<td></td>
						</tr>
						
						<tr><?dbfo bgcolor="#F0F0F0"?>
						<td colspan="2">Molecular and structural formula, molecular mass of the active substance</td> 
						</tr>
						
						<tr>
							<td>Molecular formula</td>
							<td><@com.molecularFormula com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
												
						<tr>
							<td>Molecular weight</td>
							<td><@com.molecularWeight com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>Structural formula</td>
							<td><@com.structuralFormula com.getReferenceSubstanceKey(constituents.ReferenceSubstance) /></td>
						</tr>
					</#if>
					</#list>
					</#if>
					
					<#assign additivesList = activeSubstanceCompositions.Additives.Additives />
					<#if additivesList?has_content>
					<#list additivesList as additives>
					<#if additives?has_content>							
						<tr><?dbfo bgcolor="#C0C0C0"?> 
							<td colspan="2">Additives<#if activeSubstanceCompositions.GeneralInformation.Name?has_content> for <emphasis role="bold"><@com.text activeSubstanceCompositions.GeneralInformation.Name /></emphasis></#if></td>
						</tr>
							
						<tr>
							<td>CAS number</td>
							<td><@com.casNumber com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>EC number</td>
							<td><@com.inventoryECNumber com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>IUPAC (CA name)</td>
							<td><@com.iupacName com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>CIPAC</td>
							<td></td>
						</tr>
						
						<tr><?dbfo bgcolor="#F0F0F0"?>
						<td colspan="2">Molecular and structural formula, molecular mass of the active substance
						</td> 
						</tr>
						
						<tr>
							<td>Molecular formula</td>
							<td><@com.molecularFormula com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
												
						<tr>
							<td>Molecular weight</td>
							<td><@com.molecularWeight com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>Structural formula</td>
							<td><@com.structuralFormula com.getReferenceSubstanceKey(additives.ReferenceSubstance) /></td>
						</tr>
					</#if>
					</#list>
					</#if>
					
					
					<#assign impuritiesList = activeSubstanceCompositions.Impurities.Impurities />
					<#if impuritiesList?has_content>
					<#list impuritiesList as impurities>
					<#if impurities?has_content>					
						<tr><?dbfo bgcolor="#C0C0C0"?> 
							<td colspan="2">Impurities<#if activeSubstanceCompositions.GeneralInformation.Name?has_content> for <emphasis role="bold"><@com.text activeSubstanceCompositions.GeneralInformation.Name /></emphasis></#if></td>
						</tr>
							
						<tr>
							<td>CAS number</td>
							<td><@com.casNumber com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>EC number</td>
							<td><@com.inventoryECNumber com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>IUPAC (CA name)</td>
							<td><@com.iupacName com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>CIPAC</td>
							<td></td>
						</tr>
						
						<tr><?dbfo bgcolor="#F0F0F0"?>
						<td colspan="2">Molecular and structural formula, molecular mass of the active substance
						</td> 
						</tr>
						
						<tr>
							<td>Molecular formula</td>
							<td><@com.molecularFormula com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
												
						<tr>
							<td>Molecular weight</td>
							<td><@com.molecularWeight com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
						
						<tr>
							<td>Structural formula</td>
							<td><@com.structuralFormula com.getReferenceSubstanceKey(impurities.ReferenceSubstance) /></td>
						</tr>
					</#if>
					</#list>
					</#if>				
			</tbody>				
		</table>
				
		</#if>
		</#list>
		</#if>
				
</#compress>
</#macro>


<!-- Macros and functions -->
