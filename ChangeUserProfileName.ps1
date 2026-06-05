$UsersDir = "C:\Users\"

# Get current user dir name.
while ($True) {
    $PrevName = Read-Host -Prompt "Current name of user's directory"
    if (!$PrevName) {
        Write-Output "Aborting..."
        return
    }
    try {
        $UserFolder = Get-Item -Path "$UsersDir$PrevName" -ErrorAction Stop
        break
    } catch {
        Write-Warning $_.Exception.Message
    }
}

# Get new user name.
while ($True) {
    $PrincipalName = Read-Host -Prompt "New principal name of user"
    if (!$PrincipalName) {
        Write-Output "Aborting..."
        return
    }
    try {
        $Id = New-Object System.Security.Principal.NTAccount($PrincipalName) -ErrorAction Stop
        $Sid = $Id.Translate([System.Security.Principal.SecurityIdentifier]).Value
        break
    } catch {
        Write-Warning "This user can't be found:"
        Write-Warning $_.Exception.Message
    }
}

# Check if logged in as this user.
$CId = New-Object System.Security.Principal.NTAccount($env:USERNAME)
$CSid = $CId.Translate([System.Security.Principal.SecurityIdentifier]).Value
if ($Sid.Equals($CSid)) {
    Write-Error "
    You are currently logged in as this user. You can't rename a user you are logged in as.
    Please change to an admin user different from the user to rename."
    return
}

# Rename folder.
Write-Output "Renaming folder..."
try {
    Rename-Item -Path "$UserFolder" -NewName "$PrincipalName" -ErrorAction Stop
} catch {
    Write-Error "Couldn't rename. Did you run this as admin?"
}

# Change registry entry.
Write-Output "Changing registry..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid" -Name ProfileImagePath -Value "$UsersDir$PrincipalName"

Write-Output "Done."
Pause
