if A_Args.Length() != 1 {
    MsgBox % "This script requires one parameter but it received " A_Args.Length() "."
    ExitApp
} else {
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . A_Args[1],, UseErrorLevel
	ExitApp
}
