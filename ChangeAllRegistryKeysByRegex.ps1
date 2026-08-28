# Search paths
$SearchPaths = @("HKLM:\", "HKCU:\")
$MaximumRecursionDepth = 2000

Function Read-YesNoCancelChoice {
    Param (
        [Parameter(Mandatory=$true)][String]$title,
        [Parameter(Mandatory=$true)][String]$prompt,
        [Parameter(Mandatory=$false)][Int]$defaultOption = 0
    )
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No", "&Cancel")
    return $host.ui.PromptForChoice($title, $prompt, $choices, $defaultOption)
}

# Get inputs.
:input while ($true) {
    # Regex pattern
    $pattern = Read-Host -Prompt "Regex search pattern"
    # Replacement text
    $replacement = Read-Host -Prompt "Text to replace it with"

    # Confirm correctness of inputs.
    $choice = Read-YesNoCancelChoice -Title "Is this correct?" -Prompt "Enter your choice"
    switch ($choice) {
        0 {break input}
        1 {}
        2 {return}
    }
}

# Create found items lists.
$foundKeys = New-Object System.Collections.Generic.List[System.Object]
$foundVals = New-Object System.Collections.Generic.List[System.Object]

# Show registry keys and values to process.
$SearchPaths | ForEach-Object {
    # Process keys.
    Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Where-Object {
        $_.PSChildName -match $pattern
    } | ForEach-Object {
        Write-Host "Found matching key: $($_.PSPath)"
        Write-Host "Would be replacing $($_.PSChildName) with $($_.PSChildName -replace $pattern, $replacement)"
        $foundKeys.Add($_)
    }

    # Process values.
    Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
        foreach ($prop in $props.PSObject.Properties) {
            if ($prop.Name -match $pattern -or $prop.Value -match $pattern) {
                Write-Host "Found matching value: $($_.PSPath) - $($prop.Name) = $($prop.Value)"
                Write-Host "Would be replacing $($prop.Value) with $($prop.Value -replace $pattern, $replacement)"
                $foundVals.Add(($_, $prop))
            }
        }
    }
}

# Confirm proceding.
$choice = Read-YesNoCancelChoice -Title "Is this ok?" -Prompt "Enter your choice"
switch ($choice) {
    0 {}
    1 {return}
    2 {return}
}

# Make backup.
$SearchPaths | ForEach-Object {
    Copy-Item -Path $_ -Destination ".\Backup $($_ -replace ":")" -Recurse
}

# Process keys.
foreach ($key in $foundKeys) {
    Rename-Item -Path $key.PSPath -NewName ($key.PSChildName -replace $pattern, $replacement)
}

# Process values.
foreach ($keyVal in $foundVals) {
    $key = $keyVal[0]
    $val = $keyVal[1]
    Set-ItemProperty -Path $key.PSPath -Name $val.Name -Value ($val.Value -replace $pattern, $replacement)
}
