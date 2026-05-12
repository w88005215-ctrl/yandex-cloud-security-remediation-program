#!/usr/bin/env bash

OUT_DIR="${1:-evidence/command-outputs}"
OUT_FILE="${OUT_DIR}/YCSEC_COST_CHECK_$(date -u +%Y%m%dT%H%M%SZ).txt"

mkdir -p "$OUT_DIR"

{
  echo "Yandex Cloud Cost Check Helper"
  echo "Date: $(date -Is)"
  echo "Qube: cloud-dev-workbench"
  echo

  echo "Purpose:"
  echo "This helper records cost-control context. Billing must also be checked manually in Yandex Cloud Console."
  echo

  if command -v yc >/dev/null 2>&1; then
    echo "yc CLI found"
    echo

    echo "yc config profile list:"
    yc config profile list 2>&1 || true
    echo

    echo "yc config list:"
    yc config list 2>&1 || true
    echo

    echo "yc billing account list:"
    yc billing account list 2>&1 || true
    echo
  else
    echo "yc CLI not installed"
    echo
  fi

  echo "Manual checks required:"
  echo "[ ] Yandex Cloud Console -> Billing"
  echo "[ ] Budget status checked"
  echo "[ ] Promo balance checked"
  echo "[ ] Managed Kubernetes cluster list checked"
  echo "[ ] Compute instances checked"
  echo "[ ] LoadBalancers checked"
  echo "[ ] Public IP addresses checked"
  echo "[ ] Resource inventory updated"
} | tee "$OUT_FILE"

echo "[OK] cost check evidence saved: $OUT_FILE"
