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

; Run TechieCableUtilities
Run %A_scriptdir%\ahk.zip\AutoHotkeyA32.exe %A_scriptdir%\TechieCableUtilities.ahk

ExitApp
