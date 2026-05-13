# Terraform Architecture

This directory contains the Infrastructure as Code model for the Yandex Cloud Security Remediation Program.

The project uses a modular Terraform/OpenTofu layout:

- modules contain reusable infrastructure building blocks;
- environments contain deployable compositions;
- bootstrap is used for low-cost foundation resources;
- dev is used for local and short cloud validation;
- prod-like is used for production-like control mapping and evidence.

No cloud resources are created by the repository skeleton alone.

Cloud resource creation is only allowed during controlled cloud-runs with:

- cost precheck;
- saved Terraform plan;
- evidence directory prepared;
- explicit approval before apply;
- post-run cost check;
- resource inventory update;
- destroy checklist.

Sensitive files must never be committed:

- Terraform state;
- kubeconfig files;
- service account keys;
- tokens;
- raw audit logs;
- billing data.
