# Azure platform technical exercise

Infrastructure is defined in the Terraform files at the repository root.

## Prerequisites

- Terraform 1.14.6.
- Azure CLI and an authorised Azure subscription if planning or deploying.

## Local checks

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

For an authenticated plan, sign in to Azure and copy `terraform.tfvars.example` to `terraform.tfvars`, supplying the subscription ID.

```sh
az login
terraform plan
```

Discuss changes with the interviewer before deploying resources.

## Automation

The GitHub Actions workflow runs formatting and validation checks on pushes and pull requests. It requires no Azure credentials and does not deploy resources.

Commit `.terraform.lock.hcl` after successful initialization. Keep local variables, state and plan files out of Git.
