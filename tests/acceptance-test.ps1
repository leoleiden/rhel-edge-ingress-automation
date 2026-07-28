# ==============================================================================
# UKR.PAY Enterprise Zero-Trust Edge Gateway
# Component: Automated Acceptance & Security Test Suite
# ==============================================================================

Write-Host "
==========================================================================" -ForegroundColor Cyan
Write-Host " 🛡️ UKR.PAY ZERO-TRUST EDGE GATEWAY - ACCEPTANCE TESTING" -ForegroundColor Cyan
Write-Host "==========================================================================
" -ForegroundColor Cyan

# 1. Перевірка Health Check
Write-Host "[TEST 1] Checking Nginx /healthz endpoint..." -ForegroundColor Yellow
$health = curl.exe -s http://192.168.8.2/healthz
Write-Host "Result: $health
" -ForegroundColor Green

# 2. Перевірка OWASP Headers & PCI DSS
Write-Host "[TEST 2] Verifying OWASP Security Headers & Server Tokens..." -ForegroundColor Yellow
$headers = curl.exe -I -s http://192.168.8.2/ | Select-String "Server:|X-Frame-Options:|X-Content-Type-Options:|Content-Security-Policy:"
$headers | ForEach-Object { Write-Host "  $_" -ForegroundColor Green }
Write-Host ""

# 3. Перевірка прокидання Real IP та Non-Root бекенду
Write-Host "[TEST 3] Auditing Core Banking API Payload (Real-IP & Non-Root user)..." -ForegroundColor Yellow
$apiResponse = curl.exe -s http://192.168.8.2/
Write-Host $apiResponse -ForegroundColor Green
Write-Host ""

# 4. Перевірка Zero-Trust (Спроба прямого доступу до бекенду)
Write-Host "[TEST 4] Testing Zero-Trust Isolation (Direct access to port 8080 must FAIL)..." -ForegroundColor Yellow
$null = curl.exe --connect-timeout 2 http://192.168.8.2:8080/ 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host " [V] SUCCESS: Direct access to 8080 blocked by Firewalld/127.0.0.1 binding! (curl exit code: $LASTEXITCODE)" -ForegroundColor Green
} else {
    Write-Host " [X] VULNERABILITY: Port 8080 is accessible from outside!" -ForegroundColor Red
}
Write-Host "
==========================================================================" -ForegroundColor Cyan
