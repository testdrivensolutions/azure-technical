# Networking review

Review `networking.tf`, `compute.tf`, `storage.tf` and the proposed addition in `review/networking.tf.example`.

The proposed rules should allow HTTPS traffic to Azure Storage while blocking other outbound HTTPS traffic through the integration subnet. Explain whether the rules achieve that, propose a correction, and describe the limits of this approach.

Does the existing configuration restrict storage network access to this application? Explain what you would change if private access were required.

Describe how you would investigate a connection failure: DNS resolution, routing, network controls and application permissions. State which checks need a running environment. Documentation is allowed; no deployment or live troubleshooting is required.

The `.tf.example` file is a review proposal, not an active part of the root Terraform configuration.
