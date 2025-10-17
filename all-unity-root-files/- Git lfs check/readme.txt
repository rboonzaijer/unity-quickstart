# pre-commit-install.ps1 -> Run this (Rightclick > Run with PowerShell) to 'install' pre-commit hook (the file pre-commit is copied to .git/hooks/pre-commit)


# How to test the hook in Windows CMD, with the current staged files, without doing an actual commit:
"C:\Program Files\Git\bin\bash.exe" --login -i -c ".git/hooks/pre-commit"

# How to test in GIT BASH:
bash .git/hooks/pre-commit
