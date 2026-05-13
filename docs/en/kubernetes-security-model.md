# Kubernetes security model

## Purpose

This document describes the Kubernetes security baseline for the Yandex Cloud Security Remediation Program.

Phase 8 is a static/offline phase. It validates Kubernetes manifests without connecting to a Kubernetes API.

Runtime validation is deferred to Phase 9.

## What Phase 8 proves

Phase 8 proves that:

- the insecure baseline manifest exists;
- the hardened workload manifest exists;
- namespace labels for Pod Security Standards are defined;
- the readonly RBAC model is defined;
- the NetworkPolicy baseline is defined;
- the Kyverno policy-as-code baseline is defined;
- YAML files are syntactically valid;
- the insecure baseline contains expected risks;
- the hardened baseline contains expected security controls;
- secrets and sensitive files are not present in the repository.

## What Phase 8 does not prove

Phase 8 does not prove that:

- the Kubernetes API accepts these manifests;
- Admission Controllers block insecure workloads;
- Kyverno CRDs are installed in a cluster;
- NetworkPolicy is enforced by a concrete CNI;
- Pod Security Admission works at runtime.

These checks belong to Phase 9.

## Insecure baseline

The insecure baseline is a controlled negative example.

It demonstrates:

- privileged container risk;
- root user risk;
- privilege escalation risk;
- NodePort exposure risk;
- missing resource limits;
- weak runtime constraints.

## Hardened baseline

The hardened baseline demonstrates remediation controls:

- non-root execution;
- disabled privilege escalation;
- read-only root filesystem;
- dropped Linux capabilities;
- RuntimeDefault seccomp;
- resource requests and limits;
- ClusterIP service instead of NodePort;
- disabled service account token automount;
- restricted Pod Security namespace labels;
- default deny NetworkPolicy;
- explicit allow rules;
- readonly RBAC;
- Kyverno policy-as-code.

## Phase 9 boundary

Phase 9 must create a temporary local Kubernetes cluster, apply manifests, validate runtime behavior and destroy the cluster after evidence collection.
