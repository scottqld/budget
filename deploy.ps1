# Deploy budget app to NAS
# Run from the budget folder: .\deploy.ps1

$NAS_IP   = "192.168.4.215"
$NAS_PORT = "9222"
$NAS_USER = "sclarke"
$REMOTE   = "/Volume2/appdata/budget/index.html"
$LOCAL    = "$PSScriptRoot\index.html"

if (-not (Test-Path $LOCAL)) {
    Write-Error "index.html not found at $LOCAL"
    exit 1
}

$version = (Select-String -Path $LOCAL -Pattern 'v\d+\.\d+' | Select-Object -First 1).Matches.Value
Write-Host "Deploying budget $version -> ${NAS_USER}@${NAS_IP}:${REMOTE}"

scp -P $NAS_PORT $LOCAL "${NAS_USER}@${NAS_IP}:${REMOTE}"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Done - http://${NAS_IP}:8080"
} else {
    Write-Error "Deploy failed"
}
