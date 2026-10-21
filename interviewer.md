# Interviewer notes — Azure platform engineer

Keep this file outside the candidate repository. It contains the answers.

## Terraform: deliberate issues

These notes refer to the main.tf provided in the chat. There are three deliberate issues. Finding unrelated improvements is useful, but is not required to complete this section.

### 1. Reference to an undeclared service plan

Location: azurerm_linux_web_app.application.service_plan_id

Current: `azurerm_service_plan.web.id`

Expected: `azurerm_service_plan.application.id`

The resource is declared as application, not web. After provider initialization, terraform validate should identify this undeclared resource reference. Expect the candidate to trace the reference and correct it rather than create another service plan unnecessarily.

### 2. Subnet outside the virtual network address space

Location: azurerm_subnet.application.address_prefixes

Current: `["10.30.1.0/24"]`

Expected example: `["10.20.1.0/24"]`

The VNet has address space 10.20.0.0/16. The subnet must fit within it. Other valid, non-overlapping subnets within that range are acceptable. Expect an explanation of CIDR containment. Do not expect terraform validate to catch this Azure-side constraint; Azure rejects the configuration during deployment.

Reference: [Plan Azure virtual networks](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg).

### 3. Management-plane role used for blob data access

Location: azurerm_role_assignment.application_storage.role_definition_name

Current: `"Reader"`

Expected: `"Storage Blob Data Reader"` for reading blobs, or `"Storage Blob Data Contributor"` if writing/deleting blobs is required.

Reader permits reading resource configuration, not blob contents through Microsoft Entra authentication. Expect the candidate to distinguish management-plane and data-plane permissions and ask what operations the application needs before selecting a role. Account scope works for account-wide access; a container scope is preferable when access is limited to one container.

The code does not state whether the app reads or writes blobs. This is an interviewer discussion point, not grounds to reject a valid least-privilege answer. If needed, clarify that the intended app reads blobs from this account.

The assignment itself can deploy successfully. The failure appears when application code uses its managed identity to access blobs. The supplied Terraform deploys infrastructure only: it does not deploy application code, create test blobs, or demonstrate a runtime 403. An endpoint environment variable alone does not implement authentication.

Reference: [Assign an Azure role for blob data access](https://learn.microsoft.com/en-us/azure/storage/blobs/assign-azure-role-data-access).

## Expected working approach

- Inspect the resources and explain dependencies.
- Use formatting, initialization, validation and planning appropriately; distinguish their limits.
- Correct the broken resource reference and subnet range.
- Explain the identity permission problem and choose a role based on required operations.
- Explain how they would verify deployment and application access.

Score each deliberate issue from 0–2: 0 = missed, 1 = identified with substantial prompting or incomplete reasoning, 2 = identified and corrected with a clear explanation. Record prompts given. Use the score as evidence alongside the discussion, not as a complete hiring decision.

No deployment or provider validation has been run as part of preparing these notes. Do a rehearsal in the intended interview environment before using the exercise. Azure credentials, permissions, subscription policy, provider registration and regional capacity can introduce incidental failures.

## Proposed one-hour coverage

| Time | Area | Activity | Evidence to look for |
| --- | --- | --- | --- |
| 0–20 min | Terraform | Inspect and repair main.tf | References, dependencies, validation vs deployment, reasoned fixes |
| 20–27 min | Azure products and resources | Walk through what the code creates and what is missing for a working application | Resource purposes, App Service plan vs app, regional resources, infrastructure vs application delivery |
| 27–35 min | Networking and firewalls | Discuss making storage private and investigating failed connectivity | VNet integration, private endpoints, DNS, routing, NSGs and firewall controls |
| 35–42 min | Identity | Discuss app access and deployment access | Managed identity, service connections, RBAC scope, least privilege, data-plane access |
| 42–50 min | DevOps pipelines, potentially Azure DevOps | Outline a safe Terraform delivery pipeline | PR checks, plan review, protected apply, remote state, authentication and environment separation |
| 50–58 min | Observability, Application Insights, Grafana and KQL | Discuss investigation signals and write a short query against a supplied schema | Logs vs metrics vs traces, query reasoning, useful dashboards and actionable alerts |
| 58–60 min | Wrap-up | Candidate questions and interviewer notes | Record evidence and any areas not reached |

The remaining sections are proposed coverage, not finished question sets. Build and review them one at a time. Observability was described as desirable; score it separately from essential requirements unless the client changes that priority.
