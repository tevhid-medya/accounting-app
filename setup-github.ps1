# PowerShell script to set up GitHub connection
# Run this script after installing Git

Write-Host "GitHub Account Setup Script" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
try {
    $gitVersion = git --version
    Write-Host "✓ Git is installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Git is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Please provide the following information:" -ForegroundColor Yellow
Write-Host ""

# Get GitHub username
$username = Read-Host "Enter your GitHub username"
if ([string]::IsNullOrWhiteSpace($username)) {
    Write-Host "Username cannot be empty!" -ForegroundColor Red
    exit 1
}

# Get GitHub email
$email = Read-Host "Enter your GitHub email"
if ([string]::IsNullOrWhiteSpace($email)) {
    Write-Host "Email cannot be empty!" -ForegroundColor Red
    exit 1
}

# Get repository name
$repoName = Read-Host "Enter your GitHub repository name (or press Enter for 'accounting-app')"
if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "accounting-app"
}

# Configure Git
Write-Host ""
Write-Host "Configuring Git..." -ForegroundColor Cyan
git config --global user.name $username
git config --global user.email $email

# Initialize repository if needed
if (-not (Test-Path .git)) {
    Write-Host "Initializing Git repository..." -ForegroundColor Cyan
    git init
} else {
    Write-Host "✓ Git repository already initialized" -ForegroundColor Green
}

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Remote 'origin' already exists: $remoteExists" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to update it? (y/n)"
    if ($overwrite -eq "y" -or $overwrite -eq "Y") {
        git remote set-url origin "https://github.com/$username/$repoName.git"
        Write-Host "✓ Remote updated" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "Adding GitHub remote..." -ForegroundColor Cyan
    git remote add origin "https://github.com/$username/$repoName.git"
    Write-Host "✓ Remote added" -ForegroundColor Green
}

# Verify configuration
Write-Host ""
Write-Host "Configuration Summary:" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host "Username: $username"
Write-Host "Email: $email"
Write-Host "Repository: https://github.com/$username/$repoName.git"
Write-Host ""
git remote -v
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Create the repository on GitHub (if not already created)"
Write-Host "2. Add and commit your files: git add . && git commit -m 'Initial commit'"
Write-Host "3. Push to GitHub: git push -u origin main (or master)"
Write-Host ""
Write-Host "Note: You may need to authenticate with a Personal Access Token" -ForegroundColor Yellow
Write-Host "Get one from: https://github.com/settings/tokens" -ForegroundColor Yellow

