dir := appdata . "\TechieCableUtilities"
setworkingdir %dir%

; ***** ERROR PREP *****
OnError("ErrorFunc")
ErrorFunc() {
	MsgBox, 0, TCUSetup ERROR, An error prevented TCUSetup from installing correctly. Please try again.
	ExitApp
	return true
}

TCUiniEx=0
AddonEx=0
GosubEx=0
SpecCharsEx=0

; ***** BACKUP FILES *****

if FileExist("TCU.ini") {
	TCUiniEx=1
	FileRead, TCUiniContents, TCU.ini
}
if FileExist("data\addon.txt") {
	AddonEx=1
	FileRead, AddonContents, data\addon.txt
}
if FileExist("data\gosub.txt") {
	GosubEx=1
	FileRead, GosubContents, data\gosub.txt
}
if FileExist("data\SpecChars.txt") {
	SpecCharsEx=1
	FileRead, SpecCharsContents, data\SpecChars.txt
}

; ***** TRAY AND GUI *****

Menu, Tray, NoStandard
Menu, Tray, Add, Restart, RELOAD
Menu, Tray, Add, Close, EXIT
Menu, Tray, Tip, TCUSetup in progress...

Gui, New, +AlwaysOnTop -Border, TechieCableUtilities Setup
Gui, Add, Progress, w380 h20 cBlue vSetupProgress, 0
Gui, Show, AutoSize Center, TechieCableUtilities Setup

; ***** CLOSE TCU *****

IniRead, TechieCablePID, %dir%\TCU.ini, about, PID, CLOSED
if %TechieCablePID% not contains CLOSED
{
	Process, Close, %TechieCablePID%
	Process, WaitClose, %TechieCablePID%
}

; ***** DELETE OLD VERSION *****

commands=
	(join&
	@echo off
	rmdir /s /q %dir%
)
Run, %comspec% /c %commands%

Sleep, 100
GuiControl,, SetupProgress, +20

; ***** CREATE DIRECTORIES *****
FileCreateDir, %dir%
FileCreateDir, %dir%\data

Sleep, 100
GuiControl,, SetupProgress, +10

; ***** INSTALL FILES *****

; Add the ahk file
UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, %dir%\TechieCableUtilities.ahk

Sleep, 100
GuiControl,, SetupProgress, +30

; Add the primary .exe
FileInstall, T:\Program_Files\AutoHotkey\Projects\TechieCableUtilities\TCU\TCULauncher.exe, %dir%\TCULauncher.exe, True

Sleep, 100
GuiControl,, SetupProgress, +20

; Add the TouchpadToggle .exe
FileInstall, T:\Program_Files\AutoHotkey\Projects\TechieCableUtilities\TCU\data\TouchpadToggle.exe, %dir%\data\TouchpadToggle.exe, True

Sleep, 100
GuiControl,, SetupProgress, +20

; ***** CUSTOM FILES *****

if (TCUiniEx=1) {
	FileAppend, %TCUiniContents%, TCU.ini
}
if (AddonEx=1) {
	FileAppend, %AddonContents%, data\addon.txt
}
if (GosubEx=1) {
	FileAppend, %GosubContents%, data\gosub.txt
}
if (SpecCharsEx=1) {
	FileAppend, %SpecCharsContents%, data\SpecChars.txt
}

; ***** POST-INSTALL GUI *****

Gui, Destroy
if A_Args[1]=1 {
	Gosub, update
} else {
	Gosub, install
}

; _________________________________________
; |              SCRIPT ENDS              |
; _________________________________________

exit

install:
	Gui, New, +AlwaysOnTop -Border, TechieCableUtilities Setup Complete
	Gui, Add, Text, x0 +Center, TechieCableUtilities Setup is complete! Thanks for installing!

	Gui, Add, CheckBox, vLaunchTCU Checked, Launch TCU (Recommended)
	Gui, Add, CheckBox, vDesktopShortcut, Add a desktop shortcut
	Gui, Add, CheckBox, vStartFolder Checked, Add TCU to startup? (Recommended)
	Gui, Add, Button, Default w80 x140 +Center gButtonFinish, Finish

	Gui, Add, CheckBox, x0 vLaunchHelpFile, Launch the help file.
	Gui, Add, Text, x0 +Center cBlue gLaunchDirectory, Find the help file in the `%appdata`% directory (Click here).

	Gui, Show, AutoSize Center, TechieCableUtilities Setup Complete
return

update:
	Gui, New, +AlwaysOnTop -Border, TechieCableUtilities Update
	Gui, Add, Text, x0 +Center, TechieCableUtilities Update is complete! Thanks for staying up to date!
	Gui, Add, Link,,<a href="https://github.com/TechieCable/TechieCableUtilities/releases/latest/">View update information</a>
	LaunchTCU=1
	Gui, Add, CheckBox, vDesktopShortcut, Add a new desktop shortcut
	Gui, Add, CheckBox, vStartFolder Checked, Add TCU to startup again?
	Gui, Add, Button, Default w80 x140 +Center gButtonFinish, Finish
	Gui, Add, Text, x0 +Center gLaunchDesktop, The latest TCUSetup was placed on your desktop.`nYou may delete it now. (Click here)
	Gui, Add, CheckBox, x0 vLaunchHelpFile, Launch the help file.
	Gui, Show, AutoSize Center, TechieCableUtilities Update Complete
return

LaunchDirectory:
	Run, %dir%
return

LaunchDesktop:
	Run, %A_Desktop%
return

; ***** WRAP-UP COMMANDS *****

ButtonFinish:
	Gui, Submit
	if (LaunchTCU = 1) {
		; Launch the .exe
		Run, %dir%\TCULauncher.exe
		if (LaunchHelpFile = 1) {
			Sleep, 1000
			Run, %dir%\TCU.rtf
		}
	}
	if (LaunchTCU = 0 && LaunchHelpFile = 1) {
		Gosub, LaunchDirectory
	}
	if (DesktopShortcut = 1) {
		FileCreateShortcut, %dir%\TCULauncher.exe, %A_Desktop%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,
	}
	if (StartFolder = 1) {
		FileCreateShortcut, %dir%\TCULauncher.exe, %A_Startup%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,
	}
	ExitApp
return

RELOAD:
	Reload
return
EXIT:
	ExitApp
return
