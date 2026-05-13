# Yandex Cloud readiness gate

## Purpose

This phase verifies that the local workstation is ready for a future Yandex Cloud run.

Only read-only conditions are checked:

- yc CLI availability;
- configured cloud-id;
- configured folder-id;
- cloud lookup;
- folder lookup;
- Terraform example variable files;
- absence of state, kubeconfig and key-like files in the repository.

## Phase boundary

This phase does not create, update or delete cloud resources.

A cloud run is allowed only in a separate later phase after explicit approval.
