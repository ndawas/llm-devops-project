# cloud-project

A Terraform project that provisions S3 and DynamoDB on Floci, a local AWS emulator. It is designed for local development and testing, with no real AWS account or credentials required.

## Table of contents

- [Overview](#overview)
- [Provider](#provider)
- [Services](#services)
- [Why these services](#why-these-services)
- [Project structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Getting started](#getting-started)
- [Verifying resources](#verifying-resources)
- [Destroying resources](#destroying-resources)
- [Screenshots](#screenshots)

## Overview

This project deploys two core AWS resources through Terraform, using Floci as a drop-in local replacement for AWS:

- An S3 bucket with versioning enabled
- A DynamoDB table with a simple partition key

Both resources are defined as reusable modules (`modules/s3` and `modules/dynamodb`) and wired together in the root module, so the same code could later target real AWS by removing the custom endpoints.

## Provider

**AWS** (`hashicorp/aws`, version `~> 5.0`)

The provider is configured to send every request to Floci instead of the real AWS API. Credentials are dummy values (`access_key = "test"`, `secret_key = "test"`) since Floci does not perform real authentication.

## Services

| Service | Purpose |
|---|---|
| **S3** | Object storage for project data. Simple, universal, and supports versioning out of the box. |
| **DynamoDB** | Serverless NoSQL database. A good fit for storing metadata keyed by a partition key. |

## Why these services

S3 and DynamoDB form the baseline duo of most AWS architectures. Both are stateless, require no server to manage, and are available in Floci immediately without any extra Docker configuration.

## Project structure

```
cloud-project/
├── main.tf                  # Root module, wires the S3 and DynamoDB modules together
├── providers.tf             # AWS provider configuration pointed at Floci
├── variables.tf             # Root input variables
├── locals.tf                # Computed locals (naming prefix, common tags)
├── outputs.tf                # Root outputs
├── versions.tf               # Terraform and provider version constraints
├── terraform.tfvars          # Default variable values for this environment
├── docker-compose.yml        # Starts the Floci emulator
├── modules/
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── dynamodb/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── screenshots/               # Evidence of the deployment and teardown steps
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [Docker](https://www.docker.com/) and Docker Compose, to run Floci
- `curl`, to check Floci's health endpoint

## Configuration

Variables are defined in `variables.tf` and populated by default in `terraform.tfvars`.

| Variable | Type | Default | Description |
|---|---|---|---|
| `project_name` | `string` | `"cloud-project"` | Name of the project, used as a naming prefix |
| `environment` | `string` | `"dev"` | Deployment environment (`dev`, `staging`, or `prod`) |
| `aws_region` | `string` | `"us-east-1"` | AWS region used by Floci |
| `s3_versioning_enabled` | `bool` | `true` | Enables versioning on the S3 bucket |
| `dynamodb_billing_mode` | `string` | `"PAY_PER_REQUEST"` | DynamoDB billing mode (`PAY_PER_REQUEST` or `PROVISIONED`) |

The AWS provider is pointed at Floci through custom endpoints:

```hcl
endpoints {
  s3       = "http://localhost:4566"
  dynamodb = "http://localhost:4566"
}
```

No real AWS account is required. Credentials are fictitious (`access_key = "test"`).

## Getting started

### 1. Start Floci

```bash
docker compose up -d
```

Check that Floci is running:

```bash
curl http://localhost:4566/_floci/health
```

### 2. Open Floci UI

```
http://localhost:4566/_floci/ui
```

### 3. Deploy the infrastructure

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Verifying resources

Open the Floci UI at `http://localhost:4566/_floci/ui` and navigate to **Storage** and **DynamoDB** to confirm that the bucket and table were created.

## Destroying resources

```bash
terraform destroy
```

## Screenshots

The `screenshots/` directory contains visual evidence of each step: starting Floci, browsing the Floci UI, the created S3 and DynamoDB resources, `terraform apply` output, and the state of both services after `terraform destroy`.
