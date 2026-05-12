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
