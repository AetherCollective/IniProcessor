;Get cmdline arguments. Expects Source as arg1, Dest as arg2, and if desired "readonly" as arg3
If $cmdline[0] = (2 Or 3) Then
	$source = $cmdline[1]
	$dest = $cmdline[2]
	If $cmdline[0] = 3 Then
		$readonly = $cmdline[3]
	Else
		$readonly = False
	EndIf
EndIf
;if cmdline invalid or not defined, then ask user.
If Not IsDeclared("source") Then
	$source = FileOpenDialog("Select Source File - IniProcessor", "", "Ini Settings File (*.ini)")
	If @error Then Exit
EndIf
If Not IsDeclared("dest") Then
	$dest = FileOpenDialog("Select Destination File - IniProcessor", "", "Ini Settings File (*.ini)")
	If @error Then Exit
EndIf
If Not IsDeclared("readonly") Then
	If MsgBox(32 + 4, "IniProcessor", "Would you like to make the Ini file readonly?") = 6 Then
		$readonly = "readonly"
	Else
		$readonly = False
	EndIf
EndIf
IniProcessor($source, $dest, $readonly)
Func IniProcessor($ModFile, $IniToMod, $readonly)
	FileSetAttrib($IniToMod, "-R") ;unset readonly so we can write to file.
	Local $sectionData = IniReadSectionNames($ModFile) ;prepare data
	If @error Then MsgBox(16, "IniProcessor", "Error reading Ini File." & @CRLF & "Code: " & @error & @CRLF) ;checks if there's a problem with read access
	BackupIni($IniToMod) ;backup the dest file, just in case.
	For $i = 1 To $sectionData[0] ;process data. This is what actually replaces values in dest with values from source.
		Local $iArray = IniReadSection($ModFile, $sectionData[$i])
		For $j = 1 To UBound($iArray) - 1
			If IniWrite($IniToMod, $sectionData[$i], $iArray[$j][0], $iArray[$j][1]) = 0 Then MsgBox(16, "IniProcessor", "Error writing Ini File." & @CRLF & "Code: " & @error & " in Section " & $sectionData[$i] & ":" & $iArray[$j][0] & @CRLF)
		Next
	Next
	If $readonly = "readonly" Then FileSetAttrib($IniToMod, "+R") ;if desired, sets readonly attribute.
	If $cmdline[0] < 2 Then MsgBox(0, "IniProcessor", "Done.") ;if cmdline invalid or not defined, then alert user the task has completed.
	Exit
EndFunc   ;==>IniProcessor
Func BackupIni($IniToBackup)
	If FileCopy($IniToBackup, $IniToBackup & "_" & @MON & "-" & @MDAY & "-" & @YEAR & "_" & @HOUR & "." & @MIN & "." & @SEC & ".backup") = 0 Then
		MsgBox(16, "IniProcessor", "Failed to create backup. Exiting.")
		Exit
	EndIf
EndFunc   ;==>BackupIni
