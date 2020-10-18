dir := appdata . "\TechieCableUtilities"
setworkingdir %dir%

OnError("ErrorFunc")
ErrorFunc() {
	MsgBox, 0, TCUSetup - ERROR, An error occured - please try again`nYou may  need to allow the setup to run through an antivirus program
	ExitApp
	return true
}
Menu, Tray, NoStandard
Menu, Tray, Add, Restart, RELOAD
Menu, Tray, Add, Close, EXIT
Menu, Tray, Tip, TCUSetup in progress...

/* Previously used to install in an administrator protected folder - TCU now installs to %appdata%
if not (A_IsAdmin)
{
	if A_IsCompiled
		Run *RunAs "%A_ScriptFullPath%" /restart
	else
		Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
	ExitApp
}
*/

Gui, New, +AlwaysOnTop -Border, TechieCableUtilities Setup
Gui, Add, Progress, w380 h20 cBlue vSetupProgress, 0

IniRead, TechieCablePID, %dir%\TCU.ini, about, PID, CLOSED
if %TechieCablePID% not contains CLOSED
{
	Process, Close, %TechieCablePID%
	Process, WaitClose, %TechieCablePID%
}
; FileRecycle, %dir%\TechieCableUtilities.ahk
; FileRecycle, %dir%\TCULauncher.exe

Sleep, 100
GuiControl,, SetupProgress, +20

Gui, Show, AutoSize Center, TechieCableUtilities Setup

; Create the new directory
FileCreateDir, %dir%

Sleep, 100
GuiControl,, SetupProgress, +10

; Add the settings_cog .ico
; FileInstall, TCU\settings_cog.ico, settings_cog.ico, True
; 
; Sleep, 100
; GuiControl,, SetupProgress, +10

; FileInstall, TCU\TCU.rtf, TechieCableUtilities\TCU.rtf, True

; Add the ahk file
UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, TechieCableUtilities.ahk

Sleep, 100
GuiControl,, SetupProgress, +30

; Add the primary .exe
FileInstall, T:\Program_Files\AutoHotkey\Projects\TechieCableUtilities\TCU\TCULauncher.exe, TCULauncher.exe, True

Sleep, 100
GuiControl,, SetupProgress, +20

; Add the shortcut
FileCreateShortcut, %dir%\TCULauncher.exe, %A_Startup%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,

Sleep, 100
GuiControl,, SetupProgress, +20

; Post-install message
Gui, Add, Text, x55 +Center, TechieCableUtilities Setup is complete! Thanks for installing! `n (You can delete TCUSetup.exe now).

Gui, Add, CheckBox, vLaunchTCU Checked, Launch TCU (Recommended)
Gui, Add, CheckBox, vDesktopShortcut, Add a desktop shortcut
Gui, Add, Button, Default w80 x160 +Center gButtonFinish, Finish

Gui, Add, Text, x0 +Center cBlue gLaunchHelpFile, Launch the help file (Click here).
Gui, Add, Text, x0 +Center cBlue gLaunchDirectory, You can also find the help file in the `%appdata`% directory (Click here).
Gui, Add, Text, x0 +Center cBlue gLaunchStartFolder, TCUSetup also created a shortcut in the startup folder (Click here).

Gui, Show, AutoSize Center, TechieCableUtilities Setup Complete

exit
LaunchHelpFile:
	Run, %dir%\TCULauncher.exe
	Run, %dir%\TCU.rtf
return

LaunchDirectory:
	Run, %dir%
return

LaunchStartFolder:
	Run, %A_Startup%
return

ButtonFinish:
	Gui, Submit
	if (LaunchTCU = 1) {
		; Launch the .exe
		Run, %dir%\TCULauncher.exe
	}
	if (DesktopShortcut = 1) {
		FileCreateShortcut, %dir%\TCULauncher.exe, %A_Desktop%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,
	}
	ExitApp
return

RELOAD:
	Reload
return
EXIT:
	ExitApp
return
