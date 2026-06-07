# Deploy budget app to NAS
# Usage:
#   .\deploy.ps1          — SCP index.html from this machine
#   .\deploy.ps1 --pull   — SSH into NAS and pull from GitHub

$NAS_IP   = "192.168.4.215"
$NAS_PORT = "9222"
$NAS_USER = "sclarke"
$REMOTE   = "/Volume2/appdata/budget/index.html"
$GITHUB_URL = "https://raw.githubusercontent.com/scottqld/budget/main/index.html"

if ($args[0] -eq "--pull") {
    Write-Host "Pulling latest from GitHub onto NAS..."
    $cmd = "curl -L -H 'Cache-Control: no-cache' -H 'Pragma: no-cache' `"${GITHUB_URL}?`$(date +%s)`" -o ${REMOTE} && grep -o 'v1\.[0-9]*' ${REMOTE} | head -1"
    ssh -p $NAS_PORT "${NAS_USER}@${NAS_IP}" $cmd
    Write-Host "Done - http://${NAS_IP}:8080"
} else {
    $LOCAL = "$PSScriptRoot\index.html"
    if (-not (Test-Path $LOCAL)) { Write-Error "index.html not found at $LOCAL"; exit 1 }
    $version = (Select-String -Path $LOCAL -Pattern 'v\d+\.\d+' | Select-Object -First 1).Matches.Value
    Write-Host "Deploying budget $version -> ${NAS_USER}@${NAS_IP}:${REMOTE}"
    scp -P $NAS_PORT $LOCAL "${NAS_USER}@${NAS_IP}:${REMOTE}"
    if ($LASTEXITCODE -eq 0) { Write-Host "Done - http://${NAS_IP}:8080" } else { Write-Error "Deploy failed" }
}
