
<!-- Nanoform information for substance composition -->
<#macro nanoforms _subject>
<#compress>

<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />
<#if !(recordList?has_content)>
<@com.emptyLine/>

	<#elseif recordList?has_content>
	
	<#list recordList as record>
	<#if com.picklistValueMatchesPhrases(record.GeneralInformation.StateForm, ["solid: nanoform"])>
		
	<!-- Characterisation of nanoforms -->
	<#if record?has_content && record.CharacterisationOfNanoforms?has_content>	
		<@com.emptyLine/>
		<para><emphasis role="bold">Characterisation of nanoforms</emphasis></para>
	
		<#if record.CharacterisationOfNanoforms.TypeOfInformationReported?has_content>
		<para>
		Type of information reported: <@com.picklist record.CharacterisationOfNanoforms.TypeOfInformationReported />
		</para>
		</#if>
	</#if>	
		
		<@com.emptyLine/> 
		<para>
		Justification for reporting set of similar nanoforms:				
			<#if record.CharacterisationOfNanoforms.JustificationForReportingSetOfSimilarNanoforms?has_content>
				<para><@com.text record.CharacterisationOfNanoforms.JustificationForReportingSetOfSimilarNanoforms/></para>
			</#if>	
		</para>
	
	<para></para>
				
	<@com.emptyLine/> 
	<!-- Shape -->
		<para><emphasis role="bold">Shape</emphasis></para>
		<#if record.CharacterisationOfNanoforms.Shape?has_content>
		<#assign ShapeDescriptionList = record.CharacterisationOfNanoforms.Shape.ShapeDescription/>
			
			<#if ShapeDescriptionList?has_content>
			
				<#list ShapeDescriptionList as item>
				<para>Shape description: <@com.picklist item.ShapeCategory/>, <@com.picklist item.Shape/>,
					<#if item.PureShape?has_content> Pure shape: <@com.picklist item.PureShape/>
						<#else> (not pure shape)
					</#if> 
					- typical composition: <@com.range item.TypicalComposition/> - range: <@com.range item.Range/>
				</para>
					<#if item_has_next><@com.emptyLine/></#if>
				</#list>
			
			</#if>
			
			<#if record.CharacterisationOfNanoforms.Shape.JustificationForSetContainingMultipleShapeCategoriesOrShapes?has_content>
				<@com.emptyLine/> 
				<para>
					Justification for set containing multiple shape categories or shapes:			
					<para><@com.text record.CharacterisationOfNanoforms.Shape.JustificationForSetContainingMultipleShapeCategoriesOrShapes/></para>
				</para>
			</#if>
			
		<#else>
			<para>No information available on Shape from IUCLID</para>
		</#if>
			
		<@com.emptyLine/>
			
	<!-- Particle size distribution and range -->
	<para><emphasis role="bold">Particle size distribution and range</emphasis></para>
		
		<#if  record.CharacterisationOfNanoforms.ParticleSizeDistributionAndRange?has_content>
			<#assign itemListParticle = record.CharacterisationOfNanoforms.ParticleSizeDistributionAndRange.PartSizeDistribRangeRepeatable/>
			
			<#if itemListParticle?has_content>
			<#list itemListParticle as itemParticle> 
					 
				<para>
				<#if itemParticle.ShapeCategory?has_content>Shape category: <@com.picklist itemParticle.ShapeCategory/></#if>
				<#assign itemListPercentile = itemParticle.Percentile/>
					<#if itemListPercentile?has_content>
						<#list itemListPercentile as itemP>
						<#if itemP?has_content>
							(<@com.picklist itemP.Percentile/>, Typical value: <#if itemP.TypicalValue?has_content><@com.range itemP.TypicalValue/></#if> <#if itemP.Range?has_content>, Range of typical value:<@com.range itemP.Range/></#if>)
							<#if itemP_has_next><?linebreak?></#if>
						</#if>
						</#list>
						<para role="indent">
						
							<para>
							<#if itemParticle.TypicalLength?has_content>Typical length:   <@com.range itemParticle.TypicalLength/></#if> 
							<#if itemParticle.RangeOfLength?has_content>(range of length: <@com.range itemParticle.RangeOfLength/>)</#if>
							</para>
				 
							<para>
							<#if itemParticle.TypicalLateralDimension1?has_content>Typical lateral dimension 1:   <@com.range itemParticle.TypicalLateralDimension1/></#if>
							<#if itemParticle.RangeOfLateralDimension1?has_content>(range Lateral dimension 1: <@com.range itemParticle.RangeOfLateralDimension1/>)</#if>
							</para>
				 
							<para>
							<#if itemParticle.TypicalLateralDimension2?has_content>Typical lateral dimension 2:  <@com.range itemParticle.TypicalLateralDimension2/></#if>
							<#if itemParticle.RangeOfLateralDimension2?has_content> (range Lateral dimension 2: <@com.range itemParticle.RangeOfLateralDimension2/>)</#if>
							</para>
				 
							<para><#if itemParticle.TypicalAspectRatio?has_content>Typical aspect ratio:   <@com.range itemParticle.TypicalAspectRatio/></#if>
							<#if itemParticle.RangeOfAspectRatio?has_content> (range of aspect ratio: <@com.range itemParticle.RangeOfAspectRatio/>)</#if> </para>
				 
							<#if itemParticle.FractionOfConstituentParticlesInTheSizeRange?has_content>
							<para>Fraction of constituent particles in the size range 1-100nm(%): <@com.range itemParticle.FractionOfConstituentParticlesInTheSizeRange/>
							</para>
							</#if>

						
						</para>
					</#if>
			 
					<#if itemParticle.AdditionalInformation?has_content>
						<@com.emptyLine/> 
						<para>Additional Information: 
							<para>
							<@com.text itemParticle.AdditionalInformation/>
							</para>
						</para>
					</#if>
			 
				</para>			 
			</#list>
			</#if>
			
			<#else>
			<para>No information available on Particle size distribution and range from IUCLID</para>
		</#if>
		<@com.emptyLine/>
		
		<!-- Crystallinity -->
		<para><emphasis role="bold">Crystallinity</emphasis></para>
			
		<#if record.CharacterisationOfNanoforms.Crystallinity?has_content>
			<para>
				Description:
				<#if record.CharacterisationOfNanoforms.Crystallinity.Description?has_content>
				<@com.text record.CharacterisationOfNanoforms.Crystallinity.Description />
				<#else>
				no description available from IUCLID
				</#if>		
			</para>
			<@com.emptyLine/>
			<para><emphasis role= "bold">Crystallinity structures:</emphasis></para>
			
			<#assign CrystallinityStructures = record.CharacterisationOfNanoforms.Crystallinity.Structures/>
			<#if  CrystallinityStructures?has_content>
			
			<#list CrystallinityStructures as itemC>
				<para role="indent">
					<#if itemC.Structure?has_content>
						 <para>
						 <emphasis role="bold"><@com.picklist itemC.Structure/> (<@com.text itemC.Name/>)</emphasis>
							 <#if itemC.PureStructure?has_content> Pure Structure: <@com.picklist itemC.PureStructure/> 
								<#else> (not pure Structure)
							 </#if>
						 </para>
						<@com.emptyLine/>
					</#if>
					
					<#if itemC.TypicalComposition?has_content>
						<para>Typical Composition: <@com.range itemC.TypicalComposition/></para>
					</#if>
					
					<#if itemC.Range?has_content>(range of typical composition: <@com.range itemC.Range/>)</#if>
					
					<#if itemC.CrystalSystem?has_content> 
						<para>Crystal system: <@com.picklistMultiple itemC.CrystalSystem/></para>
					</#if>
					
					<#if itemC.BravaisLattice?has_content>
						<para>Bravais lattice: <@com.picklistMultiple itemC.BravaisLattice/></para>
					</#if>
					
				</para>
				<#if itemC_has_next><@com.emptyLine/></#if>
			</#list>
			</#if>
			
		<#else>
			<para>No information available on Crystallinity in IUCLID</para>
		</#if>
		<@com.emptyLine/>
		
		<!-- Specific surface area -->		
		<para><emphasis role="bold">Specific surface area</emphasis></para>
			<para></para>
			<#assign SpecificSurfaceArea = record.CharacterisationOfNanoforms.SpecificSurfaceArea />
			<#if SpecificSurfaceArea?has_content>
				 <para>
					 <para> <#if SpecificSurfaceArea.TypicalSpecificSurfaceArea?has_content><@com.range SpecificSurfaceArea.TypicalSpecificSurfaceArea/>Typical specific surface area:</#if><#if SpecificSurfaceArea.RangeOfSpecificSurfaceArea?has_content>(range: <@com.range SpecificSurfaceArea.RangeOfSpecificSurfaceArea />)</#if> </para> 
					 <para><#if SpecificSurfaceArea.TypicalVolumeSpecificSurfaceArea?has_content>Typical volume specific surface area:<@com.range SpecificSurfaceArea.TypicalVolumeSpecificSurfaceArea /></#if> <#if SpecificSurfaceArea.RangeOfVolumeSpecificSurfaceArea?has_content>(range: <@com.range SpecificSurfaceArea.RangeOfVolumeSpecificSurfaceArea />)</#if></para>
					 <para><#if SpecificSurfaceArea.SkeletalDensity?has_content>Skeletal density: <@com.range SpecificSurfaceArea.SkeletalDensity /></#if></para>
					 <para><#if SpecificSurfaceArea.Remarks?has_content>Remarks: <@com.text SpecificSurfaceArea.Remarks /></#if></para>
				 </para>
				 
				 <#else>
				 <para>No information available on Specific surface area from IUCLID</para>
			</#if>
			
		<@com.emptyLine/>
		<!-- Surface functionalisation / treatment -->
		<para><emphasis role="bold">Surface functionalisation / treatment</emphasis></para>
		<para></para>
		<#if record.CharacterisationOfNanoforms.SurfaceFunctionalisationTreatment?has_content>
			
				<#assign SurfTreatFunc = record.CharacterisationOfNanoforms.SurfaceFunctionalisationTreatment.SetContainTreatedNon\-surfaceTreatedNanoforms /> 
			
				<#if SurfTreatFunc?has_content || record.CharacterisationOfNanoforms.SurfaceFunctionalisationTreatment.SurfaceTreatmentApplied?has_content>			
					<para>Surface treatment applied: 
						<#if com.picklistValueMatchesPhrases(record.CharacterisationOfNanoforms.SurfaceFunctionalisationTreatment.SurfaceTreatmentApplied, ["yes"]) && 	com.picklistValueMatchesPhrases(SurfTreatFunc, ["yes"])>
						(The set contains both treated and non-surface treated nanoforms)
						<#else>
							(The set does not contain both treated and non-surface treated nanoforms)
						</#if> 
					</para>
					<@com.emptyLine/>
				</#if>
			 
		
			<#list record.CharacterisationOfNanoforms.SurfaceFunctionalisationTreatment.SurfaceTreatments as SurfaceTreatmentsList >
			
				<#if SurfaceTreatmentsList?? && (SurfaceTreatmentsList.SurfaceTreatmentName?has_content || SurfaceTreatmentsList.ExternalLayer?has_content || SurfaceTreatmentsList.Description?has_content ||SurfaceTreatmentsList.PercentageOfCoverageOfParticleSurface?has_content)>
					
					<para>
						Surface treatment: <@com.text SurfaceTreatmentsList.SurfaceTreatmentName />; External Layer: <@com.picklist SurfaceTreatmentsList.ExternalLayer />(<#if SurfaceTreatmentsList.Description?has_content><@com.text SurfaceTreatmentsList.Description/></#if>)
					</para>
					
					<para>
						<#if SurfaceTreatmentsList.PercentageOfCoverageOfParticleSurface?has_content>Coverage of particle surface in %: <@com.range SurfaceTreatmentsList.PercentageOfCoverageOfParticleSurface /></#if>
					</para>
					<@com.emptyLine/>
					
				</#if>
				
				<#list SurfaceTreatmentsList.SurfaceTreatment as TreatmentOrderList >
				<#if TreatmentOrderList.Order?has_content || TreatmentOrderList.SurfaceTreatmentAgent?has_content || TreatmentOrderList.TypicalWeightbyWeightContributionWW?has_content || TreatmentOrderList.RangeWeightByWeightContributionWW?has_content || TreatmentOrderList.Remarks?has_content>
						
					<#if TreatmentOrderList.SurfaceTreatmentAgent?has_content>			
						<#assign referenceSubstanceAgent = iuclid.getDocumentForKey(TreatmentOrderList.SurfaceTreatmentAgent) />
						<para role="indent">
							<@com.picklist TreatmentOrderList.Order /> (surface treatment order), Surface treatment agent: 
								<#if referenceSubstanceAgent?has_content> Substance Name: <@com.text referenceSubstanceAgent.ReferenceSubstanceName/> (EC no: <@com.inventoryECNumber referenceSubstanceAgent.Inventory.InventoryEntry />
								</#if>
						</para>			
					</#if>			
							
					<para role="indent">
						<#if TreatmentOrderList.TypicalWeightbyWeightContributionWW?has_content>Typical % W/W contribution: <@com.range TreatmentOrderList.TypicalWeightbyWeightContributionWW />
						</#if> 
						<#if TreatmentOrderList.RangeWeightByWeightContributionWW?has_content>(range: <@com.range TreatmentOrderList.RangeWeightByWeightContributionWW /></#if> 
						- Remarks: 
						<#if TreatmentOrderList.Remarks?has_content><@com.text TreatmentOrderList.Remarks /></#if>
					</para>
						
					<#if TreatmentOrderList_has_next><@com.emptyLine/></#if>
						
				</#if>
				</#list>
				
				<#if SurfaceTreatmentsList_has_next><@com.emptyLine/></#if>
			
			</#list>
			
			<#else>
			 <para>No information available Surface functionalisation / treatment from IUCLID</para>
		</#if>
		<@com.emptyLine/>

		<#assign chemistryAssessment = iuclid.getChemistryAssessmentFor(_subject.documentKey) />
		<#if chemistryAssessment?? && chemistryAssessment.Approach?has_content>
			<para>
				<para>
				<emphasis role="bold">Approach to fate/hazard assessment: </emphasis><@com.richText chemistryAssessment.Approach/>
				</para>
			</para>
		</#if>

	</#if>
	</#list>
</#if>		
</#compress>
</#macro>
						
<!-- Macros and functions -->
<#macro surfaceTreatmentList surfaceTreatmentBlock>
<#compress>
	<#if surfaceTreatmentBlock?has_content>
		<informaltable border="1">
			<col width="30%" />
			<col width="20%" />
			<col width="25%" />
			<col width="25%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Surface treatment</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Layer</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Agent</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
				</tr>
				<#list surfaceTreatmentBlock as blockItem>
					<tr>
						<td>
							<@com.text blockItem.SurfaceTreatmentName/>
						</td>
						<td>
							<@com.picklist blockItem.ExternalLayer/>
						</td>
						<td>
							<#list blockItem.SurfaceTreatment as item>
								<#if item.SurfaceTreatmentAgent?has_content>
									
									<para>
									<@com.referenceSubstanceName com.getReferenceSubstanceKey(item.SurfaceTreatmentAgent)/>	
									EC no.: <@com.inventoryECNumber com.getReferenceSubstanceKey(item.SurfaceTreatmentAgent)/>	
									</para>
									
									<#if item_has_next>; </#if>
								</#if>
							</#list>
						</td>
						<td>
							<@com.text blockItem.Remarks/>
						</td>
					</tr>
				</#list>
			</tbody>
		</informaltable>
  	</#if>
</#compress>
</#macro>