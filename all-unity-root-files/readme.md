# Step 1

- Create 2 Build profiles:
    - WindowsDev:
        - Intel 64-bit
        - Check everything except 'Create Visual Studio Solution'
        - Compression method: LZ4
    - WindowsRelease:
        - Intel 64-bit
        - Uncheck everything
        - Compression method: LZ4HC

# Step 2

- Run `.gitconfig-update-version.bat`

# Step 3

- Push your changes to the remote repository

# Step 4

- Run `build-windows-dev.bat` and `build-windows-release.bat` and check the output.

## Notes

- The repository will be cloned for each profile, for fastest build timed (no need to switch profile and import assets etc)

Directory structure:

```bash
# The expected Unity editors locations:
E:\Unity\Editors\6000.0.43f1\Editor\Unity.exe
E:\Unity\Editors\6000.0.44f1\Editor\Unity.exe

# The automatically created workspace folders (a cloned git repo)
E:\UnityBuilds\{PROJECT_NAME}\Workspace\Profile-{PROFILE_NAME}
E:\UnityBuilds\{PROJECT_NAME}\Builds\2025-04-25__17-05-WindowsDev\Profile-{PROFILE_NAME}

# The automatically created build folders:
E:\UnityBuilds\{PROJECT_NAME}\Builds\{DATETIME}-{PROFILE_NAME}\build-log.txt
E:\UnityBuilds\{PROJECT_NAME}\Builds\{DATETIME}-{PROFILE_NAME}\Build\{PROJECT_NAME}.exe
```
