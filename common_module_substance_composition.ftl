
<!-- Substance Composition information including key information on constituents, impurities and additivies -->
<#macro substanceComposition _subject includeBatchCompositions=true>
<#compress>

	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />

	<#--Remove substance composition documents that correspond to batches if there is more than 1 entry-->
	<#local addMessage=''/>
	<#if (recordList?size > 1) && !includeBatchCompositions>
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

		<#-- If all compositions are used as batches, report a message -->
		<#if (recordList?size>0) && (filtRecordList?size==0)>
			<#local addMessage> For batch compositions, see section below.</#local>
		</#if>
		
		<#assign recordList=filtRecordList/>
	</#if>

	<#if !(recordList?has_content)>
		<para>No relevant information available.${addMessage}</para>		
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
		<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "FLEXIBLE_SUMMARY", 'AnalyticalProfileOfBatches') />

		<#-- Iterate-->
		<#if summaryList?has_content>

			<#local printSummaryName = summaryList?size gt 1 />

			<#list summaryList as summary>
				<@com.emptyLine/>

				<#local summUrl=iuclid.webUrl.documentView(summary.documentKey) />

				<para><emphasis role="bold">
					<#if printSummaryName>#${summary_index+1}:</#if>
					<ulink url="${summUrl}"><@com.text summary.name/></ulink>
				</emphasis></para>

				<#--Key Information-->
				<#if summary.DescriptionOfKeyInformation?has_content>
					<para><emphasis role="bold">Key information: </emphasis></para>

					<#if summary.DescriptionOfKeyInformation.DescriptionOfKeyInformation?has_content>
						<para style="background-color:#f7f7f7" role="indent"><@com.richText summary.DescriptionOfKeyInformation.DescriptionOfKeyInformation/></para>
					</#if>

					<#if summary.DescriptionOfKeyInformation.DescriptionOfKeyInformationConfidential?has_content>
						<para style="background-color:#f7f7f7" role="indent"><emphasis role="underline">Confidential</emphasis><@com.richText summary.DescriptionOfKeyInformation.DescriptionOfKeyInformationConfidential/></para>
					</#if>

				</#if>

				<#-- Technical Spec-->
				<#local techSpec=iuclid.getDocumentForKey(summary.DescriptionOfKeyInformation.TechnicalSpecification)/>

				<#--5-batch analysis-->
				<#if summary.AdministrativeDataSummary.BatchAnalysis?has_content>
					<para><emphasis role="bold">5-batch analysis:</emphasis></para>

					<#list summary.AdministrativeDataSummary.BatchAnalysis as batchAn>

						<#if (summary.AdministrativeDataSummary.BatchAnalysis?size>1)>
							<para><emphasis role="underline">Batch analysis #${batchAn_index+1}</emphasis></para>
							<@com.emptyLine/>
						</#if>

						<#-- site -->
						<#if batchAn.ManufacturingSite?has_content>
							<#local site=iuclid.getDocumentForKey(batchAn.ManufacturingSite)/>
							Manufacturing site: <@printSite site/>
						</#if>

						<#-- remarks -->
						<#if batchAn.Remarks?has_content>
							<para>Remarks:</para>
							<para role="indent"><@com.text batchAn.Remarks/></para>
						</#if>

						<#-- cross-referenced study -->
						<#if batchAn.CrossReference?has_content>
							<para>Linked studies:</para>
							<@printCrossReferences batchAn.CrossReference/>
						</#if>
						
						<#-- reference -->
						<#if batchAn.Reference?has_content>
							<para>References:</para>
							<@printReferences batchAn.Reference/>
						</#if>

						<#-- batch table -->
						<#if batchAn.SubstanceCompositionAnalysis?has_content>
							<para>Batch analysis:</para>
							<para role="small"><@batchAnalysisTable batchAn techSpec/></para>
						<#else>
							<para>No batch composition has been provided.</para>
						</#if>

						<#-- QC table -->
						<#if batchAn.QualityControl?has_content>
							<para>Quality control:</para>
							<para role="small"><@batchQC batchAn.QualityControl site techSpec/></para>
						</#if>

						<@com.emptyLine/>

					</#list>
				</#if>

				<#--Discussion-->
				<#if summary.Discussion.Discussion?has_content>
					<para><emphasis role="bold">Discussion:</emphasis></para>
					<para style="background-color:#f7f7f7" role="indent"><@com.richText summary.Discussion.Discussion/></para>
				</#if>

			</#list>
		</#if>

	</#compress>
</#macro>

<#macro batchAnalysisTable batchPath techSpec="">
	<#compress>

	<#--set variables-->
	<#local nBatch=batchPath.SubstanceCompositionAnalysis?size/>
	<#local batchCompHash={}/>
	<#local compTypes=["Constituents", "Impurities", "Additives"]/>
	<#local techSpecExists=techSpec?has_content/>

	<#--get list of batches and add techical specification if exists-->
	<#local batchCompList=[]/>

	<#list batchPath.SubstanceCompositionAnalysis as batch>
		<#local batchComp=iuclid.getDocumentForKey(batch)/>
		<#local batchCompList = batchCompList + [batchComp]/>
	</#list>

	<#if techSpecExists>
		<#local batchCompList = batchCompList + [techSpec]/>
	</#if>

	<#--iterate list-->
	<#list batchCompList as batchComp>

		<#local batchNo>batch${batchComp_index}</#local> <#-- the last batch correpsonds to the techspec-->

		<#list compTypes as compType>
			<#local batchCompPath='batchComp.'+compType+'.'+compType>
			<#local batchCompPath=batchCompPath?eval/>
			<#if batchCompPath?has_content>
				<#list batchCompPath as comp>
					<#if comp.ReferenceSubstance?has_content>
						<#local refSub=iuclid.getDocumentForKey(comp.ReferenceSubstance)/>
						<#local refSubUuid=refSub.documentKey.uuid/>
						<#local refSubName=refSub.ReferenceSubstanceName/>
						<#local refSubType>
							<#if compType?contains("Consti")>constituent
							<#elseif compType?contains("Add")>additive
							<#else>impurity
							</#if>
						</#local>
						<#local refSubFunction>
							<#if comp.hasElement('Function')><@com.picklist comp.Function/></#if>
						</#local>
						<#local conc><@com.range comp.ProportionTypical/></#local>
						<#local concRange><@com.range comp.Concentration/></#local>

						<#local batchHash = {'conc':conc, 'range': concRange}/>

						<#if batchCompHash?keys?seq_contains(refSubUuid)>
							<#local refSubHashEntry = batchCompHash[refSubUuid] + {batchNo:batchHash}/>

							<#if !batchCompHash[refSubUuid]['type']?seq_contains(refSubType)>
								<#local refSubType = batchCompHash[refSubUuid]['type'] + [refSubType]/>
								<#local refSubHashEntry = batchCompHash[refSubUuid] + {'type': refSubType}/>
							</#if>
							<#if refSubFunction?has_content && !batchCompHash[refSubUuid]['function']?seq_contains(refSubFunction)>
								<#if batchCompHash[refSubUuid]['function']?join("")?has_content>
									<#local refSubFunction = batchCompHash[refSubUuid]['function'] + [refSubFunction]/>
								<#else>
									<#local refSubFunction = [refSubFunction]/>
								</#if>
								<#local refSubHashEntry = batchCompHash[refSubUuid] + {'function': refSubFunction}/>
							</#if>
						<#else>
							<#local refSubHashEntry = {'ref': refSub,
								'type': [refSubType], 'function': [refSubFunction],
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
			<tr align="center" valign="middle">
				<th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Component</emphasis></th>
				<th colspan="${nBatch}"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Batches</emphasis></th>
				<#if techSpecExists>
					<th rowspan="2"><?dbfo bgcolor="#FBDDA6" ?>
						<emphasis role="bold">
							<command linkend="${batchCompList[nBatch].documentKey.uuid!}">Proposed technical specification</command>
						</emphasis>
					</th>
				</#if>
			</tr>
			<tr>
				<#list 0..(nBatch-1) as i>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold"><@com.text batchCompList[i].GeneralInformation.Name/></emphasis></th>
				</#list>
			</tr>

			<#list batchCompHash as refSubUuid, refSubData>
				<tr>
					<td>
						<command linkend="${refSubUuid}"><@com.text refSubData['ref'].ReferenceSubstanceName/></command>
						<#assign referenceSubstancesInformation = com.addDocumentToSequenceAsUnique(refSubData['ref'], referenceSubstancesInformation) />
						<?linebreak?>
						<#local refTypes=""/>
						<#list refSubData['type'] as refType>
							<#local refTypes = refTypes + refType/>
							<#if refType?contains("additive")>
							 	<#local refFunction=refSubData['function']?join(', ')/>
							 	<#if refFunction?has_content>
							 		<#local refTypes = refTypes + " (" + refFunction + ")"/>
							 	</#if>
							</#if>
							<#if refType_has_next><#local refTypes = refTypes + ", "/></#if>
						</#list>
						${refTypes}
					</td>

					<#list 0..nBatch as i>
						<#local batchNo>batch${i}</#local>
						<#if techSpecExists || i!=nBatch>
							<td>
								<#if refSubData?keys?seq_contains(batchNo)>

										<#if refSubData[batchNo]['conc']?has_content>
											<para>${refSubData[batchNo]['conc']}</para>
										</#if>
										<#if refSubData[batchNo]['range']?has_content>
											<para>[${refSubData[batchNo]['range']}]</para>
										</#if>
								</#if>
							</td>
						</#if>
					</#list>
				</tr>
			</#list>
		</tbody>
	</table>

	</#compress>
</#macro>

<#macro batchQC qcBlock site techSpec>
	<#compress>

		<#list qcBlock as qc>

			<#local units><@com.value qc.Units/></#local>

			<#if ((qcBlock?size)>1)><para><emphasis role="underline">QC #${qc?index+1}:</emphasis></para></#if>

			<table border="1">
				<title></title>

				<col width="5%" />
				<col width="20%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />


				<tbody>

					<tr valign="middle">
						<td colspan="6"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Site of manufacture</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?>
							<#if site?has_content><@printSite site/></#if>
						</td>
					</tr>

					<tr valign="middle">
						<td colspan="6"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Number of batches / lots analysed</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><@com.value qc.NumberOfBatches/></td>
					</tr>

					<tr valign="middle">
						<td colspan="6"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Date batches/lots produced</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><@com.value qc.Date/></td>
					</tr>

					<tr align="center" valign="middle">
						<td><?dbfo bgcolor="#FBDDA6" ?></td>
						<td><?dbfo bgcolor="#FBDDA6" ?></td>
						<td colspan="4"><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Content <#if units?has_content>(${units})</#if></emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?></td>
					</tr>

					<tr align="center" valign="middle">
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">No.</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Component</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Minimum observed</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Mean value</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Standard deviation</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Maximum observed</emphasis></td>
						<td><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Proposed specification</emphasis></td>
					</tr>

					<#-- list over components 
						NOTE: it could be sorted to take A.s. first
					-->
					<#list qc.QCData as qcData>
						<tr>
							<td>${qcData?index+1}</td>
							<td>
								<#if qcData.Component?has_content>
									<#local comp=iuclid.getDocumentForKey(qcData.Component)/>
									<#local compUrl=iuclid.webUrl.documentView(comp.documentKey) />
									<ulink url="${compUrl}"><@com.value comp.ReferenceSubstanceName/></ulink>
								</#if>
							</td>
							<td><@com.value qcData.Min/></td>
							<td><@com.value qcData.Avg/></td>
							<td><@com.value qcData.SD/></td>
							<td><@com.value qcData.Max/></td>
							<td><?dbfo bgcolor="#FBDDA6" ?>
								<#if techSpec?has_content && qcData.Component?has_content>
									<#local conc = getComponentFromSubstanceComposition(techSpec, comp)/>
									${conc}
								</#if>
							</td>
						</tr>
					</#list>
					
				</tbody>
			</table>

			<@com.emptyLine/>

		</#list>

	</#compress>
</#macro>

<#macro printCrossReferences crefs role='indent'>
	<#compress>
		<#list crefs as cref>
			<para role="${role}">
				<#if cref.ReasonPurposeForCrossReference?has_content>
					<@com.value cref.ReasonPurposeForCrossReference/>:
				</#if>

				<#if cref.RelatedInformation?has_content>
					<#local study=iuclid.getDocumentForKey(cref.RelatedInformation)/>
					<#local studyUrl=iuclid.webUrl.documentView(study.documentKey) />
					<ulink url="${studyUrl}"><@com.text study.name/></ulink>
				</#if>

				<#if cref.Remarks?has_content>
					- <@com.value cref.Remarks/>
				</#if>
			</para>
		</#list>
	</#compress>
</#macro>

<#macro printReferences refs role='indent'>
	<#compress>
		<#list refs as refKey>
			
			<#local ref=iuclid.getDocumentForKey(refKey)/>
			<#local refUrl=iuclid.webUrl.documentView(ref.documentKey) />

			<para role="${role}">
				<ulink url="${refUrl}">
					<@com.text ref.GeneralInfo.Name/><#if ref.GeneralInfo.LiteratureType?has_content> (<@com.picklist ref.GeneralInfo.LiteratureType/>)</#if>,
					<@com.text ref.GeneralInfo.Author/>, <@com.number ref.GeneralInfo.ReferenceYear/><#if ref.GeneralInfo.ReportNo?has_content>,<@com.text ref.GeneralInfo.ReportNo/></#if>
				</ulink>
			</para>

		</#list>
	</#compress>
</#macro>

<#macro printSite site>
	<#compress>
		<#local siteUrl=iuclid.webUrl.documentView(site.documentKey) />
		<ulink url="${siteUrl}"><@com.value site.GeneralInfo.SiteName/></ulink>
	</#compress>
</#macro>

<#function getAllBatchCompositions subject>

	<#local allBatchCompositions=[]/>

	<#local summaryList = iuclid.getSectionDocumentsForParentKey(subject.documentKey, "FLEXIBLE_SUMMARY", 'AnalyticalProfileOfBatches') />

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

<#function getComponentFromSubstanceComposition substanceComp component>
	
	<#local compTypes=["Constituents", "Impurities", "Additives"]/>

	<#list compTypes as compType>
		<#local substanceCompPath='substanceComp.'+compType+'.'+compType>
		<#local substanceCompPath=substanceCompPath?eval/>
		<#if substanceCompPath?has_content>
			<#list substanceCompPath as comp>
				<#if comp.ReferenceSubstance?has_content>
					<#local refSub=iuclid.getDocumentForKey(comp.ReferenceSubstance)/>
					<#local refSubUuid=refSub.documentKey.uuid/>
					<#if refSubUuid==component.documentKey.uuid>
						<#local conc><@com.value comp.ProportionTypical/></#local>
						<#return conc/>
					</#if>
				</#if>
			</#list>
		</#if>
	</#list>

	<#return ''/>
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

<#macro referenceSubstanceData referenceSubstanceKey>
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


<#-- Macro to display basic information of the metabolites (coming from the active substance) included in a mixture dataset:
	_subject should be a mixture dataset-->
<#macro metabolitesInformation _subject>
	<#compress>

	<#local metabCompList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_SUMMARY", "Metabolites") />

	<#if !(metabCompList?has_content)>

		No relevant information on metabolites available.

	<#else>

		<#list metabCompList as metabComp>

			<#if (metabCompList?size > 1)><para><emphasis role="bold">Metabolites #${metabComp_index+1}: <@com.text metabComp.name/></emphasis></para></#if>

			<#if metabComp.MetabolitesInfo.ParentOfMetabolites?has_content>
				<para>
					<emphasis role="underline">Parent of metabolites:</emphasis>
					<#--NOTE: can be substance or reference substance-->
					<#local parentSub=iuclid.getDocumentForKey(metabComp.MetabolitesInfo.ParentOfMetabolites)/>
					<#if parentSub?has_content>
						<#if parentSub.documentType=="SUBSTANCE">
							<@com.substanceName parentSub/>
							<#if parentSub.ReferenceSubstance.ReferenceSubstance?has_content>
								<?linebreak?>(ref. <@referenceSubstanceData parentSub.ReferenceSubstance.ReferenceSubstance/>)
							</#if>
						<#elseif parentSub.documentType=="REFERENCE_SUBSTANCE">
							<@referenceSubstanceData metabComp.MetabolitesInfo.ParentOfMetabolites/>
						</#if>
					</#if>
				</para>
			</#if>

			<#if metabComp.MetabolitesInfo.MetabolitesInfoOverview?has_content>
				<para><emphasis role="underline">Metabolites information overview: </emphasis></para>
				<para style="background-color:#f7f7f7"><@com.richText metabComp.MetabolitesInfo.MetabolitesInfoOverview/></para>
				
			</#if>

			<#if metabComp.ListMetabolites?has_content>
				<para><emphasis role="underline">List of metabolites: </emphasis></para>
				<@metabolitesTable metabComp.ListMetabolites.Metabolites/>
			</#if>

		</#list>
	</#if>

	</#compress>
</#macro>

<#macro metabolitesTable metabList>
	<#compress>
		<#if metabList?has_content>

			<table border="1">
<#--				<title>Constituents-->

				<col width="45%" />
				<col width="55%" />

				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Name</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
					</tr>

					<#list metabList as metab>
						<tr>
							<td>
								<#local metabSub=iuclid.getDocumentForKey(metab.LinkMetaboliteDataset)/>
								<#if metabSub?has_content>
									<#if metabSub.documentType=="SUBSTANCE">
										<@com.substanceName metabSub/>
										<#if metabSub.ReferenceSubstance.ReferenceSubstance?has_content>
											<?linebreak?>(ref. <@referenceSubstanceData metabSub.ReferenceSubstance.ReferenceSubstance/>)
										</#if>
									<#elseif metabSub.documentType=="REFERENCE_SUBSTANCE">
										<@referenceSubstanceData metab.LinkMetaboliteDataset/>
									</#if>
								</#if>
							</td>
							<td>
								<@com.text metab.Remarks/>
							</td>
						</tr>
					</#list>
				</tbody>
			</table>
		</#if>
	</#compress>
</#macro>