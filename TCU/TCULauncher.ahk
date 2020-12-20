version = 1.0.9
; WRITTEN BY TECHIECABLE

setworkingdir, %A_scriptdir%
#NoTrayIcon

OnError("ErrorFunc")
ErrorFunc() {
	MsgBox, 0, TCULauncher ERROR, An error prevented TCULauncher from initializing correctly. Please try again.
	ExitApp
	return false
}

SetTimer, Terminate, 60000

; ***** INI READ *****

IniRead, disable_loading, TCU.ini, disabled, disable_loading, 0
IniRead, TechieCablePID, TCU.ini, about, PID, CLOSED

; ***** STARTUP *****

if %TechieCablePID% not contains CLOSED
{
	Process, Close, %TechieCablePID%
	Process, WaitClose, %TechieCablePID%
}

if (disable_loading = 1)
{
	Gui, New, +AlwaysOnTop ToolWindow -Border -Caption, TCULauncher
	Gui, Margin, 0, 0
	try {
		pic := "https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/TCU/data/TCUico.gif"
		Gui, Add, ActiveX, w60 h60, % "mshtml:<img width=60px src='" pic "' />"
	} catch {
		Gui, Add, Picture,, TCULauncher.exe
	}
	Gui, Show, AutoSize x-10 y-10, TCULauncher
	WinSet, TransColor, FFFFFF, TCULauncher
} else {
	GUI, New, +AlwaysOnTop -Border, TCULauncher
	Gui, Margin, 0, 0
	Gui, Add, Progress, w230 h50 c6A00A7 vLaunchProgress, 0
	Gui, Add, Text, vlaunchMessage, Preparing to launch TechieCableUtilities...
	Gui, Show, AutoSize Center, TCULauncher
}

; progressupdates_start
Sleep, 100
Random, rand, 0, 20
GuiControl, Text, launchMessage, Beginning launch sequence...
GuiControl,, LaunchProgress, +%rand%
; progressupdates_end

; ***** DOWNLOADS *****

; Download AHK
if !FileExist("ahk.zip")
{
	UrlDownloadToFile, https://www.autohotkey.com/download/ahk.zip, data\ahk.zip
}

; progressupdates_start
Sleep, 100
Random, rand, 0, 20
GuiControl, Text, launchMessage, Checking for ahk files...
GuiControl,, LaunchProgress, +%rand%
; progressupdates_end

; Download TechieCableUtilities.ahk
UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, TechieCableUtilities.ahk

Gosub, update

; progressupdates_start
Sleep, 100
Random, rand, 0, 20
GuiControl, Text, launchMessage, Checking latest version...
GuiControl,, LaunchProgress, +%rand%
; progressupdates_end

; Install the settings_cog.ico and TCU.rtf
FileInstall, data\settings_cog.ico, data\settings_cog.ico, False
FileInstall, TCU.rtf, TCU.rtf, True

; progressupdates_start
Sleep, 100
Random, rand, 0, 20
GuiControl, Text, launchMessage, Installing necessary files...
GuiControl,, LaunchProgress, +%rand%
; progressupdates_end

; Create TCU.ini if it does not exist
if !FileExist("TCU.ini")
{
	IniWrite, 1, TCU.ini, config, AOT
	IniWrite, 0, TCU.ini, config, TouchPad
	IniWrite, 0, TCU.ini, config, SpecChars
}

; progressupdates_start
Sleep, 100
Random, rand, 0, 20
GuiControl, Text, launchMessage, Updating user settings...
GuiControl,, LaunchProgress, +%rand%
; progressupdates_end

; Run TechieCableUtilities
Run %A_scriptdir%\data\ahk.zip\AutoHotkeyA32.exe %A_scriptdir%\TechieCableUtilities.ahk

; progressupdates_start
Sleep, 1000
GuiControl, Text, launchMessage, Completed launcher sequence...
GuiControl,, LaunchProgress, +100
; progressupdates_end

ExitApp

Terminate:
ExitApp

GuiClose:
ExitApp
GuiEscape:
ExitApp

update:
	FileReadLine, upVersion, TechieCableUtilities.ahk, 1
	upVersion := StrReplace(upVersion, "version = ","")
	if (upVersion != version)
	{
		MsgBox, 262177, Update for TechieCableUtilities, An update is available for TechieCableUtilities! Press OK to continue.`nPress Cancel to abort the update.
		IfMsgBox, Cancel
			return
		IfMsgBox, OK
			UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TCUSetup.exe, %A_Desktop%\TCUSetup.exe
			Run, %A_Desktop%\TCUSetup.exe "1"
			if %TechieCablePID% not contains CLOSED
			{
				Process, Close, %TechieCablePID%
				Process, WaitClose, %TechieCablePID%
			}
			ExitApp
	}
return
