# 🚀 Push Bolu to GitHub - Quick Guide

Your repository is already initialized! Follow these steps to push to GitHub.

## Current Status

Your repository has:
- ✅ Git initialized
- ✅ Some changes ready to commit
- ✅ New files to add

## Step-by-Step Instructions

### Step 1: Stage All Changes

```bash
cd /Users/mangal.dev/Projects/Bolu

# Add all new and modified files
git add .

# Verify what will be committed
git status
```

### Step 2: Commit Changes

```bash
git commit -m "Complete Bolu iOS app with all features

- Player setup and management
- Round-based gameplay with Boli declarations
- Hand tracking and scoring system
- Edit rounds functionality
- Game history storage
- Winner announcement with animations
- Hamburger menu for game options
- Full documentation and build scripts"
```

### Step 3: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `Bolu`
3. Description: `Card game iOS app where players predict hand wins`
4. Choose **Public** or **Private**
5. **DO NOT** check "Add a README file" (we already have one)
6. **DO NOT** check "Add .gitignore" (we already have one)
7. Click **"Create repository"**

### Step 4: Add Remote and Push

Replace `YOUR_USERNAME` with your actual GitHub username:

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git

# Or if you prefer SSH:
# git remote add origin git@github.com:YOUR_USERNAME/Bolu.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

### Step 5: Authentication

If prompted for credentials:

**Option A: Personal Access Token (Recommended)**
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Name: "Bolu App"
4. Select scope: **repo** (check the box)
5. Click "Generate token"
6. Copy the token
7. When prompted:
   - Username: Your GitHub username
   - Password: Paste the token (not your GitHub password)

**Option B: SSH Key**
1. Generate SSH key: `ssh-keygen -t ed25519 -C "your_email@example.com"`
2. Add to GitHub: https://github.com/settings/keys
3. Use SSH URL: `git@github.com:YOUR_USERNAME/Bolu.git`

### Step 6: Verify Upload

1. Visit: `https://github.com/YOUR_USERNAME/Bolu`
2. Check that all files are present
3. Verify README.md displays correctly

## Update README Before Pushing

Before pushing, update these lines in `README.md`:

**Line 217**: Change the clone URL
```markdown
git clone https://github.com/YOUR_USERNAME/Bolu.git
```

**Line 362-363**: Update author info
```markdown
**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
```

## Complete Command Sequence

```bash
cd /Users/mangal.dev/Projects/Bolu

# 1. Add all files
git add .

# 2. Commit
git commit -m "Complete Bolu iOS app with all features"

# 3. Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git

# 4. Push
git branch -M main
git push -u origin main
```

## If Remote Already Exists

If you get "remote origin already exists":

```bash
# Check current remote
git remote -v

# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git

# Push
git push -u origin main
```

## What Gets Pushed

✅ **Will be pushed:**
- All Swift source files
- Xcode project files
- Documentation (README.md, etc.)
- Scripts (run.sh, etc.)
- Assets
- .gitignore

❌ **Will NOT be pushed** (thanks to .gitignore):
- Build artifacts
- DerivedData
- User-specific Xcode settings
- Simulator data
- .DS_Store files

## After Pushing

### Add Repository Topics

1. Go to your repository on GitHub
2. Click the gear icon ⚙️ next to "About"
3. Add topics: `ios`, `swift`, `swiftui`, `card-game`, `game`, `ios-app`

### Add Screenshots

1. Take screenshots of your app
2. Create a `screenshots/` folder
3. Add images
4. Update README.md to reference them

### Create First Release

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

Then create a release on GitHub with release notes.

## Future Updates

To push future changes:

```bash
git add .
git commit -m "Description of your changes"
git push
```

## Troubleshooting

### "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/Bolu.git
```

### "Authentication failed"
- Use Personal Access Token (not password)
- Or set up SSH keys

### "Permission denied"
- Check repository name matches exactly
- Verify you have write access
- Check remote URL is correct

### Large files warning
- Xcode projects can be large but should be fine
- If issues, check `.gitignore` is working

## Quick Reference

```bash
# Check status
git status

# See what will be committed
git status --short

# Add all changes
git add .

# Commit
git commit -m "Your commit message"

# Push
git push

# View remotes
git remote -v
```

---

**Ready to push? Run the commands above and your Bolu app will be on GitHub! 🎉**

