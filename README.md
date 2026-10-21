# Azure platform technical exercise

Infrastructure is defined in the Terraform files at the repository root.

## Working approach

Review the code with the interviewer. Explain what it creates, investigate problems and discuss how you would fix and verify them. You may edit the files, run Terraform locally and consult Terraform provider and Azure documentation.

No Azure environment or credentials are provided. Do not run `terraform apply` or deploy resources.

## Local checks

Use Terraform 1.14.6 and an internet connection to download providers. You can run:

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Read the output and explain what it tells you. Describe any other checks you would use and what they would establish.

A full `terraform plan` generally requires Azure authentication. You do not need to produce a successful plan for this exercise. If you attempt it and encounter an authentication requirement, explain the result and continue reviewing the code. Do not supply real subscription credentials.

Successful validation does not prove that Azure will accept the configuration or that an application will work correctly. Explain how you would verify your proposed changes if an environment were available.

## Automation

The GitHub Actions workflow runs formatting and validation on pushes and pull requests. It requires no Azure credentials and does not deploy resources.

Keep local variables, state and plan files out of Git. Commit `.terraform.lock.hcl` after successful initialization.
