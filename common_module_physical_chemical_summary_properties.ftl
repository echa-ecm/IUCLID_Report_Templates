<#--NOTE: MODIFIED FROM ORIGINAL-->
<!-- physical chemical property data from endpoint summaries -->
<#macro physicalChemicalPropertiesTable _subject>
<#compress>

	<!-- Physicochemical properties table -->
	<#global propertyToDataMap = {
		"Physical state" :
			{"subType" : "GeneralInformation",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"listValue", "field": "PhysicalState", "postText" : "at 20°C and 101.3 kPa"},
						{"type":"listValue", "field": "Form", "preText": "Form: "},
						{"type":"mListValue", "field": "Colour", "preText": "Colour: "},
						{"type":"listValue", "field": "ColourIntensity", "preText": "Intensity: "}
						],
			"pppName" : "Appearance (physical state, colour)"},
		"Melting / freezing point" :
			{"subType" : "Melting",
			"path":"KeyValueForChemicalSafetyAssessment",
			"values": [{"type":"value", "field" : "MelFreezPoint", "postText" : "at 101.3 kPa"}],
			"infoReq" : "Melting / freezing point",
			"pppName" : "Melting point"},
		"Boiling point" :
			{"subType" : "BoilingPoint",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "BoilingPoint", "postText" : "at 101.3 kPa"}],
			"infoReq" : "Boiling point"},
		"Relative density" :
			{"subType" : "PcDensity",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "RelativeDensity", "postText" : "at 20°C"}],
			"infoReq" : "Relative density",
			"recordSubType" : "Density"},
		"Granulometry" :
			{"subType" : "ParticleSize",
			"infoReq" : "Granulometry",
			"recordSubType" : "Granulometry"},
		"Vapour pressure" :
			{"subType" : "Vapour",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "VapourPressure", "atField" : "TemperatureOf"}],
			"infoReq" : "Vapour pressure"},
		"Partition coefficient n-octanol/water (log value)" :
			{"subType" : "PartitionCoefficient",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "LowKow", "preText" : "Log Kow (Log Pow):", "atField" : "TemperatureOf"}],
			"infoReq" : "Partition coefficient n-octanol/water (log value)",
			"recordSubType" : "Partition",
			"pppName" : "Partition coefficient n-octanol/water"},
		"Water solubility" :
			{"subType" : "WaterSolubility",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "WaterSolubility", "atField" : "TemperatureOf"}],
			"infoReq" : "Water solubility",
			"pppName" : "Solubility in water"},
		"Solubility in organic solvents / fat solubility" :
			{"subType" : "SolubilityOrganic",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [
						{"type":"value", "field" : "SolubilityStandard", "preText" : "Solubility in mg/100 g standard fat:", "atField" : "AtTheTemperatureOf"},
						{"type":"value", "field" : "SolubilitySolvents", "preText" : "Solubility in organic solvents at 20°C:"}
						],
			"infoReq" : "Solubility in organic solvents / fat solubility",
			"pppName" : "Solubility in organic solvents"},
		"Surface tension" :
			{"subType" : "SurfaceTension",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "SurfaceTension", "postText" : "mN/m at 20°C"},
						{"type":"value", "field" : "Concentration", "preText" : "and ", "postText" : "mg/L"}
						],
			"infoReq" : "Surface tension"},
		"Flash point" :
			{"subType" : "FlashPoint",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "FlashPoint", "postText" : "at 1013 hPa"}],
			"infoReq" : "Flash point"},
		"Autoflammability / self-ignition temperature" :
			{"subType" : "AutoFlammability",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "AutoFlammability", "postText" : "at 1013 hPa"}],
			"infoReq" : "Self-ignition temperature",
			"pppName" : "Self heating"},
		"Flammability" :
			{"subType" : "Flammability",
			"path" : "KeyValueChemicalAssessment",
			"values" : [{"type":"listValue", "field" : "Flammability"}],
			"infoReq" : "Flammability"},
		"Explosive properties" :
			{"subType" : "Explosiveness",
			"path" : "ResultsAndDiscussion",
			"values" : [{"type":"listValue", "field" : "Explosiveness"}],
			"infoReq" : "Explosive properties",
			"pppName" : "Explosive properties"},
		"Oxidising properties" :
			{"subType" : "OxidisingProperties",
			"path" : "KeyValueChemicalAssessment",
			"values" : [{"type":"listValue", "field" : "Oxidising"}],
			"infoReq" : "Oxidising properties"},
		"Oxidation reduction potential" :
			{"subType" : "OxidReduction",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "ReductionPotential", "preText" : "Oxidation reduction potential in mV:", "atField" : "AtTheTemperatureOf"}],
			"infoReq" : "Oxidation reduction potential",
			"recordSubType" : "OxidationReduction"},
		"Stability in organic solvents and identity of relevant degradation products" :
			{"subType" : "StabilityOrganic",
			"infoReq" : "Stability in organic solvents and identity of relevant degradation products"},
		"Storage stability and reactivity towards container material" :
			{"subType" : "StorageStability",
			"infoReq" : "Reactivity towards container material",
			"pppName" : "Storage stability"},
		"Stability: thermal, sunlight, metals" :
			{"subType" : "StabilityThermal",
			"infoReq" : "Thermal stability"},
		"pH" :
			<#--NOTE: missing checkbox-->
			{"subType" : "pH",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "pH", "preText" : "pH:"},
						{"type": "value", "field" : "SolutionConcentration", "preText" : "Solution concentration: ", "postText":"%"},
						{"type": "listValue", "field" : "Justification"}],
			"pppName" : "acidity/alcalinity and pH value"},
		"Dissociation constant" :
			{"subType" : "Dissociation",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "pka", "preText" : "pKa at 20°C:"}],
			"infoReq" : "Dissociation constant",
			"recordSubType" : "DissociationConstant",
			"pppName" : "Dissociation in water"},
		"Viscosity" :
			{"subType" : "Viscosity",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "Viscosity", "preText" : "Viscosity:", "atField" : "AtTheTemperatureOf"}],
			"infoReq" : "Viscosity"},
		"Self-reactive substances" :
			{"subType" : "SelfReactiveSubstances",
			"infoReq" : "Self-reactive substances"},
		"Organic peroxide" :
			{"subType" : "OrganicPeroxide",
			"infoReq" : "Organic peroxide"},
		"Corrosive to metals" :
			{"subType" : "CorrosiveToMetals",
			"infoReq" : "Corrosive to metals"},
		"Gasses under pressure" :
			{"subType" : "GasesUnderPressure",
			"infoReq" : "Gasses under pressure"},
		"Volatility" :
			{"subType" : "HenrysLawConstant",
			"path" : "KeyValueForChemicalSafetyAssessment",
			"values" : [{"type":"value", "field" : "HenrysLawConstant", "preText" : "Henry's Law Constant:", "atField" : "AtTheTemperatureOf", "postText" : "Pa m³/mol"}],
			"infoReq" : "Volatility"},
		"Other studies" :
			{"subType" : "AdditionalPhysicoChemical",
			"infoReq" : "Other studies"}
	}/>

	<#-- if for PPP, define list of properties to be used and their order-->
	<#if pppRelevant??>
		<#if _subject.documentType=="SUBSTANCE">
			<#assign properties = ["Melting / freezing point", "Boiling point", "Vapour pressure", "Volatility", "Physical state", <#--"Spectra",-->
			"Water solubility", "Solubility in organic solvents / fat solubility", "Partition coefficient n-octanol/water (log value)", "Dissociation constant",
			"Flammability","Autoflammability / self-ignition temperature", "Flash point", "Explosive properties", "Surface tension", "Oxidising properties", "Other studies", "pH"]
			/>
		<#elseif _subject.documentType=="MIXTURE">
			<#assign properties = ["Physical state", "Explosive properties", "Oxidising properties", "Flammability", "Autoflammability / self-ignition temperature", "Flash point",
			"pH", "Viscosity", "Surface tension", "Relative density", "Storage stability and reactivity towards container material", "Stability: thermal, sunlight, metals", "Other studies" ]
			/>
		</#if>
	<#else>
		<#assign properties = propertyToDataMap?keys />
	</#if>

	<#if properties?has_content>
	<#if pppRelevant??><para><@com.emptyLine/><emphasis role="HEAD-WoutNo">Summary of physicochemical properties</emphasis></para></#if>
	<table border="1">
		<title>Physicochemical properties</title>
		<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
			<col width="18%" />
			<col width="34%" />
			<col width="33%" />
			<col width="15%" />
		<#elseif darRelevant?? && rarRelevant??>
			<#if pppRelevant??>
				<col width="10%" />
				<col width="15%" />
				<col width="30%" />
				<col width="30%" />
				<col width="15%" />
			<#else>
				<col width="18%" />
				<col width="34%" />
				<col width="33%" />
				<col width="15%" />
			</#if>
		<#elseif pppRelevant??>
			<col width="15%" />
			<col width="20%" />
			<col width="33%" />
			<col width="32%" />
		<#else>
			<col width="20%" />
			<col width="40%" />
			<col width="40%" />
		</#if>
		<tbody>
			<tr>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Property</emphasis></th>
				<#--new column for PPP-->
				<#if pppRelevant??>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Studies</emphasis></th>
				</#if>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA / Discussion</emphasis></th>
				<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description of key information</emphasis></th>

				<#if darRelevant?? && rarRelevant??>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Literature references of studies linked ot summary</emphasis></th>
				</#if>
				<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment entity linked</emphasis></th>
				</#if>
			</tr>
			
			<#list properties as property>
		
				<#assign propertyData = propertyToDataMap[property] />

				<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", propertyData["subType"]) />

				<#assign usespan = true />
				
				<#list summaryList as summary>
					<tr>
						<!-- Property -->
						<#if usespan>
							<td  rowspan="${summaryList?size}">
								<#assign docUrl=iuclid.webUrl.documentView(summary.documentKey) />
								<#if pppRelevant??>
									<#if propertyData.pppName??>
										${propertyData.pppName!}
									<#else>
										${property!}
									</#if>
								<#else>
									<#if docUrl?has_content>
										<ulink url="${docUrl}">${property!}</ulink>
									<#else>
										${property!}
									</#if>
								</#if>
							</td>
							<#assign usespan = false />
						</#if>

						<#--added Link to individual studies-->
						<#if pppRelevant??>
							<td>
								<#if summary.LinkToRelevantStudyRecord.Link?has_content>
									<#list summary.LinkToRelevantStudyRecord.Link as studyReferenceLinkedToSummary>
										<#local studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
										<para>
											<command  linkend="${studyReference.documentKey.uuid!}">
												<@com.text studyReference.name/>
											</command>
										</para>
									</#list>
								</#if>
							</td>
						</#if>

						<!-- Value used for CSA / Discussion -->
						<td>
							<#-- ACR: I removed this if statement, what was its purpose???? And the macro to be used is new (valueForCSA instead of valueForCSA)-->
							<#-- <#if isValueForCSARelevant(summary, propertyData)>-->
							<para><emphasis role="bold"><@valueForCSA summary propertyData/></emphasis></para>
							<#--</#if>	-->
							<#compress>
							<@com.richText summary.Discussion.Discussion/>
							</#compress>

						</td>
						<!-- Description of key information -->
						<td>
							<#compress>
							<@com.richText summary.KeyInformation.KeyInformation/>
							</#compress>
						</td>

						<!-- Reference from summary to endpoint study record's literature references -->
						<#if darRelevant?? && rarRelevant??>
							<td>
								<@literatureReferencesLinkedToSummary summary />
							</td>
						</#if>
						<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
							<!-- Assessment entity linked -->
							<td>
								<#assign aeList = studyandsummaryCom.getAssessmentEntitiesLinkedToSummary(summary)/>
								<#list aeList as ae>
								<#if ae.AssessmentEntityName?has_content>
									<para><@com.text ae.AssessmentEntityName/></para>
									<#else>
									<para>--</para>
									</#if>
								</#list>
							</td>
						</#if>
					</tr>
				</#list>
			</#list>
		</tbody>
	</table>
	</#if>	
	
	<!-- Additional physicochemical properties table -->
	<#global additionalPropertyToDataMap = {
		"Agglomeration / aggregation" : 
			{"subType" : "AgglomerationAggregation",
			"infoReq" : "Nanomaterial agglomeration / aggregation"},
		"Crystalline phase" : 
			{"subType" : "CrystallinePhase",
			"infoReq" : "Nanomaterial crystalline phase"},
		"Crystallite and grain size" : 
			{"subType" : "CrystalliteGrainSize",
			"infoReq" : "Nanomaterial crystallite and grain size"},
		"Aspect ratio / shape" : 
			{"subType" : "AspectRatioShape",
			"infoReq" : "Nanomaterial aspect ratio / shape"},
		"Specific surface area" : 
			{"subType" : "SpecificSurfaceArea",
			"infoReq" : "Nanomaterial specific surface area"},
		"Zeta potential" : 
			{"subType" : "ZetaPotential",
			"infoReq" : "Nanomaterial Zeta potential"},
		"Surface chemistry" : 
			{"subType" : "SurfaceChemistry",
			"infoReq" : "Nanomaterial surface chemistry"},
		"Dustiness" : 
			{"subType" : "Dustiness",
			"infoReq" : "Nanomaterial dustiness"},
		"Porosity" : 
			{"subType" : "Porosity",
			"infoReq" : "Nanomaterial porosity"},
		"Pour density" : 
			{"subType" : "PourDensity",
			"infoReq" : "Nanomaterial pour density"},
		"Photocatalytic activity" : 
			{"subType" : "PhotocatalyticActivity",
			"infoReq" : "Nanomaterial photocatalytic activityy"},
		"Radical formation potential" : 
			{"subType" : "RadicalFormationPotential",
			"infoReq" : "Nanomaterial radical formation potential"},
		"Catalytic activity" : 
			{"subType" : "CatalyticActivity",
			"infoReq" : "Nanomaterial catalytic activity"}
	}/>
	
	<#assign properties = additionalPropertyToDataMap?keys />

	<#if properties?has_content>
		<#assign existsAdditionalPhysChemPropContent = false />
		
		<#assign additionalPhysChemPropContent>
			<@com.emptyLine/>
			<table border="1">
				<title>Additional physicochemical properties of nanomaterial</title>
				<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
					<col width="18%" />
					<col width="34%" />
					<col width="33%" />
					<col width="15%" />
				<#else>
					<col width="20%" />
					<col width="40%" />
					<col width="40%" />
				</#if>
				<tbody>
					<tr>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Property</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description of key information</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA / Discussion</emphasis></th>
						<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment entity linked</emphasis></th>
						</#if>
					</tr>
					
					<#list properties as property>
				
						<#assign propertyData = additionalPropertyToDataMap[property] />
						<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", propertyData["subType"]) />

						<#assign usespan = true />
						
						<#list summaryList as summary>
							<#assign existsAdditionalPhysChemPropContent = true />
							<tr>
								<!-- Property -->
								<#if usespan>
									<td  rowspan="${summaryList?size}">
										${property!}
									</td>
									<#assign usespan = false />
								</#if>
								<!-- Description of key information -->
								<td>
									<@com.richText summary.KeyInformation.KeyInformation/>
								</td>
								<!-- Value used for CSA / Discussion -->
								<td>
									<@com.richText summary.Discussion.Discussion/>
								</td>
								<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
									<!-- Assessment entity linked -->
									<td>
										<#assign aeList = studyandsummaryCom.getAssessmentEntitiesLinkedToSummary(summary)/>
										<#list aeList as ae>
											<#if ae.AssessmentEntityName?has_content>
												<para><@com.text ae.AssessmentEntityName/></para>
											<#else>
												<para>--</para>
											</#if>
										</#list>
									</td>
								</#if>
							</tr>
						</#list>
					</#list>
				</tbody>
			</table>
			<@com.emptyLine/>
		</#assign>
		
		<#if existsAdditionalPhysChemPropContent>
			${additionalPhysChemPropContent}
		</#if>
	</#if>
	
</#compress>
</#macro>

<!-- Summary discussion of physical chemical properties -->
<#macro physicalChemicalPropertiesSummary _subject>
	<#compress>

		<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "PhysicalChemicalProperties") />

			<#if summaryList?has_content>
				<@com.emptyLine/>
				<para><emphasis role="HEAD-WoutNo">Discussion of physicochemical properties</emphasis></para>
			</#if>

			<#if summaryList?has_content>
				<#assign printSummaryName = summaryList?size gt 1 />
				<#list summaryList as summary>
					<@com.emptyLine/>
					<@studyandsummaryCom.endpointSummary summary "" printSummaryName/>
				</#list>
			</#if>

		</#compress>
	</#macro>
						
<!-- Macros and functions -->
<#--	ACR: what's the use of this?-->
<#function isValueForCSARelevant summary propertyData>
	<#if propertyData["listValuePath"]?has_content>
		<#local valuePath = "summary." + propertyData["listValuePath"] />
		<#local value = valuePath?eval />
	</#if>
	<#if propertyData["valuePath"]?has_content>
		<#local valuePath = "summary." + propertyData["valuePath"] />
		<#local value = valuePath?eval />
	</#if>
	<#if value?has_content>
		<#return true>
	</#if>
	<#return false>
</#function>

<#--new version of macro. It loops over the values to display, using the new map structure.
This allows an indeterminate number of values to be considered -->
<#macro valueForCSA summary propertyData>
	<#compress>
		<#if propertyData["values"]?has_content>
			<#list propertyData["values"] as value>

				<#local valuePath = "summary." + propertyData["path"] + "." + value["field"] />
				<#local val = valuePath?eval />
				<#if val?has_content>
					<#-- preText -->
					${value["preText"]!}

					<#-- value
					NOTE: the "type" field in the hashMap could be omitted and just use node_type for each case
					e.g. picklist_single, picklist_multi...-->
					<#if value["type"]=='listValue'>
						<@com.picklist val />
					<#elseif value["type"]=='mListValue'>
						<@com.picklistMultiple  val />
					<#elseif value["type"]=='value'>
						<#if (val?node_type)=="decimal">
							<@com.number val />
						<#elseif (val?node_type)=="quantity">
							<@com.quantity val />
						<#elseif (val?node_type)=="range">
							<@com.range val />
						</#if>
<#--						<#if val?is_number>-->
<#--							<@com.number val />-->
<#--						<#else>-->
<#--							<@com.quantity val />-->
<#--						</#if>-->
					</#if>

					<#-- postText -->
					${value["postText"]!}

					<#-- atValuePath -->
					<#if value["atField"]?has_content>
						<#local atValuePath = "summary." + propertyData["path"] + "." + value["atField"] />
						<#local atVal = atValuePath?eval />
						<#if atVal?has_content>
							at <@com.quantity atVal />
						</#if>
					</#if>
				</#if>

				<#if value_has_next>
					<?linebreak?>
				</#if>
			</#list>
		</#if>
	</#compress>
</#macro>

<#macro literatureReferencesLinkedToSummary summary >
<#compress>
<#if summary.LinkToRelevantStudyRecord.Link?has_content>
	<#list summary.LinkToRelevantStudyRecord.Link as studyReferenceLinkedToSummary>
	<#assign studyReference = iuclid.getDocumentForKey(studyReferenceLinkedToSummary) />
		<#assign literatureReference = studyReference.DataSource.Reference />
		<#if literatureReference?has_content>
		<#list literatureReference as item>
			<#if item?has_content>
			<#assign reference = iuclid.getDocumentForKey(item) />
			<#if reference?has_content && studyReference?has_content>
				
				<#if reference.GeneralInfo.Author?has_content>
				<para><@com.text reference.GeneralInfo.Author /></para></#if>
				
				<para>
				<#if reference.GeneralInfo.ReferenceYear?has_content>
				<@com.number reference.GeneralInfo.ReferenceYear /> </#if>
				
				<#if reference.GeneralInfo.ReportNo?has_content>
				(<@com.text reference.GeneralInfo.ReportNo />)</#if>
				</para>
				
			</#if>
			</#if><#if item_has_next><@com.emptyLine/></#if>
		</#list>
		</#if>
			
	</#list>
</#if>
</#compress>
</#macro>