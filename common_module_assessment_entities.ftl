
<!-- Substance Composition information including key information on constituents, impurities and additivies -->
<#macro assessmentEntityTable _subject referenceSubstance>
<#compress>
	
	<#assign aeList = studyandsummaryCom.assessmentEntities/>
	
	<informaltable border="1">
		<col width="35%" />
		<col width="65%" />
		<tbody>
			<tr>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment entity name</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Remarks</emphasis></th>
			</tr>
			<#list aeList as ae>
				<tr>
					<td>			
					<#if ae.AssessmentEntityName?has_content>
						<emphasis role="bold"><@com.text ae.AssessmentEntityName/><para xml:id="${ae.documentKey.uuid!}"></para></emphasis>
							<#else>
							<para>--</para>
					</#if>
						<?linebreak?>
					</td>
					
					<td>
						<para>
							Assessment entity composition:
							<@assessmentEntityCompositionList ae/>
						</para>
						<#if ae.hasElement("Description") && ae.Description?has_content>
							<para>
								Additional information: <@com.richText ae.Description/>
							</para>
						</#if>
					</td>
				</tr>
			</#list>
		</tbody>
	</informaltable>
</#compress>
</#macro>
						
<!-- Macros and functions -->


<#macro assessmentEntityCompositionList assessmentEntity>
<#compress>
	<#if isAERegisteredSubstanceAsSuch(assessmentEntity)>
		The composition(s) for this assessment entity is the one listed in section 1.2 (Composition of the Substance)
	<#elseif assessmentEntity.Compositions?has_content>
		<#list assessmentEntity.Compositions as item>
			<#if compositionOfAEIsReferenceSubstance(assessmentEntity)>
			
				<@com.referenceSubstanceName com.getReferenceSubstanceKey(item)/>		
				EC no.: <@com.inventoryECNumber com.getReferenceSubstanceKey(item)/>
			
			<#else/>
				<#local compositionRecord = iuclid.getDocumentForKey(item) />
				<#if compositionRecord?has_content>
					<@com.text compositionRecord.GeneralInformation.Name/>
				</#if>
			</#if>
			<#if item_has_next>; </#if>
		</#list>
	</#if>
</#compress>
</#macro>

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