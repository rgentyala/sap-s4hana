variable "private_ssh_key" {
	type		= string
	description = "Input id_rsa private key content"
}

variable "SSH_KEYS" {
	type		= list(string)
	description = "SSH Keys ID list to access the VSI"
	validation {
		condition     = var.SSH_KEYS == [] ? false : true && var.SSH_KEYS == [""] ? false : true
		error_message = "At least one SSH KEY is needed to be able to access the VSI."
	}
}

variable "BASTION_FLOATING_IP" {
	type		= string
	description = "Input the FLOATING IP from the Bastion Server"
}

variable "RESOURCE_GROUP" {
  type        = string
  description = "EXISTING Resource Group for VSIs and Volumes"
  default     = "Default"
}

variable "REGION" {
	type		= string
	description	= "Cloud Region"
	validation {
		condition     = contains(["eu-de", "eu-gb", "us-south", "us-east"], var.REGION )
		error_message = "The REGION must be one of: eu-de, eu-gb, us-south, us-east."
	}
}

variable "ZONE" {
	type		= string
	description	= "Cloud Zone"
	validation {
		condition     = length(regexall("^(eu-de|eu-gb|us-south|us-east)-(1|2|3)$", var.ZONE)) > 0
		error_message = "The ZONE is not valid."
	}
}

variable "VPC" {
	type		= string
	description = "EXISTING VPC name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = "EXISTING Subnet name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = "EXISTING Security group name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

variable "DB-HOSTNAME" {
	type		= string
	description = "DB VSI Hostname"
	validation {
		condition     = length(var.DB-HOSTNAME) <= 13 && length(regexall("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.DB-HOSTNAME)) > 0
		error_message = "The DB-HOSTNAME is not valid."
	}
}

variable "DB-PROFILE" {
	type		= string
	description = "DB VSI Profile"
	default		= "mx2-16x128"
}

variable "DB-IMAGE" {
	type		= string
	description = "DB VSI OS Image"
	default		= "ibm-redhat-8-4-amd64-sap-hana-2"
	validation {
		condition     = length(regexall("^(ibm-redhat-7-6-amd64-sap-hana|ibm-redhat-8-4-amd64-sap-hana|ibm-sles-15-3-amd64-sap-hana)-[0-9][0-9]*", var.DB-IMAGE)) > 0
		error_message = "The OS SAP DB-IMAGE must be one of  \"ibm-sles-15-3-amd64-sap-hana-x\", \"ibm-redhat-8-4-amd64-sap-hana-x\" or \"ibm-redhat-7-6-amd64-sap-hana-x\"."
 }
}

variable "APP-HOSTNAME" {
	type		= string
	description = "APP VSI Hostname"
	validation {
		condition     = length(var.APP-HOSTNAME) <= 13 && length(regexall("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.APP-HOSTNAME)) > 0
		error_message = "The APP-HOSTNAME is not valid."
	}
}

variable "APP-PROFILE" {
	type		= string
	description = "VSI Profile"
	default		= "bx2-4x16"
}

variable "APP-IMAGE" {
	type		= string
	description = "VSI OS Image"
	default		= "ibm-redhat-8-4-amd64-sap-applications-2"
	validation {
			condition     = length(regexall("^(ibm-redhat-7-6-amd64-sap-applications|ibm-redhat-8-4-amd64-sap-applications|ibm-sles-15-3-amd64-sap-applications)-[0-9][0-9]*", var.APP-IMAGE)) > 0
			error_message = "The OS SAP APP-IMAGE must be one of \"ibm-redhat-7-6-amd64-sap-applications-x\" ,  \"ibm-redhat-8-4-amd64-sap-applications-x\" or \"ibm-sles-15-3-amd64-sap-applications-x\"."
 }
}

variable "hana_sid" {
	type		= string
	description = "hana_sid"
	default		= "HDB"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.hana_sid)) > 0
		error_message = "The hana_sid is not valid."
	}
}

variable "hana_sysno" {
	type		= string
	description = "hana_sysno"
	default		= "00"
	validation {
		condition     = var.hana_sysno >= 0 && var.hana_sysno <=97
		error_message = "The hana_sysno is not valid."
	}
}

variable "hana_main_password" {
	type		= string
	sensitive = true
	description = "hana_main_password"
	validation {
		condition     = length(regexall("^(.{0,7}|.{15,}|[^0-9a-zA-Z]*)$", var.hana_main_password)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z!@#$_]+$", var.hana_main_password)) > 0
		error_message = "The hana_main_password is not valid."
	}
}

variable "hana_system_usage" {
	type		= string
	description = "hana_system_usage"
	default		= "custom"
	validation {
		condition     = contains(["production", "test", "development", "custom" ], var.hana_system_usage )
		error_message = "The hana_system_usage must be one of: production, test, development, custom."
	}
}

variable "hana_components" {
	type		= string
	description = "hana_components"
	default		= "server"
	validation {
		condition     = contains(["all", "client", "es", "ets", "lcapps", "server", "smartda", "streaming", "rdsync", "xs", "studio", "afl", "sca", "sop", "eml", "rme", "rtl", "trp" ], var.hana_components )
		error_message = "The hana_components must be one of: all, client, es, ets, lcapps, server, smartda, streaming, rdsync, xs, studio, afl, sca, sop, eml, rme, rtl, trp."
	}
}

variable "kit_saphana_file" {
	type		= string
	description = "kit_saphana_file"
	default		= "/storage/HANADB/51054623.ZIP"
}

variable "sap_sid" {
	type		= string
	description = "sap_sid"
	default		= "S4A"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.sap_sid)) > 0
		error_message = "The sap_sid is not valid."
	}
}

variable "sap_ascs_instance_number" {
	type		= string
	description = "sap_ascs_instance_number"
	default		= "01"
	validation {
		condition     = var.sap_ascs_instance_number >= 0 && var.sap_ascs_instance_number <=97
		error_message = "The sap_ascs_instance_number is not valid."
	}
}

variable "sap_ci_instance_number" {
	type		= string
	description = "sap_ci_instance_number"
	default		= "00"
	validation {
		condition     = var.sap_ci_instance_number >= 0 && var.sap_ci_instance_number <=97
		error_message = "The sap_ci_instance_number is not valid."
	}
}

variable "sap_main_password" {
	type		= string
	sensitive = true
	description = "sap_main_password"
	validation {
		condition     = length(regexall("^(.{0,9}|.{15,}|[^0-9]*)$", var.sap_main_password)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z@#$_]+$", var.sap_main_password)) > 0
		error_message = "The sap_main_password is not valid."
	}
}

variable "hdb_concurrent_jobs" {
	type		= string
	description = "hdb_concurrent_jobs"
	default		= "23"
	validation {
		condition     = var.hdb_concurrent_jobs >= 1 && var.hdb_concurrent_jobs <=25
		error_message = "The hdb_concurrent_jobs is not valid."
	}
}

variable "kit_sapcar_file" {
	type		= string
	description = "kit_sapcar_file"
	default		= "/storage/S4HANA/SAPCAR_1010-70006178.EXE"
}

variable "kit_swpm_file" {
	type		= string
	description = "kit_swpm_file"
	default		= "/storage/S4HANA/SWPM20SP09_4-80003424.SAR"
}

variable "kit_sapexe_file" {
	type		= string
	description = "kit_sapexe_file"
	default		= "/storage/S4HANA/SAPEXE_100-70005283.SAR"
}

variable "kit_sapexedb_file" {
	type		= string
	description = "kit_sapexedb_file"
	default		= "/storage/S4HANA/SAPEXEDB_100-70005282.SAR"
}

variable "kit_igsexe_file" {
	type		= string
	description = "kit_igsexe_file"
	default		= "/storage/S4HANA/igsexe_1-70005417.sar"
}

variable "kit_igshelper_file" {
	type		= string
	description = "kit_igshelper_file"
	default		= "/storage/S4HANA/igshelper_17-10010245.sar"
}

variable "kit_saphotagent_file" {
	type		= string
	description = "kit_saphotagent_file"
	default		= "/storage/S4HANA/SAPHOSTAGENT51_51-20009394.SAR"
}

variable "kit_hdbclient_file" {
	type		= string
	description = "kit_hdbclient_file"
	default		= "/storage/S4HANA/IMDB_CLIENT20_009_28-80002082.SAR"
}

variable "kit_s4hana_export" {
	type		= string
	description = "kit_s4hana_export"
	default		= "/storage/S4HANA/export"
}
