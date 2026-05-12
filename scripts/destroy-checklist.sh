#!/usr/bin/env bash

cat <<'CHECKLIST'
Destroy Checklist

Before destroy:

[ ] Terraform state location confirmed
[ ] Evidence collected
[ ] Screenshots saved
[ ] Terraform outputs saved and redacted
[ ] Audit logs exported or inspected
[ ] Cost checked
[ ] Resource inventory updated
[ ] No required resource will be accidentally removed

Terraform destroy flow:

terraform plan -destroy -out=tfplan.destroy
terraform show tfplan.destroy
terraform apply tfplan.destroy

After destroy:

[ ] yc managed-kubernetes cluster list checked
[ ] yc compute instance list checked
[ ] yc load-balancer network-load-balancer list checked
[ ] yc vpc address list checked
[ ] cost checked in Billing
[ ] docs/resource-inventory.md updated
[ ] destroy evidence saved

Rule:

Managed Kubernetes, compute nodes, public IPs and LoadBalancers must not remain active without evidence collection purpose.
CHECKLIST
