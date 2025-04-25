@echo off

set "PROFILE_NAME=%~1"
set "PROJECT_NAME=%~2"
set "REPOSITORY=%~3"
set "BRANCH=%~4"

IF "%PROFILE_NAME%" == "" echo   ERROR: PROFILE_NAME IS EMPTY (exit) & GOTO:invalid_call
IF "%PROJECT_NAME%" == "" echo   ERROR: PROJECT_NAME IS EMPTY (exit) & GOTO:invalid_call
IF "%REPOSITORY%" == ""   echo   ERROR: REPOSITORY IS EMPTY (exit) & GOTO:invalid_call
IF "%BRANCH%" == ""       echo   ERROR: BRANCH IS EMPTY (exit) & GOTO:invalid_call

:: Get date/time for target build directory
:: Note: this will extract data from the LOCALIZED date "vr 25-04-2025" and time "15:55:12,99"
:: And will output: 2025-04-25__15-55
:: If you have another locale, change the numbers
echo   %date% --- %time%
set DAY=%date:~3,2%
set MONTH=%date:~6,2%
set YEAR=%date:~9,4%
set HOUR=%time:~0,2%
set MINUTE=%time:~3,2%
set "NOW=%YEAR%-%MONTH%-%DAY%__%HOUR%-%MINUTE%"

:: Other settings (can probably stay the same for each project)
set "BUILD_PROFILE=Assets/Settings/Build Profiles/%PROFILE_NAME%.asset"
set "ABSOLUTE_UNITY_EDITOR_DIR_ROOT=E:\Unity\Editors"
set "ABSOLUTE_WORKSPACE_ROOTDIR=E:\UnityBuilds\%PROJECT_NAME%\Workspace"
set "ABSOLUTE_WORKSPACE_DIR=%ABSOLUTE_WORKSPACE_ROOTDIR%\Profile-%PROFILE_NAME%"
set "BUILD_TARGET_ABSOLUTE_DIR=E:\UnityBuilds\%PROJECT_NAME%\Builds\%NOW%-%PROFILE_NAME%"

:: Auto-set variables
set "BUILD_PATH=%BUILD_TARGET_ABSOLUTE_DIR%\Build\%PROJECT_NAME%.exe"
set "LOG_PATH=%BUILD_TARGET_ABSOLUTE_DIR%\build-log.txt"

:: Check all variables
IF "%ABSOLUTE_UNITY_EDITOR_DIR_ROOT%" == "" echo "ERROR: ABSOLUTE_UNITY_EDITOR_DIR_ROOT IS EMPTY (exit)" & GOTO:EOF
IF "%REPOSITORY%" == "" echo "ERROR: REPOSITORY IS EMPTY (exit)" & GOTO:EOF
IF "%ABSOLUTE_WORKSPACE_ROOTDIR%" == "" echo "ERROR: ABSOLUTE_WORKSPACE_ROOTDIR IS EMPTY (exit)" & GOTO:EOF
IF "%ABSOLUTE_WORKSPACE_DIR%" == "" echo "ERROR: ABSOLUTE_WORKSPACE_DIR IS EMPTY (exit)" & GOTO:EOF
IF "%BUILD_PROFILE%" == "" echo "ERROR: BUILD_PROFILE IS EMPTY (exit)" & GOTO:EOF
IF "%BUILD_TARGET_ABSOLUTE_DIR%" == "" echo "ERROR: BUILD_TARGET_ABSOLUTE_DIR IS EMPTY (exit)" & GOTO:EOF


:: Show variables
echo   -------------------------------
echo - PROFILE_NAME:                   %PROFILE_NAME%
echo - PROJECT_NAME:                   %PROJECT_NAME%
echo - REPOSITORY:                     %REPOSITORY%
echo - BRANCH:                         %BRANCH%
echo   -------------------------------
echo - NOW:                            %NOW%
echo - ABSOLUTE_UNITY_EDITOR_DIR_ROOT: %ABSOLUTE_UNITY_EDITOR_DIR_ROOT%
echo - ABSOLUTE_WORKSPACE_ROOTDIR:     %ABSOLUTE_WORKSPACE_ROOTDIR%
echo - ABSOLUTE_WORKSPACE_DIR:         %ABSOLUTE_WORKSPACE_DIR%
echo - BUILD_TARGET_ABSOLUTE_DIR:      %BUILD_TARGET_ABSOLUTE_DIR%
echo - BUILD_PATH:                     %BUILD_PATH%
echo - LOG_PATH:                       %LOG_PATH%
echo - BUILD_PROFILE:                  %BUILD_PROFILE%
echo   -------------------------------



:: Uncomment this part if you want to confirm continue building or not
::set choice=
::set /p choice=Do you want to proceed with the build? (y/n)
::if '%choice%'=='y' goto:continue
::if '%choice%'=='Y' goto:continue
::echo Exit
::goto:eof



:continue
set "STARTED_AT=%date% - %time%"

:: Make sure the Build root directory exists
if not exist "%ABSOLUTE_WORKSPACE_ROOTDIR%" mkdir "%ABSOLUTE_WORKSPACE_ROOTDIR%"

:: Make sure the repository is cloned already
if not exist "%ABSOLUTE_WORKSPACE_DIR%" git clone --single-branch --branch=%BRANCH% %REPOSITORY% "%ABSOLUTE_WORKSPACE_DIR%"

:: Reset any changed files
echo - git reset any changed files
git -C "%ABSOLUTE_WORKSPACE_DIR%" reset --hard

:: Remove all untracked files (only enable this when the library/cache is broken, otherwise it will remove the Library on every build)
:: echo -----------------------&echo\- Remove all untracked files
:: git -C "%ABSOLUTE_WORKSPACE_DIR%" clean -d --force -x

:: Pull latest changes (single branch only)
echo - git pull latest changes (%BRANCH% branch only)
git -C "%ABSOLUTE_WORKSPACE_DIR%" pull --ff-only origin %BRANCH%

:: Pull lfs (is this still needed?)
:: echo - git lfs pull (%BRANCH% branch only)
:: git -C "%ABSOLUTE_WORKSPACE_DIR%" lfs pull origin %BRANCH%

:: Detect the Unity version by reading the ProjectSettings\ProjectVersion.txt file
set "UNITY_VERSION="
set "UNITY_VERSION_NUMS="
for /F "usebackq tokens=2-4 delims=. " %%I in ("%ABSOLUTE_WORKSPACE_DIR%\ProjectSettings\ProjectVersion.txt") do (
    if not "%%~K" == "" (
        for /F "delims=abcdef" %%L in ("%%~K") do (
            set "UNITY_VERSION=%%~I.%%~J.%%~K"
            set "UNITY_VERSION_NUMS=%%~I.%%~J.%%~L"
        )
    )
)
set "UNITY_EDITOR=%ABSOLUTE_UNITY_EDITOR_DIR_ROOT%\%UNITY_VERSION%\Editor\Unity.exe"

:: Check if the Unity Editor version is installed
IF NOT EXIST %UNITY_EDITOR% (
    echo ERROR: Unity Editor not found: %UNITY_EDITOR%
    GOTO:EOF
)

:: Show variables
echo   --------------
echo - UNITY_VERSION: %UNITY_VERSION%
echo - UNITY_EDITOR:  %UNITY_EDITOR%
echo   --------------

:: Start Unity Build
echo   Building project...
::start "Unity Build Process" /wait "%UNITY_EDITOR%" -projectPath "%ABSOLUTE_WORKSPACE_DIR%" -quit -batchmode -activeBuildProfile "%BUILD_PROFILE%" -build "%BUILD_PATH%" -logFile "%LOG_PATH%"
call "%UNITY_EDITOR%" -projectPath "%ABSOLUTE_WORKSPACE_DIR%" -quit -batchmode -activeBuildProfile "%BUILD_PROFILE%" -build "%BUILD_PATH%" -logFile "%LOG_PATH%"

echo   Build completed

:: Show result
IF NOT %ERRORLEVEL% EQU 0 (
    echo   Build ERROR (check %LOG_PATH%) & pause & GOTO:finish

    :: When using Jenkins: use 'exit 1' (error):
    :: echo   Build ERROR (check %LOG_PATH%) & exit 1
) else (
    :: Success: Open target build directory
    echo   Build SUCCESS & echo   %BUILD_TARGET_ABSOLUTE_DIR% & explorer "%BUILD_TARGET_ABSOLUTE_DIR%" & GOTO:finish
)


:finish
echo   Started:  %STARTED_AT%
echo   Finished: %date% - %time%
:: When using Jenkins: use 'exit 0' (success):
:: exit 0
GOTO:EOF

:invalid_call
echo.
echo - Usage:
echo   build-profile.bat "profileName" "projectName" "repositoryUrl" "branch"
echo.
echo - Example:
echo   build-profile.bat "WindowsRelease" "UnityBuildExample" "git@github.com:mysticeragames/unity-build-example.git" "main"
