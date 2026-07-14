param (
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [string]$OrchestratorUrl = "wss://stratus-p2p-core.onrender.com"
)

# Force the window to stay open if a fatal crash happens
trap {
    Write-Host "`n❌ CRITICAL CRASH: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Script halted. Press Enter to close this window"
    Exit
}

$ErrorActionPreference = "Stop"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "⚡ Starting StratusP2P Automated Hardware Onboarding Engine ⚡" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Verify Docker Dependency Pre-requisites
Write-Host "[1/5] Validating local container environment dependencies..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ERROR: Docker Engine / Docker Desktop was not found on this system." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    Exit
}

try {
    & docker info > $null
    Write-Host "✅ Docker engine is alive and verified responsive." -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: Docker Desktop is installed but not running. Please open Docker Desktop first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
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
    CORE_ORCHESTRATOR_URL = $OrchestrUrl
    ACCESS_TOKEN          = $Token
}
$ConfigPath = Join-Path $InstallDir "config.json"
$ConfigObject | ConvertTo-Json | Out-File -FilePath $ConfigPath -Encoding utf8
Write-Host "✅ Network routing configurations deployed successfully." -ForegroundColor Green

# 4. Fetch the Compiled Client Agent Application Binary
Write-Host "[4/5] Pulling down the latest secure network grid runner daemon..." -ForegroundColor Yellow
$BinaryPath = Join-Path $InstallDir "provider.exe"
$DownloadUrl = "https://github.com/Sujal1123/install/releases/latest/download/provider.exe"

try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $BinaryPath -UseBasicParsing
    Write-Host "✅ Provider agent executable deployed safely onto local disk storage." -ForegroundColor Green
} catch {
    Write-Host "⚠️ WARNING: Fast release mirror download failed. Checking local workspace..." -ForegroundColor Magenta
    if (Test-Path ".\provider.exe") {
        Copy-Item -Path ".\provider.exe" -Destination $BinaryPath
        Write-Host "✅ Recovered using current workspace binary executable profile target asset." -ForegroundColor Green
    } else {
        Write-Host "❌ CRITICAL ERROR: Could not retrieve provider application asset target." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        Exit
    }
}

# 5. Register and Bind Executable as a Native Windows System Service
Write-Host "[5/5] Registering cluster worker background service layer..." -ForegroundColor Yellow
$ServiceName = "StratusHardwareAgent"

# Pure Windows internal service flush overrides
& sc.exe stop $ServiceName > $null 2>&1
& sc.exe delete $ServiceName > $null 2>&1
Start-Sleep -Seconds 2

# Creating service mapping structures
New-Service -Name $ServiceName `
            -BinaryPathName "`"$BinaryPath`"" `
            -DisplayName "StratusP2P Compute Daemon Worker Engine" `
            -Description "Automates cluster sandbox compute isolation leasing structures." `
            -StartupType Automatic | Out-Null
            
Start-Service -Name $ServiceName
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "🎯 SUCCESS: Your machine hardware is officially live on the grid!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Read-Host "Press Enter to finish installation"
