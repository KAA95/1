#!/usr/bin/env bash
set -euo pipefail

required=(
  "README.md"
  ".github/workflows/1c-scenario-tests.yml"
  ".github/workflows/repository-smoke.yml"
  "config/ci.example.json"
  "features/smoke/open_base.feature"
  "features/critical/document_creation_and_posting.feature"
  "features/regression/report_after_posting.feature"
  "features/regression/rights_restriction.feature"
  "steps/README.md"
  "scripts/run-vanessa-tests.ps1"
  "scripts/restore-test-base.ps1"
  "scripts/collect-artifacts.ps1"
  "docs/definition-of-done.md"
  "docs/ci-cd-pipeline.md"
)

missing=0
for path in "${required[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "[FAIL] Missing: $path"
    missing=1
  else
    echo "[OK] $path"
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "Repository structure check failed."
  exit 1
fi

feature_count=$(find features -name '*.feature' | wc -l | tr -d ' ')
echo "[OK] Feature files found: $feature_count"

if [[ "$feature_count" -lt 4 ]]; then
  echo "[FAIL] Expected at least 4 feature files."
  exit 1
fi

echo "Repository structure check passed."
