$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git no esta en PATH." }
& git --version | Out-Host
if ($LASTEXITCODE -ne 0) { throw "No se pudo ejecutar Git." }

$gitName = (& git config --get user.name 2>$null | Select-Object -First 1)
$gitEmail = (& git config --get user.email 2>$null | Select-Object -First 1)
if ([string]::IsNullOrWhiteSpace($gitName) -or [string]::IsNullOrWhiteSpace($gitEmail)) {
  throw "Configura tu identidad de Git antes de inicializar: git config --global user.name 'Tu nombre'; git config --global user.email 'tu@correo.com'"
}

function Invoke-Git {
  param(
    [string]$RepositoryPath,
    [string[]]$Arguments
  )

  & git -C $RepositoryPath @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Fallo el comando git $($Arguments -join ' ') en $RepositoryPath."
  }
}

foreach ($repo in @("citas-api", "citas-web")) {
  $path = Join-Path $Root $repo
  if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw "No existe el directorio esperado: $path" }

  Write-Host "=== $repo ===" -ForegroundColor Cyan
  if (-not (Test-Path -LiteralPath (Join-Path $path ".git"))) {
    Invoke-Git -RepositoryPath $path -Arguments @("init", "-b", "main")
    Invoke-Git -RepositoryPath $path -Arguments @("add", ".")
    Invoke-Git -RepositoryPath $path -Arguments @("commit", "-m", "chore: initialize training template")
    Invoke-Git -RepositoryPath $path -Arguments @("switch", "-c", "develop")
    Write-Host "[OK] Ramas main y develop creadas" -ForegroundColor Green
  } else {
    Write-Host "[SKIP] ya existe .git" -ForegroundColor Yellow
  }
}
