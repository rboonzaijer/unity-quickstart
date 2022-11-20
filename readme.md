# HOWTO Setup new Unity project (with GIT/LFS)

## Setup client
- Install git: https://git-scm.com
- Install git-lfs: https://git-lfs.github.com
- Setup SSH keys: https://docs.gitlab.com/ee/user/ssh.html#generate-an-ssh-key-pair

## (optional) Setup private Gitlab server
https://github.com/rboonzaijer/gitlab-docker


## Project setup

- Unity Hub > New project > {type=`3D`, Project Name=`"My New Project"`, Location=`C:\git`} > Create project

- Edit > Project Settings:
    - [Category: Editor] Asset Serialization / Mode: “Force Text”
    - [Category: Version Control ] Mode: “Visible Meta Files”

- File > Save Project

## Git setup
- Copy ***all files*** from the directory `all-unity-root-files` to the **root** of the project

  (TIP: Download this repo as zip: https://github.com/rboonzaijer/unity-quickstart/archive/refs/heads/master.zip)

- Change to your Unity version number:
  - .gitconfig (change path)
  - .gitconfig-2021.3.13f1 (change filename only)

- Start > cmd
- `cd "\git\My New Project"`
- `git init`
- `git lfs install`
- `git add .`
- `git commit -m "initial"`
- Copy `post-merge` and `pre-commit` to the hidden folder `.git/hooks` (replace existing)
- Create new empty project in Gitlab (or other git place...)
- `git remote add origin {repository-url}`
- `git push -u origin main`

  ![Example](screenshot.png)


# HOWTO use existing Unity project (with GIT/LFS)

- `git clone {repository-url}`
- Copy `post-merge` and `pre-commit` to the hidden folder `.git/hooks` (replace existing)


# More info

- https://github.com/NYUGameCenter/Unity-Git-Config
- https://www.gamedeveloper.com/programming/the-complete-guide-to-unity-git
