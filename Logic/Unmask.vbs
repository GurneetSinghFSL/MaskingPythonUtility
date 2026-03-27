' Unmask.vbs - runs the unmasking EXE invisibly using the default Input folder.
Set WshShell = CreateObject("WScript.Shell")
Set Fso = CreateObject("Scripting.FileSystemObject")
strBin = Fso.GetParentFolderName(WScript.ScriptFullName)
strRoot = Fso.GetParentFolderName(strBin)
strExe = Fso.BuildPath(strBin, "FsMasking.UnmaskCli.exe")
strConfig = Fso.BuildPath(strRoot, "utility-config.json")
strInput = Fso.BuildPath(strRoot, "Input")
WshShell.Run Chr(34) & strExe & Chr(34) & " " & Chr(34) & strInput & Chr(34) & " " & Chr(34) & strConfig & Chr(34), 0, False
