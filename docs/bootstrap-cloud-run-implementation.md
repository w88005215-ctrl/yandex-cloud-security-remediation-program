# Bootstrap/OIDC/Audit Cloud-Run Implementation

## Purpose

This implementation package prepares the controlled bootstrap cloud-run for the Yandex Cloud Security Remediation Program.

The phase covers the foundational cloud security controls required before the Managed Kubernetes baseline/remediation cloud-runs:

- IAM service accounts for CI/CD and audit collection;
- GitHub Actions Workload Identity Federation through OIDC;
- federated credential bound to a specific GitHub repository and branch;
- Container Registry foundation for later image security evidence;
- Object Storage bucket for audit evidence delivery;
- Audit Trails trail scoped to folder-level management events;
- temporary Terraform runtime outside the repository;
- explicit approval gate before paid cloud actions;
- post-run sensitive artifact checks.

## Scope

This package does not create cloud resources by itself.

Cloud resources are created only when the operator runs:

`YCSEC_CONFIRM_BOOTSTRAP_CLOUD_RUN=YES ./scripts/run-bootstrap-oidc-audit-cloud-run.sh`

The script requires:

- `YCSEC_GITHUB_OWNER`;
- `YCSEC_GITHUB_REPO`;
- optional `YCSEC_GITHUB_BRANCH`, default: `main`;
- optional `YCSEC_BOOTSTRAP_BUCKET_NAME`;
- optional `YCSEC_BOOTSTRAP_DESTROY_AFTER_RUN`, default: `YES`.

## Expected temporary resources

- `ycsec-bootstrap-gha-sa`;
- `ycsec-bootstrap-audit-sa`;
- `ycsec-bootstrap-github-oidc`;
- federated credential for `repo:<owner>/<repo>:ref:refs/heads/<branch>`;
- `ycsec-bootstrap-registry`;
- one Object Storage bucket;
- `ycsec-bootstrap-audit-trail`.

## Evidence to collect during the real run

- Terraform plan;
- Terraform apply output;
- Terraform outputs;
- service account inventory;
- Workload Identity Federation inventory;
- Container Registry inventory;
- Object Storage bucket inventory;
- Audit Trails inventory;
- GitHub Actions OIDC token smoke result;
- post-run secret scan;
- post-run resource cleanup or retention decision.

## Security constraints

- no authorized service account keys;
- no static cloud keys in GitHub;
- no Terraform state in the repository;
- no kubeconfig in the repository;
- no token/key-like artifacts in the repository;
- no Kubernetes cluster in this phase;
- no Compute instance in this phase;
- no Network Load Balancer in this phase.

## Portfolio claim allowed after successful cloud-run

After Phase 12.8B succeeds, the project may claim that the bootstrap IAM/OIDC/Audit foundation was validated through a controlled Yandex Cloud run.

Before Phase 12.8B succeeds, the repository may only claim that the bootstrap implementation package and execution plan are prepared.
