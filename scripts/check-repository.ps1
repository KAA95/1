$ErrorActionPreference = "Stop"

$required = @(
  "README.md",
  ".github/workflows/1c-scenario-tests.yml",
  ".github/workflows/repository-smoke.yml",
  "config/ci.example.json",
  "features/smoke/open_base.feature",
  "features/critical/document_creation_and_posting.feature",
  "features/regression/report_after_posting.feature",
  "features/regression/rights_restriction.feature",
  "steps/README.md",
  "scripts/run-vanessa-tests.ps1",
  "scripts/restore-test-base.ps1",
  "scripts/collect-artifacts.ps1",
  "docs/definition-of-done.md",
  "docs/ci-cd-pipeline.md"
)

$missing = @()
foreach ($path in $required) {
  if (-not (Test-Path $path)) {
    Write-Host "[FAIL] Missing: $path"
    $missing += $path
  } else {
    Write-Host "[OK] $path"
  }
}

if ($missing.Count -gt 0) {
  throw "Repository structure check failed. Missing files: $($missing -join ', ')"
}

$featureCount = (Get-ChildItem -Path features -Filter *.feature -Recurse | Measure-Object).Count
Write-Host "[OK] Feature files found: $featureCount"

if ($featureCount -lt 4) {
  throw "Expected at least 4 feature files."
}

Write-Host "Repository structure check passed."
