<!-- APPENDIX: Information on Test Material -->

<#list com.removeDocumentDuplicates(studyandsummaryCom.testMaterialInformations) as testMaterial>
	<para xml:id="${testMaterial.documentKey.uuid!}">
		Test material: <emphasis role="bold"><@com.text testMaterial.Name/></emphasis>
		<?linebreak?>
		Form: <emphasis role="bold"><@com.picklist testMaterial.Composition.OtherCharacteristics.TestMaterialForm/></emphasis>
	</para>
	
	<#if testMaterial.Composition.CompositionList?has_content>
		<informaltable border="1">
			<col width="25%" />
			<col width="35%" />
			<col width="40%" />
			<tbody>
				<#list testMaterial.Composition.CompositionList as blockItem>
					<tr>
						<td>
							<emphasis role="bold">Composition type:</emphasis> <@com.picklist blockItem.Type/>
						</td>
						<td>
							<emphasis role="bold">Reference substance:</emphasis>
							<#assign refSubst = iuclid.getDocumentForKey(blockItem.ReferenceSubstance) />
							<#if refSubst?has_content>
								<@com.text refSubst.ReferenceSubstanceName/>
								<?linebreak?>
								EC no.: <@com.inventoryECNumber refSubst.Inventory.InventoryEntry/>
								<?linebreak?>
								CAS no: <@com.text refSubst.Inventory.CASNumber/>
								<?linebreak?>
								IUPAC name: <@com.text refSubst.IupacName/>
							</#if>
						</td>
						<td>
							<emphasis role="bold">Concentration range:</emphasis> <@com.range blockItem.Concentration/>
							<para>
							<#if blockItem.Remarks?has_content>
								Additional information:
								<@com.text blockItem.Remarks/>
							</#if>
							</para>
						</td>
					</tr>
				</#list>
			</tbody>
		</informaltable>
  	</#if>
	
	<#if testMaterial.Composition.CompositionPurityOtherInformation?has_content>
	<para>
		Composition / purity: <@com.picklist testMaterial.Composition.CompositionPurityOtherInformation/>
	</para>
	</#if>
	
	<#if testMaterial.Composition.OtherCharacteristics.DetailsOnTestMaterial?has_content>
	<para>
		Details on test material: 
		<@com.text testMaterial.Composition.OtherCharacteristics.DetailsOnTestMaterial/>
		<?linebreak?>
	</para>
	</#if>
	
	<@com.emptyLine/>
</#list>
