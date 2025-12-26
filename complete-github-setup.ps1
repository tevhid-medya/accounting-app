# Complete GitHub Setup Script
# This script will authenticate with GitHub and set up your repository

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "GitHub Account Setup - Automated" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Authenticate with GitHub
Write-Host "Step 1: Authenticating with GitHub..." -ForegroundColor Yellow
Write-Host "This will open a browser for authentication." -ForegroundColor Yellow
Write-Host ""

$authResult = gh auth login --web --hostname github.com 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Successfully authenticated with GitHub" -ForegroundColor Green
} else {
    Write-Host "Authentication may require manual steps. Continuing..." -ForegroundColor Yellow
}

# Step 2: Get GitHub user info
Write-Host ""
Write-Host "Step 2: Getting GitHub user information..." -ForegroundColor Yellow
$userInfo = gh api user --jq '{login: .login, email: .email}' 2>&1
if ($LASTEXITCODE -eq 0) {
    $userData = $userInfo | ConvertFrom-Json
    $username = $userData.login
    $email = $userData.email
    
    if ([string]::IsNullOrWhiteSpace($email)) {
        # Try to get email from GitHub API
        $emailInfo = gh api user/emails --jq '.[0].email' 2>&1
        if ($LASTEXITCODE -eq 0) {
            $email = $emailInfo.Trim()
        }
    }
    
    Write-Host "✓ Found GitHub account: $username" -ForegroundColor Green
    if ($email) {
        Write-Host "✓ Email: $email" -ForegroundColor Green
    }
} else {
    Write-Host "Could not automatically get user info. Please provide manually:" -ForegroundColor Yellow
    $username = Read-Host "Enter your GitHub username"
    $email = Read-Host "Enter your GitHub email"
}

# Step 3: Configure Git
Write-Host ""
Write-Host "Step 3: Configuring Git..." -ForegroundColor Yellow
if ($username -and $email) {
    git config --global user.name $username
    git config --global user.email $email
    Write-Host "✓ Git configured with: $username <$email>" -ForegroundColor Green
} else {
    Write-Host "⚠ Git configuration skipped (missing info)" -ForegroundColor Yellow
}

# Step 4: Create initial commit if needed
Write-Host ""
Write-Host "Step 4: Creating initial commit..." -ForegroundColor Yellow
$hasCommits = git rev-parse --verify HEAD 2>$null
if ($LASTEXITCODE -ne 0) {
    git add .
    git commit -m "Initial commit"
    Write-Host "✓ Initial commit created" -ForegroundColor Green
} else {
    Write-Host "✓ Repository already has commits" -ForegroundColor Green
}

# Step 5: Create GitHub repository and link
Write-Host ""
Write-Host "Step 5: Creating GitHub repository..." -ForegroundColor Yellow
$repoName = "accounting-app"
$repoExists = gh repo view $username/$repoName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Repository already exists on GitHub" -ForegroundColor Yellow
    $useExisting = Read-Host "Use existing repository? (y/n)"
    if ($useExisting -ne "y" -and $useExisting -ne "Y") {
        $repoName = Read-Host "Enter new repository name"
    }
} else {
    Write-Host "Creating new repository: $repoName" -ForegroundColor Cyan
    $createResult = gh repo create $repoName --public --source=. --remote=origin --push 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Repository created and linked successfully!" -ForegroundColor Green
        Write-Host "✓ Code pushed to GitHub" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Could not create repository automatically. Error:" -ForegroundColor Yellow
        Write-Host $createResult -ForegroundColor Red
    }
}

# Step 6: Link existing repository
Write-Host ""
Write-Host "Step 6: Linking to GitHub repository..." -ForegroundColor Yellow
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote 'origin' already exists" -ForegroundColor Yellow
    git remote set-url origin "https://github.com/$username/$repoName.git"
} else {
    git remote add origin "https://github.com/$username/$repoName.git"
}
Write-Host "✓ Remote configured: https://github.com/$username/$repoName.git" -ForegroundColor Green

# Step 7: Push to GitHub
Write-Host ""
Write-Host "Step 7: Pushing to GitHub..." -ForegroundColor Yellow
$currentBranch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
    git branch -M main
    $currentBranch = "main"
}

$pushResult = git push -u origin $currentBranch 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "Push failed. You may need to:" -ForegroundColor Yellow
    Write-Host "1. Create the repository on GitHub first: https://github.com/new" -ForegroundColor Yellow
    Write-Host "2. Use a Personal Access Token for authentication" -ForegroundColor Yellow
    Write-Host "3. Run: git push -u origin $currentBranch" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host "Repository URL: https://github.com/$username/$repoName" -ForegroundColor Cyan

