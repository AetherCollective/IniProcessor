$source = FileOpenDialog("Select Mod Ini file - IniProcessor", "", "Ini Settings File (*.ini)")
If @error Then Exit
$dest = FileOpenDialog("Select Ini file to Mod - IniProcessor", "", "Ini Settings File (*.ini)")
If @error Then Exit
IniProcessor($source, $dest)
Func IniProcessor($ModFile, $IniToMod)
	FileSetAttrib($ModFile, "-R")
	Local $sectionData = IniReadSectionNames($ModFile)
	If $sectionData = 0 Then MsgBox(16, "Error", "Error Reading Ini File." & @CRLF & "Code: " & @error & @CRLF)
	If BackupIni($IniToMod) = 1 Then
		For $i = 1 To $sectionData[0]
			Local $iArray = IniReadSection($ModFile, $sectionData[$i])
			For $j = 1 To UBound($iArray) - 1
				$section = $sectionData[$i]
				$Name = $iArray[$j][0]
				$Value = $iArray[$j][1]
				$WriteResult = IniWrite($IniToMod, $section, $Name, $Value)
				If $WriteResult = 0 Then MsgBox(16, "Error", "Error writing Ini File." & @CRLF & "Code: " & @error & @CRLF)
			Next
		Next
	EndIf
	MsgBox(64, "IniProcessor", "Done.")
	Exit
EndFunc   ;==>IniProcessor
Func BackupIni($IniToBackup)
	$sysTime = @MON & "-" & @MDAY & "-" & @YEAR & "_" & @HOUR & "." & @MIN & "." & @SEC
	$BackUpFile = $IniToBackup & ".backup_" & $sysTime
	$CopyResult = FileCopy($IniToBackup, $BackUpFile)

	If $CopyResult = 1 Then Return 1
	If $CopyResult = 0 Then
		MsgBox(16, "Error", "Failed to create backup.")
		Return 0
	EndIf
EndFunc   ;==>BackupIni
