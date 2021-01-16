version = 0.1.0.10
; WRITTEN BY TECHIECABLE
;@Ahk2Exe-Let Version = %A_PriorLine~^version = (.+)$~$1%

dir := appdata . "\TechieCableUtilities"
setworkingdir %dir%

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

LICENSETEXT =
(
End-User License Agreement (EULA) of TechieCableUtilities

This End-User License Agreement ("EULA") is a legal agreement between you and TechieCable.

This EULA agreement governs your acquisition and use of our TechieCableUtilities software ("Software") directly from TechieCable or indirectly through a TechieCable authorized reseller or distributor (a "Reseller").

Please read this EULA agreement carefully before completing the installation process and using the TechieCableUtilities software. It provides a license to use the TechieCableUtilities software and contains warranty information and liability disclaimers.

If you register for a free trial of the TechieCableUtilities software, this EULA agreement will also govern that trial. By clicking "I accept the EULA" or installing and/or using the TechieCableUtilities software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.

If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.

TechieCable may at any time change the terms of this EULA without any notice given to you. By using the Software, you are agreeing to become bound by the terms of any future terms of the EULA.

This EULA agreement shall apply only to the Software supplied by TechieCable herewith regardless of whether other software is referred to or described herein. The terms also apply to any TechieCable updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.

License Grant

TechieCable hereby grants you a personal, non-transferable, non-exclusive license to use the TechieCableUtilities software on your devices per the terms of this EULA agreement.

You are permitted to load the TechieCableUtilities software (for example a PC, laptop, mobile, or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the TechieCableUtilities software.

You are not permitted to:

 - Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
 - Reproduce, copy, distribute, resell, or otherwise use the Software for any commercial purpose
 - Allow any third party to use the Software on behalf of or for the benefit of any third party
 - Use the Software in any way which breaches any applicable local, national or international law
 - Use the Software for any purpose that TechieCable considers is a breach of this EULA agreement

Intellectual Property and Ownership

TechieCable shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of TechieCable.

TechieCable retains the right to use feedback or suggestions from you in the Software without credit or compensation given to you in any form. Such additions shall become the property of TechieCable.

TechieCable reserves the right to grant licenses to use the Software to third parties.

Termination

This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to TechieCable.

It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.

Governing Law

This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed under the laws of the United States.
)

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
Gui, 1:Add, Text,, License
Gui, Font
Gui, 1:Add, Edit, xp y150 h100 w500 ReadOnly, %LICENSETEXT%
Gui, 1:Add, Radio, y+10 vEULAradio Checked, I do not accept the EULA
Gui, 1:Add, Radio,, I accept the EULA
Gui, 1:Add, Button, y+10 Default gContinue_EULA, Continue
Gui, 1:Show, w720 Center, TechieCableUtilities Setup
Send, {Tab}

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

Run, %comspec% /c "del /Q %pic%`nexit"

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
	progressFunc("Terminating running processes")
	
	; ***** DELETE OLD VERSION *****
	
	commands=
		(join&
		@echo off
		rmdir /s /q %dir%
	)
	Run, %comspec% /c %commands%
	progressFunc("Removing old files")
	
	; ***** CREATE DIRECTORIES *****
	
	FileCreateDir, %dir%
	FileCreateDir, %dir%\data
	progressFunc("Creating directories")
	
	; ***** INSTALL FILES *****
	
	; Add the ahk file
	; UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, %dir%\TechieCableUtilities.ahk
	progressFunc("Installing ahk files")
	
	; Add the primary .exe
	FileInstall, T:\Program_Files\AutoHotkey\Projects\TechieCableUtilities\TCU\TCULauncher.exe, %dir%\TCULauncher.exe, 1
	progressFunc("Installing launcher")
	
	; Add the TouchpadToggle .exe
	FileInstall, T:\Program_Files\AutoHotkey\Projects\TechieCableUtilities\TCU\data\TouchpadToggle.exe, %dir%\data\TouchpadToggle.exe, 1
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
	Run, %comspec% /c "%commands%"
	Run, %comspec% /c "del /Q %pic%`nexit"
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
