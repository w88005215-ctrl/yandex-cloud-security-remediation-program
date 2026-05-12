#!/usr/bin/env bash

OUT_DIR="${1:-evidence/command-outputs}"
OUT_FILE="${OUT_DIR}/YCSEC_04_OUTPUT_qubes_toolchain_discovery.txt"

mkdir -p "$OUT_DIR"

{
  echo "Phase 4 — Qubes Toolchain Discovery"
  echo "Date: $(date -Is)"
  echo "Qube: cloud-dev-workbench"
  echo

  echo "Current user:"
  id
  echo

  echo "Hostname:"
  hostname
  echo

  echo "OS release:"
  if [ -f /etc/os-release ]; then
    cat /etc/os-release
  else
    echo "[WARN] /etc/os-release not found"
  fi
  echo

  echo "Kernel:"
  uname -a
  echo

  echo "Shell:"
  echo "SHELL=${SHELL:-unknown}"
  echo

  echo "PATH:"
  echo "$PATH" | tr ':' '\n'
  echo

  echo "Persistent user paths:"
  test -d "$HOME" && echo "[OK] HOME exists: $HOME" || echo "[FAIL] HOME missing"
  test -d "$HOME/.local" && echo "[OK] ~/.local exists" || echo "[WARN] ~/.local missing"
  test -d "$HOME/.local/bin" && echo "[OK] ~/.local/bin exists" || echo "[WARN] ~/.local/bin missing"
  test -d /usr/local/bin && echo "[INFO] /usr/local/bin exists" || echo "[WARN] /usr/local/bin missing"
  echo

  echo "Package manager detection:"
  command -v apt >/dev/null 2>&1 && echo "[OK] apt found" || echo "[INFO] apt not found"
  command -v dnf >/dev/null 2>&1 && echo "[OK] dnf found" || echo "[INFO] dnf not found"
  command -v rpm >/dev/null 2>&1 && echo "[OK] rpm found" || echo "[INFO] rpm not found"
  command -v dpkg >/dev/null 2>&1 && echo "[OK] dpkg found" || echo "[INFO] dpkg not found"
  echo

  echo "Qubes indicators:"
  command -v qubesdb-read >/dev/null 2>&1 && echo "[OK] qubesdb-read found" || echo "[WARN] qubesdb-read not found"
  if command -v qubesdb-read >/dev/null 2>&1; then
    echo "Qubes VM name:"
    qubesdb-read /name 2>/dev/null || echo "[WARN] cannot read /name"
    echo "Qubes VM type:"
    qubesdb-read /qubes-vm-type 2>/dev/null || echo "[WARN] cannot read /qubes-vm-type"
  fi
  echo

  echo "Git repository:"
  git rev-parse --show-toplevel 2>/dev/null || echo "[WARN] not inside git repository"
  echo

  echo "Git status:"
  git status --short 2>/dev/null || true
} | tee "$OUT_FILE"

echo "[OK] discovery evidence saved: $OUT_FILE"
