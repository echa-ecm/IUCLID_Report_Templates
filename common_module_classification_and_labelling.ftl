
<!-- Classification and labelling information -->
<#macro classificationAndLabellingTable _subject>
<#compress>

<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "Ghs") />

	<#if !recordList?has_content>
		No relevant information available.
		<@com.emptyLine/> 
	<#else/>
		<@com.emptyLine/>
		<#list recordList as record>			
			
			<#if csrRelevant??>
				<para>
					<@com.emptyLine/>
					<emphasis role="bold"><emphasis role="underline">Substance: <@classificationSubstanceName record _subject/></emphasis></emphasis>
				</para>
				
				<para>
					<emphasis role="bold">Implementation:</emphasis> <@com.picklist record.GeneralInformation.Implementation/>
				</para>
				
				<#if record.GeneralInformation.Remarks?has_content>
					<para>
						<emphasis role="bold">Remarks:</emphasis> <@com.richText record.GeneralInformation.Remarks/>
					</para>
				</#if>
				
				<#if record.GeneralInformation.RelatedCompositions.Composition?has_content>
					<para>
						<emphasis role="underline">Related composition: <@com.documentReferenceMultiple record.GeneralInformation.RelatedCompositions.Composition/></emphasis>
					</para>
				</#if>
				
				<#elseif csrRelevant?? || genericRelevant??>
				
					<#if record.GeneralInformation.NotClassified>
						<para>					
							The substance is not classified
						</para>
					<#else/>
						<para>
							The substance is classified as follows: 
						</para>
					</#if>
					
			</#if>		
	
		<@com.emptyLine/>
		<table border="1">
			
				<#if nzEPArelevant??>
				<title>Classification according to GHS for physicochemical properties</title>
				<#else>
				<title>Classification and labelling according to CLP / GHS for physicochemical properties</title>
				</#if>
			<col width="20%" />
			<col width="25%" />
			<col width="30%" />
			<col width="25%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard class</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard category</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard statement</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Reason for no classification</emphasis></th>
				</tr>
				
				<#assign classToBlockMap = {
					"Explosives:" : record.Classification.PhysicalHazards.Explosives,
					"Desensitised explosives:" : record.Classification.PhysicalHazards.DesensitizedExplosives,
					"Flammable gases and chemically unstable gases:" : record.Classification.PhysicalHazards.FlammableGases,
					"Aerosols:" : record.Classification.PhysicalHazards.FlammableAerosols,					
					"Chemicals under Pressure:" : record.Classification.PhysicalHazards.ChemicalsUnderPressure,					
					"Oxidising gases:" : record.Classification.PhysicalHazards.OxidisingGases,
					"Gases under pressure:" : record.Classification.PhysicalHazards.GasesPres,
					"Flammable liquids:" : record.Classification.PhysicalHazards.FlammableLiquids,
					"Flammable solids:" : record.Classification.PhysicalHazards.FlammableSolids,
					"Self-reactive substances and mixtures:" : record.Classification.PhysicalHazards.SelfReactiveSubstMixt,
					"Pyrophoric liquids:" : record.Classification.PhysicalHazards.PyrophoricLiquids,
					"Pyrophoric solids:" : record.Classification.PhysicalHazards.PyrophoricSolids,
					"Self-heating substances and mixtures:" : record.Classification.PhysicalHazards.SelfHeatSubstMixt,
					"Substances and mixtures which in contact with water emit flammable gases:" : record.Classification.PhysicalHazards.SubstMixtWater,
					"Oxidising liquids:" : record.Classification.PhysicalHazards.OxidisingLiquids,
					"Oxidising solids:" : record.Classification.PhysicalHazards.OxidisingSolids,
					"Organic peroxides:" : record.Classification.PhysicalHazards.OrganicPeroxides,
					"Corrosive to metals:" : record.Classification.PhysicalHazards.CorMetals
				}/>
				<#assign hazardClasses = classToBlockMap?keys />
				
				<#list hazardClasses as hazardClass>
					<#assign block = classToBlockMap[hazardClass] />
					
					<#if isNotEmptyClassificationBlock(block)>
						<tr>
							<!-- Hazard class -->
							<td>
								${hazardClass!}
							</td>
							<!-- Hazard category -->
							<td>
								<@com.picklist block.HazardCategory/>
							</td>
							<!-- Hazard statement -->
							<td>
								<@com.picklist block.HazardStatement/>
							</td>
							<!-- Reason for no classification -->
							<td>
								<@com.picklist block.ReasonForNoClassification/> 
							</td>
						</tr>
					</#if>
				</#list>
			</tbody>
		</table>
				
		<@com.emptyLine/>
		<table border="1">
			<title>Classification and labelling according to CLP / GHS for health hazards</title>
			<col width="20%" />
			<col width="25%" />
			<col width="30%" />
			<col width="25%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard class</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard category</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard statement</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Reason for no classification</emphasis></th>
				</tr>
				
				<#assign classToBlockMap = {
					"Acute toxicity - oral:" : record.Classification.HealthHazards.AcuteToxicityOral,
					"Acute toxicity - dermal:" : record.Classification.HealthHazards.AcuteToxicityDermal,
					"Acute toxicity - inhalation:" : record.Classification.HealthHazards.AcuteToxicityInhalation,
					"Skin corrosion / irritation:" : record.Classification.HealthHazards.Irritation,
					"Serious damage / eye irritation:" : record.Classification.HealthHazards.EyeIrritation,
					"Respiratory sensitisation:" : record.Classification.HealthHazards.RespiratorySensitisation,
					"Skin sensitisation:" : record.Classification.HealthHazards.SkinSensitisation,
					"Aspiration hazard:" : record.Classification.HealthHazards.AspirationHazard,
					"Reproductive Toxicity:" : record.Classification.HealthHazards.ReproductiveToxicity.ReproductiveToxicity,
					"Reproductive Toxicity: Effects on or via lactation:" : record.Classification.HealthHazards.ReproductiveToxicity.Effects,
					"Germ cell mutagenicity:" : record.Classification.HealthHazards.GermCell.GermCell,
					"Carcinogenicity:" : record.Classification.HealthHazards.Carcinogenicity.Carcinogenicity
				}/>
				<#assign hazardClasses = classToBlockMap?keys />
				
				<#list hazardClasses as hazardClass>
					<#assign block = classToBlockMap[hazardClass] />
					<#if isNotEmptyClassificationBlock(block)>
						<tr>
							<!-- Hazard class -->
							<td>
								${hazardClass!}
							</td>
							<!-- Hazard category -->
							<td>
								<@com.picklist block.HazardCategory/>
								<#if block.hasElement("SpecificEffect") && block.SpecificEffect?has_content>
									<para>
										Specific effect: <@com.text block.SpecificEffect/>
									</para>
								</#if>
								<#if block.hasElement("RouteExposure") && block.RouteExposure?has_content>
									<para>
										Route of exposure: <@com.picklistMultiple block.RouteExposure/>
									</para>
								</#if>
							</td>
							<!-- Hazard statement -->
							<td>
								<@com.picklist block.HazardStatement/>
							</td>
							<!-- Reason for no classification -->
							<td>
								<@com.picklist block.ReasonForNoClassification/> 
							</td>
						</tr>
					</#if>
				</#list>
				
				<#assign usespan = true />
				<#list record.Classification.HealthHazards.ToxicitySingle.Toxicity as item>
					<tr>
						<!-- Hazard class -->
						<#if usespan>
							<td rowspan="${record.Classification.HealthHazards.ToxicitySingle.Toxicity?size}">
								Specific target organ toxicity – single exposure:
							</td>
							<#assign usespan = false />
						</#if>
						<!-- Hazard category -->
						<td>
							<para>
								<@com.picklist item.Toxicity.HazardCategory/> 
							</para>
							<para>
								<#if item.Toxicity.AffectedOrgans?has_content>
								Affected organs: <@com.picklistMultiple item.Toxicity.AffectedOrgans/>
								</#if>
							</para>
							<para>
								<#if item.Toxicity.RouteExposure?has_content>
								Route of exposure: <@com.picklistMultiple item.Toxicity.RouteExposure/> 
								</#if>
							</para>
						</td>
						<!-- Hazard statement -->
						<td>
							<@com.picklist item.Toxicity.HazardStatement/>
						</td>
						<!-- Reason for no classification -->
						<td>
							<@com.picklist item.Toxicity.ReasonForNoClassification/>
						</td>
					</tr>
				</#list>
				
				<#assign usespan = true />
				<#list record.Classification.HealthHazards.ToxicityRepeated.Toxicity as item>
					<tr>
						<!-- Hazard class -->
						<#if usespan>
							<td rowspan="${record.Classification.HealthHazards.ToxicityRepeated.Toxicity?size}">
								Specific target organ toxicity – repeated exposure:
							</td>
							<#assign usespan = false />
						</#if>
						<!-- Hazard category -->
						<td>
							<para>
								<@com.picklist item.Toxicity.HazardCategory/> 
							</para>
							<para>
								<#if item.Toxicity.AffectedOrgans?has_content>
								Affected organs: <@com.picklistMultiple item.Toxicity.AffectedOrgans/>
								</#if>								
							</para>
							<para>
								<#if item.Toxicity.RouteExposure?has_content>
								Route of exposure: <@com.picklistMultiple item.Toxicity.RouteExposure/> 
								</#if>
							</para>
						</td>
						<!-- Hazard statement -->
						<td>
							<@com.picklist item.Toxicity.HazardStatement/>
						</td>
						<!-- Reason for no classification -->
						<td>
							<@com.picklist item.Toxicity.ReasonForNoClassification/>
						</td>
					</tr>
				</#list>
			</tbody>
		</table>		
		
		<#list record.Classification.SpecificConcentrations.ConcentrationRange as item>
			<#if isNotEmptyConcentrationBlock(item)>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Specific concentration limits:</emphasis>
				</para>
				
				<informaltable border="1">
					<col width="30%" />
					<col width="70%" />
					<tbody>
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Concentration (%)</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Classification</emphasis></th>
						</tr>							
						<tr>
							<!-- Concentration (%) -->
							<td>
								<@com.range item.ConcentrationRangeVal/>					
							</td>
							<!-- Classification -->
							<td>
								<@com.picklistMultiple item.HazardCategories/>
							</td>
						</tr>
					</tbody>
				</informaltable>
			</#if>
		</#list>			
		
		<@com.emptyLine/>
		<table border="1">
			<title>Classification and labelling according to CLP / GHS for environmental hazards</title>
			<col width="24%" />
			<col width="21%" />
			<col width="30%" />
			<col width="25%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard class</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard category</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Hazard statement</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Reason for no classification</emphasis></th>
				</tr>
				
				<#if isNotEmptyClassificationBlock(record.Classification.EnvironmentalHazards.AquaticEnvironment.AcuteShortTerm)>
					<tr>
						<!-- Hazard class -->
						<td>
							Hazards to the aquatic environment (acute/short-term):
						</td>
						<!-- Hazard category -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.AcuteShortTerm.HazardCategory/>
						</td>
						<!-- Hazard statement -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.AcuteShortTerm.HazardStatement/>
						</td>
						<!-- Reason for no classification -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.AcuteShortTerm.ReasonForNoClassification/> 
						</td>
					</tr>
				</#if>
				
				<#if isNotEmptyClassificationBlock(record.Classification.EnvironmentalHazards.AquaticEnvironment.LongTerm)>
					<tr>
						<!-- Hazard class -->
						<td>
							Hazards to the aquatic environment (chronic/long-term):
						</td>
						<!-- Hazard category -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.LongTerm.HazardCategory/>
						</td>
						<!-- Hazard statement -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.LongTerm.HazardStatement/>
						</td>
						<!-- Reason for no classification -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.AquaticEnvironment.LongTerm.ReasonForNoClassification/> 
						</td>
					</tr>
				</#if>
				
				<!-- M-Factor acute -->
				<tr>
					<td colspan="4">
						M-Factor acute: <@com.number record.Classification.EnvironmentalHazards.AquaticEnvironment.MFactor.MFactorAcute/>
					</td>
				</tr>
			
				<!-- M-Factor chronic -->
				<tr>
					<td colspan="4">
						M-Factor chronic: <@com.number record.Classification.EnvironmentalHazards.AquaticEnvironment.MFactor.MFactorChronic/>
					</td>
				</tr>

				<#if isNotEmptyClassificationBlock(record.Classification.EnvironmentalHazards.OzoneLayer.HazardousOzone)>
					<tr>
						<!-- Hazard class -->
						<td>
							Hazardous to the ozone layer:
						</td>
						<!-- Hazard category -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.OzoneLayer.HazardousOzone.HazardCategory/>
						</td>
						<!-- Hazard statement -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.OzoneLayer.HazardousOzone.HazardStatement/>
						</td>
						<!-- Reason for no classification -->
						<td>
							<@com.picklist record.Classification.EnvironmentalHazards.OzoneLayer.HazardousOzone.ReasonForNoClassification/> 
						</td>
					</tr>
				</#if>
			</tbody>
		</table>
		
		<#if (record.Classification.AdditionalHazard.Classes?has_content) && (record.Classification.AdditionalHazard.Statements?has_content)>
			<@com.emptyLine/>
			<table border="1">
				<title>Classification and labelling according to CLP / GHS for additional hazard classes</title>
				<col width="30%" />
				<col width="70%" />
				<tbody>						
					<tr>
						<!-- Additional hazard classes -->
						<td><?dbfo bgcolor="#FBDDA6" ?>
							Additional hazard classes:
						</td>
						<td>
							<@com.text record.Classification.AdditionalHazard.Classes/>
						</td>
					</tr>																
					<tr>		
						<!-- Additional hazard statements -->
						<td><?dbfo bgcolor="#FBDDA6" ?>
							Additional hazard statements:
						</td>							
						<td>
							<@com.text record.Classification.AdditionalHazard.Statements/>
						</td>
					</tr>
				</tbody>
			</table>
		</#if>
		
		<!-- Labelling section -->
		<#if !nzEPArelevant??>
			<@com.emptyLine/>
			<para><emphasis role="bold">Labelling</emphasis></para>
			
			<#if record.Labelling.SignalWord?has_content>
				<@com.emptyLine/>
				<para>
					Signal word: <@com.picklist record.Labelling.SignalWord/>
				</para>
			</#if>
			
			<#if record.Labelling.HazardPictogramBlock.HazardPictogram?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Hazard pictogram:</emphasis>
					<@com.emptyLine/>
					<@HazardPictogramList record.Labelling.HazardPictogramBlock.HazardPictogram/>
				</para>
			</#if>
			
			<#if record.Labelling.HazardStatementsBlock.HazardStatements?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Hazard statements:</emphasis>
					<@HazardStatementList record.Labelling.HazardStatementsBlock.HazardStatements/>
				</para>
			</#if>
			
			<#if record.Labelling.PrecautionaryStatementsBlock.PrecautionaryStatements?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Precautionary statements:</emphasis>
					<@PrecautionaryStatementsList record.Labelling.PrecautionaryStatementsBlock.PrecautionaryStatements/>
				</para>
			</#if>
			
			<#if record.Labelling.LabelingRequirementsBlock.LabelingRequirements?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Additional labelling requirements (CLP supplemental hazard statement):</emphasis>
					<@SupplimentalHazardStatementList record.Labelling.LabelingRequirementsBlock.LabelingRequirements/>
				</para>
			</#if>
			
			<#if record.Labelling.LabelingRequirementsBlock.AdditionalLabelling?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Additional labelling:</emphasis>
					<@AdditionalLabellingList record.Labelling.LabelingRequirementsBlock.AdditionalLabelling/>
				</para>
			</#if>
			
			<#if record.NotesBlock.Notes?has_content>
				<@com.emptyLine/>
				<para>
					<emphasis role="underline">Notes:</emphasis>
					<@NotesLabellingList record.NotesBlock.Notes/>
				</para>
			</#if>
			
		</#if>
		
		
	</#list>	
	</#if>
	
</#compress>
</#macro>

<!-- Macros and functions -->
<#macro HazardPictogramList HazardPictogramRepeatableBlock>
<#compress>
	<#if HazardPictogramRepeatableBlock?has_content>
		<#list HazardPictogramRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Code/>
				<#if blockItem.Code.code?has_content>
					<#assign phraseImageMeta = iuclid.getImageMetadataForPhraseCode(blockItem.Code.code) />					
					<#if phraseImageMeta?has_content>
						<#assign phraseImagePrinted = false/> 
						<#if iuclid.imageMimeTypeSupported(phraseImageMeta.mediaType)>
							<#assign phraseImagePrinted = true/> 
								<mediaobject>
									<imageobject>
										<imagedata fileref="data:${phraseImageMeta.mediaType};base64,${iuclid.getImageContentForPhraseCode(phraseImageMeta.code, phraseImageMeta.mediaType)}" />
									</imageobject>
								</mediaobject>
							<@com.emptyLine/>
						</#if>
						<#if !phraseImagePrinted>
							<para><emphasis role="bold">The image for phrase code ${blockItem.Code.code} is in an unsupported format!</emphasis></para>
						</#if>
					<#else/>
						<para><emphasis role="bold">No image found for phrase code ${blockItem.Code.code}</emphasis></para>
					</#if>
				</#if>				
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro HazardStatementList HazardStatementRepeatableBlock>
<#compress>
	<#if HazardStatementRepeatableBlock?has_content>
		<#list HazardStatementRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.HazardStatement/>
				<#if blockItem.AdditionalText?has_content>
					(<@com.text blockItem.AdditionalText/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro PrecautionaryStatementsList PrecautionaryStatementRepeatableBlock>
<#compress>
	<#if PrecautionaryStatementRepeatableBlock?has_content>
		<#list PrecautionaryStatementRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.PrecautionaryStatement/>
				<#if blockItem.AdditionalText?has_content>
					(<@com.text blockItem.AdditionalText/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro SupplimentalHazardStatementList SupplimentalHazardStatementRepeatableBlock>
<#compress>
	<#if SupplimentalHazardStatementRepeatableBlock?has_content>
		<#list SupplimentalHazardStatementRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.SupplHazardStatement/>
				<#if blockItem.AdditionalText?has_content>
					(<@com.text blockItem.AdditionalText/>)
				</#if>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro AdditionalLabellingList AdditionalLabellingRepeatableBlock>
<#compress>
	<#if AdditionalLabellingRepeatableBlock?has_content>
		<#list AdditionalLabellingRepeatableBlock as blockItem>
			<para role="indent">
				<@com.text blockItem.Labelling/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#macro NotesLabellingList NotesRepeatableBlock>
<#compress>
	<#if NotesRepeatableBlock?has_content>
		<#list NotesRepeatableBlock as blockItem>
			<para role="indent">
				<@com.picklist blockItem.Note/>
			</para>
		</#list>
  	</#if>
</#compress>
</#macro>

<#function isNotEmptyClassificationBlock block>
	<#if !(block?has_content)>
		<#return false>
	</#if>
	<#if block.HazardCategory?has_content || block.HazardStatement?has_content || block.ReasonForNoClassification?has_content>
		<#return true>
	</#if>
	<#return false>
</#function>

<#function isNotEmptyConcentrationBlock record>
	<#if !(record?has_content)>
		<#return false>
	</#if>
	<#if record.ConcentrationRangeVal?has_content || record.HazardCategories?has_content>
		<#return true>
	</#if>
	<#return false>
</#function>

<#macro classificationSubstanceName ghsOrDsdDpdRecord, _subject>
<#compress>
	<#if ghsOrDsdDpdRecord.GeneralInformation.Name?has_content>
	<#assign docUrl=iuclid.webUrl.documentView(ghsOrDsdDpdRecord.documentKey)/>
		<#if docUrl?has_content>
		<ulink url="${docUrl}"><@com.text ghsOrDsdDpdRecord.GeneralInformation.Name/></ulink>
		
	<#else/>
		<@com.substanceName _subject />
		</#if>
  	</#if>
</#compress>
</#macro>
	
