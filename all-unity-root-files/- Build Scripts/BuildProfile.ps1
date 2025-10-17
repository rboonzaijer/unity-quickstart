param(
    [Parameter(Mandatory = $true)][string]$PROFILE_NAME,
    [Parameter(Mandatory = $true)][string]$PROJECT_NAME,
    [Parameter(Mandatory = $true)][string]$REPOSITORY,
    [Parameter(Mandatory = $true)][string]$BRANCH,
    [Parameter(Mandatory = $true)][string]$BUILD_DIR,
    [Parameter(Mandatory = $true)][string]$UNITY_EDITORS_DIR
)

# Check SSH version
ssh -V

# Validate inputs
if (-not $PROFILE_NAME)      { Write-Error "ERROR: PROFILE_NAME IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }
if (-not $PROJECT_NAME)      { Write-Error "ERROR: PROJECT_NAME IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }
if (-not $REPOSITORY)        { Write-Error "ERROR: REPOSITORY IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }
if (-not $BRANCH)            { Write-Error "ERROR: BRANCH IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }
if (-not $BUILD_DIR)         { Write-Error "ERROR: BUILD_DIR IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }
if (-not $UNITY_EDITORS_DIR) { Write-Error "ERROR: UNITY_EDITORS_DIR IS EMPTY"; Read-Host -Prompt "Press Enter to exit"; exit 1 }

# Get date/time in desired format
$now = Get-Date
$NOW = $now.ToString("yyyy-MM-dd__HH-mm")

# Static settings
$BUILD_PROFILE = "Assets/Settings/Build Profiles/$PROFILE_NAME.asset"
$WORKSPACE_DIR = Join-Path -Path $BUILD_DIR -ChildPath "$PROJECT_NAME\Workspace"

# Validate required variables
foreach ($var in @("UNITY_EDITORS_DIR", "REPOSITORY", "WORKSPACE_DIR", "BUILD_PROFILE")) {
    if (-not (Get-Variable $var -ValueOnly)) {
        Write-Error "ERROR: $var IS EMPTY"
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

# Track start time
$STARTED_AT = Get-Date

# Clone repository if needed
if (-not (Test-Path $WORKSPACE_DIR)) {
    git clone --single-branch --branch=$BRANCH $REPOSITORY $WORKSPACE_DIR
}



# Reset repository to clean state (discard local changes and untracked files)
Write-Host "- git reset any changed files"
git -C $WORKSPACE_DIR reset --hard
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Git reset failed in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

git -C $WORKSPACE_DIR clean -d -f
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Git clean failed in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Optional: ensure on correct branch
# Write-Host "- checkout branch '$BRANCH'"
# git -C $WORKSPACE_DIR checkout $BRANCH
# if ($LASTEXITCODE -ne 0) {
#     Write-Error "ERROR: Git checkout failed for branch '$BRANCH' in '$WORKSPACE_DIR'"
#     Read-Host -Prompt "Press Enter to exit"
#     exit 1
# }

# Fetch latest changes and reset hard to remote branch
Write-Host "- git fetch and hard reset to latest changes ($BRANCH branch only)"
git -C $WORKSPACE_DIR fetch origin $BRANCH
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Git fetch failed for branch '$BRANCH' in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Fetch all tags from origin
Write-Host "- git fetch all tags"
git -C $WORKSPACE_DIR fetch --tags origin
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Git fetch of tags failed in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

git -C $WORKSPACE_DIR reset --hard origin/$BRANCH
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERROR: Git reset failed for branch '$BRANCH' in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}


# Get short commit hash
$COMMIT_HASH = git -C $WORKSPACE_DIR rev-parse --short HEAD
if ($LASTEXITCODE -ne 0 -or -not $COMMIT_HASH) {
    Write-Error "ERROR: Failed to retrieve Git commit hash in '$WORKSPACE_DIR'"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}
$COMMIT_HASH = $COMMIT_HASH.Trim()  # ensure no newline/space


# Get the most recent Git tag pointing at HEAD (if any)
$GIT_TAG = git -C $WORKSPACE_DIR tag --points-at HEAD | Select-Object -First 1

if ($LASTEXITCODE -ne 0 -or -not $GIT_TAG) {
    $GIT_TAG = ""
} else {
    $GIT_TAG = $GIT_TAG.Trim()  # Clean whitespace or newline
}

$BUILD_TARGET_ABSOLUTE_DIR = Join-Path -Path $BUILD_DIR -ChildPath "$PROJECT_NAME\Builds\$NOW-$COMMIT_HASH-$PROFILE_NAME"
if ($GIT_TAG) {
    Write-Host "Git tag detected: $GIT_TAG"
    $BUILD_TARGET_ABSOLUTE_DIR += "-$GIT_TAG"
}
$BUILD_PATH = Join-Path -Path $BUILD_TARGET_ABSOLUTE_DIR -ChildPath "Build\$PROJECT_NAME.exe"
$LOG_PATH = Join-Path -Path $BUILD_TARGET_ABSOLUTE_DIR -ChildPath "build-log.txt"



# Display environment
Write-Host "-------------------------------"
Write-Host "- PROFILE_NAME:                 $PROFILE_NAME"
Write-Host "- PROJECT_NAME:                 $PROJECT_NAME"
Write-Host "- REPOSITORY:                   $REPOSITORY"
Write-Host "- BRANCH:                       $BRANCH"
Write-Host "-------------------------------"
Write-Host "- NOW:                          $NOW"
Write-Host "- UNITY_EDITORS_DIR:            $UNITY_EDITORS_DIR"
Write-Host "- WORKSPACE_DIR:                $WORKSPACE_DIR"
Write-Host "- BUILD_TARGET_ABSOLUTE_DIR:    $BUILD_TARGET_ABSOLUTE_DIR"
Write-Host "- BUILD_PATH:                   $BUILD_PATH"
Write-Host "- LOG_PATH:                     $LOG_PATH"
Write-Host "- BUILD_PROFILE:                $BUILD_PROFILE"
Write-Host "-------------------------------"




# Parse Unity version
$versionFile = Join-Path $WORKSPACE_DIR "ProjectSettings\ProjectVersion.txt"
$UNITY_VERSION = ""
$UNITY_VERSION_NUMS = ""

if (Test-Path $versionFile) {
    $line = Get-Content $versionFile | Select-String -Pattern "m_EditorVersion:"
    if ($line) {
        $version = $line.ToString().Split(":")[1].Trim()
        $UNITY_VERSION = $version
        $UNITY_VERSION_NUMS = ($version -replace "[^0-9.]", "")
    }
}

$UNITY_EDITOR = Join-Path $UNITY_EDITORS_DIR "$UNITY_VERSION\Editor\Unity.exe"

# Check if Unity exists
if (-not (Test-Path $UNITY_EDITOR)) {
    Write-Error "ERROR: Unity Editor not found: $UNITY_EDITOR"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Display Unity info
Write-Host "--------------"
Write-Host "- UNITY_VERSION: $UNITY_VERSION"
Write-Host "- UNITY_EDITOR:  $UNITY_EDITOR"
Write-Host "--------------"

# Ensure output directory exists
New-Item -ItemType Directory -Force -Path (Split-Path $BUILD_PATH) | Out-Null



#Write-Host "Press any key to continue build..."
#pause



# Run Unity Build
Write-Host "Building project..."

# Helper function to quote arguments with spaces
function Quote-Argument($arg) {
    if ($arg -match '\s') {
        return '"' + $arg + '"'
    }
    else {
        return $arg
    }
}

# Quote all variable arguments that may contain spaces
$quotedWorkspaceDir = Quote-Argument $WORKSPACE_DIR
$quotedBuildProfile = Quote-Argument $BUILD_PROFILE
$quotedBuildPath = Quote-Argument $BUILD_PATH
$quotedLogPath = Quote-Argument $LOG_PATH

$argumentList = @(
    "-projectPath", $quotedWorkspaceDir,
    "-quit",
    "-batchmode",
    "-activeBuildProfile", $quotedBuildProfile,
    "-build", $quotedBuildPath,
    "-logFile", $quotedLogPath,
    "-EnableCacheServer",
    "-cacheServerEndpoint", "192.168.2.98:10080",
    "-cacheServerEnableDownload", "true",
    "-cacheServerEnableUpload", "false"
)

$processInfo = Start-Process -FilePath "$UNITY_EDITOR" `
    -ArgumentList $argumentList `
    -Wait `
    -PassThru

if ($processInfo.ExitCode -ne 0) {
    Write-Error "Build ERROR (exit code $($processInfo.ExitCode)). Check log: $LOG_PATH"
    Read-Host -Prompt "Press Enter to exit"
    exit 1
} else {
    Write-Host "Build SUCCESS"
    Write-Host $BUILD_TARGET_ABSOLUTE_DIR
    Start-Process explorer "$BUILD_TARGET_ABSOLUTE_DIR"
}



# Done
$FINISHED_AT = Get-Date
Write-Host "Started:  $STARTED_AT"
Write-Host "Finished: $FINISHED_AT"

Read-Host -Prompt "Press Enter to exit"

# exit 0 for Jenkins
# exit 0
