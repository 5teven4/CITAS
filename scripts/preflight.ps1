$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "=== Preflight FCV Citas ===" -ForegroundColor Cyan

$required = @(
  ".env.example",
  "docker-compose.yml",
  "database\reference\db.sql",
  "citas-api\README.md",
  "citas-web\README.md",
  "PRD.md"
)
foreach ($file in $required) {
  if (-not (Test-Path -LiteralPath $file)) { throw "Falta archivo requerido: $file" }
}

if (-not (Test-Path -LiteralPath ".env")) {
  throw "Falta .env. Crea el archivo con: Copy-Item .env.example .env"
}
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "Docker no esta en PATH." }

& docker info *> $null
if ($LASTEXITCODE -ne 0) { throw "Docker Desktop esta instalado pero el engine no responde." }
& docker compose version | Out-Host
if ($LASTEXITCODE -ne 0) { throw "Docker Compose no esta disponible." }

# Valida variables obligatorias y la sintaxis real que Docker Compose usara.
& docker compose config --quiet
if ($LASTEXITCODE -ne 0) { throw "La configuracion de Docker Compose no es valida. Revisa .env y docker-compose.yml." }

$envMap = @{}
Get-Content -LiteralPath ".env" | Where-Object { $_ -match '^[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
  $key, $value = $_.Split('=', 2)
  $envMap[$key] = $value.Trim()
}

$portSettings = @(
  @{ Label = "MySQL"; Key = "MYSQL_PORT"; Default = 3307 },
  @{ Label = "API"; Key = "API_PORT"; Default = 8080 },
  @{ Label = "React"; Key = "REACT_PORT"; Default = 5173 },
  @{ Label = "Angular"; Key = "ANGULAR_PORT"; Default = 4200 }
)

$ports = @()
foreach ($setting in $portSettings) {
  $rawPort = if ($envMap.ContainsKey($setting.Key)) { $envMap[$setting.Key] } else { [string]$setting.Default }
  $port = 0
  if (-not [int]::TryParse($rawPort, [ref]$port) -or $port -lt 1 -or $port -gt 65535) {
    throw "El valor de $($setting.Key) debe ser un puerto entre 1 y 65535. Valor recibido: '$rawPort'."
  }
  $ports += [PSCustomObject]@{ Label = $setting.Label; Port = $port }
}

foreach ($entry in $ports | Sort-Object Port -Unique) {
  $used = Get-NetTCPConnection -LocalPort $entry.Port -ErrorAction SilentlyContinue
  if ($used) { Write-Host "[AVISO] Puerto $($entry.Port) ($($entry.Label)) en uso." -ForegroundColor Yellow }
  else { Write-Host "[OK] Puerto $($entry.Port) ($($entry.Label)) disponible" -ForegroundColor Green }
}

Write-Host "[OK] Estructura, Docker y Compose disponibles." -ForegroundColor Green
