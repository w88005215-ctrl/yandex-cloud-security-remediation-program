# Bootstrap Cloud-Run Checklist

## Before Apply

| Check | Required Result |
|---|---|
| Current milestone verified | HEAD points to the approved planning tag |
| Billing budget verified | Budget exists and alert thresholds are configured |
| Folder/cloud verified | Correct Yandex Cloud folder selected |
| Repository scan passed | gitleaks passes |
| Terraform state absent from repository | No *.tfstate files |
| Kubeconfig absent from repository | No kubeconfig-like files |
| Token/key files absent from repository | No token/key/pem files |
| Terraform plan saved | Plan stored outside sensitive public context or sanitized |
| Expected resources reviewed | Only bootstrap resources are planned |
| Cleanup path known | Destroy or retention decision documented |

---

## During Apply

| Check | Required Result |
|---|---|
| Apply scope controlled | Only expected bootstrap resources are created |
| IAM roles reviewed | No broad unnecessary roles |
| OIDC/WIF validated | Short-lived identity path tested or limitation documented |
| Audit/logging path validated | Events or logging path captured |
| Registry/storage validated | Created and access checked if in scope |
| Evidence captured | Command outputs saved |

---

## After Apply

| Check | Required Result |
|---|---|
| Resource inventory captured | All created resources listed |
| Audit evidence captured | Relevant events exported or limitation documented |
| Sensitive output redacted | Public evidence safe |
| Cost checked | No unexpected cost risk |
| Destroy or retention executed | No undocumented resource remains |
| Post-run scan passed | gitleaks and repository checks pass |
| Evidence committed | Phase evidence committed and tagged |

---

## Retention Rule

A resource may remain after the bootstrap run only if:

1. it is required for the next cloud phase;
2. it is low-cost or no-cost;
3. it is documented in the resource inventory;
4. it has an owner, purpose and cleanup condition.

Otherwise it must be destroyed.
