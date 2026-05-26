param(
  [string]$ResultDir = "artifacts\local",
  [string]$SettingsPath = "config\ci.example.json"
)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path $ResultDir | Out-Null
New-Item -ItemType Directory -Force -Path "reports" | Out-Null
New-Item -ItemType Directory -Force -Path "logs" | Out-Null
New-Item -ItemType Directory -Force -Path "screenshots" | Out-Null

$summaryPath = Join-Path $ResultDir "summary.md"
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

@"
# Scenario test run summary

- Finished at: $now
- Result directory: $ResultDir
- Settings: $SettingsPath
- GitHub run: $env:GITHUB_RUN_NUMBER
- Branch: $env:GITHUB_REF_NAME
- Commit: $env:GITHUB_SHA

## Expected artifacts

- Vanessa Runner log
- Vanessa Automation report
- Screenshots for failed steps
- Run parameters
- JUnit/XML report, if enabled in the real environment
"@ | Set-Content -Encoding UTF8 -Path $summaryPath

Write-Host "Artifacts summary written to $summaryPath"
