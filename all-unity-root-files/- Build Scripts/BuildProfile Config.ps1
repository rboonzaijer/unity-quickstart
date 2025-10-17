# Project settings
$PROJECT_NAME = "UnityBuildExample" # The project name
$REPOSITORY = "git@github.com:mysticeragames/unity-build-example.git" # The git repository to checkout
$BRANCH = "main" # The branch to build
$BUILD_DIR = "F:\Builds" # It will create a workspace folder and a folder for each build: F:\Builds\{PROJECT_NAME}\[Workspace|Builds\y-m-d__h-m-{commit}-WindowsDefault-{git-tag-if-set}]
$UNITY_EDITORS_DIR = "E:\Unity\Editors" # This is where the Unity Editors are installed

# Get input
param(
    [Parameter(Mandatory = $true)][string]$PROFILE_NAME
)

# Validate input
if (-not $PROFILE_NAME) {
    Write-Error "ERROR: PROFILE_NAME IS EMPTY"
    Show-Usage
    exit 1
}

# Call the main build script
& ".\BuildProfile.ps1" -PROFILE_NAME $PROFILE_NAME -PROJECT_NAME $PROJECT_NAME -REPOSITORY $REPOSITORY -BRANCH $BRANCH -BUILD_DIR $BUILD_DIR -UNITY_EDITORS_DIR $UNITY_EDITORS_DIR

exit 0

function Show-Usage {
    Write-Host ""
    Write-Host "- Usage:"
    Write-Host '  & ".\BuildProfile Config.ps1 "profileName"'
    Write-Host ""
    Write-Host "- Example:"
    Write-Host '  & ".\BuildProfile Config.ps1 "WindowsLZ4"'
}
