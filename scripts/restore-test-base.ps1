param(
  [string]$SettingsPath = "config\ci.example.json"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SettingsPath)) {
  throw "Settings file not found: $SettingsPath"
}

$settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json
$backupPath = $env:TEST_BASE_BACKUP
if ([string]::IsNullOrWhiteSpace($backupPath)) { $backupPath = $settings.testBaseBackup }

$platformPath = $env:ONEC_PLATFORM_PATH
$connectionString = $env:ONEC_CONNECTION_STRING
if ([string]::IsNullOrWhiteSpace($connectionString)) { $connectionString = $settings.connectionString }

Write-Host "Preparing test base..."
Write-Host "Backup path: $backupPath"
Write-Host "Connection string: $connectionString"

if ([string]::IsNullOrWhiteSpace($platformPath)) {
  Write-Warning "ONEC_PLATFORM_PATH is not set. Add real restore command for your infrastructure."
  Write-Warning "This script currently acts as a documented placeholder."
  exit 0
}

if (-not (Test-Path $platformPath)) {
  throw "1C platform executable not found: $platformPath"
}

if (-not (Test-Path $backupPath)) {
  throw "Test base backup not found: $backupPath"
}

# Пример для файловой базы. В реальном проекте команда может отличаться.
# Перед применением проверьте путь, права доступа и необходимость завершения сеансов.
# & $platformPath DESIGNER $connectionString /RestoreIB $backupPath /DisableStartupMessages

Write-Host "Restore command is intentionally commented out. Adapt it to the real 1C environment."
