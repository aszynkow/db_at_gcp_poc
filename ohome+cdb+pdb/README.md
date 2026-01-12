# Oracle Database Home, CDB, and PDB Configuration

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Oracle Cloud](https://img.shields.io/badge/Oracle_Cloud-F80000?logo=oracle&logoColor=white)](https://www.oracle.com/cloud/)
[![License](https://img.shields.io/badge/License-UPL-blue.svg)](LICENSE)

This Terraform module automates the provisioning of Oracle Database infrastructure including Database Home (OHOME), Container Database (CDB), and Pluggable Databases (PDB) on Oracle Cloud Infrastructure (OCI).

## 📋 Overview

This module provides complete automation for:

- **Database Home (OHOME)**: Oracle Database installation and configuration
- **Container Database (CDB)**: The multitenant container database instance
- **Pluggable Databases (PDB)**: Multiple pluggable database instances within the CDB

The configuration is deployed on an existing Oracle VM Cluster and supports both OLTP and Data Warehouse workloads.

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────┐
│         Oracle VM Cluster                        │
│   (from infra+vmcluster deployment)              │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │      Database Home (OHOME)                │   │
│  │  • Database Version: 19.23.0.0            │   │
│  │  • Source: VM_CLUSTER_NEW                 │   │
│  └──────────────────────────────────────────┘   │
│           ↓                                      │
│  ┌──────────────────────────────────────────┐   │
│  │   Container Database (CDB) - DEMO1       │   │
│  │  • Character Set: AL32UTF8                │   │
│  │  • NCharacter Set: AL16UTF16              │   │
│  │  • Workload: OLTP (configurable)          │   │
│  │  • Admin User: SYS                        │   │
│  └──────────────────────────────────────────┘   │
│           ↓                                      │
│  ┌──────────────────────────────────────────┐   │
│  │     Pluggable Databases (PDBs)            │   │
│  │  • PDB1: Production workload              │   │
│  │  • PDB2: Development/Test workload        │   │
│  │  • TDE Wallet Protection: Enabled         │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
└──────────────────────────────────────────────────┘
```

## 📁 Directory Structure

```
ohome+cdb+pdb/
├── README.md              # This file
├── provider.tf            # OCI provider configuration
├── database.tf            # Database resources (OHOME, CDB, PDB)
├── variables.tf           # Input variable definitions
├── terraform.tfvars       # Variable values (not in repo)
└── .terraform.lock.hcl    # Provider version lock file
```

## 📄 Configuration Files

### provider.tf
Configures the OCI Terraform provider with authentication credentials:
- Tenancy OCID
- User OCID
- API key fingerprint
- Private key path
- Region configuration

### database.tf
Defines the core database resources:

**oci_database_db_home**: Creates the Oracle Database Home
- Configurable database version (e.g., 19.23.0.0)
- Deploys on existing VM Cluster
- Display name configuration

**oci_database_database**: Creates the Container Database (CDB)
- Admin password management
- Character set configuration (UTF8, AL16UTF16)
- Backup settings and auto-backup capability
- Database workload type (OLTP/DW)

**oci_database_pluggable_database**: Creates Pluggable Databases
- Multiple PDBs within single CDB
- TDE (Transparent Data Encryption) wallet protection
- Individual PDB admin passwords

### variables.tf
Defines all input variables with sensible defaults:
- OCI authentication parameters
- VM Cluster reference
- Database configuration options
- PDB names and passwords

## 🔧 Input Variables

### OCI Authentication (Required)

| Variable | Description | Type |
|----------|-------------|------|
| `tenancy_ocid` | OCI Tenancy OCID | `string` |
| `user_ocid` | OCI User OCID | `string` |
| `fingerprint` | API Key fingerprint | `string` |
| `private_key_path` | Path to private key file | `string` |
| `region` | OCI Region | `string` |

### Database Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `vm_cluster_id` | Required | Existing VM Cluster OCID |
| `ohome_display_name` | `DB-Home-01` | Database Home display name |
| `ohome_db_version` | `19.23.0.0` | Oracle Database version |
| `ohome_source` | `VM_CLUSTER_NEW` | Source type for database home |
| `database_database_db_name` | `DEMO1` | Container Database name |
| `database_database_admin_password` | `temppass1234` | CDB admin password (SYS user) |
| `database_database_character_set` | `AL32UTF8` | Character set (AL32UTF8 recommended) |
| `database_database_sid_prefix` | `DEMO1` | System Identifier prefix |
| `database_database_db_workload` | `OLTP` | Workload type: OLTP or DW |
| `db_db_ncharacter_set` | `AL16UTF16` | National character set |
| `auto_backup_enabled` | `false` | Enable automatic backups |
| `database_database_source` | `NONE` | Database creation source |

### Pluggable Database Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `pluggable_database_name` | `["PDB1", "PDB2"]` | List of PDB names |
| `pdb_admin_password` | `["temppass1234", "temppass1234"]` | List of PDB admin passwords |
| `pluggable_database_tde_wallet_password` | `["temppass1234", "temppass1234"]` | TDE wallet passwords |

## 🚀 Getting Started

### Prerequisites

- **Terraform**: Version 1.0 or later
- **OCI Provider**: Latest version
- **OCI Account**: Active subscription with billing enabled
- **API Keys**: Generated for OCI user account
- **Existing VM Cluster**: From `infra+vmcluster` deployment
- **Permissions**: Appropriate IAM policies for database operations

### Step 1: Configure OCI Credentials

Set up OCI API authentication:

```bash
# Generate API key
openssl genrsa -out ~/.oci/oci_api_key.pem 4096
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem

# Upload public key to OCI Console under User Settings
# Retrieve fingerprint from the console
```

### Step 2: Create terraform.tfvars

```hcl
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaa..."
user_ocid            = "ocid1.user.oc1..aaaaaa..."
fingerprint          = "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99"
private_key_path     = "/path/to/oci_api_key.pem"
region               = "us-ashburn-1"

# Database Configuration
vm_cluster_id                        = "ocid1.vmcluster.oc1.iad.aaaaaaa..."
ohome_display_name                   = "Production-DB-Home-01"
ohome_db_version                     = "19.23.0.0"
database_database_db_name            = "PRODDB"
database_database_admin_password     = "SecurePassword123!"
database_database_db_workload        = "OLTP"
database_database_character_set      = "AL32UTF8"

# PDB Configuration
pluggable_database_name              = ["PRODPDB1", "PRODPDB2"]
pdb_admin_password                   = ["PDBPassword123!", "PDBPassword123!"]
pluggable_database_tde_wallet_password = ["TDEWallet123!", "TDEWallet123!"]

auto_backup_enabled                  = true
```

### Step 3: Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Review planned changes
terraform plan

# Apply configuration
terraform apply
```

## 📊 Database Architecture Details

### Database Home (OHOME)
- Installed on the VM Cluster infrastructure
- Contains database binaries and configuration files
- Version: 19.23.0.0 (Enterprise Edition)
- Source: VM_CLUSTER_NEW (fresh installation)

### Container Database (CDB)
- **Name**: DEMO1 (customizable)
- **Role**: Hosts multiple pluggable databases
- **Character Set**: AL32UTF8 (supports all Unicode characters)
- **NCharacter Set**: AL16UTF16 (national language support)
- **SID Prefix**: DEMO1 (unique identifier)
- **Workload**: OLTP (Online Transaction Processing) or DW (Data Warehouse)
- **Admin User**: SYS (initial account)

### Pluggable Databases (PDBs)
- **PDB1**: Primary production workload
- **PDB2**: Development/testing workload
- **TDE Enabled**: Transparent Data Encryption for data protection
- **Individual Passwords**: Each PDB has separate admin credentials

## 🔐 Security Best Practices

### Password Management
- ⚠️ **Never commit `terraform.tfvars` to version control**
- Use strong, complex passwords (minimum 12 characters)
- Include uppercase, lowercase, numbers, and special characters
- Store passwords securely (password manager, vault)
- Change default passwords immediately after deployment

### Network Security
- Restrict database access through security lists
- Use VPN for remote connections
- Enable Transparent Data Encryption (TDE)
- Configure backup encryption

### API Key Management
- Keep API key files secure (0600 permissions)
- Rotate keys regularly
- Use service accounts for automation
- Monitor API key usage in OCI audit logs

### Database Hardening
- Change default SYS password immediately
- Create separate database users with limited privileges
- Enable audit logging
- Configure password policies
- Use database native encryption

## 🔄 Common Operations

### View Current State
```bash
terraform show
```

### Update Database Configuration
```bash
# Edit terraform.tfvars
nano terraform.tfvars

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Scaling PDBs
To add more pluggable databases, update variables:
```hcl
pluggable_database_name = ["PDB1", "PDB2", "PDB3"]
pdb_admin_password = ["pwd1", "pwd2", "pwd3"]
pluggable_database_tde_wallet_password = ["pwd1", "pwd2", "pwd3"]
```

### Destroy Infrastructure
```bash
terraform destroy
```

> ⚠️ **Warning**: This operation permanently deletes all databases and data.

## 📈 Monitoring and Maintenance

### Database Health Checks
```sql
-- Connect to CDB
sqlplus sys@cdb_name as sysdba

-- Check instance status
select * from v$instance;

-- Check database status
select * from v$database;

-- List PDBs
show pdbs;
```

### Backup Configuration
- Enable auto-backup: Set `auto_backup_enabled = true`
- Configure backup windows in `auto_backup_window`
- Verify backups in OCI Console

### Performance Tuning
- Monitor CPU and memory utilization
- Check database alert logs
- Analyze slow queries
- Adjust SGA/PGA parameters as needed

## 🐛 Troubleshooting

### Authentication Issues
```bash
# Verify OCI credentials
oci iam user list --region us-ashburn-1

# Check API key configuration
openssl rsa -in ~/.oci/oci_api_key.pem -check
```

### Provider Not Found
```bash
# Reinitialize Terraform
terraform init -upgrade
```

### VM Cluster Not Found
```bash
# Verify VM Cluster OCID
oci database vm-cluster list --region us-ashburn-1
```

### Database Creation Fails
- Check VM Cluster status
- Verify available compute resources
- Review OCI logs for errors
- Ensure correct character set configuration

## 📚 Documentation and Resources

- [OCI Terraform Provider Documentation](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [Oracle Database 19c Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/)
- [OCI Database Cloud Service](https://www.oracle.com/cloud/database/)
- [Oracle Multitenant Architecture](https://docs.oracle.com/en/database/oracle/oracle-database/19/multi/index.html)
- [TDE Implementation Guide](https://docs.oracle.com/en/database/oracle/oracle-database/19/asoag/index.html)

## 📋 Related Modules

This module requires:
- **infra+vmcluster**: Oracle VM Cluster infrastructure

Typically followed by:
- Database user and schema creation
- Application deployment
- Backup and recovery configuration

## 🔗 Dependencies

```
infra+vmcluster
       ↓
ohome+cdb+pdb (this module)
       ↓
Application Deployment
       ↓
Backup & DR Configuration
```

## 📝 Outputs

The module creates:
- Database Home instance
- Container Database (CDB)
- 2 Pluggable Databases (PDB1, PDB2)
- TDE wallets for each PDB
- Database initialization parameters

Access database details:
```bash
terraform output
```

## ⚙️ Advanced Configuration

### Enable Database Backups
```hcl
auto_backup_enabled = true
auto_backup_window = "SLOT_TWO"  # Time slot for backups
```

### Change Database Version
```hcl
ohome_db_version = "19.23.0.0"  # Update to desired version
```

### Data Warehouse Workload
```hcl
database_database_db_workload = "DW"  # Change to DW for analytics
```

## 📞 Support and Feedback

For issues, questions, or improvements:
1. Review this documentation
2. Check OCI documentation
3. Contact your OCI support team
4. Review Terraform best practices

## 📄 License

Copyright © 2020, Oracle and/or its affiliates.
All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

## 🎯 Next Steps

1. ✅ Configure OCI credentials
2. ✅ Set up API keys
3. ✅ Create terraform.tfvars
4. ✅ Deploy infrastructure
5. ✅ Connect to databases
6. ✅ Configure users and schemas
7. ✅ Set up backups
8. ✅ Monitor and optimize

---

**Last Updated**: January 2026

**Module Version**: 1.0

**Status**: Production Ready
