## Copyright © 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Variables
variable "tenancy_ocid" {
}

variable "user_ocid" {
  description = "User OCID"
  default = ""
}

variable "fingerprint" {
  description = "Fingerprint"
  default = ""
}

variable "private_key_path" {
  description = "API private key path"
  default = ""
}

variable "region" {
  description = "OCI Region"
  default = ""
}

variable vm_cluster_id {
  description = "Existing VM Cluster OCID"
  default = ""
}
# OHome
variable ohome_display_name {
  default = "DB-Home-01"
}

variable ohome_db_version {
  default = "19.23.0.0"
}

variable ohome_source{
  default = "VM_CLUSTER_NEW"
}

# CDB
variable database_database_admin_password {
  default = "temppass1234"
}

variable database_database_db_name {
  default = "DEMO1"
}

variable database_database_character_set { 
  default = "AL32UTF8"
}

variable database_database_db_workload {
  default = "OLTP"
}

variable database_database_sid_prefix {
  default = "DEMO1"
}

variable database_database_source {
  default = "NONE"
}

variable db_db_ncharacter_set {
default = "AL16UTF16"
}

variable auto_backup_enabled {
  default = "false"
}

variable auto_backup_window {
  default = ""
}

#PDB
variable pdb_admin_password {
  default = ["temppass1234","temppass1234"]
}

variable pluggable_database_tde_wallet_password {
  default = ["temppass1234","temppass1234"]
}

variable pluggable_database_name {
  default = ["PDB1","PDB2"]
}