# Unity Quickstart (with GIT/LFS)

## Step 1. Create new Unity Project

- Edit > Project Settings:
    - [Category: Editor] Asset Serialization / Mode: “Force Text”
    - [Category: Version Control ] Mode: “Visible Meta Files”

- File > Save Project

## Step 2. Download files

Note, png file requires a [user agent](https://www.whatismybrowser.com/guides/the-latest-user-agent/firefox) to download (used 'Firefox on Linux')

- Open command prompt (Win+R -> 'cmd')

```bash
# Example png (quick check if LFS is working)
curl -L -A "Mozilla/5.0 (X11; Linux i686; rv:140.0) Gecko/20100101 Firefox/140.0" -O https://media.githubusercontent.com/media/rboonzaijer/unity-quickstart/refs/heads/main/all-unity-root-files/git-lfs-logo.png

# Gitignore/gitattributes for LFS
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/{.gitattributes,.gitignore} -O

# Gitconfig (for merge tool)
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/{.gitconfig,.gitconfig-update-version.bat} -O
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitconfig---%5Brun%20update-version.bat%5D -o ".gitconfig---[run update-version.bat]"

# Editor scripts
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/Assets/Editor/{UnityEditorMenuSaveAll.cs,UnityPostBuildCallbacks.cs} -o Assets\Editor\#1 --create-dirs

# Build scripts
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/refs/heads/main/all-unity-root-files/-%20Build%20Scripts/Build{-WindowsDefault,WindowsLZ4,WindowsLZ4HC,Config,Profile}.ps1 -o "- Build Scripts/Build#1.ps1" --create-dirs

# pre-commit (git lfs - avoid committing large files without lfs)
curl https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/refs/heads/main/all-unity-root-files/-%20Git%20lfs%20check/pre-commit -o .git/hooks/pre-commit

# detect unity version and update '.gitconfig' accordingly
.gitconfig-update-version.bat
```

## Step 3. Update Unity path/version in .gitconfig

- Open current folder in Explorer:

```bash
explorer .
```

- Doubleclick on '<ins>**.gitconfig-update-version.bat**</ins>'

## Step 4. Open project in Unity, Save + Save Project

- Go into Unity again, and press **CTRL+SHIFT+ALT+S** (Or: **File > Save All**)

## Step 5. Setup GIT lfs

```bash
git init
git lfs install
git add .
git commit -m "initial"
```

## Step 6. Push to remote

```bash
git remote add origin ssh://git@{host}:{port}/{new-repo}.git
git push -u origin main
```

Now check if the png is stored with lfs:

![Example](screenshot.png)

# HOWTO use existing Unity project (with GIT/LFS)

- `git clone {repository-url}`

( lfs will already be enabled if it's enabled in the repository )




# More info

- https://github.com/NYUGameCenter/Unity-Git-Config
- https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git
