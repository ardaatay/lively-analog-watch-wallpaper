' Analog Saat - disk betigini penceresiz calistirir (siyah ekran titremesi olmaz).
Dim sh, fso, klasor
Set sh = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
klasor = fso.GetParentFolderName(WScript.ScriptFullName)
sh.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & klasor & "\disk-yaz.ps1""", 0, False
