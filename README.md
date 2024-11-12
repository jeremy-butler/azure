# Table of Contents
- [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [How to Perform Setup](#how-to-perform-setup)
  - [Basic Workflow Instructions](#basic-workflow-instructions)
    - [Code Modification Process](#code-modification-process)
  - [Example Commands](#example-commands)
  - [Directory Functions and Structure](#directory-functions-and-structure)
  - [Common Errors](#common-errors)

## Introduction
This code repository is designed to automatically deploy an Azure landing zone. The landing zone should be considered the basic building blocks of an Azure environment designed with a hub and spoke network / workload topology. This repository is not

## How to Perform Setup

## Basic Workflow Instructions
### Code Modification Process 
1.	The infrastructure is managed using a combination of YAML and Terraform. Variables are defined in settings.yaml for the Hub resources such as VNETs and subnets, VPN Public IPs, VPN Prefix and count of VMs to deploy.
2.	To commit changes, you can either edit the code directly in the Azure DevOps portal or clone the Repo to Visual Studio Code. 
3.	Once the changes are committed, the pipeline runs a plan and applies to the target subscriptions as defined in the pipeline.yaml file.
For additional context and a more rich walkthrough, please reference the Azure Landing Zone Build Document.

## Example Commands

## Directory Functions and Structure
    Landing_Zone (Root directory for the Terraform code and the Landing_Zone repo)
    | environments - this directory contains all the parameter values for each environment and region
    || dev - this sub-directory houses information for a pipeline to deploy a dev landing zone.
    || prod - this sub-directory houses information for a pipeline to deploy a production landing zone.
    ||| eastus / centralus - this sub-directory contains settings.yaml files for declairing what Azure region to deploy to.
    | pipelines - this directory contains a yaml pipeline for deployment and a yaml pipeline for destroying what was build be the deployment yaml pipeline.
    | scripts - this directory houses all the bash scripts to install and uninstall any prereqs that may exist.
    | terraform - this directory contains all the information regarding any resources Renovo may see fit to deploy for an Azure landing zone.

## Common Errors
1.  "Error: name ("[STORAGE ACCOUNT NAME]") can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long":
        This error happens when attempting to deploy an Azure storage account. Storage accounts can only contain lowercase letters and numbers and must be globally unique. That is, if one storage account has a name of 'storageaccount1234' in uswest region in subscription 1, you may not have a storage account with the same name even if it is in a different subscription, in a different region.
2.  "Error: making Read request on Azure KeyVault Secret devops-pat: keyvault.BaseClient#GetSecret: Failure responding to request: StatusCode=403...":
        This error happens when a service principal running a deployment pipeline attempts to access a secret stored inside an Azure key vault. In order to list and read secrets inside a key vault, the service principal must have one of the following role assignment in addition to any other roles required to deploy infrastructure (ie: contributor):
            1.  "Key vault secrets user" -- This role is used to list and read secret values inside a key vault. This role is good for achieving least priviledge from a built in role assignment.
            2.  "Key vault secrets officer" -- This role is not recommended for any service principal that is access a key vault to retrieve a secret. This role should only be used for any user or service principal to administer the key vault. Least priviledge dictates this role should be use sparingly.
            3.  Custom role -- This option, though technically difficult to achieve exactly the effect desired, is the best option for least privilege. It allows kay vault admins to define exactly what a user or service principal can access.
3. "Error: failed to read provider configuration schema for registry.terraform.io/hashicorp/random: failed to instantiate provider 
    "registry.terraform.io/hashicorp/random" to obtain schema: unavailable provider "registry.terraform.io/hashicorp/random" :
        This error happens when the pipeline attempts to generate a random passwork for a virtual machine local admin login credentials. To resolve this error, make sure the following provider is in the version.tf file:
            random = {
                source = "hashicorp/random"
                version = ">= 3.0"
            }
4. "Error: Saved plan is stale 
    │ 
    │ The given plan file can no longer be applied because the state was changed 
    │ by another operation after the plan was created. 
    " :
        This error occures when changes were made to the terraform code base somewhere. Terraform registers a change when compairing the build.tf against the declaired environment. To resolve simply rerun a tf build command or rerun the pipeline instead of rerun error code.