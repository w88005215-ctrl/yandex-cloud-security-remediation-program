# Kyverno Admission Policy Enforcement Plan

## Purpose

This plan defines how the project will demonstrate policy-as-code enforcement in Managed Kubernetes.

The goal is to show not only that insecure manifests can be detected, but that the platform can actively reject unsafe deployment patterns.

## Enforcement model

The cloud-run should demonstrate two policy stages:

### Stage 1 — Observe baseline weakness

Apply or validate the insecure baseline workload and collect evidence showing:

- root container execution;
- privilege escalation risk;
- privileged security context or excessive permissions;
- missing read-only root filesystem;
- missing capability drop;
- missing seccomp;
- missing resource governance;
- missing NetworkPolicy or default-deny posture.

### Stage 2 — Enforce admission policy

Install Kyverno policies and show that insecure deployment is denied.

Expected controls:

- require non-root execution;
- deny privilege escalation;
- require read-only root filesystem;
- require capabilities drop;
- require seccomp RuntimeDefault;
- restrict privileged workloads;
- require resource requests and limits;
- restrict mutable or unsafe image patterns where practical;
- require namespace policy labels or equivalent enforcement metadata.

### Stage 3 — Accept hardened deployment

Apply hardened manifests and show that they are accepted.

## Required evidence

Planned public evidence:

- Kyverno policy installation output;
- policy inventory;
- denied insecure deployment output;
- accepted hardened deployment output;
- policy report output;
- kubectl auth can-i evidence;
- NetworkPolicy evidence;
- pod security label evidence;
- before/after comparison.

## Success criteria

The cloud-run succeeds only if evidence proves:

- Kyverno policies were installed;
- insecure workload was denied or flagged according to the documented enforcement mode;
- hardened workload was accepted;
- policy results were captured;
- Managed Kubernetes resources were destroyed after the run;
- bootstrap OIDC/Audit resources remained available until final cleanup.
