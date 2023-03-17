#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.15.0 (Beta)
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>

FileInstall("C:\Users\whiggs\Documents\GitHub\wol_solution\paexec.exe", "C:\WOL\paexec.exe")
If FileExists ( "C:\WOL\WakeMeOnLan.cfg" ) Then
	$hold = enableWOL (10)
Else
	$hold = scanAgain(0)
	DeviceCat()
EndIf

While 1
	Sleep(2000)
	If $hold < 10 Then
		$hold = sendWol($hold)
	Else
		$hold = scanAgain($hold)
		DeviceCat ()
	EndIf
WEnd

Func sendWol($num)
	RunWait(@ComSpec & " /c WakeMeOnLan.exe /wakeupall", "C:\WOL", @SW_HIDE)
	$num += 1
	Return $num
EndFunc   ;==>sendWol
Func scanAgain($num2)
	RunWait(@ComSpec & " /c WakeMeOnLan.exe /scan", "C:\WOL", @SW_HIDE)
	DeviceCat()
	$num2 = 0
	Return $num2
EndFunc   ;==>scanAgain
Func DeviceCat()
	$isip = False
	$info = FileReadToArray("C:\WOL\WakeMeOnLan.cfg")
	$star = ""
	$end = ""
	For $i = 0 To UBound($info) - 1 Step 1
		If StringLeft($info[$i], 1) = "[" Then
			$star = $star & $i & "|"
		ElseIf StringLeft($info[$i], 15) = "MultiplePackets" Then
			$end = $end & $i & "|"
		Else
			ContinueLoop
		EndIf
	Next
	$starind = StringSplit(StringTrimRight($star, 1), "|", $STR_NOCOUNT)
	$endind = StringSplit(StringTrimRight($end, 1), "|", $STR_NOCOUNT)
	If Not FileExists("C:\WOL\devices.ini") Then
		For $i = 0 To UBound($starind) - 1 Step 1
			$temarr = 0
			Local $temarr[($endind[$i] - $starind[$i]) - 1][2]
			For $p = 0 To UBound($temarr) - 1 Step 1
				$split = StringSplit($info[$starind[$i] + ($p + 1)], "=")
				$temarr[$p][0] = $split[1]
				$temarr[$p][1] = $split[2]
			Next
			IniWriteSection("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), $temarr)
			If IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", "") <> "" Then
				$isip = False
				$val = enableWOL(IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", ""))
			Else
				$isip = True
				$val = enableWOL(IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "IPAddress", ""))
			EndIf

			If @error Then
				SetError(0)
				IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
				ContinueLoop
			Else
				;MsgBox ( 1, "", $val )
				If $isip = False Then
					$proc = Run(@ComSpec & ' /c paexec.exe \\' & IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", "") & ' -h powercfg /deviceenablewake "' & $val & '"', "C:\WOL", @SW_HIDE, $STDOUT_CHILD)
					ProcessWaitClose($proc)
					$text = StdoutRead($proc)
					If StringInStr($text, "Couldn't access") > 0 Then
						IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
					Else
						IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "True")
					EndIf

				Else
					$proc = Run(@ComSpec & ' /c paexec.exe \\' & IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "IPAddress", "") & ' -h powercfg /deviceenablewake "' & $val & '"', "C:\WOL", @SW_HIDE, $STDOUT_CHILD)
					ProcessWaitClose($proc)
					$text = StdoutRead($proc)
					If StringInStr($text, "Couldn't access") > 0 Then
						IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
					Else
						IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "True")
					EndIf
				EndIf

			EndIf
		Next
	Else
		$cur = IniReadSectionNames("C:\WOL\devices.ini")
		For $i = 0 To UBound($starind) - 1 Step 1
			$search = _ArraySearch($cur, StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1))
			If @error Then
				SetError(0)
				$temarr = 0
				Local $temarr[($endind[$i] - $starind[$i]) - 1][2]
				For $p = 0 To UBound($temarr) - 1 Step 1
					$split = StringSplit($info[$starind[$i] + ($p + 1)], "=")
					$temarr[$p][0] = $split[1]
					$temarr[$p][1] = $split[2]
				Next
				IniWriteSection("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), $temarr)
				If IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", "") <> "" Then
					$isip = False
					$val = enableWOL(IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", ""))
				Else
					$isip = True
					$val = enableWOL(IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "IPAddress", ""))
				EndIf

				If @error Then
					SetError(0)
					IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
					ContinueLoop
				Else
					If $isip = False Then
						$proc = Run(@ComSpec & ' /c paexec.exe \\' & IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "Name", "") & ' -h powercfg /deviceenablewake "' & $val & '"', "C:\WOL", @SW_HIDE, $STDOUT_CHILD)
						ProcessWaitClose($proc)
						$text = StdoutRead($proc)
						If StringInStr($text, "Couldn't access") > 0 Then
							IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
						Else
							IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "True")
						EndIf

					Else
						$proc = Run(@ComSpec & ' /c paexec.exe \\' & IniRead("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "IPAddress", "") & ' -h powercfg /deviceenablewake "' & $val & '"', "C:\WOL", @SW_HIDE, $STDOUT_CHILD)
						ProcessWaitClose($proc)
						$text = StdoutRead($proc)
						If StringInStr($text, "Couldn't access") > 0 Then
							IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "False")
						Else
							IniWrite("C:\WOL\devices.ini", StringTrimLeft(StringTrimRight($info[$starind[$i]], 1), 1), "WOL Configured", "True")
						EndIf
					EndIf
				EndIf
			Else
				ContinueLoop
			EndIf
		Next
	EndIf
EndFunc   ;==>DeviceCat
Func enableWOL($compname)
	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""
	$objWMIService = ""
	$error = 0
	$hol = ""
	$checkob = True
	$objWMIService = ObjGet("winmgmts:\\" & $compname & "\ROOT\CIMV2")
	If Not IsObj($objWMIService) Then
		$error = 1
		$checkob = False
	Else
		$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True").Itemindex(0)
		$hol = $colItems.Description
	EndIf

	SetError($error)
	Return $hol
EndFunc   ;==>enableWOL
