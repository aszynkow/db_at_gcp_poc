# DB at GCP

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?logo=google-cloud&logoColor=white)](https://cloud.google.com/)

A Terraform configuration to deploy an Oracle Database Cloud VM Cluster on Google Cloud Platform (GCP). This setup provisions a fully configured VM cluster backed by Exadata infrastructure, enabling high-performance Oracle database operations in the cloud.

## Overview

This project automates the deployment of an Oracle Database Cloud VM Cluster using Google's Oracle Database service. The configuration includes:

- **VM Cluster Creation**: Deploys a cloud VM cluster with customizable CPU cores, memory, and networking.
- **Exadata Integration**: Leverages existing Exadata infrastructure for optimal performance.
- **Security Configuration**: Includes SSH key management and network isolation.
- **License Management**: Supports included or bring-your-own-license models.

Key features:
- Automated provisioning of Oracle Database environments
- Scalable CPU and storage configurations
- Secure access via SSH keys
- Deletion protection for production safety

## Prerequisites

Before running this configuration, ensure you have:

- **Terraform**: Version 1.0 or later installed ([Download](https://www.terraform.io/downloads))
- **Google Cloud Account**: Access to a GCP project with billing enabled
- **gcloud CLI**: Configured with your GCP account ([Installation Guide](https://cloud.google.com/sdk/docs/install))
- **Permissions**: Appropriate IAM roles for Oracle Database and Compute Engine operations
- **Existing Infrastructure**: Pre-configured ODB Network and Exadata Infrastructure

## Quick Start

### 1. Clone and Navigate
```bash
git clone <your-repo-url>
cd db_at_gcp
```

### 2. Configure Variables
Edit `variables.tf` or create a `terraform.tfvars` file to customize:

```hcl
project_id = "your-gcp-project-id"
region = "us-central1"
vm_cluster_id = "my-oracle-vm-cluster"
exadata_infrastructure_id = "your-exadata-infra"
# ... other variables as needed
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```
Review the plan to ensure it matches your expectations.

### 5. Apply the Configuration
```bash
terraform apply
```
Type `yes` when prompted to confirm the deployment.

## Validation

After deployment, validate your Oracle Database Cloud VM Cluster:

### 1. Terraform State Check
```bash
terraform show
```
This displays the current state of all resources.

### 2. GCP Console Verification
- Navigate to [Oracle Database in GCP Console](https://console.cloud.google.com/oracle/database)
- Locate your VM cluster under the specified project and region
- Verify cluster status, CPU cores, and network configurations

### 3. Connection Test
Once provisioned, connect to the VM cluster using SSH:
```bash
ssh -i <your-private-key> oracle@<cluster-ip>
```

### 4. Database Access
After successful deployment, you can:
- Create databases within the VM cluster
- Configure backup and recovery settings
- Set up high availability features

## Configuration Options

### Key Variables
- `project_id`: GCP project identifier
- `region`: Deployment region (default: us-central1)
- `cpu_core_count`: Number of CPU cores (default: 4)
- `license_type`: License model (default: LICENSE_INCLUDED)
- `deletion_protection`: Enable/disable resource deletion protection (default: true)

### Networking
- `odb_network`: Pre-configured Oracle Database network
- `odb_subnet`: Primary subnet for the VM cluster
- `backup_odb_subnet`: Dedicated subnet for backups

## Troubleshooting

- **Permission Errors**: Ensure your GCP account has the necessary IAM roles
- **Quota Issues**: Check GCP quotas for Oracle Database resources
- **Network Configuration**: Verify ODB network and subnet existence
- **Terraform Lock**: Use `terraform force-unlock <lock-id>` if needed (rare)

## Cleanup

To remove the deployed resources:
```bash
terraform destroy
```

**⚠️ Warning**: This will permanently delete the VM cluster and any associated data. Ensure backups are in place.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the terms specified in [LICENSE.txt](LICENSE.txt).

## Support

For issues related to Oracle Database on GCP, refer to the [official documentation](https://cloud.google.com/oracle/database/docs).
