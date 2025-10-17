Write-Host "Installing pre-commit hook..."

# Get the folder where this script lives
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Source = pre-commit in same folder as this script
$src = Join-Path $scriptDir "pre-commit"

# Destination = one folder up, then .git/hooks/pre-commit
$dst = Join-Path (Join-Path $scriptDir "..\.git\hooks") "pre-commit"

# Copy the file, overwrite if exists
Copy-Item $src $dst -Force

# Optional: mark executable if Git Bash is in use
# try { git update-index --chmod=+x $dst } catch {}

Write-Host "Pre-commit hook installed to $dst"

pause