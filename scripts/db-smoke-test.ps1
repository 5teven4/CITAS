param(
  [ValidateRange(2, 600)]
  [int]$TimeoutSeconds = 60
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Test-Path -LiteralPath ".env")) { throw "Falta .env. Crea el archivo con: Copy-Item .env.example .env" }
$envMap = @{}
Get-Content -LiteralPath ".env" | Where-Object { $_ -match '^[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
  $key, $value = $_.Split('=', 2)
  $envMap[$key] = $value.Trim()
}
$db = $envMap['MYSQL_DATABASE']
$rootPassword = $envMap['MYSQL_ROOT_PASSWORD']
if ([string]::IsNullOrWhiteSpace($db)) { throw "MYSQL_DATABASE no esta definido en .env." }
if ($db -notmatch '^[A-Za-z0-9_]+$') { throw "MYSQL_DATABASE contiene caracteres no permitidos para este script." }
if ([string]::IsNullOrWhiteSpace($rootPassword)) { throw "MYSQL_ROOT_PASSWORD no esta definido en .env." }
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "Docker no esta en PATH." }

& docker compose config --quiet
if ($LASTEXITCODE -ne 0) { throw "La configuracion de Docker Compose no es valida." }

Write-Host "Esperando MySQL..." -ForegroundColor Cyan
$ready = $false
for ($i = 0; $i -lt [Math]::Ceiling($TimeoutSeconds / 2.0); $i++) {
  & docker compose exec -T -e "MYSQL_PWD=$rootPassword" mysql mysqladmin ping -h 127.0.0.1 -uroot --silent *> $null
  if ($LASTEXITCODE -eq 0) { $ready = $true; break }
  Start-Sleep -Seconds 2
}
if (-not $ready) { throw "MySQL no estuvo disponible despues de $TimeoutSeconds segundos." }

$sql = @"
USE $db;
SELECT COUNT(*) AS tables_count FROM information_schema.tables WHERE table_schema='$db';
SELECT COUNT(*) AS locations_count FROM locations;
SELECT COUNT(*) AS specialties_count FROM specialties;
SELECT COUNT(*) AS users_count FROM users;
SELECT COUNT(*) AS professionals_count FROM professionals;
SELECT COUNT(*) AS appointments_count FROM appointments;
"@

$sql | & docker compose exec -T -e "MYSQL_PWD=$rootPassword" mysql mysql -uroot
if ($LASTEXITCODE -ne 0) { throw "El smoke test de la base de datos fallo." }
Write-Host "[OK] MySQL y el esquema base son consultables." -ForegroundColor Green
