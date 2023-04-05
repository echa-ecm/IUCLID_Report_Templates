<!-- physical chemical property data from endpoint summaries -->
<#global propertyToDataMap = {
	"Physical state":
		{"subType" : "GeneralInformation",
		"values" : [{"field": "PhysicalState", "postText" : "at 20°C and 101.3 kPa"}, 
					{"field": "Form", "preText": "Form: "}, {"field": "Colour", "preText": "Colour: "}, {"field": "ColourIntensity", "preText": "Intensity: "}],
		"pppName" : "Appearance (physical state, colour)"},<#-- can this be changed to the label?-->
	"Melting / freezing point" :
		{"subType" : "Melting",
		"values": [{"field" : "MelFreezPoint", "conditions":["AtThePressureOf"]}],
		"infoReq" : "Melting / freezing point",
		"pppName" : "Melting point"},
	"Boiling point" :
		{"subType" : "BoilingPoint",
		"path" : "KeyValueForChemicalSafetyAssessment",
		"values" : [{"field" : "BoilingPoint", "conditions":["AtThePressureOf"]}, {"field" : "TemperatureOfDecompositionStatePurity", "preText":"Temperature of decomposition:"}],
		"infoReq" : "Boiling point"},
	"Relative density" :
		{"subType" : "PcDensity",
		"path" : "KeyValueForChemicalSafetyAssessment",
		"values" : [{"field" : "RelativeDensity", "conditions":["AtTheTemperatureOf"]}],
		"infoReq" : "Relative density",
		"recordSubType" : "Density"},
	"Granulometry" :
		{"subType" : "ParticleSize",
		"infoReq" : "Granulometry",
		"recordSubType" : "Granulometry"},
	"Vapour pressure" :
		{"subType" : "Vapour",
		"values" : [{"field" : "VapourPressure", "conditions" : ["TemperatureOf"]}],
		"infoReq" : "Vapour pressure"},
	"Partition coefficient n-octanol/water (log value)" :
		{"subType" : "PartitionCoefficient",
		"values" : [{"field" : "LowKow", "conditions" : ["TemperatureOf"], "preText" : "Log Kow (Log Pow):"}],
		"infoReq" : "Partition coefficient n-octanol/water (log value)",
		"recordSubType" : "Partition",
		"pppName" : "Partition coefficient n-octanol/water"},
	"Water solubility" :
		{"subType" : "WaterSolubility",
		"values" : [{"field" : "WaterSolubility", "conditions" : ["TemperatureOf"]}],
		"infoReq" : "Water solubility",
		"pppName" : "Solubility in water"},
	"Solubility in organic solvents / fat solubility" :
		{"subType" : "SolubilityOrganic",
		"values" : [{"field" : "SolubilityStandard", "conditions" : ["AtTheTemperatureOf"], "preText" : "Solubility in mg/100 g standard fat:"},
					{"field" : "SolubilitySolvents", "conditions" : ["AtTheTemperatureOfSolvents"], "preText" : "Solubility in organic solvents:"}],
		"infoReq" : "Solubility in organic solvents / fat solubility",
		"pppName" : "Solubility in organic solvents"},
	"Surface tension" :
		{"subType" : "SurfaceTension",
		"values" : [{"field" : "SurfaceTension", "conditions" : ["AtTheTemperatureOf", "Concentration"]},
					{"field" : "CriticalMicelleConcentrationCMC", "preText":"Critical micelle concentration (CMC):"}],
		"infoReq" : "Surface tension"},
	"Flash point" :
		{"subType" : "FlashPoint",
		"values" : [{"field" : "FlashPoint", "conditions" : ["AtThePressureOf"]}],
		"infoReq" : "Flash point"},
	"Autoflammability / self-ignition temperature" :
		{"subType" : "AutoFlammability",
		"values" : [{"field" : "AutoFlammability", "conditions" : ["AtThePressureOf"]}],
		"infoReq" : "Self-ignition temperature",
		"pppName" : "Self heating"},
	"Flammability" :
		{"subType" : "Flammability",
		"values" : [{"field" : "Flammability"}],
		"infoReq" : "Flammability"},
	"Explosive properties" :
		{"subType" : "Explosiveness",
		"values" : [{"field" : "Explosiveness"}],
		"infoReq" : "Explosive properties",
		"pppName" : "Explosive properties"},
	"Oxidising properties" :
		{"subType" : "OxidisingProperties",
		"values" : [{"field" : "Oxidising"}],
		"infoReq" : "Oxidising properties"},
	"Oxidation reduction potential" :
		{"subType" : "OxidReduction",
		"values" : [{"field" : "ReductionPotential", "conditions" : ["AtTheTemperatureOf"], "preText" : "Oxidation reduction potential in mV:"}],
		"infoReq" : "Oxidation reduction potential",
		"recordSubType" : "OxidationReduction"},
	"Stability in organic solvents and identity of relevant degradation products" :
		{"subType" : "StabilityOrganic",
		"infoReq" : "Stability in organic solvents and identity of relevant degradation products"},
	"Storage stability and reactivity towards container material" :
		{"subType" : "StorageStability",
		"infoReq" : "Reactivity towards container material"},
	"Stability: thermal, sunlight, metals" :
		{"subType" : "StabilityThermal",
		"infoReq" : "Thermal stability"},
	"pH" :
		{"subType" : "pH",
			"values" : [{"field" : "pH", "conditions":["pHNotRelevant"]},<#-- NOTE: check how this is printed -->
						{"field" : "SolutionConcentration", "preText": "Solution concentration (%)"}]
			},
	"Dissociation constant" :
		{"subType" : "Dissociation",
		"values" : [{"field" : "pka", "conditions" : ["AtTheTemperatureOf"], "preText" : "pKa:"}],
		"infoReq" : "Dissociation constant",
		"recordSubType" : "DissociationConstant",
		"pppName" : "Dissociation in water"},
	"Viscosity" :
		{"subType" : "Viscosity",
		"values" : [{"field" : "Viscosity", "conditions" : ["AtTheTemperatureOf"]}],
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
		"values" : [{"field" : "HenrysLawConstant", "conditions" : ["AtTheTemperatureOf"], "preText": "Henry's law constant (H):"}],
		"infoReq" : "Volatility"},
	"Other studies" :
		{"subType" : "AdditionalPhysicoChemical",
		"infoReq" : "Other studies"}
}/>

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

<#-- physicalChemicalPropertiesTable generates an HTML table with physicochemical properties of a chemical substance / mixture. 
	The properties are obtained from two maps:
		- propertyToDataMap, which contains the main properties
		- additionalPropertyToDataMap, which contains additional properties
	These maps have the name of the property as key and values are hashmaps containing:
		- 'subtype'
		- 'values': list of hashmaps for every value to be printed, with fields:
			- 'field': path of object to be printed
			- 'conditions': list of paths to additional objects to be printed (which will be join to the main one by the word 'at'); might not exist
			- 'preText': text to be printed before the values; might not exist
			- 'postText': text to be printed after the values; might not exist
		- 'infoReq': requirement name
		- 'pppName': name for PPP applications (if different to standard property name)
	They are parsed using the macro valueForCSA

	If pppRelevant is true and includeMetabolites is true, the macro also includes information for any metabolites associated with the substance as provided by the
	global varible _metabolites. Also for PPP, a property is printed in the table only if the CSA value exists (otherwise it is ignored)

	Input parameters:

	- _subject: ENTITY object (SUBSTANCE or MIXTURE)
	- selectedDocSubTypes=[]: list of subtypes of endpoint summaries to include in the table (defaults to empty list, meaning all summaries in the hashMap will be used)
	- printTitle=true: whether to print a title for the table (defaults to true)
	- includeMetabolites=true: whether to include metabolites in the table (defaults to true), provided the global variable _metabolites has content
-->
<#macro physicalChemicalPropertiesTable _subject selectedDocSubTypes=[] printTitle=true includeMetabolites=true>
	<#compress>

	<#-- Main properties table -->
	<#local properties = propertyToDataMap?keys />

	<#if properties?has_content>

		<table border="1">
			
			<#if printTitle><title>Physicochemical properties</title></#if>
			
			<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
				<col width="18%" />
				<col width="34%" />
				<col width="33%" />
				<col width="15%" />
			<#elseif darRelevant?? && rarRelevant?? && !pppRelevant??>
				<col width="18%" />
				<col width="34%" />
				<col width="33%" />
				<col width="15%" />
			<#elseif pppRelevant??>
				<#if includeMetabolites && _metabolites??>
					<col width="20%" />
					<col width="20%" />
					<col width="30%" />
					<col width="30%" />
				<#else>
					<col width="25%" />
					<col width="35%" />
					<col width="40%" />
				</#if>
			<#else>
				<col width="20%" />
				<col width="40%" />
				<col width="40%" />
			</#if>

			<tbody valign="middle">
				<tr align="center">
					<#if pppRelevant??>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Property</emphasis></th>
						<#if includeMetabolites && _metabolites??><th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Substance</emphasis></th></#if>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Linked studies</emphasis></th>
					<#else>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Property</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA / Discussion</emphasis></th>
						<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description of key information</emphasis></th>
						<#if darRelevant?? && rarRelevant??>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Literature references of studies linked ot summary</emphasis></th>
						</#if>
						<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment entity linked</emphasis></th>
						</#if>
					</#if>
				</tr>

				<#list properties as property>

					<#local propertyData = propertyToDataMap[property] />

					<#if (! selectedDocSubTypes?has_content) || selectedDocSubTypes?seq_contains(propertyData["subType"])>

						<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", propertyData["subType"]) />

						<#-- for PPP, if there are metabolites, at them to the list of documents -->
						<#if pppRelevant?? && includeMetabolites && _metabolites??>

							<#-- get a list of entities of same size as summaryList-->
							<#local entityList = []/>
							<#list summaryList as summary>
								<#local entityList = entityList + [_subject.ChemicalName]/>
							</#list>

							<#-- add metabolites-->
							<#if _metabolites??>
								<#list _metabolites as metab>
									<#local metabSummaryList =  iuclid.getSectionDocumentsForParentKey(metab.documentKey, "ENDPOINT_SUMMARY", propertyData["subType"]) />
									<#if metabSummaryList?has_content>
										<#local summaryList = summaryList + metabSummaryList/>
										<#list metabSummaryList as metabSummary>
											<#local entityList = entityList + [metab.ChemicalName]/>
										</#list>
									</#if>
								</#list>
							</#if>
						</#if>

						<#local usespan = true />

						<#list summaryList as summary>
							
							<#-- if PPP and no CSA value, skip -->
							<#if !pppRelevant?? || propertyData?keys?seq_contains("values")>
								<tr>
								<!-- Property -->

								<#if usespan> 
									<td> 
										<#local docUrl=iuclid.webUrl.documentView(summary.documentKey) />
										
										<#if pppRelevant??>
											
											<#if propertyData.pppName??>
												<#local propertyName = propertyData.pppName!/>
											<#else>
												<#local propertyName = property/>
											</#if>  
											
											<#-- option to cross-reference:  <command linkend="${_subject.documentKey.uuid!}_${summary.documentSubType}">${propertyName!}</command>  -->
											<#-- print link only for full table (when title is printed) -->
											<#if printTitle && (!includeMetabolites || !_metabolites??)>
												<ulink url="${docUrl}">${propertyName!}</ulink>

												<#if (summaryList?size>1)>
													<#list 1..(summaryList?size-1) as index>
														<#local docUrl=iuclid.webUrl.documentView(summaryList[index].documentKey) />
														<ulink url="${docUrl}">[${index+1}]</ulink>
													</#list>
												</#if>
											<#else>
												${propertyName!}
											</#if>
										<#else>
											<#if docUrl?has_content>
												<ulink url="${docUrl}">${property!}</ulink>
											<#else>
												${property!}
											</#if>
										</#if>
										
									</td>
									
									<#local usespan = false />
								</#if>

								<!-- for PPP: substance name -->
								<#if pppRelevant??>

									<#if includeMetabolites && _metabolites??>
										<td>
											<#local docUrl=iuclid.webUrl.documentView(summary.documentKey) />
											<ulink url="${docUrl}"><@com.text entityList[summary_index]/></ulink>
										</td>
									</#if>

									<td>
										<@valueForCSA summary propertyData/>
									</td>

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

								<#else>

									<!-- Value used for CSA / Discussion -->
									<td>
										<para><emphasis role="bold"><@valueForCSA summary propertyData/></emphasis></para>
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
								</#if>
								</tr>
							</#if>
						</#list>
					</#if>
				</#list>
			</tbody>
		</table>
	</#if>	
	
	<#-- Additional properties table -->
	<#if !pppRelevant??>

		<#local properties = additionalPropertyToDataMap?keys />

		<#if properties?has_content>
			<#local existsAdditionalPhysChemPropContent = false />
			
			<#local additionalPhysChemPropContent>
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
					<tbody >
						<tr>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Property</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Description of key information</emphasis></th>
							<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Value used for CSA / Discussion</emphasis></th>
							<#if studyandsummaryCom.assessmentEntitiesExist && csrRelevant??>
								<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Assessment entity linked</emphasis></th>
							</#if>
						</tr>
						
						<#list properties as property>
					
							<#local propertyData = additionalPropertyToDataMap[property] />
							<#local summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", propertyData["subType"]) />

							<#local usespan = true />
							
							<#list summaryList as summary>
								<#local existsAdditionalPhysChemPropContent = true />
								<tr>
									<!-- Property -->
									<#if usespan>
										<td  rowspan="${summaryList?size}">
											${property!}
										</td>
										<#local usespan = false />
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
			</#local>
			
			<#if existsAdditionalPhysChemPropContent>
				${additionalPhysChemPropContent}
			</#if>

		</#if>
	</#if>
	
</#compress>
</#macro>

<!-- Summary discussion of physical chemical properties -->
<#macro physicalChemicalPropertiesSummary _subject>
	<#compress>

		<#assign summaryList = iuclid.getSectionDocumentsForParentKey(_subject.documentKey, "ENDPOINT_SUMMARY", "PhysicalChemicalProperties") />
		<#if pppRelevant?? && _metabolites??>

			<#-- get a list of entities of same size as summaryList-->
			<#assign entityList = []/>
			<#list summaryList as summary>
				<#assign entityList = entityList + [_subject.ChemicalName]/>
			</#list>

			<#-- add metabolites-->
			<#list _metabolites as metab>
				<#local metabSummaryList =  iuclid.getSectionDocumentsForParentKey(metab.documentKey, "ENDPOINT_SUMMARY", "PhysicalChemicalProperties") />
				<#if metabSummaryList?has_content>
					<#assign summaryList = summaryList + metabSummaryList/>
					<#list metabSummaryList as metabSummary>
						<#assign entityList = entityList + [metab.ChemicalName]/>
					</#list>
				</#if>
			</#list>
		</#if>

		<#if summaryList?has_content>
			<@com.emptyLine/>
			<para><emphasis role="HEAD-WoutNo">Discussion of physicochemical properties</emphasis></para>
		<#else>
			<#if pppRelevant??>
				<@com.emptyLine/>
				<para>No summary information for physicochemical properties available.</para>
				<@com.emptyLine/>
			</#if>
		</#if>

		<#if summaryList?has_content>
			<#assign printSummaryName = summaryList?size gt 1 />
			<#list summaryList as summary>
				<@com.emptyLine/>
				<#if pppRelevant?? && _metabolites??
					&& _subject.documentType=="SUBSTANCE"
					&& _subject.ChemicalName!=entityList[summary_index]
					&& entityList?seq_index_of(entityList[summary_index]) == summary_index>
					<para><emphasis role="underline">----- Metabolite <emphasis role="bold">${entityList[summary_index]}</emphasis> -----</emphasis></para>
					<@com.emptyLine/>
				</#if>
				<@studyandsummaryCom.summaryKeyInformation summary/>
				<@studyandsummaryCom.assessmentEntitiesList summary />
				<@studyandsummaryCom.summaryAdditionalInformation summary/>
			</#list>
		</#if>

		</#compress>
	</#macro>
						
<!-- Macros and functions -->
<#function isValueForCSARelevant summary propertyData><#-- OBSOLETE?-->
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

<#--  valueForCSA prints the value for CSA extracted from a summary following the structure of the hashMap in propertyData

	First, the macro tries to find the CSA block in the summary using the function "studyandsummaryCom.getObjectFromPathOptions()" 
	with a list of possible paths where the CSA block might be located. 

	Then, if the "values" property of the "propertyData" object is not empty and the CSA block has been found, the macro loops through each item in the "values" list.

	Inputs:
	- summary: ENDPOINT_SUMMARY object
	- propertyData: hashMap mapping the type of summary and the property to be printed

#-->
<#macro valueForCSA summary propertyData>
	<#compress>

		<#-- consider path options for CSA block-->
		<#local CSAblock = studyandsummaryCom.getObjectFromPathOptions(summary, ["KeyValueForChemicalSafetyAssessment", "KeyValueChemicalAssessment", "ResultsAndDiscussion"])/>
		
		<#-- print all values -->
		<#if propertyData["values"]?has_content && CSAblock?has_content>
			
			<#list propertyData["values"] as value>

				<#local valuePath = "CSAblock." + value["field"] />
				<#local val = valuePath?eval />
				
				<#if val?has_content>
					
					<#-- preText: print label unless another specific text is provided -->
					<#if value?keys?seq_contains("preText")>
						${value['preText']}
					</#if>

					<#-- value -->
					<@com.value val/>

					<#-- postText -->
					<#if value?keys?seq_contains("postText")>
						${value['postText']}
					</#if>

					<#-- conditions -->
					<#if value?keys?seq_contains("conditions")>
						<#list value["conditions"] as condition>
							<#local condPath = "CSAblock." + condition />
							<#local condVal = condPath?eval />
							<#if condVal?has_content>
								<#--  <@iuclid.label for=condVal var="condLabel"/>  -->
								<#--  ${condLabel}   -->
								at <@com.value condVal/>
							</#if>
						</#list>
					</#if>
				</#if>
			
				<#if value?has_next>
					<@com.emptyLine/>
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