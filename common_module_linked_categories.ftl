
<!-- Linked categories and their member substances -->
<#macro categoryInformation _subject>
<#compress>
	
	<!-- Iterate the related categories to the substance -->
	<#list com.relatedCategories(_subject.documentKey) as categoryKey>	
	<!-- Get the keys of all the related categories to the substance -->
	<#assign category = iuclid.getDocumentForKey(categoryKey) />
	<#if category?has_content>
	
		<@com.emptyLine/>
		<para><emphasis role="bold">Category name:</emphasis> <@com.text category.CategoryName /></para>		
		<@com.emptyLine/>
		
		<informaltable border="1">
			<col width="35%" />
			<col width="65%" />
			<tbody>
				<tr>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Other category members</emphasis></th>
					<th><?dbfo bgcolor="#FBDDA6" ?><emphasis role="bold">Category documents</emphasis></th>
				</tr>
				
				<#assign categorydocspan = true />
				
				<!-- iterate through substance members -->
				<#if category.Substances?has_content>				
				<#list category.Substances as categoryMembers>
					<#if categoryMembers?has_content>
					<#assign substanceMember = iuclid.getDocumentForKey(categoryMembers) />
					
						<tr>
							<td>
							<para>
								<#assign docUrl=iuclid.webUrl.entityView(categoryMembers)/>
								<#if docUrl?has_content>
									<emphasis role="bold">Substance name:</emphasis> 
									<ulink url="${docUrl}">
										<@com.text substanceMember.name />
									</ulink>
										<#else>
									<emphasis role="bold">Substance name:</emphasis> <@com.text substanceMember.name />
								</#if>
							</para>						
							</td>
							
							<#if categorydocspan>
								<td rowspan="${category.Substances?size}">
									<@com.documentReferenceMultiple category.CategoryDocuments.CategorySections />							
								</td>
							<#assign categorydocspan = false />
							</#if>
						</tr>
					
					</#if>					
				</#list>
				</#if>
				
			</tbody>
		</informaltable>
		
		<@com.emptyLine/>
		<para>
			<emphasis role="bold">Category definition:</emphasis> <@com.text category.JustificationsAndDiscussions.CategoryDefinition />
		</para>
		
		<@com.emptyLine/>
		<para>
			<emphasis role="bold">Category Rationale:</emphasis> <@com.text category.JustificationsAndDiscussions.CategoryRationale />
		</para>
	
	</#if>
	</#list>
	
</#compress>
</#macro>
						
<!-- Macros and functions -->