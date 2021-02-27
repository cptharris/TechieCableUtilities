version = 1.0.11
; WRITTEN BY TECHIECABLE
;@Ahk2Exe-Let Version = %A_PriorLine~^version = (.+)$~$1%

dir := appdata . "\TechieCableUtilities"
setworkingdir %dir%
#SingleInstance Force

;@Ahk2Exe-SetCompanyName TechieCable
;@Ahk2Exe-SetCopyright (c) 2020-2021 TechieCable
;@Ahk2Exe-SetDescription TechieCableUtilities Setup Process
;@Ahk2Exe-SetFileVersion %U_Version%
;@Ahk2Exe-SetInternalName TCUSetup
;@Ahk2Exe-SetName TCUSetup
;@Ahk2Exe-SetOrigFilename TCUSetup
;@Ahk2Exe-SetProductName TCUSetup
;@Ahk2Exe-SetProductVersion %U_Version%
;@Ahk2Exe-SetVersion %U_Version%

; ***** ERROR PREP *****
OnError("ErrorFunc")
ErrorFunc() {
	MsgBox, 262164, TCUSetup Error, An error prevented TCUSetup from installing correctly. TCULauncher will attempt to continue`, but you may need to run it again.`n`nPress "Yes" to view the error. Press "No" to continue.
	IfMsgBox Yes
		return false
	return true
}

if A_Args[1]="--update" {
	isUpdate := 1
} else {
	if FileExist("TCU.ini") {
		isUpdate := 1
	} else {
		isUpdate := 0
	}
}

; ***** CREATE SETUPWIZARD PIC *****
pic := A_Temp . "\setupwizard.png"
URLDownloadToFile, https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/setupwizard.png, %pic%

; ***** PROGRESS FUNC *****
progressFunc(message,min:=0,max:=20) {
	Sleep, 100
	Random, rand, %min%, %max%
	GuiControl, 3:Text, installMessage, %message%
	GuiControl, 3:, SetupProgress, +%rand%
}


; ***** TRAY AND GUI *****

Menu, Tray, NoStandard
Menu, Tray, Add, Restart, RELOAD
Menu, Tray, Add, Close, EXIT
Menu, Tray, Tip, TCUSetup in progress...

; ***** LICENSE GUI *****

Gui, 1:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Color, White
Gui, Margin, 0, 0
Gui, 1:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 1:Add, Text, x+10 y10, TechieCableUtilites Setup
Gui, Font, s15
Gui, 1:Add, Text,, License && Privacy Policy
Gui, Font
Gui, 1:Add, Link, y+40, By installing, you are agreeing to the <a href="https://github.com/TechieCable/TechieCableUtilities/blob/main/LICENSE.md">License</a> and <a href="https://github.com/TechieCable/TechieCableUtilities/blob/main/PrivacyPolicy.md">Privacy Policy</a>.
Gui, 1:Add, Radio, y+10 vEULAradio Checked, I do not accept these binding documents
Gui, 1:Add, Radio,, I accept these binding documents
Gui, 1:Add, Button, y+10 Default gContinue_EULA, Continue
Gui, 1:Show, w720 Center, TechieCableUtilities Setup
Send, {Tab}{Tab}

; ***** OPTIONS GUI *****

Gui, 2:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 2:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 2:Add, Text, x+10 y10, TechieCableUtilites Setup
Gui, Font, s15
if (isUpdate = 1) {
	Gui, 2:Add, Text,, Update Options
} else {
	Gui, 2:Add, Text,, Install Options
}
Gui, Font
Gui, 2:Add, CheckBox, xp y180 vT_DesktopShortcut, Desktop Shortcut
Gui, 2:Add, CheckBox, vT_StartUp Checked, Add to startup (Recommended)
Gui, 2:Add, Button, y+10 Default gContinue_Options, Install

; ***** INSTALL GUI *****

Gui, 3:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 3:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 3:Add, Text, x+10 y10, TechieCableUtilites Setup
Gui, Font, s15
if (isUpdate = 1) {
	Gui, 3:Add, Text,, Updating TechieCableUtilities
} else {
	Gui, 3:Add, Text,, Installing TechieCableUtilities
}
Gui, Font
Gui, 3:Add, Progress, xp y200 w400 h20 c6A00A7 vSetupProgress, 0
if (isUpdate = 1) {
	Gui, 3:Add, Text, y+10 vinstallMessage, Preparing to update TechieCableUtilites...
} else {
	Gui, 3:Add, Text, y+10 vinstallMessage, Preparing to install TechieCableUtilites...
}

; ***** FINISH GUI *****

Gui, 4:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 4:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 4:Add, Text, x+10 y10, TechieCableUtilites Setup
Gui, Font, s15
if (isUpdate = 1) {
	Gui, 4:Add, Text,, TechieCableUtilities Updated
} else {
	Gui, 4:Add, Text,, TechieCableUtilities Installed
}
Gui, Font
Gui, 4:Add, CheckBox, xp y200 vT_LaunchTCU Checked, Launch TCU (Recommended)
Gui, 4:Add, CheckBox, vT_LaunchHelpFile, Launch the help file
Gui, 4:Add, Button, y+10 Default w80 +Center gFinish_Install, Finish
Gui, 4:Add, Text, y+30 +Center c6A00A7 gLaunchDirectory, Open the TechieCableUtilities Directory (Click here).

Run, %comspec% /c "del /Q %pic%`nexit",, Hide

; _________________________________________
; |              SCRIPT ENDS              |
; _________________________________________

exit

Continue_EULA:
	Gui, 1:Submit
	if (EULAradio = 1) {
		MsgBox, 262192, , TechieCableUtilities will not install because the EULA was not accepted.`nPlease run TCUSetup again if you wish to change your choice.
		ExitApp
	}
	if (EULAradio = 2) {
		Gui, 1:Destroy
		Gui, 2:Show, w620 Center, TechieCableUtilities Setup
	}
return

Continue_Options:
	Gui, 2:Submit
	Gui, 2:Destroy
	Gui, 3:Show, w620 Center, TechieCableUtilities Setup
	gosub, process_install
	Gui, 3:Destroy
	Gui, 4:Show, w620 Center, TechieCableUtilities Setup
return

process_install:	
	; ***** BACKUP FILES *****
	
	gosub, process_backup
	progressFunc("Attempting to backup files")
	
	; ***** CLOSE TCU *****
	
	IniRead, TechieCablePID, %dir%\TCU.ini, about, PID, CLOSED
	if %TechieCablePID% not contains CLOSED
	{
		Process, Close, %TechieCablePID%
		Process, WaitClose, %TechieCablePID%
	}
	IniRead, LauncherPID, %dir%\TCU.ini, about, LauncherPID, CLOSED
	if %LauncherPID% not contains CLOSED
	{
		Process, Close, %LauncherPID%
		Process, WaitClose, %LauncherPID%
	}
	progressFunc("Terminating running processes")
	
	; ***** DELETE OLD VERSION *****
	
	commands=
		(join&
		@echo off
		rmdir /s /q %dir%
	)
	Run, %comspec% /c %commands%,, Hide
	progressFunc("Removing old files")
	
	; ***** CREATE DIRECTORIES *****
	
	FileCreateDir, %dir%
	FileCreateDir, %dir%\data
	progressFunc("Creating directories")
	
	; ***** INSTALL FILES *****
	
	; Add the ahk file
	progressFunc("Installing ahk files")
	
	; Add the primary .exe
	FileInstall, TCU\TCULauncher.exe, %dir%\TCULauncher.exe, 1
	progressFunc("Installing launcher")
	
	; Add the TouchpadToggle .exe
	FileInstall, TCU\data\TouchpadToggle.exe, %dir%\data\TouchpadToggle.exe, 1
	progressFunc("Installing TouchpadToggle")
	
	; ***** RESTORE BACKUP FILES *****
	
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
	progressFunc("Attempting to restore backups")
	
	progressFunc("Wrapping up install")
return

process_backup:
	TCUiniEx=0
	AddonEx=0
	GosubEx=0
	SpecCharsEx=0

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
return

Finish_Install:
	Gui, 4:Submit
	; Launch TCU and the help file
	if (T_LaunchTCU = 1) {
		Run, %dir%\TCULauncher.exe
		if (T_LaunchHelpFile = 1) {
			Sleep, 5000
			Run, %dir%\TCUManual.html
		}
	}
	; If not launching TCU, open the directory instead
	if (T_LaunchTCU = 0 && T_LaunchHelpFile = 1) {
		Gosub, LaunchDirectory
	}
	; Create a desktop shortcut
	if (T_DesktopShortcut = 1) {
		FileCreateShortcut, %dir%\TCULauncher.exe, %A_Desktop%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,
	}
	; Add to startup
	if (T_StartUp = 1) {
		FileCreateShortcut, %dir%\TCULauncher.exe, %A_Startup%\TechieCableUtilities.lnk, %dir%, , TechieCable's Useful Utilities in One! (Launches TCU), %dir%\TCULauncher.exe, , ,
	}
	; Remove TCUSetup.exe from the desktop
	commands=
		(join&
		timeout /t 2 /nobreak>nul
		del /Q %A_Desktop%\TCUSetup.exe
	)
	Run, %comspec% /c "%commands%",, Hide
	Run, %comspec% /c "del /Q %pic%`nexit",, Hide
	ExitApp
return

LaunchDirectory:
	Run, %dir%
return

GuiClose:
GuiEscape:
2GuiClose:
2GuiEscape:
3GuiClose:
3GuiEscape:
4GuiClose:
4GuiEscape:
ExitApp

RELOAD:
	Reload
return
EXIT:
	ExitApp
return
