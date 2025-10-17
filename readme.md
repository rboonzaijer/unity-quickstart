# Unity Quickstart (with GIT/LFS)

## New Unity Project

- Edit > Project Settings:
    - [Category: Editor] Asset Serialization / Mode: “Force Text”
    - [Category: Version Control ] Mode: “Visible Meta Files”

- File > Save Project

## Download files

- Open command prompt (Win+R -> 'cmd')

```bash
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitattributes
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitconfig
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitconfig---[run update-version.bat]
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitconfig-update-version.bat
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/.gitignore
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:137.0) Gecko/20100101 Firefox/137.0" -O https://media.githubusercontent.com/media/rboonzaijer/unity-quickstart/refs/heads/main/all-unity-root-files/git-lfs-logo.png

curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Build Scripts/BuildProfile - WindowsDefault.ps1
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Build Scripts/BuildProfile - WindowsLZ4.ps1
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Build Scripts/BuildProfile - WindowsLZ4HC.ps1
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Build Scripts/BuildProfile Config.ps1
curl -O https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Build Scripts/BuildProfile.ps1

mkdir Assets\Editor

curl -o Assets\Editor\UnityPostBuildCallbacks.cs https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/UnityPostBuildCallbacks.cs
curl -o Assets\Editor\UnityEditorMenuSaveAll.cs https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/UnityEditorMenuSaveAll.cs

curl -o .git/hooks/pre-commit https://raw.githubusercontent.com/rboonzaijer/unity-quickstart/main/all-unity-root-files/- Git lfs check/pre-commit
```

- Open current folder in Explorer:

```bash
explorer .
```

- Doubleclick on '<ins>**.gitconfig-update-version.bat**</ins>'

- Now go into Unity again, and press **CTRL+SHIFT+ALT+S** (Or: **File > Save All**)

```bash
git init
git lfs install
git add .
git commit -m "initial"
```

```bash
git remote add origin ssh://git@{host}:{port}/{new-repo}.git
git push -u origin main
```

![Example](screenshot.png)

# HOWTO use existing Unity project (with GIT/LFS)

- `git clone {repository-url}`

( lfs will already be enabled if it's enabled in the repository )




# More info

- https://github.com/NYUGameCenter/Unity-Git-Config
- https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git
