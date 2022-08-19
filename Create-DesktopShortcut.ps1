Param (
    [Parameter(Mandatory=$true)]
    [String]$ShortcutName,

    [Parameter(Mandatory=$true)]
    [String]$WebsiteUrl,

    [Parameter(Mandatory=$true)]
    [String]$IconName,

    [Parameter(Mandatory=$true)]
    [String]$IconDownload
)

function Create-DesktopShortcut {
    param (
        [Parameter()]
        [String] $shortcutPath,
        [Parameter()]
        [String] $websiteUrl,
        [Parameter()]
        [String] $iconPath
    )

    $wshShell = New-Object -comObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
    $shortcut.Arguments = $websiteUrl
    $shortcut.IconLocation = $iconPath
    $shortcut.Save()
    [Runtime.InteropServices.Marshal]::ReleaseComObject($wshShell) | Out-Null
}

#Save icons to
$IconPath = "C:\ProgramData\IntuneIcons\$IconName"
#Public Desktop
$PublicDesktop = "C:\Users\Public\Desktop"
#Create shortcut path
$OutputIcon = Join-Path -Path "$PublicDesktop" -ChildPath "$ShortcutName.lnk"

#Download icon file
if (-not (Test-Path "C:\ProgramData\IntuneIcons\")){
    New-Item -Path "C:\ProgramData\IntuneIcons\" -ItemType Directory
}
Invoke-WebRequest -Uri $IconDownload -OutFile "$IconPath"

#Create Desktop Shortcut
Create-DesktopShortcut -shortcutPath $OutputIcon -websiteUrl $WebsiteUrl -iconPath $IconPath