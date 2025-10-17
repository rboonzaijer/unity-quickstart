# Unity Quickstart (with GIT/LFS)

This will help you get a quick setup with a new Unity project and GIT LFS.

## Overview:

- [Setup new Project](#setup-new-project)
  - [Step 1. Create new Unity Project](#step-1-create-new-unity-project)
  - [Step 2. Download files from this repo](#step-2-download-files-from-this-repo)
  - [Step 3. Open project in Unity, Save + Save Project](#step-3-open-project-in-unity-save--save-project)
  - [Step 4. Initial commit](#step-4-initial-commit)
  - [Step 5. Push to remote](#step-5-push-to-remote)
- [Clone Existing Project](#clone-existing-project)
  - [Step 1. Clone](#step-1-clone)
  - [Step 2. Git pre-commit hook](#step-2-git-pre-commit-hook)
- [Move to another repository](#move-to-another-repository)
- [Add a new staged file to LFS](#add-a-new-staged-file-to-lfs)
- [Related info](#related-info)

# Setup new Project

## Step 1. Create new Unity Project

- Edit > Project Settings:
    - [Category: Editor] Asset Serialization / Mode: “Force Text”
    - [Category: Version Control ] Mode: “Visible Meta Files”

- File > Save Project

## Step 2. Download files from this repo

Note, png file requires a [user agent](https://www.whatismybrowser.com/guides/the-latest-user-agent/firefox) to download (used 'Firefox on Linux')

- Open command prompt (Win+R -> 'cmd')
- Copy the following commands and paste/execute them all at once

```bash
git init --initial-branch=main
git lfs install
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/-%20Git%20lfs%20check/pre-commit -o ".git/hooks/pre-commit"

curl -L -A "Mozilla/5.0 (X11; Linux i686; rv:140.0) Gecko/20100101 Firefox/140.0" -O https://media.githubusercontent.com/media/rboonzaijer/unity-quickstart/main/Project/git-lfs-logo.png

curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/{.gitattributes,.gitignore} -O

curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/-%20Git%20lfs%20check/{README.md,pre-commit,pre-commit-install.ps1} -o "- Git lfs check\#1" --create-dirs

curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/Assets/Editor/{UnityEditorMenuSaveAll.cs,UnityPostBuildCallbacks.cs} -o "Assets\Editor\#1" --create-dirs

curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/-%20Build%20Scripts/Build{-WindowsDefault,WindowsLZ4,WindowsLZ4HC,Config,Profile}.ps1 -o "- Build Scripts/Build#1.ps1" --create-dirs

curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/{.gitconfig,.gitconfig-update-version.bat} -O
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/Project/.gitconfig---%5Brun%20update-version.bat%5D -o ".gitconfig---[run update-version.bat]"
.gitconfig-update-version.bat

```

## Step 3. Open project in Unity, Save + Save Project

- Go into Unity again, and press **CTRL+SHIFT+ALT+S** (Or: **File > Save All**)

## Step 4. Initial commit

```bash
git add .
git commit -m "initial"
```

```bash
# Optionally, see which files are tracked with LFS (can be done before the commit)
git lfs ls-files
```

## Step 5. Push to remote

```bash
git remote add origin ssh://git@{host}:{port}/{new-repo}.git
git push -u origin main
```

You can check in your repository if the png is stored with lfs.

- Gitlab:
  ![Example](readme-lfs-gitlab.png)
- Github:
  ![Example](readme-lfs-github.png)

# Clone Existing Project

## Step 1. Clone

```bash
git clone {repo}
```

GIT LFS will already be enabled (if it was enabled in the repository) and it should already download all the LFS-tracked files, but if you need it:

```bash
# Download lfs objects for current branch
git lfs fetch

# Download lfs objects for all branches
git lfs fetch --all
```

## Step 2. Git pre-commit hook

- Navigate to `Project/- Git lfs check/pre-commit-install.ps1` Rightclick > Run with PowerShell

# Move to another repository

Example: from Github to Gitlab, including all LFS objects

```bash
# Clone the repository as a mirror into "repo-mirror"
git clone --mirror git@github.com:rboonzaijer/source-unity-project.git repo-mirror
cd repo-mirror

# Download all LFS objects for all refs (not just current branch)
git lfs fetch --all

# Point the "origin" remote to the new GitLab repo
git remote set-url origin git@gitlab.com:rboonzaijer/target-unity-project.git

# First, push all LFS files (for all branches/tags) to the new remote
git lfs push --all origin

# Now push all refs (branches, tags, etc.) to the new remote
git push --mirror origin
```

# Add a new staged file to LFS

```bash
# Optional (perhaps the file is already added to the staged files)
git add "Assets/My file.large"
# or add all files:   git add .

# Track if with lfs (will be added to .gitattributes)
git lfs track -- "Assets/My file.large"

# Add .gitattributes
git add .gitattributes

# Add the file and renormalize
git add --renormalize -- "Assets/My file.large"

# now commit...
```

# Related info

- https://github.com/git-lfs/git-lfs/tree/main/docs/man
- https://github.com/git-lfs/git-lfs/wiki/Tutorial
- https://github.com/NYUGameCenter/Unity-Git-Config
- https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git
