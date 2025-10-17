# pre-commit hook - Git lfs check

This will do a check before each commit to make sure no extreme large files (configurable) are stored without git-lfs.

Save this file as: `.git/hooks/pre-commit`

Workflow:
- Do each commit from the windows commandline (cmd).
- It also gives warnings for files above $min_bytes_warning, but you are able to continue the commit.
- When warnings or errors occur, it will also give the commands to fix them.

# Install

- pre-commit-install.ps1 (Rightclick > Run with PowerShell)

This will copy the `pre-commit` file to `../git/hooks/pre-commit`

# Testing pre-commit

#### How to test the hook in Windows CMD, with the current staged files, without doing an actual commit:

```bash
"C:\Program Files\Git\bin\bash.exe" --login -i -c ".git/hooks/pre-commit"
```

#### How to test in GIT BASH:

```bash
bash .git/hooks/pre-commit
```
