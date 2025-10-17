# Set default profile name
$PROFILE_NAME = "WindowsDefault"

# Call the build script with the profile name
& ".\BuildProfile Config.ps1" -PROFILE_NAME $PROFILE_NAME
