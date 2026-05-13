# Yandex Cloud smoke-run

## Purpose

Phase 11 performs a short real Yandex Cloud validation.

The check confirms that:

- Terraform can create minimal infrastructure;
- Managed Kubernetes API is reachable;
- kubeconfig stays outside the repository;
- project Kubernetes manifests can be applied to a real cluster;
- Pod Security Admission works on a real API server;
- resources are deleted with Terraform destroy after validation.

## Phase boundary

Only temporary smoke-run resources are allowed:

- VPC network;
- subnet;
- service accounts;
- Managed Kubernetes zonal cluster;
- one small preemptible node group.

PersistentVolume, LoadBalancer, public node IPs and production workloads are not created.

## Budget

Target short-run budget: up to 100 RUB.

Main cost drivers:

- Managed Kubernetes zonal master: about 9.6624 RUB per hour;
- node group: billed as Compute Cloud;
- node boot disk: billed as Compute Cloud disk until deletion.

Terraform destroy is executed after validation.

## Stop rule

If apply succeeds but validation fails, evidence is collected first, then destroy is executed.

If destroy fails, Phase 11 is considered an incident and requires manual verification in Yandex Cloud Console.
