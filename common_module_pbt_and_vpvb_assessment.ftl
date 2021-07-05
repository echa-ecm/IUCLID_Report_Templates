
<!-- PBT AND vPvB ASSESSMENT template file -->
<!-- CSR 8. -->

<!-- Assessment of PBT/vPvB Properties -->
<!-- CSR 8.1 -->
<#macro pbtandvPvBcriteriaAndJustification _subject>
<#compress>

<!-- Assessment of PBT/vPvB Properties -->
<#if !csrRelevant?? && !pppRelevant??>
<@com.emptyLine/>
	<para><emphasis role="bold">Assessment of PBT/vPvB Properties</emphasis></para>
</#if>

<!-- PBT/vPvB criteria and justification -->
<#if !csrRelevant?? && !pppRelevant??>
<@com.emptyLine/>
	<para><emphasis role="bold">PBT/vPvB criteria and justification</emphasis></para>
</#if>
	
	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "PbtAssessment") />	
	<#assign recordList = iuclid.sortByField(recordList, "AssessedSubstance.AssessedSubstance", ["substance itself","(group of) constituent(s) /impurities/additives","transformation product"]) />		
					
	<#if !recordList?has_content>
	No relevant information available.		
	<#else>
		
		<#list recordList as record>
			
			<!-- Assessed substance: <Assessed substance> -->
			<!-- CSR: 8.1.1.n -->
			<@com.emptyLine/>
			<#if csrRelevant??>
				<section>
			<#elseif  pppRelevant??>
				<sect3>
			</#if>
					
			<#if csrRelevant?? || pppRelevant??>
					<title>Assessed substance:
					<#if record.AssessedSubstance.AssessedSubstance?has_content>
					 <@com.picklist record.AssessedSubstance.AssessedSubstance/>
					<#else>
						not specified
						<@com.emptyLine/>
					</#if>
					</title>
				<#else>
					<para>Assessed substance:</para>
				</#if>
				
				<para>
					<#if pppRelevant??>Reference substance: </#if><@com.documentReference record.AssessedSubstance.ReferenceSubstance/>
				</para>
				
				<para>
					<#if record.AssessedSubstance.AssessedSubstanceCompo?has_content>
					Composition of assessed substance: <@com.documentReferenceMultiple record.AssessedSubstance.AssessedSubstanceCompo/>
					</#if>
				</para>
				
				<para>
					<#if record.AssessedSubstance.PBTStatusOfTheAssessedSubstance?has_content>
					PBT status of the assessed substance: <@com.picklist record.AssessedSubstance.PBTStatusOfTheAssessedSubstance/>
					</#if>
				</para>
				
				<para>
					<#if record.AssessedSubstance.AssessedSubstanceRemark?has_content>
					Remark for  assessed substance: <@com.text record.AssessedSubstance.AssessedSubstanceRemark/>
					</#if>
				</para>
				
				
				<!-- Persistence assessment -->
				<!-- CSR 8.1.1.n.1 -->
				<@com.emptyLine/>
				<#if csrRelevant?? >
					<section>
				<#elseif pppRelevant??>
					<sect4>
				</#if>
				
				<@com.emptyLine/>
				<#if csrRelevant?? || pppRelevant??>
					<title>Persistence assessment</title>
					<#else>
					<para>Persistence assessment</para>
				</#if>
					
					<#assign cb1 = record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPReadilyBiodegradable />
					<#assign cb2 = record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPOtherTest />
					<#assign cb3 = record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.NotPBasedOn />
					<#assign cb4 = record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.PNotvPBasedOn />
					
					<#if cb1 || cb2 || cb3 || cb4>
						<@com.emptyLine/>
						<para><emphasis role="HEAD-WoutNo">Evidence of non-P / non-vP properties</emphasis></para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb1 || cb2>
						<para><emphasis role="bold">Screening criteria</emphasis></para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb1>
						<#if record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPReadilyBiodegradableRemark?has_content>
							<para>
								<emphasis>- Not P / vP based on ready biodegradability:</emphasis>
								<@com.text record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPReadilyBiodegradableRemark/>
							</para>
						</#if>
					</#if>
					
					<#if !cb1>
						<para>
							<#if record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPReadilyBiodegradableRemark?has_content>
							<emphasis>- Remarks on ready biodegradability:</emphasis>
							<@com.text record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPReadilyBiodegradableRemark/>
							</#if>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb2>
						<para>
							<#if record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPOtherTestRemark?has_content>
							<emphasis>- Not P / vP based on other screening test(s) (e.g. enhanced ready biodegradability, inherent biodegradability) under valid conditions:</emphasis>
							<@com.text record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPOtherTestRemark/>
							</#if>
						</para>
					<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if !cb2>
						<para>
							<#if record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPOtherTestRemark?has_content>
							<emphasis>- Remarks on other screening test(s) (e.g. enhanced ready biodegradability, inherent biodegradability) under valid conditions:</emphasis>				
							<@com.text record.ResultsDetailed.Persistence.Evidence.ScreeningCriteria.NotPOtherTestRemark/>
							</#if>
						</para>
					<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb3>
						<para>
							<emphasis role="underline">Criteria based on Annex XIII of REACH</emphasis>
						</para>
					<#-- remarks rule missing TO DO -->
					</#if>
					
						<#if cb3>
							<para><emphasis>- Not P / vP based on criteria laid down in Annex XIII of REACH:</emphasis></para>
														
							<para role="indent">
								<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterMarine60?has_content
									|| record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterFresh40?has_content
									|| record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentMarine180?has_content>
									<itemizedlist mark='bullet'>
										<listitem>
											<para>
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterMarine60?has_content>
													<emphasis>T1/2&lt;=60 days in marine water:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterMarine60/>
												</#if>
												
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterFresh40?has_content>
													<emphasis>T1/2&lt;=40 days in fresh- or estuarine water:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterFresh40/>
												</#if>
												
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentMarine180?has_content>
													<emphasis>T1/2&lt;=180 days in marine sediment:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentMarine180/>
												</#if>
											</para>
										</listitem>
									</itemizedlist>
								</#if>
							</para>
									
							<para role="indent">
								<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentFresh120?has_content
									|| record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120?has_content>
									<itemizedlist mark='bullet'>
										<listitem>
											<para>
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentFresh120?has_content>
													<emphasis>T1/2&lt;=120 days in fresh- or estuarine sediment:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentFresh120/>				
												</#if>
												
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120?has_content>
													<emphasis>T1/2&lt;=120 days in soil:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120/>			
												</#if>
											</para>	
										</listitem>
									</itemizedlist>
								</#if>
							</para>
						</#if>
								
						<#if !cb3>
							<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120?has_content || record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterFresh40?has_content || 
							record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentMarine180?has_content || 
							record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentFresh120?has_content || 
							record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120?has_content>
							
							<para><emphasis>- Remarks on Annex XIII criteria (P/vP):</emphasis></para>
							<#-- remarks rule missing TO DO -->						
					
							<para role="indent">
								<itemizedlist mark='bullet'>
									<listitem>
											T1/2&lt;=60 days in marine water: <@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterMarine60/>
									</listitem>
															
									<listitem>
											T1/2&lt;=40 days in fresh- or estuarine water: <@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.WaterFresh40/>
									</listitem>									
								
									<listitem>
											T1/2&lt;=180 days in marine sediment: <@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentMarine180/>
									</listitem>
															
									<listitem>
											T1/2&lt;=120 days in fresh- or estuarine sediment: <@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.SedimentFresh120/>
									</listitem>
								
									<listitem>
											T1/2&lt;=120 days in soil: <@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil120/>
									</listitem>
								</itemizedlist>
							</para>	
							</#if>
						</#if>
							
						<#if cb4>
							<emphasis>- P but not vP based on criteria laid down in Annex XIII of REACH:</emphasis>
													
							<para role="indent">
								<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Water60?has_content
									|| record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Sediment180?has_content
									|| record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil180?has_content>
									<itemizedlist mark='bullet'>
										<listitem>
											<para>
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Water60?has_content>
													<emphasis>T1/2&lt;=60 days in marine, fresh- or estuarine water:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Water60/>
												</#if>
												
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Sediment180?has_content>
													<emphasis>T1/2&lt;=180 days in marine, fresh- or estuarine sediment:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Sediment180/>
												</#if>
												
												<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil180?has_content>
													<emphasis>T1/2&lt;=180 days in soil:</emphasis>
													<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil180/>
												</#if>
											</para>
										</listitem>
									</itemizedlist>
								</#if>
							</para>
						</#if>
							
						<#if !cb4>
							<#if record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Water60?has_content || record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Sediment180?has_content || 
							record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil180?has_content>
															
							<para><emphasis>- Remarks on Annex XIII criteria (P/vP):</emphasis></para>
						
							<para role="indent">
								<itemizedlist mark='bullet'>
									<listitem>
											<emphasis>T1/2&lt;=60 days in marine, fresh- or estuarine water:</emphasis>
											<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Water60/>
										<#-- remarks rule missing TO DO -->
									</listitem>
									
									<listitem>
											<emphasis>T1/2&lt;=180 days in marine, fresh- or estuarine sediment:</emphasis>
											<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Sediment180/>
										<#-- remarks rule missing TO DO -->
									</listitem>
									
									<listitem>
											<emphasis>T1/2&lt;=180 days in soil:</emphasis>
											<@com.text record.ResultsDetailed.Persistence.Evidence.PersistenceAnnexBased.Soil180/>
											<#-- remarks rule missing TO DO -->
									</listitem>
								</itemizedlist>
							</para>
							</#if>
						</#if>
													
					<#if record.ResultsDetailed.Persistence.Evidence.OtherEvidence.Remark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Other evidence of non-P / non-vP properties</emphasis>
							<@com.text record.ResultsDetailed.Persistence.Evidence.OtherEvidence.Remark/>
						</para>
					</#if>
					
					<#if record.ResultsDetailed.Persistence.PersistenceFurtherInfo.FurtherInfoRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Further information is necessary to conclude on the P or vP properties in the context of the PBT assessment</emphasis>
							<@com.text record.ResultsDetailed.Persistence.PersistenceFurtherInfo.FurtherInfoRemark/>
						</para>
					</#if>
					
					<#if record.ResultsDetailed.Persistence.PersistenceEvidence.EvidenceRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Evidence of P or vP properties</emphasis>
							<@com.text record.ResultsDetailed.Persistence.PersistenceEvidence.EvidenceRemark/>
						</para>
					</#if>
					
					<#if (record.ResultsDetailed.Persistence.PersistenceConclusion.ConclustionOnPvP?has_content) || (record.ResultsDetailed.Persistence.PersistenceConclusion.Remark?has_content)>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Conclusion on P / vP properties:</emphasis>			
							<para>								
							<@com.picklist record.ResultsDetailed.Persistence.PersistenceConclusion.ConclustionOnPvP/>.
							</para>
							<para>
							<@com.text record.ResultsDetailed.Persistence.PersistenceConclusion.Remark/>
							</para>
						</para>
					</#if>
					
				<#if csrRelevant??>	
					</section>
				<#elseif pppRelevant??>
					</sect4>
				</#if>
				
				<!-- Bioaccumulation assessment -->	
				<!-- CSR 8.1.1.n.2 -->
				<@com.emptyLine/>
				<#if csrRelevant??>	
					<section>
				<#elseif pppRelevant??>
					<sect4>
				</#if>
				
				<@com.emptyLine/>
				<#if csrRelevant?? || pppRelevant??>
				<title>Bioaccumulation assessment</title>
				<#else>
					<para>Bioaccumulation assessment</para>
				</#if>
					
					<#assign cb1 = record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioScreening.NotBBasedOnLogKow />
					<#assign cb2 = record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.NotBBCF200 />
					<#assign cb3 = record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.BNotVBBCF5000 />
											
					<#if cb1 || cb2 || cb3>
						<@com.emptyLine/>
						<para><emphasis role="HEAD-WoutNo">Evidence of non-B / non-vB properties</emphasis></para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb1>
						<para><emphasis role="bold">Screening criteria</emphasis></para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb1>
						<#if record.ResultsDetailed.Persistence.PersistenceEvidence.EvidenceRemark?has_content>
							<para>
								<emphasis>- Not B / vB based on Log Kow&lt;=4.5</emphasis>
								<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioScreening.NotBRemark/>
							</para>
							<#-- remarks rule missing TO DO -->
						</#if>
					</#if>
					
					<#if cb1>
						<para>
							<emphasis>- Remarks on criterion "Log Kow&lt;=4.5":</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioScreening.NotBRemark/>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
			
					<#if cb2 || cb3>
						<para>
							<emphasis role="bold">Criteria based on Annex XIII of REACH</emphasis>
						</para>
					<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb2>
						<para>
							<#if record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.NotBBCF200Remark?has_content>
							<emphasis>- Not B / vB based on BCF&lt;=2000 L/kg:</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.NotBBCF200Remark/>
							</#if>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
			
					<#if !cb2>
						<para>
							<#if record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.NotBBCF200Remark?has_content>
							<emphasis>- Remarks on criterion "BCF&lt;=2000 L/kg":</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.NotBBCF200Remark/>
							</#if>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if cb3>
						<para>
							<emphasis>- B but not vB based on 2000&lt;BCF&lt;=5000 L/kg</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.BNotVBBCF5000Remark/>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if !cb3>
						<para>
							<#if record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.BNotVBBCF5000Remark?has_content>
							<emphasis>- Remarks on criterion "2000&lt;BCF&lt;=5000 L/kg"</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioAnnexBased.BNotVBBCF5000Remark/>
							</#if>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioOtherEvidence.OtherEvidenceRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Other evidence of non-B / non-vB properties</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.EvidenceNonB.BioOtherEvidence.OtherEvidenceRemark/>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if record.ResultsDetailed.Bioaccumulation.BioFurtherInfo.PBTInfoRemark?has_content>
						<@com.emptyLine/>
						<para><emphasis role="HEAD-WoutNo">Further information is necessary to conclude on the B or vB properties in the context of the PBT assessment</emphasis></para>
						<@com.text record.ResultsDetailed.Bioaccumulation.BioFurtherInfo.PBTInfoRemark/>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if record.ResultsDetailed.Bioaccumulation.BioEvidence.BioEvidenceRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Evidence of B or vB properties</emphasis>
							<@com.text record.ResultsDetailed.Bioaccumulation.BioEvidence.BioEvidenceRemark/>
						</para>
						<#-- remarks rule missing TO DO -->
					</#if>
					
					<#if (record.ResultsDetailed.Bioaccumulation.BioConclusion.ConclusionOnB?has_content) || (record.ResultsDetailed.Bioaccumulation.BioConclusion.BioConclusionRemark?has_content)>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Conclusion on B / vB properties:</emphasis>
							<para>
							<@com.picklist record.ResultsDetailed.Bioaccumulation.BioConclusion.ConclusionOnB/>.
							</para>
							<para>
							<@com.text record.ResultsDetailed.Bioaccumulation.BioConclusion.BioConclusionRemark/>
							</para>
						</para>
					</#if>
					<@com.emptyLine/>
				
				<#if csrRelevant??>
					</section>
				<#elseif pppRelevant??>
					</sect4>
				</#if>
				
				<!-- Toxicity assessment -->
				<!-- CSR 8.1.1.n.3 -->
				<@com.emptyLine/>
				<#if csrRelevant??>
					<section>
				<#elseif pppRelevant??>
					<sect4>
				</#if>
				
				<@com.emptyLine/>
				<#if csrRelevant?? || pppRelevant??>
					<title>Toxicity assessment</title>
					<#else>
					<para>Toxicity assessment</para>
				</#if>
					
					<#assign cb1 = record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NotT />
					<#assign cb2 = record.ResultsDetailed.Toxicity.ToxicityEvidence.ToxicityEvidenceScreening />
					<#assign cb3 = record.ResultsDetailed.Toxicity.ToxicityEvidence.ToxicityOtherEvidence />
											
					<#if cb1>
						<@com.emptyLine/>
						<para><emphasis role="HEAD-WoutNo">Evidence of non-T properties</emphasis></para>
						<#-- text fields rule missing TO DO -->
					</#if>
					
					<#if cb1>
						<para><emphasis role="bold">Criteria based on Annex XIII of REACH</emphasis></para>
						<#-- text fields rule missing TO DO -->
					</#if>
					
					<#if cb1>	
						<para><emphasis>- Not T based on criteria laid down in Annex XIII of REACH:</emphasis></para>
						
						<para role="indent">
							<itemizedlist mark='bullet'>
								<listitem>
									<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm?has_content 
									|| record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified?has_content>
										<para>
											<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm?has_content>
												<emphasis>EC10 / NOEC&gt;=0.01 mg/L for marine / freshwater organisms (long-term toxicity):</emphasis>
												<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm/>
											</#if>
											
											<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified?has_content>
												<emphasis>Substance is not classified as carcinogenic (category 1A or 1B), germ cell mutagenic (category 1A or 1B), or toxic for reproduction (category 1A, 1B or 2) according to Regulation EC No 1272/2008 (or CLP Regulation) (see also section "3. Classification and labelling"):</emphasis>
												<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified/>
											</#if>
										</para>
									</#if>
								</listitem>									
							</itemizedlist>
						</para>							
						
						<para role="indent">
							<itemizedlist mark='bullet'>
								<listitem>
									<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NoOtherEvidence?has_content>
										<emphasis>
											No other evidence of chronic toxicity, as identified by or specific target organ toxicity after repeated exposure (STOT RE category 1 or 2) according to Regulation EC No 1272/2008:  
											<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NoOtherEvidence/>
										</emphasis>
									</#if>
								</listitem>
							</itemizedlist>
						</para>		
					</#if>
								
					<#if !cb1>
						<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm?has_content || 
						record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified?has_content || 
						record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NoOtherEvidence?has_content>							
												
						<para><emphasis>- Remarks on Annex XIII criteria (T):</emphasis></para>
						<#-- remarks rule missing TO DO -->
						
						<para role="indent">
							<itemizedlist mark='bullet'>
								<listitem>
									<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm?has_content>
										<emphasis>
											EC10 / NOEC&gt;=0.01 mg/L for marine / freshwater organisms (long-term toxicity):
										</emphasis>
										<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.ToxicityLongTerm/> 
									</#if>
								</listitem>
						
								<listitem>
									<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified?has_content>
										<emphasis>
											Substance is not classified as carcinogenic (category 1 or 2), mutagenic (category 1 or 2), or toxic for reproduction (category 1, 2 or 3) according to Directive 67/548/EEC (or the DSD) or carcinogenic (category 1A or 1B), germ cell mutagenic (category 1A or 1B), or toxic for reproduction (category 1A, 1B or 2) according to Regulation EC No 1272/2008 (or CLP Regulation) (see also section "3. Classification and labelling"):
										</emphasis>
										<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.SubstanceNotClassified/>
									</#if>
								</listitem>
								
								<listitem>
									<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NoOtherEvidence?has_content>
										<emphasis>
											No other evidence of chronic toxicity, as identified by or specific target organ toxicity after repeated exposure (STOT RE category 1 or 2) according to Regulation EC No 1272/2008:  
											<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityAnnexBased.NoOtherEvidence/>
										</emphasis>
									</#if>
								</listitem>
							</itemizedlist>
						</para>
						</#if>
					</#if>		
					
					<#if record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityOtherEvidence.OtherEvidenceRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Other evidence of non-T properties</emphasis>
							<@com.text record.ResultsDetailed.Toxicity.EvidenceOfNonT.ToxicityOtherEvidence.OtherEvidenceRemark/>
						</para>
					</#if>
					
					<#if record.ResultsDetailed.Toxicity.ToxicityFurtherInfo.ToxicityFurtherInfoRemark?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Further information is necessary to conclude on the T properties in the context of the PBT assessment</emphasis>
							<@com.text record.ResultsDetailed.Toxicity.ToxicityFurtherInfo.ToxicityFurtherInfoRemark/>
						</para>
					</#if>
					
					<#if cb2 || cb3>
						<@com.emptyLine/>
						<para><emphasis role="HEAD-WoutNo">Evidence of T properties</emphasis></para>
					</#if>
						
					<#if cb2>
						<para>
							Screening criteria (L(E)C50&lt;0.01 mg/L) fulfilled
						</para>
					</#if>
					
					<#if cb3>
						<para>
							Other evidence
						</para>
					</#if>
						
					<#if record.ResultsDetailed.Toxicity.ToxicityEvidence.ToxicityEvidenceRemark?has_content>
						<para>
							Remark: <@com.text record.ResultsDetailed.Toxicity.ToxicityEvidence.ToxicityEvidenceRemark/>
						</para>
					</#if>
					
					<#if (record.ResultsDetailed.Toxicity.ToxicityConclusion.Conclusion?has_content) || (record.ResultsDetailed.Toxicity.ToxicityConclusion.ToxicityConclusionRemark?has_content)>
						<@com.emptyLine/>
						<para>
							<emphasis role="HEAD-WoutNo">Conclusion on T properties:</emphasis>
							<para>
							<@com.picklist record.ResultsDetailed.Toxicity.ToxicityConclusion.Conclusion/>.
							</para>
							<para>
							<@com.text record.ResultsDetailed.Toxicity.ToxicityConclusion.ToxicityConclusionRemark/>
							</para>
						</para>
					</#if>
					<@com.emptyLine/>
					
					<#if csrRelevant??>
						</section>
					<#elseif pppRelevant??>
						</sect4>
					</#if>
				
			<#if csrRelevant??>				
				</section>
			<#elseif pppRelevant??>
				</sect3>
			</#if>
				
		</#list>
	</#if>

</#compress>
</#macro>
	
<!-- Summary and overall conclusions on PBT or vPvB properties -->
<#macro summaryAndOverallConclusionsOnPBTorvPvBproperties _subject>
<#compress>

	<#if !csrRelevant??>
		<para><emphasis role="bold">Summary and overall conclusions on PBT or vPvB properties</emphasis></para>
	</#if>
		
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", "PbtAssessment") />	
		
		<#if !summaryList?has_content>
			No relevant information available.
		<#else>
			<#assign printSummaryName = summaryList?size gt 1 />
			<#list summaryList as summary>
				
				<#if printSummaryName>
					<@com.emptyLine/>
					<para><emphasis role="bold"><@com.text summary.name/></emphasis></para>
				</#if>
								
				<para>
					<#if summary.PbtAssessmentOverallResult.AssessedCompositionS?has_content>
					<emphasis role="bold">Assessed composition:</emphasis>
					<@com.documentReferenceMultiple summary.PbtAssessmentOverallResult.AssessedCompositionS/>
					</#if>
				</para>
				
				
				<#if studyandsummaryCom.assessmentEntitiesExist>
					<#assign aeList = studyandsummaryCom.getAssessmentEntitiesLinkedToSummary(summary)/>
					<#if aeList?has_content>
						<@com.emptyLine/>
						<para>
							<emphasis role="bold">Assessment entity linked:</emphasis>
							<#list aeList as ae>
								<para><emphasis role="bold"><@com.text ae.AssessmentEntityName/></emphasis>. 
								View the assessment entity table in chapter 1.3 <command linkend="${ae.documentKey.uuid!}">here</command><#if ae_has_next>;</#if></para>
							</#list>
						</para>
					</#if>
				</#if>
				
				<para>
					<@com.emptyLine/>
					<emphasis role="bold">Overall conclusion:</emphasis>
		
					<#if isSubstanceNotPBT(summary)>
						Based on the assessment described in the subsections above the submission substance is not a PBT / vPvB substance.
					</#if>
					
					<#if isSubstancePBT(summary)>
					Based on the assessment described in the subsections above the submission substance is a PBT / vPvB substance.
					</#if>
		
					<#if isHandledasPBT(summary)>
					The submission substance is handled as if it were a PBT / vPvB substance.
					</#if>
				
					<#if isPBTdoesNotApply(summary)>
					PBT assessment does not apply.
					</#if>
		
					<#if isFurtherInformationForPBT(summary)>
					Further information relevant for the PBT assessment is necessary.
					</#if>
				</para>
				
				<para>
					<#if summary.PbtAssessmentOverallResult.Justification?has_content>
						<@com.emptyLine/>
						<emphasis role="bold">Justification:</emphasis>
						<@com.richText summary.PbtAssessmentOverallResult.Justification/>
					</#if>
				</para>
			
			</#list>
		</#if>
		
</#compress>
</#macro>

<!-- Emission characterisation -->
<#macro emissionCharacterisation _subject>
<#compress>
	
	<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", "PbtAssessment") />	
	
	<#if !csrRelevant??>	
		<para><emphasis role="bold">Emission characterisation</emphasis></para>
	</#if>
		
		<#if !(summaryList?has_content)>		
		No relevant information available.			
		<#else>

		<#list summaryList as summary>
			
			<#if isEmissionCharacterisation(summary)>
		
				<para>
					<emphasis role="bold">Operational conditions and risk management measures:</emphasis>
					The operational conditions and risk management measures put in place are reported in the exposure scenarios in section 9.
				</para>	
				
				<para>
					<@com.emptyLine/>
					<emphasis role="bold">Residual releases</emphasis>
					The total release and emissions values are reported in section 9.
				</para>
	
				<para>
					<@com.emptyLine/>
					<emphasis role="bold">Likely routes by which humans and the environment are exposed:</emphasis>
					<@com.richText summary.PbtAssessmentOverallResult.LikelyRoutesOfExposure/>
				</para>
				
				<para>
					<@com.emptyLine/>
					<emphasis role="bold">Justification of minimisation of emission/exposure:</emphasis>
					The justification of the minimisation of emissions and (subsequent) exposures of humans and the environment is reported in sections 9 and 10.
				</para>
				
			</#if>	
		
		</#list>
	</#if>
	<@com.emptyLine/>

</#compress>
</#macro>

<!-- Macros and functions -->

<#function isSubstanceNotPBT summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*not PBT.*"]) />
</#function>

<#function isSubstancePBT summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*is PBT.*"]) />
</#function>

<#function isHandledasPBT summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*is handled.*"]) />
</#function>

<#function isPBTdoesNotApply summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*does not apply.*"]) />
</#function>

<#function isFurtherInformationForPBT summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*further information.*"]) />
</#function>

<#function isEmissionCharacterisation summary>
	<#if !(summary?has_content)>
		<#return false>
	</#if>
	<#local PBTstatus = summary.PbtAssessmentOverallResult.Regarded />
	<#return com.picklistValueMatchesPhrases(PBTstatus, [".*is PBT.*", ".*is handled.*"]) />
</#function>
