# GitHub Account Setup Guide

## Prerequisites

1. **Install Git** (if not already installed):
   - Download from: https://git-scm.com/download/win
   - Or use: `winget install Git.Git` (if you have Windows Package Manager)

2. **Create a GitHub Account** (if you don't have one):
   - Sign up at: https://github.com

## Steps to Link Your GitHub Account

### 1. Configure Git with Your GitHub Credentials

Open PowerShell or Command Prompt and run:

```bash
git config --global user.name "Your GitHub Username"
git config --global user.email "your-email@example.com"
```

### 2. Initialize Git Repository (if not already done)

```bash
git init
```

### 3. Create a GitHub Repository

1. Go to https://github.com/new
2. Create a new repository (don't initialize with README if the repo already exists locally)
3. Copy the repository URL (e.g., `https://github.com/yourusername/accounting-app.git`)

### 4. Add GitHub Remote

```bash
git remote add origin https://github.com/yourusername/accounting-app.git
```

Or if using SSH:
```bash
git remote add origin git@github.com:yourusername/accounting-app.git
```

### 5. Authenticate with GitHub

**Option A: Personal Access Token (Recommended)**
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with `repo` permissions
3. Use the token as your password when pushing

**Option B: GitHub CLI**
```bash
winget install GitHub.cli
gh auth login
```

**Option C: SSH Keys**
1. Generate SSH key: `ssh-keygen -t ed25519 -C "your-email@example.com"`
2. Add to GitHub: Settings → SSH and GPG keys → New SSH key

### 6. Verify Connection

```bash
git remote -v
```

This should show your GitHub repository URL.

## Quick Setup Script

After installing Git, you can run the `setup-github.ps1` script (see below) to automate some of these steps.

