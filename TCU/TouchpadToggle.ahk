#NoTrayIcon
if A_Args.Length() != 1 {
	InputBox, touchpadEnabled, TouchPadToggle, Enter 0 to turn off`, 1 to turn on
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . touchpadEnabled,, UseErrorLevel
    ExitApp
} else {
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . A_Args[1],, UseErrorLevel
	ExitApp
}
