version = 1.0.13
; Copyright (c) TechieCable 2020-2021
;@Ahk2Exe-Let Version = %A_PriorLine~^version = (.+)$~$1%

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

dir := A_AppData . "\TechieCableUtilities"
setworkingdir %dir%
T_TEMP := A_Temp "\TCU.tmp"
#SingleInstance Force

; ***** ERROR PREP *****

#Include *i TCU\app\analytics.ahk

OnError("ErrorFunc")
ErrorFunc(e) {
	global
	Gui, Error:New, +Disabled, TechieCableUtilities Setup Error Reporter
	Gui, Error:Add, ActiveX, w0 h0 verror_analytics, Shell.Explorer
	error_analytics.silent := true
	Gui, Error:Show, w0 h0 x0 y0 Hide, TechieCableUtilities Setup Error Reporter
	
	exceptionText := "-----`n> " e.file " (" e.line ")`n> """ e.what """ threw the error:`n" e.message "`n" e.extra "`n-----"
	
	error_analytics.Navigate(analytics(exceptionText))
	Sleep 500
	Gui, Error:Submit
	Gui, Error:Destroy
	
	MsgBox, 262164, TCUSetup Error, An error prevented TCUSetup from installing correctly. An error report has been sent. TCUSetup will attempt to continue`, but you may need to run it again.`n`nPress "Yes" to view the error. Press "No" to continue.
	Gui, Error:Submit
	Gui, Error:Destroy
	IfMsgBox Yes
		return false
	return true
}

; ***** Process Parameters *****
isUpdate := 0
isCustomDir := 0
customDir := ""
for n, param in A_Args
{
	if InStr(param, "--update") {
		isUpdate := 1
	}
	if InStr(param, "--directory=") {
		isCustomDir := 1
		
		RegExMatch(param, "--directory=(.*)", customDir)
		customDir := customDir1
		Loop, Files, %customDir%
			customDir := A_LoopFileFullPath
	}
}

if (isUpdate = 0) {
	if FileExist("TCU.ini") {
		isUpdate := 1
	}
}

; ***** CUSTOM INSTALL DIRECOTORY FUNCTION *****

verifyDir(customDir, retry:=0) { ; returns 0 on success, 1 on failure, 2 on retry request
	global dir
	Gui +OwnDialogs
	
	if !FileExist(customDir "\") {
		if retry {
			MsgBox, 262197, TCUSetup, %customDir% does not exist. Click retry to enter a different directory. Click cancel to install to the default directory.`nBe sure not to include the trailing slash. Remember to reference the directory directly.
			IfMsgBox, Retry
				return 2
			return 1
		} else {
			MsgBox, 262192, TCUSetup, %customDir% does not exist. The default install folder will be used instead.`nBe sure not to include the trailing slash. Remember to reference the directory directly.
			return 1
		}
	}
	
	testFile := "test" A_NowUTC ".tmp"
	FileAppend, test, %customDir%\%testFile%
	Sleep, 200
	
	if !FileExist(customDir "\" testFile) {
		if retry {
			MsgBox, 262197, TCUSetup, TechieCableUtilities cannot access %customDir%. Click retry to enter a different directory. Click cancel to install to the default directory.`nBe sure not to include the trailing slash. Remember to reference the directory directly.
			IfMsgBox, Retry
				return 2
			return 1
		} else {
			MsgBox, 262192, TCUSetup, TechieCableUtilities cannot access %customDir%. The default install folder will be used instead.`nBe sure not to include the trailing slash. Remember to reference the directory directly.
			return 1
		}
	} else {
		FileDelete, %customDir%\%testFile%
		
		dir := StrReplace(customDir, "TechieCableUtilities")
		dir .= "\TechieCableUtilities"
		setworkingdir %dir%
		return 0
	}
}

; ***** CREATE SETUPWIZARD PIC *****
FileCreateDir, %T_TEMP%
pic := T_TEMP "\setupwizard.png"
URLDownloadToFile, https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/imgs/setupwizard.png, %pic%

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
Gui, 1:Add, Text, x+10 y10, TechieCableUtilities Setup
Gui, Font, s15
Gui, 1:Add, Text,, License && Privacy Policy
Gui, Font
Gui, 1:Add, Link, y+40, By installing, you are agreeing to the <a href="https://github.com/TechieCable/TechieCableUtilities/blob/main/LICENSE.md">License</a> and <a href="https://github.com/TechieCable/TechieCableUtilities/blob/main/PrivacyPolicy.md">Privacy Policy</a>.
Gui, 1:Add, Radio, y+10 vEULAradio Checked, I do not accept these binding documents
Gui, 1:Add, Radio,, I accept these binding documents
Gui, 1:Add, Button, y+10 Default gContinue_EULA, Continue
Gui, 1:Add, Button, y+20 gContinue_InfoSent, Data to Transmit
Gui, 1:Show, w720 Center, TechieCableUtilities Setup
Send, {Tab}{Tab}

; ***** OPTIONS GUI *****

Gui, 2:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 2:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 2:Add, Text, x+10 y10, TechieCableUtilities Setup
Gui, Font, s15
if (isUpdate = 1) {
	Gui, 2:Add, Text,, Update Options
} else {
	Gui, 2:Add, Text,, Install Options
}
Gui, Font
Gui, 2:Add, CheckBox, xp y180 vT_DesktopShortcut, Desktop Shortcut
Gui, 2:Add, CheckBox, vT_StartUp Checked, Add to startup (Recommended)
Gui, 2:Add, CheckBox, vT_TouchpadToggle Checked, Include TouchPadToggle.exe
Gui, 2:Add, Text, y+10, Install Directory:
Gui, 2:Add, Edit, r1 vT_CustomDir w300, %dir%
Gui, 2:Add, Button, y+10 Default gContinue_Options, Install

; ***** INSTALL GUI *****

Gui, 3:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 3:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 3:Add, Text, x+10 y10, TechieCableUtilities Setup
Gui, Font, s15
if (isUpdate = 1) {
	Gui, 3:Add, Text,, Updating TechieCableUtilities
} else {
	Gui, 3:Add, Text,, Installing TechieCableUtilities
}
Gui, Font
Gui, 3:Add, Progress, xp y200 w400 h20 c6A00A7 vSetupProgress, 0
if (isUpdate = 1) {
	Gui, 3:Add, Text, y+10 vinstallMessage, Preparing to update TechieCableUtilities...
} else {
	Gui, 3:Add, Text, y+10 vinstallMessage, Preparing to install TechieCableUtilities...
}

; ***** FINISH GUI *****

Gui, 4:New, +AlwaysOnTop, TechieCableUtilities Setup
Gui, Margin, 0, 0
Gui, 4:Add, Picture, x0 y0 w200 h-1, %pic%
Gui, Font, s20
Gui, 4:Add, Text, x+10 y10, TechieCableUtilities Setup
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
Gui, 4:Add, ActiveX, w0 h0 vinstall_analytics, Shell.Explorer
install_analytics.silent := true

Run, %comspec% /c "rmdir /s /q %T_TEMP%`nexit",, Hide

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

Continue_InfoSent:
	for n, param in A_Args
	{
		listArgs .= "(" n ") > " param "`n"
	}
	Gui +OwnDialogs
	MsgBox, 262144, Data to Transmit, % "The following data will be transmitted to monitor traffic and fix bugs:`n"
	. "Time and date: " . A_NowUTC . "`n"
	. "Script directory: " . A_ScriptDir . "`n"
	. "Working directory: " . A_WorkingDir . "`n"
	. "Script name: " . A_ScriptName . "`n"
	. "Computer name: " . A_ComputerName . "`n"
	. "isAdmin: " . A_IsAdmin . "`n"
	. "ErrorLevel: " . ErrorLevel . "`n"
	. "LastError: " . A_LastError . "`n"
	. "AhkVersion: " . A_AhkVersion . "`n"
	. "ProgVersion: " . version . "`n"
	. "OSVersion: " . A_OSVersion . "`n"
	. "64-bit OS: " . A_Is64bitOS . "`n"
	. "Args: " . listArgs
return

Continue_Options:
	Gui, 2:Submit
	verifyDirResult := verifyDir(T_CustomDir, 1)
	if (verifyDirResult = 2) {
		Gui, 2:Show
		return
	}
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
	if TechieCablePID not contains CLOSED
	{
		Process, Close, %TechieCablePID%
		Process, WaitClose, %TechieCablePID%
	}
	IniRead, LauncherPID, %dir%\TCU.ini, about, LauncherPID, CLOSED
	if LauncherPID not contains CLOSED
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
	FileCreateDir, %dir%\usr
	FileCreateDir, %dir%\app
	progressFunc("Creating directories")
	
	; ***** INSTALL FILES *****
	
	; Add the ahk file
	progressFunc("Installing ahk files")
	
	; Add the primary .exe
	FileInstall, TCU\TCULauncher.exe, %dir%\TCULauncher.exe, 1
	progressFunc("Installing launcher")
	
	
	if T_TouchpadToggle {
		; Add the TouchpadToggle .exe
		FileInstall, TCU\app\TouchpadToggle.exe, %dir%\app\TouchpadToggle.exe, 1
		progressFunc("Installing TouchpadToggle")
	}
	
	; ***** RESTORE BACKUP FILES *****
	
	installError := 0
	
	if (TCUiniEx=1) {
		FileAppend, %TCUiniContents%, TCU.ini
		if !FileExist("TCU.ini") {
			installError := 1
		}
	}
	if (AddonEx=1) {
		FileAppend, %AddonContents%, usr\addon.txt
		if !FileExist("usr\addon.txt") {
			installError := 1
		}
	}
	if (GosubEx=1) {
		FileAppend, %GosubContents%, usr\gosub.txt
		if !FileExist("usr\gosub.txt") {
			installError := 1
		}
	}
	if (SpecCharsEx=1) {
		FileAppend, %SpecCharsContents%, usr\SpecChars.txt
		if !FileExist("usr\SpecChars.txt") {
			installError := 1
		}
	}
	
	progressFunc("Attempting to restore backups")
	
	if !FileExist("TCULauncher.exe") || installError { ; if the installation failed
		Gui +OwnDialogs
		progressFunc("INSTALLATION FAILED")
		
		install_analytics.Navigate(analytics("-----`n> " A_LineFile " (" A_LineNumber ")`n> """ A_ThisLabel """ threw the error:`n" "INSTALLATION FAILED: TCULauncher or a user file was not restored. Backups will be attempted and the installation will restart." "`n-----"))
		
		MsgBox, 262160, INSTALLATION FAILED, TCULauncher or a user file was not restored. Backups will be attempted and the installation will restart.
		
		backupFolder := A_Desktop . "\TCUBackup"
		FileCreateDir %backupFolder%\usr
		
		if (TCUiniEx=1) {
			FileAppend, %TCUiniContents%, %backupFolder%\TCU.ini
		}
		if (AddonEx=1) {
			FileAppend, %AddonContents%, %backupFolder%\usr\addon.txt
		}
		if (GosubEx=1) {
			FileAppend, %GosubContents%, %backupFolder%\usr\gosub.txt
		}
		if (SpecCharsEx=1) {
			FileAppend, %SpecCharsContents%, %backupFolder%\usr\SpecChars.txt
		}
		
		for n, param in A_Args  ; For each parameter:
		{
			argumentList .= param " "
		}
		commands=
		(join& LTrim
			@echo off
			start %backupFolder%
			timeout /t 2 /nobreak>nul
			%A_ScriptFullPath% %argumentList%
			exit
		)
		Run, %comspec% /c "rmdir /s /q %T_TEMP%`nexit",, Hide
		Run, %comspec% /c %commands%,, Hide
		ExitApp
	}
	
	progressFunc("Wrapping up install")
	install_analytics.Navigate(analytics("0"))
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
	if FileExist("usr\addon.txt") {
		AddonEx=1
		FileRead, AddonContents, usr\addon.txt
	} else if FileExist("data\addon.txt") {
		SpecCharsEx=1
		FileRead, SpecCharsContents, data\addon.txt
	}
	if FileExist("usr\gosub.txt") {
		GosubEx=1
		FileRead, GosubContents, usr\gosub.txt
	} else if FileExist("data\gosub.txt") {
		GosubEx=1
		FileRead, GosubContents, data\gosub.txt
	}
	if FileExist("usr\SpecChars.txt") {
		SpecCharsEx=1
		FileRead, SpecCharsContents, usr\SpecChars.txt
	} else if FileExist("data\SpecChars.txt") {
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
	Run, %comspec% /c "rmdir /s /q %T_TEMP%`nexit",, Hide
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
