# IUCLID_report_common_modules

# General
If you wish to contribute to the common modules for IUCLID reporting, please follow the guidance below. If you have further questions, contact the IUCLID support team: iuclid6@echa.europa.eu 
----
# Getting started
1. Request access to the GIT repository from the IUCLID support team: iuclid6@echa.europa.eu
2. When you have access, first clone the Repository on your local machine, see [these instructions](https://docs.microsoft.com/en-us/azure/devops/repos/git/clone?view=azure-devops&tabs=visual-studio) from Microsoft.
3. When you have cloned the repository you will have access to the repository and can commit changes to the relevant branches (see 'Governance' below for how to the repository can be used)

# What are the common modules?
IUCLID comes with a report generator tool that uses Freemarker (FTL) files to generate standalone reports in various formats, such as RTF, PDF, CSV, XML, HTML _et al_. With the intensified interest in using the FTL templates to generate large hazard assessment reports, a series of common modules were developed in 2020 for re-use across different reports. To ensure the common modules stay relevant and continue to be re-usable, an Azure GIT repository has been created to permit contributors to work together on **one set of common modules**.
Updates to modules will be coordinated and monitored via the ECHA IUCLID team and the OECD IUCLID Customisation forum will serve as a discussion platform for collaboration on the common modules.

# Governance
To contribute to the updates, maintenance, and discussion of the common modules for reporting, you will need to join the IUCLID customisation forum.

![Alt text](./customisation_forum_logo.jpg)

> You can register directly from the forum’s [page](https://community.oecd.org/community/iuclidcustomisation)
>> **_Important information_**: before making changes to the common modules which affects other users, ensure you have discussed and consulted these changes with the customisation forum.
**Changes to common modules affecting other users, without seeking a common approval first, will not be approved**

If you wish to make regulatory- or organisation- specific changes to the common modules which do not affect other users, please discuss first in the customisation forum in case other users will benefit from the change. Otherwise, this can be done without consultation. The changes will still need to be approved.

# How to make a regulatory-specific change in a common module
- Check in ‘macros_common_general.ftl’ if your regulatory-specific variable exists, e.g. ‘ppp’ is relevant for the Plant Protection Product regulation. If it does not exist, request from the IUCLID team to add a relevant variable:

> <#global relevance = {
'relevant' : 'csr',
'relevant' : 'ppp',
'relevant' : 'par',
'relevant' : 'dar',
'relevant' : 'rar',
'relevant' : 'generic'
} />

- Initiate from the main FTL the relevant variable, e.g. for the CSR report:
> <@com.initiRelevanceForCSR relevance/>

 - Include or exclude data from the common modules using the relevant variable found in ‘macros_common_general.ftl’. 

> To exclude information in the module, put the following around what you want to exclude:
<#if !pppRelevant??>CONTENT TO EXCLUDE</#if>	

> To include extra information not in the module, put the following around what you want to include:
<#if pppRelevant??>NEW CONTENT TO INCLUDE</#if>	

# How to update a common module in GIT
To update a common module follow these steps:
1.	Go to the ‘common_modules_ftls’ folder in your local directory
2.	Switch to the relevant branch you are intending to work on. Each available branch corresponds to an existing module. E.g. switch to the common module for human health hazard assessment: 
> com-mod/common_module_human_health_hazard_assessment
3. Open GIT Bash or the regular CMD command line, and type in the following command:
Git checkout <name of branch>
4.	Work on the common module
5. When finalised, **Commit** and **Push** your changes to the relevant branch
> When committing, type in a subject and description of the commit
6. When finished working on the branch, create a pull request under ‘common_modules_ftls’ and include a title, description and reviewer for your pull request
> The Reviewer may comment on your commits, and request or make, changes. When the pull request is approved, the changes will be merged to the main branch and will be part of the series of common modules
