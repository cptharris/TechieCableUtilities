;@Ahk2Exe-SetCompanyName TechieCable
;@Ahk2Exe-SetCopyright (c) 2020-2021 TechieCable
;@Ahk2Exe-SetDescription TCU TouchpadToggle Process
;@Ahk2Exe-SetFileVersion 1.0.0.0
;@Ahk2Exe-SetInternalName TouchpadToggle
;@Ahk2Exe-SetName TouchpadToggle
;@Ahk2Exe-SetOrigFilename TouchpadToggle
;@Ahk2Exe-SetProductName TouchpadToggle
;@Ahk2Exe-SetProductVersion 1.0.0.0
;@Ahk2Exe-SetVersion 1.0.0.0
#NoTrayIcon
if A_Args.Length() != 1 {
	InputBox, touchpadEnabled, TouchPadToggle, Enter 0 to turn off`, 1 to turn on
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . touchpadEnabled,, UseErrorLevel
    ExitApp
} else {
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . A_Args[1],, UseErrorLevel
	ExitApp
}
