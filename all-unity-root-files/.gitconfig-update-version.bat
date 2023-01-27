@echo off


:: This file will update the .gitconfig file to use the same version as the Unity project.


:: remove all existing .gitconfig---{version} files (a fresh one will be created)
del ".gitconfig---*"

:: Detect the Unity version by reading the ProjectSettings\ProjectVersion.txt file
set "UNITY_VERSION="
set "UNITY_VERSION_NUMS="
for /F "usebackq tokens=2-4 delims=. " %%I in ("ProjectSettings\ProjectVersion.txt") do (
    if not "%%~K" == "" (
        for /F "delims=abcdef" %%L in ("%%~K") do (
            set "UNITY_VERSION=%%~I.%%~J.%%~K"
            set "UNITY_VERSION_NUMS=%%~I.%%~J.%%~L"
        )
    )
)

:: Show the detected version
echo   -----------------------&echo\  Detected Unity version: &echo\  %UNITY_VERSION%&echo\

:: Overwrite the .gitconfig file with the new path to the UnityYAMLMerge file
echo - Write: .gitconfig
(
  echo [merge]
  echo tool = unityyamlmerge&echo\
  echo [mergetool "unityyamlmerge"]
  echo trustExitCode = false
  echo cmd = 'C:\\Program Files\\Unity\\Hub\\Editor\\%UNITY_VERSION%\\Editor\\Data\\Tools\\UnityYAMLMerge.exe' merge -p "$BASE" "$REMOTE" "$LOCAL" "$MERGED"
) > .gitconfig

:: create a new .gitconfig=={version} file to indicate which version currently is used
echo - Write: .gitconfig---%UNITY_VERSION%
(
  echo Keep this file as a quick indicator of the used mergetool version/path&echo\
  echo "Update the filename (+ the path in .gitconfig) on every Editor-version upgrade!"
) > .gitconfig---%UNITY_VERSION%

timeout 10
