# Analog Saat - tek tik kurulum (yonetici yetkisi gerekmez).
# Yaptiklari:
#  1) "AnalogSaatDisk" zamanlanmis gorevi (oturum acilista + 2 dakikada bir)
#  2) Yenile butonu icin analogsaat:// protokol kaydi
#  3) Lively'nin yerel dosyayi okumasi icin WebView2 dosya erisim bayragi
$ErrorActionPreference = "Stop"

$kendiKlasoru = Split-Path -Parent $MyInvocation.MyCommand.Path
$betik = Join-Path $kendiKlasoru "disk-yaz.ps1"

# 1) Zamanlanmis gorev
$a = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$betik`""
$t1 = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$t2 = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 2) -RepetitionDuration (New-TimeSpan -Days 3650)
$s = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName "AnalogSaatDisk" -Action $a -Trigger @($t1, $t2) -Settings $s -Force | Out-Null

# 2) analogsaat:// protokol kaydi
$ps = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
New-Item -Path "HKCU:\Software\Classes\analogsaat" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\analogsaat" -Name "(Default)" -Value "URL:AnalogSaat Disk Yenile"
New-ItemProperty -Path "HKCU:\Software\Classes\analogsaat" -Name "URL Protocol" -Value "" -PropertyType String -Force | Out-Null
New-Item -Path "HKCU:\Software\Classes\analogsaat\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Classes\analogsaat\shell\open\command" -Name "(Default)" -Value "`"$ps`" -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$betik`""

# 3) WebView2 dosya erisim bayragi (kullanici ortami)
[Environment]::SetEnvironmentVariable("WEBVIEW2_ADDITIONAL_BROWSER_ARGUMENTS", "--allow-file-access-from-files", "User")
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Ortam {
  [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
  public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
}
"@
$sonuc = [UIntPtr]::Zero
[Ortam]::SendMessageTimeout([IntPtr]0xffff, 0x1A, [UIntPtr]::Zero, "Environment", 2, 5000, [ref]$sonuc) | Out-Null

# 4) Ilk veriyi hemen uret
Start-ScheduledTask -TaskName "AnalogSaatDisk"

Write-Output "Kurulum tamam."
Write-Output "1) Lively penceresine bu klasoru surukleyip birakin (veya index.html'i ekleyin)."
Write-Output "2) Lively'yi kapatip acin."
