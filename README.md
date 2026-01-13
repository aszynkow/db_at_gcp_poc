# DB at GCP - Oracle Database on Google Cloud Platform

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive Terraform project for deploying Oracle Database infrastructure on Google Cloud Platform (GCP). This repository contains multiple modules for deploying and managing Oracle Database VM Clusters and their underlying infrastructure.

## 📋 Project Overview

This project provides Terraform configurations to automate the deployment of Oracle Database solutions on GCP, including:

- **Oracle Cloud VM Clusters**: High-performance database clusters with flexible compute resources
- **Exadata Infrastructure**: Dedicated infrastructure optimized for Oracle Database workloads
- **Network Integration**: Secure networking with ODB networks and subnets
- **Automated Provisioning**: Complete IaC solutions for repeatable deployments

## 📁 Directory Structure

```
db_at_gcp_poc/
├── README.md                             # This file
├── LICENSE                               # Project license
│
├── gcp/                                  # Google Cloud Platform Deployments
│   │
│   ├── infra+vmcluster/                  # GCP Infrastructure and VM Cluster deployment
│   │   ├── README.md                    # Detailed setup and configuration guide
│   │   ├── dbgcp.tf                     # Exadata and VM cluster Terraform resources
│   │   ├── variables.tf                 # Input variables definitions
│   │   └── .terraform.lock.hcl          # Provider version lock file
│   │
│   └── vmcluster/                        # GCP VM Cluster configuration
│       ├── README.md                    # VM cluster specific documentation
│       ├── dbgcp.tf                     # VM cluster Terraform resources
│       ├── variables.tf                 # Input variables definitions
│       └── .terraform.lock.hcl          # Provider version lock file
│
└── ohome+cdb+pdb/                        # OCI Database Home, CDB, and PDB
    ├── README.md                         # Database deployment guide
    ├── provider.tf                       # OCI provider configuration
    ├── database.tf                       # Database resources (OHOME, CDB, PDB)
    ├── variables.tf                      # Input variables definitions
    └── .terraform.lock.hcl               # Provider version lock file
```

## 🚀 Quick Start

### Prerequisites

- **Terraform** ≥ 1.0
- **Google Cloud SDK** (gcloud CLI)
- **GCP Account** with billing enabled
- **Appropriate IAM Permissions** for Oracle Database and Compute services

### Getting Started

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd db_at_gcp_poc
   ```

2. **Choose Your Deployment Module**

   Choose one of the modules below based on your needs:

   - **[GCP infra+vmcluster](gcp/infra+vmcluster/README.md)** - Complete GCP infrastructure with Exadata and VM Cluster
   - **[GCP vmcluster](gcp/vmcluster/README.md)** - GCP VM Cluster only (requires existing Exadata infrastructure)
   - **[OCI ohome+cdb+pdb](ohome+cdb+pdb/README.md)** - OCI Database Home, Container Database, and Pluggable Databases

3. **Navigate to Your Module**
   ```bash
   # For GCP deployments
   cd gcp/infra+vmcluster     # or gcp/vmcluster
   
   # For OCI deployments
   cd ohome+cdb+pdb
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Configure Variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

6. **Plan and Apply**
   ```bash
   terraform plan
   terraform apply
   ```

## 🏗️ Architecture

This project deploys a multi-tier OCI/GCP infrastructure with:

- **Network Layer** - Secure VCN and subnet configuration (Network Security Zone)
- **Compute Layer** - Exadata infrastructure with VM Clusters (Exadata & Database Security Zone)
- **Database Layer** - Oracle Container Database (CDB) with Pluggable Databases (PDB)
- **Security Layer** - OCI Security Zones, IAM policies, encryption (TDE), and monitoring

### Security Zones & Compartmentalization

This architecture implements OCI Security Zones with the following structure:

**Key Architecture Components:**
- **Two Security Zones:** Network (separate zone) and Exadata & Database (separate zone)
- **Compartment Hierarchy:** Infra compartment with Prod and NonProd subcompartments
- **Resource Segregation:** Production and Non-Production environments with different resource allocations
- **Deployment Sequence:** 4-phase deployment (Network → Exadata → Production → Non-Production)
- **Security Features:** Mandatory TDE encryption, Cloud Guard monitoring, VCN security controls, IAM role-based access

## 📚 Modules

### 1. infra+vmcluster

**Complete Oracle Database Infrastructure Deployment**

This module provisions everything needed for a production Oracle Database deployment on GCP:

- Cloud Exadata Infrastructure (compute and storage nodes)
- Oracle Cloud VM Cluster
- Network integration with ODB networks
- Security and access configuration

**Use this module when you need:**
- A complete Oracle Database environment from scratch
- Both Exadata infrastructure and VM cluster management
- Full control over compute and storage resources

📖 **[Full Documentation →](gcp/infra+vmcluster/README.md)**

Key Features:
- Exadata infrastructure shape configuration (Exadata.X9M)
- Flexible compute and storage node counts
- Integration with existing ODB networks
- SSH key management
- License type configuration
- Deletion protection

### 2. vmcluster

**Oracle Cloud VM Cluster Configuration**

This module focuses on VM cluster provisioning and assumes Exadata infrastructure already exists:

- Oracle Cloud VM Cluster deployment
- Grid Infrastructure (GI) configuration
- CPU core and memory allocation
- Hostname and networking setup
- License management

**Use this module when you:**
- Have existing Exadata infrastructure
- Need to deploy additional VM clusters
- Want to manage clusters separately from infrastructure

📖 **[Full Documentation →](gcp/vmcluster/README.md)**

Key Features:
- Customizable CPU core allocation
- GI version selection
- Hostname prefix configuration
- License type options
- Network and subnet integration

### 3. ohome+cdb+pdb

**Oracle Database Home, Container Database, and Pluggable Databases**

This module provisions Oracle database instances on an existing VM Cluster:

- Database Home (OHOME) deployment
- Container Database (CDB) creation
- Pluggable Database (PDB) provisioning
- TDE (Transparent Data Encryption) configuration
- Backup and recovery settings

**Use this module when you:**
- Have an existing VM Cluster ready
- Need to deploy Oracle database instances
- Want to manage multiple PDBs within a CDB
- Require multitenant database architecture

📖 **[Full Documentation →](ohome+cdb+pdb/README.md)**

Key Features:
- Database version configuration (19.x, 21.x)
- Multiple pluggable databases support
- TDE wallet encryption
- Automatic backup configuration
- Character set and language customization
- OLTP and Data Warehouse workload options

## 🔧 Configuration

Each module uses Terraform variables for customization. Common variables include:

| Variable | Description | Module(s) | Example |
|----------|-------------|-----------|----------|
| `project_id` | GCP Project ID | infra+vmcluster, vmcluster | `my-gcp-project` |
| `region` | GCP Region | infra+vmcluster, vmcluster | `europe-west2` |
| `vm_cluster_id` | Cluster identifier | infra+vmcluster, vmcluster, ohome+cdb+pdb | `prod-vm-cluster-1` |
| `cpu_core_count` | CPU cores | infra+vmcluster, vmcluster | `8` |
| `gi_version` | Grid Infrastructure version | vmcluster | `19.0.0.0` |
| `license_type` | License model | infra+vmcluster, vmcluster | `LICENSE_INCLUDED` |
| `ohome_db_version` | Oracle database version | ohome+cdb+pdb | `19.23.0.0` |
| `database_database_db_name` | CDB name | ohome+cdb+pdb | `PRODDB` |
| `pluggable_database_name` | PDB names | ohome+cdb+pdb | `["PDB1", "PDB2"]` |

See individual module READMEs for complete variable documentation.

## 📊 Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    GCP Project                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │             ODB Networks & Subnets               │  │
│  │  • Primary ODB Subnet                            │  │
│  │  • Backup ODB Subnet                             │  │
│  └──────────────────────────────────────────────────┘  │
│                      ↓                                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │        Cloud Exadata Infrastructure              │  │
│  │  Shape: Exadata.X9M                              │  │
│  │  Compute Nodes: 2+ | Storage Nodes: 3+           │  │
│  └──────────────────────────────────────────────────┘  │
│                      ↓                                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │       Oracle Cloud VM Clusters                    │  │
│  │  • GI Version 19.0.0.0 or later                   │  │
│  │  • Configurable CPU cores                         │  │
│  │  • Production-grade HA capabilities               │  │
│  └──────────────────────────────────────────────────┘  │
│                      ↓                                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │      Database Home, CDB, and PDBs                │  │
│  │  • Oracle DBMS Installation (OHOME)              │  │
│  │  • Container Database (CDB)                       │  │
│  │  • Pluggable Databases (PDBs)                     │  │
│  │  • TDE Encryption & Backup Configuration          │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 🔐 Security Best Practices

- **SSH Access**: Configure SSH public keys in variables
- **Deletion Protection**: Enabled by default to prevent accidental deletion
- **Network Isolation**: Use ODB networks for secure database connectivity
- **IAM Permissions**: Grant minimal required GCP IAM roles
- **State Management**: Use remote state backend (GCS) for team collaboration
- **Secrets**: Never commit sensitive data or terraform.tfvars to version control

## 📝 Common Tasks

### Deploy Complete Infrastructure Stack
```bash
# Step 1: Deploy infrastructure and VM cluster
cd infra+vmcluster
terraform init
terraform plan
terraform apply

# Step 2: Deploy databases
cd ../ohome+cdb+pdb
terraform init
terraform plan
terraform apply
```

### Deploy Additional VM Cluster
```bash
cd vmcluster
terraform init
terraform plan
terraform apply
```

### Deploy Databases on Existing Cluster
```bash
cd ohome+cdb+pdb
terraform init
terraform plan
terraform apply
```

### Update Existing Configuration
```bash
# Edit terraform.tfvars
terraform plan
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

> ⚠️ **Warning**: Deletion protection is enabled by default. Manually disable before destruction.

## 🐛 Troubleshooting

### Provider Issues
```bash
terraform init -upgrade
terraform validate
```

### Authentication Errors
```bash
gcloud auth application-default login
```

### Network Connectivity
- Verify ODB network resource paths
- Check GCP project permissions
- Ensure APIs are enabled in GCP console

## 📖 Documentation

- [GCP Oracle Database Documentation](https://cloud.google.com/oracle/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Oracle Database Cloud Service](https://cloud.google.com/sql/docs/oracle)
- [GCP Networking Guide](https://cloud.google.com/vpc/docs)
- [Oracle Database Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/)
- [OCI Terraform Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)

## 🔄 Terraform State

For production environments:

1. **Configure Remote State** (e.g., GCS bucket)
   ```hcl
   terraform {
     backend "gcs" {
       bucket = "my-terraform-state"
       prefix = "db-at-gcp"
     }
   }
   ```

2. **Enable State Locking** for team collaboration

3. **Backup State Files** regularly

## 📋 Requirements

| Component | Version |
|-----------|---------|
| Terraform | ≥ 1.0 |
| Google Provider (beta) | ≥ 5.0 |
| Google Cloud SDK | Latest |
| GCP APIs | Oracle Database, Compute Engine, Resource Manager |
| OCI Provider | Latest |

## 🤝 Contributing

1. Review existing documentation
2. Test changes in a non-production environment
3. Update relevant README files
4. Follow Terraform best practices

## 📄 License

See [LICENSE](LICENSE) file for details.

## 📞 Support

For issues or questions:
1. Check module-specific READMEs
2. Review GCP and Terraform documentation
3. Contact your GCP support team

## 📚 Related Resources

- [Exadata Infrastructure Guide](infra+vmcluster/README.md)
- [VM Cluster Setup](vmcluster/README.md)
- [Database Configuration](ohome+cdb+pdb/README.md)
- [Terraform Best Practices](https://www.terraform.io/docs)
- [GCP Security Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-running-cost-effective-kubernetes)

---

**Last Updated**: January 2026

**Project Status**: Active

**Contributors**: Database Infrastructure Team
