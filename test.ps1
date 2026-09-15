$users = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"

foreach ($user in $users) {
    $sid = $user.PSChildName
    $profile = $user.GetValue("ProfileImagePath")

    $uninstallPath = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows\CurrentVersion\Uninstall"

    if (Test-Path $uninstallPath) {
        Get-ChildItem $uninstallPath | ForEach-Object {
            $app = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue

            if ($app.DisplayName) {
                [PSCustomObject]@{
                    User          = Split-Path $profile -Leaf
                    SID           = $sid
                    Software      = $app.DisplayName
                    Version       = $app.DisplayVersion
                    InstallDate   = $app.InstallDate
                    InstallPath   = $app.InstallLocation
                }
            }
        }
    }
}