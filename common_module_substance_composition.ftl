
<!-- Substance Composition information including key information on constituents, impurities and additivies -->
<#macro substanceComposition _subject>
<#compress>

	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />
	<#if !(recordList?has_content)>
		No relevant information available.		
	<#else/>
		
		<#list recordList as record>
		
			<para>
			<emphasis role="HEAD-WoutNo">Name: <#if record.GeneralInformation.Name?has_content><@com.text record.GeneralInformation.Name/><#else> 
			<@com.text record.name/></#if>
			</emphasis>			
				<#if record.GeneralInformation.TypeOfComposition?has_content>
				(<@com.picklist record.GeneralInformation.TypeOfComposition/>)
				</#if>			
			</para>
			
			<#if record.GeneralInformation.StateForm?has_content>
			<para>State/form: <@com.picklist record.GeneralInformation.StateForm/></para>
			</#if>
			
			<#if record.DegreeOfPurity.Purity?has_content>
			<para>Degree of purity: <@com.range record.DegreeOfPurity.Purity/></para>
			</#if>
			
			<#if record.GeneralInformation.DescriptionOfComposition?has_content>
			<para>Description: <@com.text record.GeneralInformation.DescriptionOfComposition/></para>
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
				
		</#list>
	</#if>
		
</#compress>
</#macro>

<!-- Overall substance composition information -->
<#macro overallSubstanceComposition _subject>
<#compress>
	
	<#assign recordList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "FLEXIBLE_RECORD", "SubstanceComposition") />
	<#if (csrRelevant?? && !(recordList?has_content) && !(recordList?size gt 1)) || (!(csrRelevant??) && !(recordList?has_content))>
		No relevant information available.		
		<#else/>
	
		<para>Overall information on composition:</para>
		<informaltable border="1">
			<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
				<col width="30%" />
				<col width="35%" />
				<col width="35%" />
			<#else/>
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
		<#else/>
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

<#macro referenceSubstanceData referenceSubstanceKey >
<#compress>
	<#local refSubst = iuclid.getDocumentForKey(referenceSubstanceKey) />
	<#if refSubst?has_content>
		<@com.text refSubst.ReferenceSubstanceName/>
		EC no.: <@com.inventoryECNumber com.getReferenceSubstanceKey(referenceSubstanceKey)/>
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
		<#else/>
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