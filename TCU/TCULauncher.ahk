setworkingdir, %A_scriptdir%

; Add the loading screen for startup
GUI, New, +AlwaysOnTop -Border, TCULauncher
Gui, Add, Text, x1 y2 w230 h80 +Center, Loading TechieCableUtilities...
Gui, Add, Progress, w230 h50 cBlue vLaunchProgress, 0
Gui, Show, AutoSize Center, TCULauncher

; Download AHK
if !FileExist("ahk.zip") {
	UrlDownloadToFile, https://www.autohotkey.com/download/ahk.zip, ahk.zip
}

IniRead, TechieCablePID, TCU.ini, about, PID, CLOSED
if %TechieCablePID% not contains CLOSED
{
	Process, Close, %TechieCablePID%
	Process, WaitClose, %TechieCablePID%
}

; Download TechieCableUtilities.ahk
UrlDownloadToFile, https://github.com/TechieCable/TechieCableUtilities/releases/latest/download/TechieCableUtilities.ahk, TechieCableUtilities.ahk



UrlDownloadToFile, https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/TCU/TouchpadToggle.ahk, TouchpadToggle.ahk
UrlDownloadToFile, https://raw.githubusercontent.com/TechieCable/TechieCableUtilities/main/TCU/mouse.ico, mouse.ico

Run %A_scriptdir%\ahk.zip\compiler\ahk2exe.exe "/in T:\Program_Files\atom-portable\github\TechieCableUtilities\TCU\TouchpadToggle.ahk /icon T:\Program_Files\atom-portable\github\TechieCableUtilities\TCU\mouse.ico"

commands = 
	(join&
DEL TouchpadToggle.ahk
DEL mouse.ico
)
Run, %comspec% %commands%

Sleep, 100
GuiControl,, LaunchProgress, +50

; Install the settings_cog.ico and TCU.rtf
FileInstall, settings_cog.ico, settings_cog.ico, False
FileInstall, TCU.rtf, TCU.rtf, True

Sleep, 100
GuiControl,, LaunchProgress, +30

; Create TCU.ini if it does not exist
if !FileExist("TCU.ini")
{
	IniWrite, 1, TCU.ini, config, AOT
	IniWrite, 1, TCU.ini, config, TouchPad
	IniWrite, 0, TCU.ini, config, SpecChars
}

Sleep, 100
GuiControl,, LaunchProgress, +20

FileSetAttrib, +RH, ahk.zip

; Run TechieCableUtilities
Run %A_scriptdir%\ahk.zip\AutoHotkeyA32.exe %A_scriptdir%\TechieCableUtilities.ahk

ExitApp
