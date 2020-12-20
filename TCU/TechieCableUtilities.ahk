version = 1.0.9
; WRITTEN BY TECHIECABLE

; settings_cog.ico, TCU.rtf, and TCU.ini are created by TCULauncher
setworkingdir, %A_scriptdir%
#SingleInstance Force
#NoEnv
#Persistent

; ******************** STARTUP ********************

if (!A_IsCompiled) {
	Menu, Tray, Icon, TCULauncher.exe, 1, 1
}

IniWrite, %version%, TCU.ini, about, version

; Create variables
AOTCONFIG := 0
TouchPadCONFIG := 0
SpecCharsCONFIG := 0
touchpadEnabled := 0 ; Assume so on start

AOT_key=^!+Space
AOTMenu_key=^!+Up
TouchPad_key=^F2

; Write the PID to the .ini - used to operate on the process
IniWrite, % DllCall("GetCurrentProcessId"), TCU.ini, about, PID

; ******************** CUSTOM FILES ********************

#Include *i data\addon.txt

; ******************** Check TCU.ini ********************

FileRead, lastFileContent, TCU.ini
setTimer, checkFile, 10000

; ******************** LOAD CONFIG ********************

; Load the config on start
IniRead, AOTCONFIG, TCU.ini, config, AOT, 1 ; Is AOT turned on?
IniRead, TouchPadCONFIG, TCU.ini, config, TouchPad, 0 ; Is TouchPad turned on?
IniRead, SpecCharsCONFIG, TCU.ini, config, SpecChars, 0 ; Is SpecChars turned on?

; Load the hotkeys on start
IniRead, AOT_key, TCU.ini, hotkey, AOT_key, ^!+Space
IniRead, AOTMenu_key, TCU.ini, hotkey, AOTMenu_key, ^!+Up
IniRead, TouchPad_key, TCU.ini, hotkey, TouchPad_key, ^F2

; Load permanently disabled items on start
IniRead, disable_AOT, TCU.ini, disabled, disable_AOT, 0 ; Is AOT disabled?
IniRead, disable_TouchPad, TCU.ini, disabled, disable_TouchPad, 0 ; Is TouchPad disabled? 

; ******************** TRAY MENU ********************

; TopMenu
Menu, TopMenu, Add, Version v%version%, blank
Menu, TopMenu, Add, Website, Top_Web
Menu, TopMenu, Add, Remove TCU, Top_Remove

; OptionsMenu
Menu, OptionsMenu, Add, AlwaysOnTop, AOTCONFIG
Menu, OptionsMenu, Add, TouchPad, TouchPadCONFIG
Menu, OptionsMenu, Add, SpecChars, SpecCharsCONFIG

; Title of Tray Menu
Menu, Tray, Add, TechieCableUtilities, :TopMenu
Menu, Tray, Add

; Primary Tray Menu
Menu, Tray, Add, Options (Hotkeys), :OptionsMenu ; Add the Options sub-menu
Menu, Tray, Add, Hotkey Customizer, hotkeyGUI
Menu, Tray, Add
Menu, Tray, NoStandard ; Remove default AHK tray menu buttons
Menu, Tray, Add, TouchPadToggle, TouchPadAction
Menu, Tray, Add
Menu, Tray, Add, Open Script Directory, OpenDirectory
Menu, Tray, Add
Menu, Tray, Add, Reload, RELOAD ; Add a reload button
Menu, Tray, Add, Exit, EXIT ; Add an exit button

; Other Tray Menu Things
Menu, Tray, Default, TechieCableUtilities ; Set the default menu
Menu, Tray, Icon, Options (Hotkeys), data\settings_cog.ico
Menu, Tray, Tip, TechieCableUtilities (v%version%) ; Tooltip

; ******************** CHECK MARKS & DISABLED ITEMS ********************

; Set the Check on start
if (AOTCONFIG = 1) {
	MENU, OptionsMenu, Check, AlwaysOnTop ; AOT checkmark
}
if (TouchPadCONFIG = 1) {
	MENU, OptionsMenu, Check, TouchPad ; TouchPad checkmark
}
if (SpecCharsCONFIG = 1) {
	Menu, OptionsMenu, Check, SpecChars ; SpecChars checkmark
}

; Disable Menu Items
if (disable_AOT = 1) {
	AOTCONFIG := 0
	MENU, OptionsMenu, Disable, AlwaysOnTop
	IniWrite, %AOTCONFIG%, TCU.ini, config, AOT
}
if (disable_TouchPad = 1) {
	TouchPadCONFIG := 0
	MENU, OptionsMenu, Disable, TouchPad
	MENU, Tray, Disable, TouchPadToggle
	IniWrite, %TouchPadCONFIG%, TCU.ini, config, TouchPad
}

; ******************** HOTKEY ACTIONS ********************

; Only perform actions when set to "on"
if (AOTCONFIG = 1) {
	Hotkey, %AOT_key%, AOTAction, On
	Hotkey, %AOTMenu_key%, AOTMenuAction, On
}
if (TouchPadCONFIG = 1) {
	Hotkey, %TouchPad_key%, TouchPadAction, On
}
if (SpecCharsCONFIG = 1) {
	Gosub, SpecCharsAction
}

; ---------------------------------------------------------
; |*******************************************************|
; |******************** END OF SCRIPT ********************|
; |*******************************************************|
; ---------------------------------------------------------
exit

; ******************** OPTIONSMENU ACTIONS ********************

; Set checkmark, write to .ini file for AOT
AOTCONFIG:
	AOTCONFIG := !AOTCONFIG
	MENU, OptionsMenu, ToggleCheck, AlwaysOnTop
	IniWrite, %AOTCONFIG%, TCU.ini, config, AOT
	FileRead, lastFileContent, TCU.ini
	
	if (AOTCONFIG = 1) {
		Hotkey, %AOT_key%, AOTAction, On
		Hotkey, %AOTMenu_key%, AOTMenuAction, On
	} else {
		Hotkey, %AOT_key%, AOTAction, Off
		Hotkey, %AOTMenu_key%, AOTMenuAction, Off
	}
return

; Set checkmark, write to .ini file for TouchPad
TouchPadCONFIG:
	TouchPadCONFIG := !TouchPadCONFIG
	MENU, OptionsMenu, ToggleCheck, TouchPad
	IniWrite, %TouchPadCONFIG%, TCU.ini, config, TouchPad
	FileRead, lastFileContent, TCU.ini
	
	if (TouchPadCONFIG = 1) {
		Hotkey, %TouchPad_key%, TouchPadAction, On
	} else {
		Hotkey, %TouchPad_key%, TouchPadAction, Off
	}
return

SpecCharsCONFIG:
	SpecCharsCONFIG := !SpecCharsCONFIG
	MENU, OptionsMenu, ToggleCheck, SpecChars
	IniWrite, %SpecCharsCONFIG%, TCU.ini, config, SpecChars
	FileRead, lastFileContent, TCU.ini
return

; ******************** OTHER ACTIONS ********************

AOTAction:
	Winset, Alwaysontop, , A
return

AOTMenuAction:
	try {
		Menu, AOTMenu, DeleteAll
	}
	MenuFunction := func("AOTFunction")
	Menu, AOTMenu, Add, AlwaysOnTop Selector, Blank
	Menu, AOTMenu, Add
	WinGet windows, List
	Loop %windows% {
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		if (wt != "") {
			Menu, AOTMenu, Add, %wt%, % MenuFunction
		}
	}
	Menu, AOTMenu, Add
	Menu, AOTMenu, Add, Choose ^^ to pin, Blank
	Menu, AOTMenu, Show
	AOTFunction(ItemName) {
		WinSet, AlwaysOnTop, Toggle, % ItemName
	}
return

TouchPadAction:
	; Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . (touchpadEnabled := !touchpadEnabled),, UseErrorLevel
	touchpadEnabled := !touchpadEnabled
	Run, data\TouchpadToggle.exe %touchpadEnabled%
	MENU, Tray, ToggleCheck, TouchPadToggle
return

hotkeyGUI:
	Hotkey, %AOT_key%, Off
	Hotkey, %AOTMenu_key%, Off
	Hotkey, %TouchPad_key%, Off
	Gui, New, +AlwaysOnTop, TCU Hotkey Customizer
	Gui, Add, Text, x2 y10 w100 h20, AlwaysOnTop
	Gui, Add, Hotkey, x2 y30 w150 h30 vAOT_key, %AOT_key%
	Gui, Add, Text, x2 y60 w100 h20, AOT Menu
	Gui, Add, Hotkey, x2 y80 w150 h30 vAOTMenu_key, %AOTMenu_key%
	Gui, Add, Text, x2 y110 w100 h20, TouchPad
	Gui, Add, Hotkey, x2 y130 w150 h30 vTouchPad_key, %TouchPad_key%
	Gui, Add, Button, x2 y165 w50 h20 Default gsubmitHotkey, Submit
	Gui, Add, Button, x55 y165 w50 h20 gcancelHotkey, Cancel
	Gui, Show, AutoSize Center
return

submitHotkey:
	Gui, Submit
	Gui, Destroy
	if (AOT_key = "") {
		AOT_key=^!+Space
	}
	if (AOTMenu_key = "") {
		AOTMenu_key=^!+Up
	}
	if (TouchPad_key = "") {
		TouchPad_key=^F2
	}
	IniWrite, %AOT_key%, TCU.ini, hotkey, AOT_key
	IniWrite, %AOTMenu_key%, TCU.ini, hotkey, AOTMenu_key
	IniWrite, %TouchPad_key%, TCU.ini, hotkey, TouchPad_key
	Gosub, RELOAD
	; Hotkey, %AOT_key%, AOTAction, On
	; Hotkey, %AOTMenu_key%, AOTMenuAction, On
	; Hotkey, %TouchPad_key%, TouchPadAction, On
return
cancelHotkey:
	Gui, Destroy
return

checkFile:
	FileRead, newFileContent, TCU.ini
	if (newFileContent != lastFileContent) {
		lastFileContent := newFileContent
		MsgBox, 36, Reload TCU, It looks like you just changed TCU.ini!`nWould you like to reload TechieCableUtilities?, 20
		IfMsgBox, Yes
			Gosub, RELOAD
		IfMsgBox, No
			return
		IfMsgBox, Timeout
			Gosub, RELOAD
	}
return

; ***** CUSTOM SCRIPT *****
addon:
	#Include *i data\gosub.txt
return

; ******************** GENERAL FUNCTIONS ********************

OpenDirectory:
	Run, %A_scriptdir%
return

RELOAD:
	Reload
exit

EXIT:
	IniWrite, CLOSED, TCU.ini, about, PID
	ExitApp
exit

Blank:
return

; ******************** SPECIAL CHARACTERS ********************

SpecCharsAction:
	#EscapeChar |
	#Hotstring ?C
	#IF (SpecCharsCONFIG = 1)
		;Spanish Characters
		:*:`a::{U+00e1}
		:*:`e::{U+00e9}
		:*:`i::{U+00ed}
		:*:`o::{U+00f3}
		:*:`u::{U+00fa}
		:*:`n::{U+00f1}
		:*:`u::{U+00fc}
		:*:`A::{U+00c1}
		:*:`E::{U+00c9}
		:*:`I::{U+00cd}
		:*:`O::{U+00d3}
		:*:`U::{U+00da}
		:*:`N::{U+00d1}
		:*:`?::{U+00bf}
		:*:`!::{U+00a1}
		;Superscripts
		:*:^1::{U+00B9}
		:*:^2::{U+00B2}
		:*:^3::{U+00B3}
		:*:^4::{U+2074}
		:*:^5::{U+2075}
		:*:^6::{U+2076}
		:*:^7::{U+2077}
		:*:^8::{U+2078}
		:*:^9::{U+2079}
		:*:^0::{U+2070}
		;Math operators
		:*:`*::{U+00D7}
		:*:`/::{U+00F7}
		:*:`+-::{U+00B1}
		:*:`~=::{U+2248}
		:*:`<=::{U+2264}
		:*:`>=::{U+2265}
		#Include *i data\SpecChars.txt
		#EscapeChar `
	#If
return

; ******************** TOPMENU FUNCTIONS ********************
Top_Web:
	Run https://techiecable.github.io
return
Top_Remove:
	commands=
	(join&
@echo off
cd ..
timeout /t 2 /nobreak>nul
rmdir /s /q "TechieCableUtilities"
	)
	Run, %comspec% /c %commands%
	ExitApp
return
