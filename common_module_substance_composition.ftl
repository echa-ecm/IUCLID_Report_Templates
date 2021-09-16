
<!-- Substance Composition information including key information on constituents, impurities and additivies -->
<#macro substanceComposition _subject includeBatchCompositions=true>
<#compress>

	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />

	<#if !includeBatchCompositions>
		<#local batchCompositions=getAllBatchCompositions(_subject)/>
		<#local filtRecordList=[]/>
		<#list recordList as record>
			<#local isBatch=false>
			<#list batchCompositions as batchComp>
				<#if batchComp.documentKey=record.documentKey>
					<#local isBatch=true/>
					<#break>
				</#if>
			</#list>
			<#if !isBatch>
				<#local filtRecordList=com.addDocumentToSequenceAsUnique(record, filtRecordList)/>
			</#if>
		</#list>
		<#assign recordList=filtRecordList/>
	</#if>

	<#if !(recordList?has_content)>
		No relevant information available.		
	<#else>
		
		<#list recordList as record>
		
			<#if pppRelevant??><para xml:id="${record.documentKey.uuid!}"><#else><para></#if>
			<emphasis role="HEAD-WoutNo">
				<#if pppRelevant??>
					<#if (recordList?size>1)>Composition #{record_index+1}:</#if>
				<#else>
					Name:
				</#if>
				<#if record.GeneralInformation.Name?has_content><@com.text record.GeneralInformation.Name/><#else><@com.text record.name/></#if>
			</emphasis>			
				<#if record.GeneralInformation.TypeOfComposition?has_content>
				(<@com.picklist record.GeneralInformation.TypeOfComposition/>)
				</#if>			
			</para>
			
			<#if record.GeneralInformation.StateForm?has_content>
				<para><emphasis role="underline">State/form:</emphasis> <@com.picklist record.GeneralInformation.StateForm/></para>
			</#if>
			
			<#if record.DegreeOfPurity.Purity?has_content>
				<para><emphasis role="underline">Degree of purity:</emphasis> <@com.range record.DegreeOfPurity.Purity/></para>
			</#if>
			
			<#if record.GeneralInformation.DescriptionOfComposition?has_content>
				<para><emphasis role="underline">Description:</emphasis> <@com.text record.GeneralInformation.DescriptionOfComposition/></para>
			</#if>		
				
				<!-- Constituents -->
				<#assign itemList = record.Constituents.Constituents />
				<#if itemList?has_content>
					<@com.emptyLine/>
					<table border="1">
						<title>Constituents
						<#if record.GeneralInformation.Name?has_content>
						(<@com.text record.GeneralInformation.Name/>)</#if></title>
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<tbody>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Constituent</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Typical concentration</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Concentration range</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
							</tr>
							<#list itemList as item>
								<tr>
									<td>
										<@referenceSubstanceData item.ReferenceSubstance/>
									</td>
									<td>
										<@com.range item.ProportionTypical/>
									</td>
									<td>
										<@com.range item.Concentration/>
									</td>
									<td>
										<@com.text item.Remarks/>
									</td>
								</tr>
							</#list>
						</tbody>
					</table>
				</#if>
				
				<!-- Impurities -->
				<#assign itemList = record.Impurities.Impurities />
				<#if itemList?has_content>
					<@com.emptyLine/>
					<table border="1">
						<title>Impurities 
						<#if record.GeneralInformation.Name?has_content>
						(<@com.text record.GeneralInformation.Name/>)</#if></title>
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<tbody>
							<tr>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Constituent</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Typical concentration</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Concentration range</emphasis></th>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
							</tr>
							<#list itemList as item>
								<tr>
									<td>
										<@referenceSubstanceData item.ReferenceSubstance/>
									</td>
									<td>
										<@com.range item.ProportionTypical/>
									</td>
									<td>
										<@com.range item.Concentration/>
									</td>
									<td>
										<#if item.RelevantForClassificationLabeling><emphasis role="bold">Impurity is relevant for C&amp;L of the substance</emphasis><?linebreak?></#if>
										<@com.text item.Remarks/>
									</td>
								</tr>
							</#list>
						</tbody>
					</table>
				</#if>
				
				<!-- Additives -->
				<#assign itemList = record.Additives.Additives />
				<#if itemList?has_content>
					<@com.emptyLine/>
					<table border="1">
						<title>Additives <#if record.GeneralInformation.Name?has_content>
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
										<@referenceSubstanceData item.ReferenceSubstance/>
									</td>
									<td>
										<@com.picklist item.Function/>
									</td>
									<td>
										<@com.range item.ProportionTypical/>
									</td>
									<td>
										<@com.range item.Concentration/>
									</td>
									<td>
										<#if item.RelevantForClassificationLabeling><emphasis role="bold">Impurity is relevant for C&amp;L of the substance</emphasis><?linebreak?></#if>
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

<#macro batchAnalysisSummary subject>
	<#compress>

		<#-- Get doc-->
		<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", 'AnalyticalProfileOfBatches') />

		<#-- Iterate-->
		<#if summaryList?has_content>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Summary</emphasis></para>

			<#local printSummaryName = summaryList?size gt 1 />

			<#list summaryList as summary>
				<@com.emptyLine/>

				<#if printSummaryName><para><emphasis role="bold">#${summary_index+1}: <@com.text summary.name/></emphasis></para></#if>


				<#--Key Information-->
				<#if summary.DescriptionOfKeyInformation?has_content>
					<para><emphasis role="bold">Key information: </emphasis></para>


					<#if summary.DescriptionOfKeyInformation.DescriptionOfKeyInformation?has_content>
						<para role="indent"><@com.richText summary.DescriptionOfKeyInformation.DescriptionOfKeyInformation/></para>
					</#if>

					<#if summary.DescriptionOfKeyInformation.DescriptionOfKeyInformationConfidential?has_content>
						<para role="indent"><emphasis role="underline">Confidential</emphasis><@com.richText summary.DescriptionOfKeyInformation.DescriptionOfKeyInformationConfidential/></para>
					</#if>

				</#if>

				<#-- Technical Spec-->
				<#if summary.DescriptionOfKeyInformation.TechnicalSpecification?has_content>
					<#local techSpec=iuclid.getDocumentForKey(summary.DescriptionOfKeyInformation.TechnicalSpecification)/>
					<#if techSpec?has_content>
						<para><emphasis role="bold">Technical specification: </emphasis>
							<emphasis role="underline"><command linkend="${techSpec.documentKey.uuid!}">
								<#if techSpec.GeneralInformation.Name?has_content>
									<@com.text techSpec.GeneralInformation.Name/>
								<#else>
									<@com.text techSpec.name/>
								</#if>
							</command></emphasis>
						</para>
					</#if>
				</#if>

				<#--5-batch analysis-->
				<#if summary.AdministrativeDataSummary.BatchAnalysis?has_content>
					<para><emphasis role="bold">5-batch analysis:</emphasis></para>

					<#list summary.AdministrativeDataSummary.BatchAnalysis as batchAn>

						<#if (summary.AdministrativeDataSummary.BatchAnalysis?size>1)>
							<para><emphasis role="underline">Batch analysis #${batchAn_index+1}</emphasis></para>
						</#if>

						<para role="small"><@batchAnalysisTable batchAn/></para>

					</#list>
				</#if>

				<#--Discussion-->
				<#if summary.Discussion.Discussion?has_content>
					<para><emphasis role="bold">Discussion:</emphasis></para>
					<para role="indent"><@com.richText summary.Discussion.Discussion/></para>
				</#if>

			</#list>
		</#if>


	</#compress>
</#macro>

<#macro batchAnalysisTable batchPath>
	<#compress>


	<#local nBatch=batchPath.SubstanceCompositionAnalysis?size/>
	<#local batchCompHash={}/>
	<#local compTypes=["Constituents", "Impurities", "Additives"]/>

	<#list batchPath.SubstanceCompositionAnalysis as batch>
		<#local batchComp=iuclid.getDocumentForKey(batch)/>
		<#local batchNo>batch${batch_index+1}</#local>
		<#list compTypes as compType>
			<#local batchCompPath='batchComp.'+compType+'.'+compType>
			<#local batchCompPath=batchCompPath?eval/>
			<#if batchCompPath?has_content>
				<#list batchCompPath as comp>
<#--			<#if batchComp.Constituents.Constituents?has_content>-->
<#--				<#list batchComp.Constituents.Constituents as comp>-->
					<#if comp.ReferenceSubstance?has_content>
						<#local refSub=iuclid.getDocumentForKey(comp.ReferenceSubstance)/>

						<#local refSubUuid=refSub.documentKey.uuid/>
						<#local refSubName=refSub.ReferenceSubstanceName/>
<#--						<#local refSubType>-->
<#--							<#if compPath?contains("consti")>-->
<#--							constituent-->
<#--							<#elseif compPath?contains("add")>additive-->
<#--							<#else>impurity-->
<#--							</#if>-->
<#--						</#local>-->
<#--						<#local refSubFunction>-->
<#--							<#if comp.hasElement('Function')><@com.picklist comp.Function/></#if>-->
<#--						</#local>-->
						<#local conc><@com.range comp.ProportionTypical/></#local>
						<#local concRange><@com.range comp.Concentration/></#local>

						<#local batchHash = {'conc':conc, 'range': concRange}/>

						<#if batchCompHash?keys?seq_contains(refSubUuid)>
							<#local refSubHashEntry = batchCompHash[refSubUuid] + {batchNo:batchHash}/>
						<#else>
							<#local refSubHashEntry = {'name': refSubName,
<#--							'type': refSubType, 'function': refSubFunction, -->
							batchNo:batchHash}/>
						</#if>

						<#local refSubHash = { refSubUuid : refSubHashEntry}/>
						<#local batchCompHash = batchCompHash + refSubHash/>
					</#if>
				</#list>
			</#if>
		</#list>
	</#list>

	<table border="1">
		<title></title>

		<tbody>
			<tr>
				<th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Component</emphasis></th>
				<th colspan="${nBatch}"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Batches</emphasis></th>
			</tr>
			<tr>
				<#list 1..nBatch as i>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">#{i}</emphasis></th>
				</#list>
			</tr>

			<#list batchCompHash as refSubUuid, refSubData>
				<tr>
					<td>${refSubData['name']}</td>

					<#list 1..nBatch as i>
						<#local batchNo>batch${i}</#local>
						<td>
							<#if refSubData?keys?seq_contains(batchNo)>
								${refSubData[batchNo]['conc']}
								<?linebreak?>
								${refSubData[batchNo]['range']}
							</#if>
						</td>
					</#list>
				</tr>
			</#list>
		</tbody>
	</table>

<#--		Add reference-->
	<#--.Reference-->
	</#compress>
</#macro>

<#function getAllBatchCompositions subject>

	<#local allBatchCompositions=[]/>

	<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "ENDPOINT_SUMMARY", 'AnalyticalProfileOfBatches') />

	<#list summaryList as summary>
		<#local summaryBatchCompositions = getBatchCompositions(summary)/>
		<#list summaryBatchCompositions as batchComp>
			<#local allBatchCompositions = com.addDocumentToSequenceAsUnique(batchComp, allBatchCompositions)/>
		</#list>
	</#list>

	<#return allBatchCompositions/>
</#function>

<#function getBatchCompositions summary>
	<#local batchCompositions=[]>

	<#list summary.AdministrativeDataSummary.BatchAnalysis as batchAnalysis>
		<#list batchAnalysis.SubstanceCompositionAnalysis as batch>
			<#local batchComp=iuclid.getDocumentForKey(batch)/>
			<#local batchCompositions = com.addDocumentToSequenceAsUnique(batchComp, batchCompositions)/>
		</#list>
	</#list>

	<#return batchCompositions/>
</#function>


<!-- Overall substance composition information -->
<#macro overallSubstanceComposition _subject>
<#compress>
	
	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />
	<#if (csrRelevant?? && !(recordList?has_content) && !(recordList?size gt 1)) || (!(csrRelevant??) && !(recordList?has_content))>
		No relevant information available.		
		<#else>
	
		<para>Overall information on composition:</para>
		<informaltable border="1">
			<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
				<col width="30%" />
				<col width="35%" />
				<col width="35%" />
			<#else>
				<col width="35%" />
				<col width="65%" />
			</#if>
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Composition</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Related composition(s)</emphasis></th>
					<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Related assessment entity</emphasis></th>
					</#if>
				</tr>
				
				<@com.emptyLine/>
				
				<#list recordList as record>
					<tr>
						<td>
							<para>
							<@com.text record.GeneralInformation.Name/> 
								<#if record.GeneralInformation.TypeOfComposition?has_content>
									(<@com.picklist record.GeneralInformation.TypeOfComposition/>)
								</#if>
							</para>
						</td>
						<td>
							<@relatedCompositionNameList record.GeneralInformation.RelatedCompositions.RelatedComposition/>
							<para>
								<@com.text record.GeneralInformation.RelatedCompositions.ReferenceToRelatedCompositions/>
							</para>
						</td>
						<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
							<td>
								<#assign aeList = getAssessmentEntitiesRelatedToComposition(record)/>
								<#list aeList as ae>
									<@com.text ae.AssessmentEntityName/>
									<?linebreak?>
								</#list>
							</td>
						</#if>
					</tr>
				</#list>
			</tbody>
		</informaltable>
	</#if>
	
</#compress>
</#macro>
						
<!-- Macros and functions -->
<#function getAssessmentEntitiesRelatedToComposition compositionRecord>
	<#local aeList = [] />
	<#list com.assessmentEntities as ae>
		<#if isAERegisteredSubstanceAsSuch(ae)>
			<#local aeList = aeList + [ae] />
		<#elseif compositionOfAEIsReferenceSubstance(ae)>
			<#local compositionList = ae.RelatedComposition />
			<#if compositionList?has_content>
				<#list compositionList as compKey>
					<#if compositionRecord.documentKey == compKey>
						<#local aeList = aeList + [ae] />
					</#if>
				</#list>
			</#if>
		<#else>
			<#local compositionList = ae.Compositions />
			<#if compositionList?has_content>
				<#list compositionList as compKey>
					<#if compositionRecord.documentKey == compKey>
						<#local aeList = aeList + [ae] />
					</#if>
				</#list>
			</#if>
		</#if>
	</#list>
		
	<#return aeList />
</#function>

<#function isAERegisteredSubstanceAsSuch assessmentEntity>
	<#local aeSubType = assessmentEntity.documentSubType />
	<#if aeSubType?matches("RegisteredSubstanceAsSuch")>
		<#return true />
	</#if>
	<#return false />
</#function>

<#function compositionOfAEIsReferenceSubstance assessmentEntity>
	<#local aeSubType = assessmentEntity.documentSubType />
	<#if aeSubType?matches("GroupOfConstituentInTheRegisteredSubstance") || aeSubType?matches("TransformationProductOfTheRegisteredSubstance")>
		<#return true />
	</#if>
	<#return false />
</#function>

<#assign referenceSubstancesInformation = [] />

<#macro referenceSubstanceData referenceSubstanceKey >
<#compress>
	<#local refSubst = iuclid.getDocumentForKey(referenceSubstanceKey) />
	<#if refSubst?has_content>
		<#if pppRelevant??>
			<command linkend="${refSubst.documentKey.uuid!}"><@com.text refSubst.ReferenceSubstanceName/></command>
			<#assign referenceSubstancesInformation = com.addDocumentToSequenceAsUnique(refSubst, referenceSubstancesInformation) />
		<#else>
			<@com.text refSubst.ReferenceSubstanceName/>
			EC no.: <@com.inventoryECNumber com.getReferenceSubstanceKey(referenceSubstanceKey)/>
		</#if>
  	</#if>
</#compress>
</#macro>

<#macro relatedCompositionNameList relatedCompositionRepeatableBlock>
<#compress>
	<#if relatedCompositionRepeatableBlock?has_content>
		<#list relatedCompositionRepeatableBlock as blockItem>
			<#local composition = iuclid.getDocumentForKey(blockItem) />
			
			<#if composition.GeneralInformation.Name?has_content>
			<@com.text composition.GeneralInformation.Name/>
			<#else>
			<para><emphasis role="italic" >Composition: no name defined </emphasis></para>
			</#if>
			<#if blockItem_has_next>; </#if>
		</#list>
  	</#if>
</#compress>
</#macro>

<#function getAssessmentEntitiesRelatedToComposition compositionRecord>
	<#local aeList = [] />
	<#list studyandsummaryCom.assessmentEntities as ae>
		<#if isAERegisteredSubstanceAsSuch(ae)>
			<#local aeList = aeList + [ae] />
		<#elseif compositionOfAEIsReferenceSubstance(ae)>
			<#local compositionList = ae.RelatedComposition />
			<#if compositionList?has_content>
				<#list compositionList as compKey>
					<#if compositionRecord.documentKey == compKey>
						<#local aeList = aeList + [ae] />
					</#if>
				</#list>
			</#if>
		<#else>
			<#local compositionList = ae.Compositions />
			<#if compositionList?has_content>
				<#list compositionList as compKey>
					<#if compositionRecord.documentKey == compKey>
						<#local aeList = aeList + [ae] />
					</#if>
				</#list>
			</#if>
		</#if>
	</#list>
		
	<#return aeList />
</#function>

<#function isAERegisteredSubstanceAsSuch assessmentEntity>
	<#local aeSubType = assessmentEntity.documentSubType />
	<#if aeSubType?matches("RegisteredSubstanceAsSuch")>
		<#return true />
	</#if>
	<#return false />
</#function>

<#function compositionOfAEIsReferenceSubstance assessmentEntity>
	<#local aeSubType = assessmentEntity.documentSubType />
	<#if aeSubType?matches("GroupOfConstituentInTheRegisteredSubstance") || aeSubType?matches("TransformationProductOfTheRegisteredSubstance")>
		<#return true />
	</#if>
	<#return false />
</#function>

<#macro relatedCompositionNameList relatedCompositionRepeatableBlock>
<#compress>
	<#if relatedCompositionRepeatableBlock?has_content>
		<#list relatedCompositionRepeatableBlock as blockItem>
			<#local composition = iuclid.getDocumentForKey(blockItem) />
			
			<#if composition.GeneralInformation.Name?has_content>
			<@com.text composition.GeneralInformation.Name/>
			<#else>
			<para><emphasis role="italic" >Composition: no name defined </emphasis></para>
			</#if>
			<#if blockItem_has_next>; </#if>
		</#list>
  	</#if>
</#compress>
</#macro>