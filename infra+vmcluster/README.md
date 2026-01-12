# GCP Oracle Database Infrastructure + VM Cluster

This Terraform configuration deploys Oracle Database infrastructure on Google Cloud Platform (GCP), including Exadata infrastructure and Oracle VM clusters using the Google Cloud provider.

## Overview

This module provisions:
- **Cloud Exadata Infrastructure**: High-performance, dedicated compute and storage infrastructure for Oracle Database
- **Oracle Cloud VM Cluster**: Managed VM cluster running Oracle Database on the Exadata infrastructure
- **Networking**: Integration with ODB (Oracle Database) networks and subnets

## Prerequisites

Before applying this Terraform configuration, ensure you have:

- **GCP Account**: Active GCP project with billing enabled
- **Terraform**: Version 1.0 or later
- **Provider**: Google Cloud provider (beta) version ~> 5.0
- **Permissions**: Sufficient IAM permissions to create:
  - Cloud Exadata Infrastructure
  - Oracle VM Clusters
  - Network resources
- **GCP SDK**: Installed and configured with appropriate credentials

## Architecture

```
┌─────────────────────────────────────────────────┐
│         GCP Project                             │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  ODB Network                             │  │
│  │  ├─ ODB Subnet (Primary)                 │  │
│  │  └─ ODB Subnet (Backup)                  │  │
│  └──────────────────────────────────────────┘  │
│           ↓                                     │
│  ┌──────────────────────────────────────────┐  │
│  │  Cloud Exadata Infrastructure            │  │
│  │  ├─ Shape: Exadata.X9M                   │  │
│  │  ├─ Compute Count: 2                     │  │
│  │  └─ Storage Count: 3                     │  │
│  └──────────────────────────────────────────┘  │
│           ↓                                     │
│  ┌──────────────────────────────────────────┐  │
│  │  Oracle Cloud VM Cluster                 │  │
│  │  ├─ GI Version: 19.0.0.0                 │  │
│  │  ├─ CPU Cores: 4                         │  │
│  │  └─ Linked to Exadata Infrastructure     │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Directory Structure

```
infra+vmcluster/
├── README.md                    # This file
├── dbgcp.tf                     # Main Terraform configuration
├── variables.tf                 # Input variables
├── terraform.tfvars            # Variable values (not included in repo)
├── .terraform.lock.hcl          # Lock file for provider versions
└── LICENSE                      # License file
```

## Configuration Files

### dbgcp.tf
Contains the main Terraform resources:
- **google_oracle_database_cloud_exadata_infrastructure**: Defines Exadata infrastructure properties
- **google_oracle_database_cloud_vm_cluster**: Defines Oracle VM cluster configuration
- **google_oracle_database_db_servers**: Data source to retrieve available database servers

### variables.tf
Defines input variables for customization:
- GCP project and region settings
- VM cluster configuration
- Exadata infrastructure properties
- Network and subnet specifications
- License and security settings

## Input Variables

### Required Variables

| Variable | Description | Type |
|----------|-------------|------|
| `project_id` | The GCP project ID | `string` |
| `odb_network` | ODB network resource path | `string` |
| `odb_subnet` | ODB primary subnet resource path | `string` |
| `backup_odb_subnet` | ODB backup subnet resource path | `string` |

### Optional Variables (with defaults)

| Variable | Default | Description |
|----------|---------|-------------|
| `region` | `us-central1` | GCP region |
| `zone` | `us-central1-a` | GCP zone |
| `vm_cluster_id` | `my-instance` | Cloud VM cluster ID |
| `vm_cluster_display_name` | `my-instance displayname` | Display name for VM cluster |
| `vm_cluster_location` | `europe-west2` | VM cluster location |
| `license_type` | `LICENSE_INCLUDED` | Oracle license type |
| `cpu_core_count` | `4` | Number of CPU cores |
| `gi_version` | `19.0.0.0` | Oracle Grid Infrastructure version |
| `hostname_prefix` | `hostname1` | Hostname prefix for cluster nodes |
| `deletion_protection` | `true` | Enable deletion protection |
| `exadata_infrastructure_id` | `my-exadata` | Exadata infrastructure ID |
| `exadata_infrastructure_shape` | `Exadata.X9M` | Exadata infrastructure shape |
| `exadata_infrastructure_compute_count` | `2` | Number of compute nodes |
| `exadata_infrastructure_storage_count` | `3` | Number of storage nodes |

## Getting Started

### 1. Clone the Repository
```bash
cd db_at_gcp_poc/infra+vmcluster
```

### 2. Create terraform.tfvars
Create a `terraform.tfvars` file with your specific configuration:

```hcl
project_id                             = "your-gcp-project-id"
region                                 = "europe-west2"
vm_cluster_location                    = "europe-west2"
vm_cluster_id                          = "prod-vm-cluster"
vm_cluster_display_name                = "Production VM Cluster"
odb_network                           = "projects/your-project/locations/europe-west2/odbNetworks/prod-network"
odb_subnet                            = "projects/your-project/locations/europe-west2/odbNetworks/prod-network/odbSubnets/primary"
backup_odb_subnet                     = "projects/your-project/locations/europe-west2/odbNetworks/prod-network/odbSubnets/backup"
cpu_core_count                        = "8"
gi_version                            = "19.0.0.0"
license_type                          = "LICENSE_INCLUDED"
exadata_infrastructure_compute_count  = "2"
exadata_infrastructure_storage_count  = "3"
ssh_public_keys                       = ["ssh-rsa AAAA..."]
deletion_protection                   = true
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Validate Configuration
```bash
terraform validate
```

### 5. Review Changes
```bash
terraform plan
```

### 6. Apply Configuration
```bash
terraform apply
```

## Outputs

The configuration will create:
- One Cloud Exadata Infrastructure instance
- One Oracle Cloud VM Cluster
- Associated networking configurations

## Management

### View Current State
```bash
terraform show
```

### Update Configuration
Modify `terraform.tfvars` and run:
```bash
terraform plan
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

> **⚠️ Warning**: Deletion protection is enabled by default. Ensure you understand the implications before destroying resources.

## Security Considerations

- **SSH Keys**: Add your public SSH keys to the `ssh_public_keys` variable
- **Deletion Protection**: Enabled by default to prevent accidental deletion
- **Network Access**: Configure network security through ODB network policies
- **Credentials**: Use GCP Application Default Credentials or service accounts
- **State Management**: Store Terraform state in a remote backend (e.g., GCS) for team collaboration

## Troubleshooting

### Common Issues

**Provider not found**
```bash
terraform init
terraform validate
```

**Authentication errors**
```bash
gcloud auth application-default login
```

**Network connectivity issues**
- Verify ODB network and subnet paths are correct
- Ensure proper network permissions in GCP

## Dependencies

- Terraform >= 1.0
- Google Cloud provider (google-beta) >= 5.0
- GCP project with appropriate APIs enabled:
  - Cloud Oracle Database API
  - Compute Engine API
  - Cloud Resource Manager API

## Support

For issues or questions:
1. Check [GCP Oracle Database Documentation](https://cloud.google.com/oracle/docs)
2. Review [Terraform Google Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
3. Consult your GCP account team

## License

See LICENSE file for details.

## Contributors

- Initial infrastructure setup

---

**Last Updated**: January 2026
