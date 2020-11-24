version = 1.0.7
setworkingdir, %A_scriptdir%
#NoTrayIcon

OnError("ErrorFunc")
ErrorFunc() {
	MsgBox, 0, TCULauncher ERROR, An error prevented TCULauncher from initializing correctly. Please try again.
	ExitApp
	return false
}

SetTimer, Terminate, 300000

; ***** INI READ *****

IniRead, disable_loading, TCU.ini, disabled, disable_loading, 0
IniRead, TechieCablePID, TCU.ini, about, PID, CLOSED

; ***** STARTUP *****

if (disable_loading != 1) {
	; Add the loading screen for startup
	GUI, New, +AlwaysOnTop -Border, TCULauncher
	Gui, Add, Text, x1 y2 w230 h80 +Center, Loading TechieCableUtilities...
	Gui, Add, Progress, w230 h50 cBlue vLaunchProgress, 0
	Gui, Show, AutoSize Center, TCULauncher
}

if %TechieCablePID% not contains CLOSED {
	Process, Close, %TechieCablePID%
	Process, WaitClose, %TechieCablePID%
}

Sleep, 100
GuiControl,, LaunchProgress, +20

; ***** DOWNLOADS *****

; Download AHK
if !FileExist("ahk.zip") {
	UrlDownloadToFile, https://www.autohotkey.com/download/ahk.zip, data\ahk.zip
}

Sleep, 100
GuiControl,, LaunchProgress, +10

; Download TechieCableUtilities.ahk
UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, TechieCableUtilities.ahk

Gosub, update

Sleep, 100
GuiControl,, LaunchProgress, +20

; Install the settings_cog.ico and TCU.rtf
FileInstall, data\settings_cog.ico, data\settings_cog.ico, False
FileInstall, TCU.rtf, TCU.rtf, True

Sleep, 100
GuiControl,, LaunchProgress, +30

; Create TCU.ini if it does not exist
if !FileExist("TCU.ini") {
	IniWrite, 1, TCU.ini, config, AOT
	IniWrite, 0, TCU.ini, config, TouchPad
	IniWrite, 0, TCU.ini, config, SpecChars
}

Sleep, 100
GuiControl,, LaunchProgress, +20

; Run TechieCableUtilities
Run %A_scriptdir%\data\ahk.zip\AutoHotkeyA32.exe %A_scriptdir%\TechieCableUtilities.ahk

ExitApp

GuiClose:
ExitApp
GuiEscape:
ExitApp

Terminate:
	ExitApp
return

update:
	FileReadLine, upVersion, TechieCableUtilities.ahk, 1
	upVersion := StrReplace(upVersion, "version = ","")
	if (upVersion != version) {
		MsgBox, 262177, Update for TechieCableUtilities, An update is available for TechieCableUtilities! Press OK to continue.`nPress Cancel to abort the update.
		IfMsgBox, Cancel
			return
		IfMsgBox, OK
			UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TCUSetup.exe, %A_Desktop%\TCUSetup.exe
			Run, %A_Desktop%\TCUSetup.exe "1"
			if %TechieCablePID% not contains CLOSED {
				Process, Close, %TechieCablePID%
				Process, WaitClose, %TechieCablePID%
			}
			ExitApp
	}
return
