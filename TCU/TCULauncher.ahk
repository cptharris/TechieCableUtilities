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

; ***** PROGRESS FUNC *****
progressFunc(message,min:=0,max:=20) {
	Sleep, 100
	Random, rand, %min%, %max%
	GuiControl, Text, launchMessage, %message%
	GuiControl,, LaunchProgress, +%rand%
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
	Gui, Color, White
	Gui, New, +AlwaysOnTop ToolWindow -Border -Caption, TCULauncher
	Gui, Margin, 0, 0
	try {
		pic := "https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/TCU/data/TCUico.gif"
		Gui, Add, ActiveX, w60 h60, % "mshtml:<img width=100% src='" pic "' />"
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

progressFunc("Beginning launch sequence")

progressFunc("Running v"version)

Gosub, update

progressFunc("Latest version v"versionNum)

; ***** DOWNLOADS *****

; Download AHK
if !FileExist("ahk.zip")
{
	UrlDownloadToFile, https://www.autohotkey.com/download/ahk.zip, data\ahk.zip
}

progressFunc("Checking for ahk files")

; Download TechieCableUtilities.ahk
FileInstall, TechieCableUtilities.ahk, %A_scriptdir%\TechieCableUtilities.ahk

; Install the settings_cog.ico and TCU.rtf
FileInstall, data\settings_cog.ico, data\settings_cog.ico, False
FileInstall, TCUManual.html, TCUManual.html, True

progressFunc("Installing necessary files")

; Create TCU.ini if it does not exist
if !FileExist("TCU.ini")
{
	IniWrite, 1, TCU.ini, config, AOT
	IniWrite, 0, TCU.ini, config, TouchPad
	IniWrite, 0, TCU.ini, config, SpecChars
}
IniWrite, %version%, TCU.ini, about, version

progressFunc("Updating user settings")

; Run TechieCableUtilities
Run %A_scriptdir%\data\ahk.zip\AutoHotkeyA32.exe %A_scriptdir%\TechieCableUtilities.ahk

Sleep, 900
progressFunc("Completed launcher sequence",100,100)

ExitApp

Terminate:
GuiClose:
GuiEscape:
ExitApp

update:
	URLDownloadToFile, https://api.github.com/repos/TechieCable/TechieCableUtilities/releases/latest, version.txt ; Get the file
	FileRead, versionText, version.txt ; Read the file
	RegExMatch(versionText, """tag_name"":""v(.*?)""", versionNum) ; Parse the file for version
	RegExMatch(versionText, """body"":""(.*?)""", versionMessage) ; Parse the file for message
	versionNum := versionNum1
	versionMessage := StrReplace(versionMessage1, "\r\n", "`n") ; Fix linebreaks
	Run %ComSpec% /c "del /q version.txt`nexit" ; Delete the file
	
	if (version != versionNum)
	{
		MsgBox, 262177, Update for TechieCableUtilities, An update is available for TechieCableUtilities! Press OK to continue.`nPress Cancel to abort the update.`n`nChangelog for v%versionNum%`n%versionMessage%`n`nYou currently have %version%.
		IfMsgBox, Cancel
			return
		IfMsgBox, OK
			UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TCUSetup.exe, %A_Desktop%\TCUSetup.exe
			Run, %A_Desktop%\TCUSetup.exe "--update"
			if %TechieCablePID% not contains CLOSED
			{
				Process, Close, %TechieCablePID%
				Process, WaitClose, %TechieCablePID%
			}
			ExitApp
	}
return
