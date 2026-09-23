param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not $Force) {
  throw "Esta operacion elimina permanentemente los datos de MySQL. Para confirmarla ejecuta: .\scripts\reset-db.ps1 -Force"
}
if (-not (Test-Path -LiteralPath ".env")) { throw "Falta .env. Crea el archivo con: Copy-Item .env.example .env" }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "Docker no esta en PATH." }

$composeJson = & docker compose config --format json
if ($LASTEXITCODE -ne 0) { throw "La configuracion de Docker Compose no es valida." }
$compose = $composeJson | ConvertFrom-Json
$mysqlMount = @($compose.services.mysql.volumes | Where-Object { $_.target -eq "/var/lib/mysql" } | Select-Object -First 1)
if ($mysqlMount.Count -ne 1 -or [string]::IsNullOrWhiteSpace($mysqlMount[0].source)) {
  throw "No se pudo identificar el volumen de datos del servicio mysql."
}
$volumeKey = $mysqlMount[0].source
$volumeProperty = $compose.volumes.PSObject.Properties[$volumeKey]
if ($null -eq $volumeProperty -or [string]::IsNullOrWhiteSpace($volumeProperty.Value.name)) {
  throw "No se pudo resolver el volumen Compose '$volumeKey'."
}
$mysqlVolume = $volumeProperty.Value.name

Write-Host "ATENCION: se eliminara solo el volumen MySQL '$mysqlVolume'." -ForegroundColor Yellow
& docker compose rm -s -f mysql
if ($LASTEXITCODE -ne 0) { throw "No se pudo detener y eliminar el contenedor MySQL." }

& docker volume inspect $mysqlVolume *> $null
if ($LASTEXITCODE -eq 0) {
  & docker volume rm $mysqlVolume | Out-Host
  if ($LASTEXITCODE -ne 0) { throw "No se pudo eliminar el volumen MySQL '$mysqlVolume'." }
}

& docker compose up -d mysql
if ($LASTEXITCODE -ne 0) { throw "No se pudo iniciar MySQL despues del reinicio." }
& "${PSScriptRoot}\db-smoke-test.ps1"
