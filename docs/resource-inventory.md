# Resource Inventory

## Purpose

This document tracks all local, repository and cloud resources created during the project.

Every cloud resource must have:

- purpose;
- owner;
- creation phase;
- expected cost risk;
- destroy condition;
- evidence reference.

## Inventory table

| Date | Phase | Resource | Type | Location | Purpose | Cost Risk | Status | Destroy Condition | Evidence |
|---|---|---|---|---|---|---|---|---|---|
| 2026-05-12 | Phase 1 | Repository skeleton | Local Git repository | cloud-dev-workbench | Project structure | None | Active | N/A | EVID-LOCAL-001 |
| 2026-05-12 | Phase 2 | Root portfolio docs | Documentation | cloud-dev-workbench | Portfolio publication baseline | None | Active | N/A | EVID-DOC-001 |
| 2026-05-12 | Phase 3 | Evidence model | Documentation | cloud-dev-workbench | Audit-ready evidence structure | None | Active | N/A | EVID-COST-001 |

## Cloud resource tracking template

Use this template for future cloud-runs:

| Date | Phase | Resource | Yandex Cloud Type | Folder/Region | Purpose | Cost Risk | Created By | Status | Destroyed At | Evidence |
|---|---|---|---|---|---|---|---|---|---|---|
| TBD | TBD | TBD | TBD | TBD | TBD | Low/Medium/High | Terraform/yc/GitHub Actions | Planned/Active/Destroyed | TBD | TBD |

## Required cloud resource statuses

Allowed statuses:

- Planned
- Active
- Destroyed
- Retained with reason
- Failed cleanup

If a paid resource is marked as Active, it must have a reason and next action.

## Expensive resource rule

The following resources must not stay active without an evidence collection purpose:

- Managed Kubernetes cluster;
- Managed Kubernetes node group;
- Compute Cloud instances;
- public IP addresses;
- Network Load Balancers;
- large disks;
- managed databases;
- heavy logging or monitoring stacks.

## End-of-run resource checklist

After each cloud-run:

- update this inventory;
- confirm expensive resources are destroyed;
- record retained resources and reason;
- save cost check evidence;
- save destroy evidence.

## Phase 4 local resources

| Date | Phase | Resource | Type | Location | Purpose | Cost Risk | Status | Destroy Condition | Evidence |
|---|---|---|---|---|---|---|---|---|---|
| 2026-05-12 | Phase 4 | Toolchain discovery scripts | Local scripts | cloud-dev-workbench | Detect local toolchain gaps | None | Active | N/A | EVID-LOCAL-007 |
| 2026-05-12 | Phase 4 | Toolchain model docs | Documentation | cloud-dev-workbench | Qubes-aware installation model | None | Active | N/A | EVID-LOCAL-006 |

<!-- YCSEC:PHASE-11-SMOKE-RUN:START -->
## Phase 11.2 — Temporary Smoke-Run Inventory

| Resource Type | Planned Count | Created | Destroyed | Final State |
|---|---:|---:|---:|---|
| VPC network | 1 | 1 | 1 | Removed |
| Subnet | 1 | 1 | 1 | Removed |
| Service accounts | 2 | 2 | 2 | Removed |
| IAM role bindings | 3 | 3 | 3 | Removed |
| Managed Kubernetes cluster | 1 | 1 | 1 | Removed |
| Managed Kubernetes node group | 1 | 1 | 1 | Removed |
| Persistent volumes | 0 | 0 | 0 | Not used |
| Network load balancers | 0 | 0 | 0 | Not used |

Final inventory status:

| Check | Result |
|---|---|
| Smoke Managed Kubernetes clusters | 0 remaining |
| Smoke node groups | 0 remaining |
| Smoke compute instances | 0 remaining |
| Smoke network load balancers | 0 remaining |
| Smoke VPC networks | 0 remaining |
| Smoke subnets | 0 remaining |
| Smoke service accounts | 0 remaining |

<!-- YCSEC:PHASE-11-SMOKE-RUN:END -->
