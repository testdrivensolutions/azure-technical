# Identity review

Review the managed identity in `compute.tf`, the existing assignment in `identity.tf`, and the alternative proposal in `review/identity.tf.example`.

The application must read blobs from the application storage account. It must not write or delete data, manage Azure resources, or grant access to other identities.

Explain whether the proposed assignment meets that requirement. Edit or describe the changes you would make, including which identity receives access and at what scope. Treat this as an alternative to the existing assignment, not an additional permission grant.

Explain how the application would authenticate without a stored password, and how its identity differs from the identity that runs Terraform. Describe how you would investigate a failed request after permissions were changed.

Documentation is allowed. No Azure environment, live tokens, credentials or deployment is required. The `.tf.example` file is a review proposal and is not loaded by the root Terraform checks.
