param(
  [string]$TagExpression = "@smoke and not @unstable",
  [string]$ResultDir = "artifacts\local",
  [string]$SettingsPath = "config\ci.example.json"
)

$ErrorActionPreference = "Stop"

function Read-Settings {
  param([string]$Path)
  if (-not (Test-Path $Path)) {
    throw "Settings file not found: $Path"
  }
  return Get-Content $Path -Raw | ConvertFrom-Json
}

$settings = Read-Settings -Path $SettingsPath

$vanessaRunner = $env:VANESSA_RUNNER_PATH
if ([string]::IsNullOrWhiteSpace($vanessaRunner)) { $vanessaRunner = $settings.vanessaRunnerPath }

$vanessaAutomation = $env:VANESSA_AUTOMATION_PATH
if ([string]::IsNullOrWhiteSpace($vanessaAutomation)) { $vanessaAutomation = $settings.vanessaAutomationPath }

$connectionString = $env:ONEC_CONNECTION_STRING
if ([string]::IsNullOrWhiteSpace($connectionString)) { $connectionString = $settings.connectionString }

$user = $env:ONEC_USER
if ([string]::IsNullOrWhiteSpace($user)) { $user = $settings.user }

$password = $env:ONEC_PASSWORD
if ($null -eq $password) { $password = $settings.password }

New-Item -ItemType Directory -Force -Path $ResultDir | Out-Null
New-Item -ItemType Directory -Force -Path "logs" | Out-Null
New-Item -ItemType Directory -Force -Path "reports" | Out-Null
New-Item -ItemType Directory -Force -Path "screenshots" | Out-Null

$runInfo = [ordered]@{
  startedAt = (Get-Date).ToString("s")
  tagExpression = $TagExpression
  resultDir = $ResultDir
  featureRoot = $settings.featureRoot
  branch = $env:GITHUB_REF_NAME
  commit = $env:GITHUB_SHA
}
$runInfo | ConvertTo-Json | Set-Content -Encoding UTF8 -Path (Join-Path $ResultDir "run-parameters.json")

if (-not (Test-Path $vanessaRunner)) {
  throw "Vanessa Runner not found: $vanessaRunner. Set VANESSA_RUNNER_PATH or update $SettingsPath."
}

if (-not (Test-Path $vanessaAutomation)) {
  throw "Vanessa Automation processing not found: $vanessaAutomation. Set VANESSA_AUTOMATION_PATH or update $SettingsPath."
}

# Команда ниже является шаблоном. В реальном проекте параметры запуска нужно сверить
# с используемой версией Vanessa Runner и Vanessa Automation.
$arguments = @(
  "vanessa",
  "--settings", $SettingsPath,
  "--ibconnection", $connectionString,
  "--db-user", $user,
  "--db-pwd", $password,
  "--pathvanessa", $vanessaAutomation,
  "--features", $settings.featureRoot,
  "--tags", $TagExpression,
  "--workspace", $ResultDir
)

Write-Host "Starting Vanessa Runner..."
Write-Host "$vanessaRunner $($arguments -join ' ')"

& $vanessaRunner @arguments 2>&1 | Tee-Object -FilePath (Join-Path $ResultDir "vanessa-runner.log")
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
  throw "Vanessa Runner finished with exit code $exitCode"
}

Write-Host "Scenario tests finished successfully."
