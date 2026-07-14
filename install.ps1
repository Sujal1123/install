# install.ps1
param (
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [string]$OrchestratorUrl = "wss://your-render-app-name.onrender.com" # Replace with your live Render WSS URL
)

$ErrorActionPreference = "Stop"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "⚡ Starting StratusP2P Automated Hardware Onboarding Engine ⚡" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Verify Docker Dependency Pre-requisites
Write-Host "[1/5] Validating local container environment dependencies..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ERROR: Docker Engine / Docker Desktop was not found on this system." -ForegroundColor Red
    Write-Host "Please download and install Docker Desktop from https://www.docker.com/products/docker-desktop/ before continuing." -ForegroundColor White
    Exit
}

# Ensure Docker daemon is actually up and running
try {
    & docker info > $null
    Write-Host "✅ Docker engine is alive and verified responsive." -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: Docker Desktop is installed but not running. Please open Docker Desktop first." -ForegroundColor Red
    Exit
}

# 2. Establish Hidden Sandboxed System Directory
Write-Host "[2/5] Allocating system application sandboxes..." -ForegroundColor Yellow
$InstallDir = "C:\ProgramData\StratusP2P"
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
}

# 3. Dynamically Generate config.json Layout Environment
Write-Host "[3/5] Injecting cryptographic grid access tokens..." -ForegroundColor Yellow
$ConfigObject = @{
    CORE_ORCHESTRATOR_URL = $OrchestratorUrl
    ACCESS_TOKEN          = $Token
}
$ConfigPath = Join-Path $InstallDir "config.json"
$ConfigObject | ConvertTo-Json | Out-File -FilePath $ConfigPath -Encoding utf8
Write-Host "✅ Network routing configurations deployed successfully." -ForegroundColor Green

# 4. Fetch the Compiled Client Agent Application Binary
Write-Host "[4/5] Pulling down the latest secure network grid runner daemon..." -ForegroundColor Yellow
$BinaryPath = Join-Path $InstallDir "provider.exe"

# NOTE: Replace this mock URL string layout path with your actual public GitHub releases binary build payload download path!
$DownloadUrl = "https://github.com/your-username/your-repo/releases/latest/download/provider.exe"

try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $BinaryPath -UseBasicParsing
    Write-Host "✅ Provider agent executable deployed safely onto local disk storage." -ForegroundColor Green
} catch {
    Write-Host "⚠️ WARNING: Fast release mirror download failed. Defaulting to local workspace compilation tracking backup." -ForegroundColor Magenta
    # Local fallback for your specific testing profile machine setup
    if (Test-Path ".\provider.exe") {
        Copy-Item -Path ".\provider.exe" -Destination $BinaryPath
        Write-Host "✅ Recovered using current workspace binary executable profile target asset." -ForegroundColor Green
    } else {
        Write-Host "❌ CRITICAL ERROR: Could not retrieve provider application asset target." -ForegroundColor Red
        Exit
    }
}

# 5. Register and Bind Executable as a Native Windows System Service
Write-Host "[5/5] Registering cluster worker background service layer..." -ForegroundColor Yellow
$ServiceName = "StratusHardwareAgent"

# Check if an older running instance service configuration exists to tear it down cleanly first
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Stopping existing agent infrastructure blocks..." -ForegroundColor Gray
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    Remove-Service -Name $ServiceName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

try {
    # Registers the binary to automatically execute silently hidden inside the background framework
    New-Service -Name $ServiceName `
                -BinaryPathName "`"$BinaryPath`"" `
                -DisplayName "StratusP2P Compute Daemon Worker Engine" `
                -Description "Automates cluster sandbox compute isolation leasing structures over the distributed grid network framework." `
                -StartupType Automatic | Out-Null
                
    # Fires up the system process service engine engine immediately
    Start-Service -Name $ServiceName
    Write-Host "=================================================================" -ForegroundColor Green
    Write-Host "🎯 SUCCESS: Your machine hardware is officially live on the grid!" -ForegroundColor Green
    Write-Host "System tray console terminals can be safely closed. Earning active." -ForegroundColor Green
    Write-Host "=================================================================" -ForegroundColor Green
} catch {
    Write-Host "❌ CRITICAL ERROR: Background service creation failed. Ensure you are running terminal as Admin." -ForegroundColor Red
}