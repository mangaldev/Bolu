# Pushing Bolu to GitHub - Step by Step Guide

This guide will help you push your Bolu iOS app to GitHub.

## Prerequisites

- Git installed on your Mac
- GitHub account created
- Terminal access

## Step 1: Check Git Status

First, check if this is already a git repository:

```bash
cd /Users/mangal.dev/Projects/Bolu
git status
```

If you see "not a git repository", proceed to Step 2.
If you see file listings, skip to Step 4.

## Step 2: Initialize Git Repository

If this is not a git repository yet:

```bash
cd /Users/mangal.dev/Projects/Bolu
git init
```

## Step 3: Create GitHub Repository

1. **Go to GitHub**: https://github.com/new
2. **Repository name**: `Bolu` (or your preferred name)
3. **Description**: "Card game iOS app where players predict hand wins"
4. **Visibility**: Choose Public or Private
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **"Create repository"**

## Step 4: Add All Files

```bash
cd /Users/mangal.dev/Projects/Bolu

# Add all files
git add .

# Check what will be committed
git status
```

## Step 5: Make Initial Commit

```bash
git commit -m "Initial commit: Bolu iOS card game app"
```

## Step 6: Add Remote Repository

Replace `YOUR_USERNAME` with your GitHub username:

```bash
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git
```

Or if you prefer SSH:

```bash
git remote add origin git@github.com:YOUR_USERNAME/Bolu.git
```

## Step 7: Push to GitHub

```bash
# Push to main branch
git branch -M main
git push -u origin main
```

If prompted for credentials:
- **Username**: Your GitHub username
- **Password**: Use a Personal Access Token (not your GitHub password)
  - Create one at: https://github.com/settings/tokens
  - Select "repo" scope

## Step 8: Verify

1. Go to your GitHub repository: `https://github.com/YOUR_USERNAME/Bolu`
2. Verify all files are uploaded
3. Check that README.md displays correctly

## Quick Command Summary

```bash
cd /Users/mangal.dev/Projects/Bolu

# If not a git repo
git init

# Add files
git add .

# Commit
git commit -m "Initial commit: Bolu iOS card game app"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git

# Push
git branch -M main
git push -u origin main
```

## Updating README Before Pushing

Before pushing, update the README.md:

1. **Line 217**: Replace `yourusername` with your GitHub username
2. **Line 362**: Replace "Your Name" with your actual name
3. **Line 363**: Replace `@yourusername` with your GitHub username

## What Gets Pushed

The `.gitignore` file ensures these are **NOT** pushed:
- Xcode build artifacts
- DerivedData
- User-specific settings
- Simulator data

These **ARE** pushed:
- ✅ All source code (.swift files)
- ✅ Project files (.xcodeproj)
- ✅ Documentation (.md files)
- ✅ Scripts (.sh files)
- ✅ Assets (images, etc.)

## Troubleshooting

### "Repository not found"
- Check the repository name matches exactly
- Verify you have access to the repository
- Make sure the remote URL is correct

### "Authentication failed"
- Use Personal Access Token instead of password
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### "Files not showing"
- Make sure you ran `git add .`
- Check `.gitignore` isn't excluding important files
- Verify files aren't in `.gitignore`

### "Large file warning"
- Xcode projects can be large
- Consider using Git LFS for large assets if needed

## Future Updates

After initial push, to update:

```bash
git add .
git commit -m "Description of changes"
git push
```

## Optional: Add GitHub Topics

After pushing, add topics to your repository:
- Go to repository → Settings → Topics
- Add: `ios`, `swift`, `swiftui`, `card-game`, `game`, `ios-app`

## Optional: Create Releases

For version releases:

```bash
git tag -a v1.0.0 -m "Version 1.0.0"
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

