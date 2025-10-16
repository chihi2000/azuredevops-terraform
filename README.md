# Azure DevOps Terraform Infrastructure

A terraform infrastructure project for managing Azure networking resources with automated CI/CD pipelines, security scanning, and multi-environment support. This project is demonstrative and doesn't belong to any existing solution.


## Architecture Overview

### Project Structure

```
azuredevops-terraform/
├── modules/                    # Reusable Terraform modules
│   └── networking/vnet/       # Virtual Network module
├── environments/              # Environment-specific configurations
│   ├── dev/                  # Development environment
│   └── prod/                 # Production environment
└── .azuredevops/pipelines/   # CI/CD pipeline definitions
```

### Network Architecture

**3-Tier Security Model:**

```
Internet → Web Tier → App Tier → Data Tier
           (10.1.1.0/24)  (10.1.2.0/24)  (10.1.3.0/24)
           HTTP/HTTPS     Port 8080      Port 1433 (SQL)
```

- **Web Subnet**: Public-facing, allows HTTP (80) and HTTPS (443)
- **App Subnet**: Only accessible from Web subnet on port 8080
- **Data Subnet**: Only accessible from App subnet on port 1433

## Features

- **Modular Design**: DRY principle with reusable modules
- **Multi-Environment**: Separate dev/prod configurations
- **Security-First**: Automated tfsec scanning before deployment
- **CI/CD Ready**: Azure DevOps pipelines with approval gates
- **Remote State**: Azure Storage backend with state locking
- **Type Safety**: Strongly typed variables with validation

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions
- Azure DevOps organization (for CI/CD)

## Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd azuredevops-terraform
   ```

2. **Configure Azure authentication**
   ```bash
   az login
   ```

3. **Initialize Terraform (Dev environment)**
   ```bash
   cd environments/dev
   terraform init
   ```

4. **Plan changes**
   ```bash
   terraform plan
   ```

5. **Apply changes**
   ```bash
   terraform apply
   ```

## Configuration

### Adding/Modifying Subnets

Edit `environments/dev/terraform.tfvars`:

```hcl
subnets = {
  web = {
    name             = "dev-subnet-web"
    address_prefixes = ["10.1.1.0/24"]
    nsg_name         = "dev-nsg-web"
    security_rule = {
      name                       = "AllowHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  # Add more subnets here...
}
```

### Environment Variables

Required variables for each environment:

| Variable | Description | Example |
|----------|-------------|---------|
| `location` | Azure region | `eastus` |
| `resource_group_name` | Resource group name | `Built-In-Identity-RG` |
| `address_space` | VNet address space | `["10.1.0.0/16"]` |
| `subnets` | Subnet configurations | See above |

## CI/CD Pipeline

### Pipeline Flow

```
Push to main → Security Scan → Terraform Plan → Manual Approval → Terraform Apply
```

### Environment-Specific Pipelines

**Dev Pipeline** (`dev.yml`):
- Trigger: Automatic on push to `main` branch
- Pull Request validation enabled
- Optional manual approval before apply

**Prod Pipeline** (`prod.yml`):
- Trigger: Manual only
- Requires manual approval before apply
- Extra validation gates

### Security Scanning

All deployments include automated security scanning with [tfsec](https://github.com/aquasecurity/tfsec):

- Minimum severity: MEDIUM
- Blocks deployment on critical issues
- Results published to pipeline

### Pipeline Setup

1. **Create Variable Group** in Azure DevOps named `terraform-backend-dev`:
   ```
   BACKEND_RESOURCE_GROUP_NAME
   BACKEND_STORAGE_ACCOUNT_NAME
   BACKEND_CONTAINER_NAME
   BACKEND_KEY
   ```

2. **Create Service Connection** named `connect-terraform-azure`

3. **Create Agent Pool** named `terraform-agents` (or use Azure-hosted agents)

4. **Import pipelines** from `.azuredevops/pipelines/`

## Module Documentation

### VNet Module

**Location**: `modules/networking/vnet/`

**Inputs**:
- `vnet_name` (string): Virtual network name
- `address_space` (list(string)): VNet address space
- `location` (string): Azure region
- `resource_group_name` (string): Resource group
- `subnets` (map(object)): Subnet configurations
- `tags` (map(string)): Resource tags

**Outputs**:
- `vnet_id`: Virtual network ID
- `vnet_name`: Virtual network name
- `subnet_ids`: Map of subnet IDs
- `nsg_ids`: Map of NSG IDs

## State Management

State files are stored in Azure Storage:

- **Backend**: Azure Storage Account
- **Container**: `tfstate`
- **Dev State**: `dev.terraform.tfstate`
- **Prod State**: `prod.terraform.tfstate`

## Best Practices

1. **Never commit secrets** - Use Azure Key Vault or variable groups
2. **Always run plan** before apply
3. **Use feature branches** for changes
4. **Review security scan results** before deployment
5. **Test in dev** before promoting to prod
6. **Use semantic commit messages** for better tracking





## AUTHER
Cloud enthusiast who hates CSS.