variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

 variable odb_network {
 default = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork"
 }
 variable odb_subnet { 
  default= "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork/odbSubnets/my-odbsubnet"
 }
  variable backup_odb_subnet {
    default = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork/odbSubnets/my-backup-odbsubnet"
  }

variable "vm_cluster_id" {
  description = "The cloud VM cluster ID"
  type        = string
  default     = "my-instance"
}

variable "vm_cluster_display_name" {
  description = "The display name for the VM cluster"
  type        = string
  default     = "my-instance displayname"
}

variable "vm_cluster_location" {
  description = "The location for the VM cluster"
  type        = string
  default     = "europe-west2"
}

variable "license_type" {
  description = "The license type"
  type        = string
  default     = "LICENSE_INCLUDED"
}

variable "ssh_public_keys" {
  description = "List of SSH public keys"
  type        = list(string)
  default     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCz1X2744t+6vRLmE5u6nHi6/QWh8bQDgHmd+OIxRQIGA/IWUtCs2FnaCNZcqvZkaeyjk5v0lTA/n+9jvO42Ipib53athrfVG8gRt8fzPL66C6ZqHq+6zZophhrCdfJh/0G4x9xJh5gdMprlaCR1P8yAaVvhBQSKGc4SiIkyMNBcHJ5YTtMQMTfxaB4G1sHZ6SDAY9a6Cq/zNjDwfPapWLsiP4mRhE5SSjJX6l6EYbkm0JeLQg+AbJiNEPvrvDp1wtTxzlPJtIivthmLMThFxK7+DkrYFuLvN5AHUdo9KTDLvHtDCvV70r8v0gafsrKkM/OE9Jtzoo0e1N/5K/ZdyFRbAkFT4QSF3nwpbmBWLf2Evg//YyEuxnz4CwPqFST2mucnrCCGCVWp1vnHZ0y30nM35njLOmWdRDFy5l27pKUTwLp02y3UYiiZyP7d3/u5pKiN4vC27VuvzprSdJxWoAvluOiDeRh+/oeQDowxoT/Oop8DzB9uJmjktXw8jyMW2+Rpg+ENQqeNgF1OGlEzypaWiRskEFlkpLb4v/s3ZDYkL1oW0Nv/J8LTjTOTEaYt2Udjoe9x2xWiGnQixhdChWuG+MaoWffzUgx1tsVj/DBXijR5DjkPkrA1GA98zd3q8GKEaAdcDenJjHhNYSd4+rE9pIsnYn7fo5X/tFfcQH1XQ== nobody@google.com"]
}

variable "cpu_core_count" {
  description = "The CPU core count"
  type        = string
  default     = "4"
}

variable "gi_version" {
  description = "The GI version"
  type        = string
  default     = "19.0.0.0"
}

variable "hostname_prefix" {
  description = "The hostname prefix"
  type        = string
  default     = "hostname1"
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = string
  default     = "true"
}

variable "exadata_infrastructure_id" {
  description = "The cloud Exadata infrastructure ID"
  type        = string
  default     = "my-exadata"
}
