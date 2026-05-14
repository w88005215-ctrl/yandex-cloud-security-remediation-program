# GitHub Actions OIDC Validation Trigger

## Purpose

This document records the repository-side trigger used to validate GitHub Actions to Yandex Cloud authentication through Workload Identity Federation.

## Validation scope

- GitHub Actions requests an OIDC ID token.
- The workflow exchanges that token for a Yandex Cloud IAM token.
- The IAM token is used to call the Yandex Cloud Resource Manager API.
- No long-lived cloud key material is used by the workflow.

## Phase

Phase 12.8D — GitHub Actions OIDC validation.
