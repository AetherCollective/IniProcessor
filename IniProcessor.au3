$source = FileOpenDialog("Select Source File - IniProcessor", "", "Ini Settings File (*.ini)")
If @error Then Exit
$dest = FileOpenDialog("Select Destination File - IniProcessor", "", "Ini Settings File (*.ini)")
If @error Then Exit
IniProcessor($source, $dest)
Func IniProcessor($ModFile, $IniToMod)
	FileSetAttrib($IniToMod, "-R")
	Local $sectionData = IniReadSectionNames($ModFile)
	If $sectionData = 0 Then MsgBox(16, "IniProcessor", "Error reading Ini File." & @CRLF & "Code: " & @error & @CRLF)
	BackupIni($IniToMod)
	For $i = 1 To $sectionData[0]
		Local $iArray = IniReadSection($ModFile, $sectionData[$i])
		For $j = 1 To UBound($iArray) - 1
			If IniWrite($IniToMod, $sectionData[$i], $iArray[$j][0], $iArray[$j][1]) = 0 Then MsgBox(16, "IniProcessor", "Error writing Ini File." & @CRLF & "Code: " & @error & @CRLF)
		Next
	Next
	If MsgBox(32 + 4, "IniProcessor", "Would you like to make the Ini file read-only?") = 6 Then FileSetAttrib($IniToMod, "+R")
	MsgBox(0, "IniProcessor", "Done.")
	Exit
EndFunc   ;==>IniProcessor
Func BackupIni($IniToBackup)
	If FileCopy($IniToBackup, $IniToBackup & "_" & @MON & "-" & @MDAY & "-" & @YEAR & "_" & @HOUR & "." & @MIN & "." & @SEC & ".backup") = 0 Then
		MsgBox(16, "IniProcessor", "Failed to create backup. Exiting.")
		Exit
	EndIf
EndFunc   ;==>BackupIni
