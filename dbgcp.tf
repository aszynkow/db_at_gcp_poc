terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_oracle_database_cloud_vm_cluster" "my_vmcluster"{
  cloud_vm_cluster_id = var.vm_cluster_id
  display_name = var.vm_cluster_display_name
  location = var.vm_cluster_location
  project = var.project_id
  exadata_infrastructure = data.google_oracle_database_cloud_exadata_infrastructure.cloudExadataInfrastructures
  odb_network = var.odb_network
  odb_subnet = var.odb_subnet
  backup_odb_subnet = var.backup_odb_subnet
  properties {
    license_type = var.license_type
    ssh_public_keys = var.ssh_public_keys
    cpu_core_count = var.cpu_core_count
    gi_version = var.gi_version
    hostname_prefix = var.hostname_prefix
  }

  deletion_protection = var.deletion_protection
}

data google_oracle_database_cloud_exadata_infrastructure "cloudExadataInfrastructures"{
  cloud_exadata_infrastructure_id = var.exadata_infrastructure_id
  location = var.vm_cluster_location
  project = var.project_id
}
