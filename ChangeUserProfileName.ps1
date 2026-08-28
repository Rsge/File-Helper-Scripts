# Base user directory
$UsersDir = "C:\Users\"

# Get current user dir name.
while ($true) {
    $prevName = Read-Host -Prompt "Current name of user's directory"
    if (!$prevName) {
        Write-Output "Aborting..."
        return
    }
    try {
        $userFolder = Get-Item -Path "$UsersDir$prevName" -ErrorAction Stop
        break
    } catch {
        Write-Warning $_.Exception.Message
    }
}

# Get new user name.
while ($true) {
    $principalName = Read-Host -Prompt "New principal name of user"
    $principalName = $principalName -replace '@.*$' -replace '^.*\\'
    if (!$principalName) {
        Write-Output "Aborting..."
        return
    }
    try {
        $id = New-Object System.Security.Principal.NTAccount($principalName) -ErrorAction Stop
        $sID = $id.Translate([System.Security.Principal.Securityidentifier]).Value
        break
    } catch {
        Write-Warning "This user can't be found:"
        Write-Warning $_.Exception.Message
    }
}

# Check if logged in as this user.
$cID = New-Object System.Security.Principal.NTAccount($env:USERNAME)
$csID = $cID.Translate([System.Security.Principal.Securityidentifier]).Value
if ($sID.Equals($csID)) {
    Write-Error "
    You are currently logged in as this user. You can't rename a user you are logged in as.
    Please change to an admin user different from the user to rename."
    pause
    return
}

# Rename folder.
Write-Output "Renaming folder..."
try {
    Rename-Item -Path "$userFolder" -NewName "$principalName" -ErrorAction Stop
} catch {
    Write-Error "Couldn't rename. Did you run this as admin?"
}

# Change registry entry.
Write-Output "Changing registry..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sID" -Name ProfileImagePath -Value "$UsersDir$principalName"

Write-Output "Done."
Pause
