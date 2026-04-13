---
name: infrastructure-as-code
description: 'Terraform and Pulumi patterns for managing cloud infrastructure. Covers module design, state management, environment promotion, and drift detection.'
---

# Infrastructure as Code

## Overview

Infrastructure as Code (IaC) means your cloud resources are defined in version-controlled files, not ClickOps in a console. Changes go through code review, CI validates them with a plan, and deployment is automated and repeatable. When your staging environment drifts from production because someone clicked a button in AWS, you've already lost.

This skill covers Terraform and Pulumi — the two dominant IaC tools. Terraform uses declarative HCL; Pulumi uses your existing programming language (TypeScript, Python, Go). The principles apply to both: modular design, remote state, environment isolation, and drift detection.

## When to Use

- Provisioning cloud infrastructure for a new project
- Migrating ClickOps resources to code
- Setting up multi-environment infrastructure (dev/staging/prod)
- Designing reusable infrastructure modules
- Establishing CI/CD for infrastructure changes
- Importing existing resources into IaC management

**When NOT to use:** Local development tools (Docker Compose is fine), one-off throwaway environments that live for minutes, or infrastructure managed by a dedicated platform team with their own tooling.

## Process

### Step 1 — Define Infrastructure Requirements

Before writing any code, map out what you're building.

**Infrastructure inventory template:**

```
Project: [project name]
Cloud provider: [AWS / GCP / Azure / multi-cloud]
Environments: [dev, staging, production]

Resources:
  Compute: [ECS/EKS/Lambda/EC2/Cloud Run/etc.]
  Database: [RDS/Aurora/Cloud SQL/DynamoDB/etc.]
  Storage: [S3/GCS/R2/etc.]
  Networking: [VPC, subnets, load balancers, DNS]
  Security: [IAM roles, KMS keys, secrets manager]
  Monitoring: [CloudWatch/Datadog/Grafana Cloud]

Environment differences:
  Dev: [smaller instances, single AZ, no HA]
  Staging: [mirrors prod topology, smaller instances]
  Prod: [full HA, multi-AZ, autoscaling]
```

### Step 2 — Choose Tool and Set Up Project

**Terraform vs Pulumi decision:**

| Factor           | Terraform                             | Pulumi                                 |
| ---------------- | ------------------------------------- | -------------------------------------- |
| Language         | HCL (domain-specific)                 | TypeScript, Python, Go, C#             |
| Learning curve   | Lower (simpler syntax)                | Lower if you know the language already |
| State management | Built-in (local, S3, Terraform Cloud) | Built-in (Pulumi Cloud, S3, local)     |
| Module ecosystem | Terraform Registry (huge)             | Smaller, but growing                   |
| Testing          | `terraform test`, Terratest           | Native unit tests in your language     |
| Dynamic logic    | Limited (for_each, conditionals)      | Full programming language              |

**Terraform project structure:**

```
infrastructure/
├── modules/                  # Reusable modules
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/
│   └── compute/
├── environments/             # Environment-specific configs
│   ├── dev/
│   │   ├── main.tf          # Calls modules with dev values
│   │   ├── terraform.tfvars
│   │   └── backend.tf       # Dev state backend
│   ├── staging/
│   └── production/
├── .terraform-version        # Pin Terraform version
└── terragrunt.hcl            # (Optional) DRY config with Terragrunt
```

**Pulumi project structure:**

```
infrastructure/
├── index.ts                  # Entry point
├── Pulumi.yaml               # Project config
├── Pulumi.dev.yaml           # Dev stack config
├── Pulumi.staging.yaml
├── Pulumi.production.yaml
├── components/               # Reusable components
│   ├── networking.ts
│   ├── database.ts
│   └── compute.ts
├── package.json
└── tsconfig.json
```

### Step 3 — Design Module Structure

Modules are the building blocks. Design them like library functions: clear inputs, clear outputs, no hidden side effects.

**Module design rules:**

- One module = one logical concern (networking, database, compute)
- All configuration through variables — no hardcoded values
- Validate variable inputs at the module level
- Document every variable and output
- Pin provider versions in the module

**Terraform module example:**

```hcl
# modules/database/variables.tf
variable "name" {
  description = "Database instance name"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+$", var.name))
    error_message = "Name must be lowercase alphanumeric with hyphens."
  }
}

variable "engine_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  validation {
    condition     = startswith(var.instance_class, "db.")
    error_message = "Instance class must start with 'db.'"
  }
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

# modules/database/outputs.tf
output "endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "Database port"
  value       = aws_db_instance.this.port
}
```

### Step 4 — Configure State Backend

State is the single most critical piece of your IaC setup. Lose it and you're reimporting everything.

**Remote state rules:**

- Never store state locally for shared infrastructure
- Enable state locking to prevent concurrent modifications
- Enable versioning on the state bucket for recovery
- Encrypt state at rest (it contains secrets)

**Terraform S3 backend:**

```hcl
# environments/production/backend.tf
terraform {
  backend "s3" {
    bucket         = "mycompany-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

**State isolation strategy — directory per environment (recommended):**

```
environments/dev/        → s3://bucket/dev/terraform.tfstate
environments/staging/    → s3://bucket/staging/terraform.tfstate
environments/production/ → s3://bucket/production/terraform.tfstate
```

Each environment has its own state file. `terraform apply` in `dev/` cannot touch production resources.

### Step 5 — Implement Environments

Use the same modules across environments — only the variable values differ.

**Environment config (Terraform):**

```hcl
# environments/dev/main.tf
module "networking" {
  source = "../../modules/networking"
  environment    = "dev"
  vpc_cidr       = "10.0.0.0/16"
  az_count       = 2
}

module "database" {
  source = "../../modules/database"
  environment    = "dev"
  name           = "myapp-dev"
  instance_class = "db.t3.micro"
  multi_az       = false
  subnet_ids     = module.networking.private_subnet_ids
}
```

```hcl
# environments/production/main.tf
module "database" {
  source = "../../modules/database"
  environment    = "production"
  name           = "myapp-prod"
  instance_class = "db.r6g.xlarge"
  multi_az       = true
  subnet_ids     = module.networking.private_subnet_ids
}
```

**Terragrunt DRY pattern (optional but recommended for 3+ environments):**

```hcl
# terragrunt.hcl (root)
remote_state {
  backend = "s3"
  config = {
    bucket         = "mycompany-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# environments/dev/terragrunt.hcl
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment    = "dev"
  instance_class = "db.t3.micro"
  multi_az       = false
}
```

### Step 6 — Set Up CI/CD for Infrastructure

Infrastructure changes must go through the same rigor as application code.

**CI/CD pipeline flow:**

```
PR opened → terraform fmt check → terraform validate → terraform plan → Post plan as PR comment
PR merged → terraform apply (auto-approve for dev, manual approval for prod)
```

**GitHub Actions example:**

```yaml
name: Terraform Plan
on:
  pull_request:
    paths: ['infrastructure/**']

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform fmt -check -recursive
      - run: terraform init
        working-directory: infrastructure/environments/staging
      - run: terraform validate
        working-directory: infrastructure/environments/staging
      - run: terraform plan -no-color -out=tfplan
        working-directory: infrastructure/environments/staging
      - uses: actions/github-script@v7
        with:
          script: |
            // Post plan output as PR comment
```

**Safety rules:**

- `terraform plan` on every PR — always review the plan
- `terraform apply` only on merge to main (never from a laptop)
- Production apply requires manual approval
- Pin Terraform and provider versions to avoid surprise upgrades

### Step 7 — Verify with Plan and Drift Detection

**Pre-apply verification:**

```bash
# Format check
terraform fmt -check -recursive

# Validate syntax and references
terraform validate

# Plan — review every change
terraform plan -out=tfplan

# Apply only after reviewing the plan
terraform apply tfplan
```

**Drift detection:**

```bash
# Run periodically (cron) to detect manual changes
terraform plan -detailed-exitcode

# Exit codes:
# 0 — no changes (no drift)
# 1 — error
# 2 — changes detected (drift found!)
```

**Importing existing resources:**

```bash
# Terraform import (one resource at a time)
terraform import aws_s3_bucket.logs my-existing-bucket

# Write the matching HCL, then plan to confirm no changes
terraform plan  # should show "No changes"
```

## Common Rationalizations

| Rationalization                                | Reality                                                                                                      |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| "I'll just create it in the console this once" | That's how drift starts. Every "just this once" becomes permanent. Import it into IaC afterwards at minimum. |
| "State is too complex — we'll use local state" | Local state works for one person. The moment two people touch infra, you get state corruption.               |
| "We don't need separate environments in IaC"   | Then your first prod deploy will have zero testing. Environment parity starts with infrastructure.           |
| "Terraform is overkill for a small project"    | A VPC + RDS + ECS setup has 20+ resources. Recreating that by hand after a disaster is not small.            |
| "We can just copy-paste between environments"  | Copy-paste is how staging drifts from production. Use modules with different variable values.                |
| "We'll add CI/CD for infra later"              | "Later" means after someone runs `terraform apply` from their laptop and takes down production.              |

## Red Flags

- State files committed to git (secrets exposed, merge conflicts guaranteed)
- No state locking (concurrent applies will corrupt state)
- Hardcoded values in modules instead of variables
- `terraform apply` run from developer laptops instead of CI/CD
- No plan review before apply — just YOLO applying
- Different Terraform versions across team members (state incompatibility)
- Monolithic Terraform config (one giant `main.tf` with everything)
- No drift detection — manual console changes go unnoticed

## Verification

- [ ] All infrastructure resources are defined in code (no ClickOps resources outside IaC)
- [ ] State is stored remotely with locking and encryption enabled
- [ ] State is versioned (bucket versioning) for recovery
- [ ] Modules accept all configuration through variables with validation
- [ ] Each environment has its own state file and variable values
- [ ] `terraform plan` runs on every PR that touches infrastructure
- [ ] `terraform apply` runs only from CI/CD, never from laptops
- [ ] Production apply requires manual approval
- [ ] Terraform and provider versions are pinned
- [ ] Drift detection runs on a schedule (weekly minimum)
- [ ] Existing resources have been imported into state
