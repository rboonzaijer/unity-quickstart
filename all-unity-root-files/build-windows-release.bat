@echo off

set "PROFILE_NAME=WindowsRelease"
set "PROJECT_NAME=UnityBuildExample"
set "REPOSITORY=git@github.com:mysticeragames/unity-build-example.git"
set "BRANCH=main"

call build-profile.bat "%PROFILE_NAME%" "%PROJECT_NAME%" "%REPOSITORY%" "%BRANCH%"
