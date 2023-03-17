#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.15.0 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <_SelfDelete.au3>
firstRun()

Func firstRun()
DirCreate ( "C:\WOL" )
FileInstall ( "C:\Users\whiggs\Documents\GitHub\wol_solution\WakeMeOnLan.exe", "C:\WOL\WakeMeOnLan.exe" )
FileInstall ( "C:\Users\whiggs\Documents\GitHub\wol_solution\multiplatform_201607260046.exe", "C:\WOL\dell.exe" )
FileInstall ( "C:\Users\whiggs\Documents\GitHub\wol_solution\enable-wol.vbs", "C:\WOL\enable-wol.vbs" )
FileInstall ( "C:\Users\whiggs\Documents\GitHub\wol_solution\paexec.exe", "C:\WOL\paexec.exe" )
RunWait ( @ComSpec & " /c echo y | cacls C:\WOL /T /C /G Everyone:F", @SystemDir, @SW_HIDE )
ShellExecuteWait ( "dell.exe", "", "C:\WOL" )
FileInstall ( "C:\Users\whiggs\Documents\GitHub\wol_solution\WOL.exe", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\WOL.exe" )
$proc = Run ( @ComSpec & " /c WOL.exe", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup", @SW_HIDE )
Do
	FileDelete ( "C:\WOL\dell.exe" )
Until Not FileExists ( "C:\WOL\dell.exe" )
_SelfDelete()
EndFunc
