version = 1.0.4

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
touchpadEnabled := False ; Assume so on start

; Write the PID to the .ini - used to operate on the process
IniWrite, % DllCall("GetCurrentProcessId"), TCU.ini, about, PID

; ******************** CUSTOM FILES ********************

#Include *i addon.txt

; ******************** Check TCU.ini ********************

FileRead, lastFileContent, TCU.ini
setTimer, checkFile, 10000

; ******************** LOAD CONFIG ********************

; Load the config on start
IniRead, AOTCONFIG, TCU.ini, config, AOT, 1 ; Is AOT turned on?
IniRead, TouchPadCONFIG, TCU.ini, config, TouchPad, 1 ; Is TouchPad turned on?
IniRead, SpecCharsCONFIG, TCU.ini, config, SpecChars, 0 ; Is SpecChars turned on?

; Load permanently disabled items on start
IniRead, disable_AOT, TCU.ini, disabled, disable_AOT, "FALSE" ; Is AOT disabled?
IniRead, disable_TouchPad, TCU.ini, disabled, disable_TouchPad, "FALSE" ; Is TouchPad disabled? 

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
Menu, Tray, Icon, TechieCableUtilities, TCULauncher.exe, 1, 1
Menu, Tray, Icon, TechieCableUtilities, %A_IconFile%, %A_IconNumber%
Menu, Tray, Add

; Primary Tray Menu
Menu, Tray, Add
Menu, Tray, Add, Options (Hotkeys), :OptionsMenu ; Add the Options sub-menu
Menu, Tray, Add
Menu, Tray, NoStandard ; Remove default AHK tray menu buttons
Menu, Tray, Add, TouchPadToggle, TouchPadAction
Menu, Tray, Add
Menu, Tray, Add, Open Script Directory, OpenDirectory
Menu, Tray, Add
Menu, Tray, Add, Reload, RELOAD ; Add a reload button
Menu, Tray, Add, Exit, EXIT ; Add an exit button

; Other Tray Menu Things
Menu, Tray, Default, Options (Hotkeys) ; Set the options menu to the default
Menu, Tray, Icon, Options (Hotkeys), settings_cog.ico
Menu, Tray, Tip, TechieCableUtilities ; Tooltip

; ******************** CHECK MARKS & DISABLED ITEMS ********************

; Set the Check on start
if (AOTCONFIG = 1)
{
	MENU, OptionsMenu, Check, AlwaysOnTop ; AOT checkmark
}
if (TouchPadCONFIG = 1)
{
	MENU, OptionsMenu, Check, TouchPad ; TouchPad checkmark
}
if (SpecCharsCONFIG = 1)
{
	Menu, OptionsMenu, Check, SpecChars ; SpecChars checkmark
}

; Disable Menu Items
if (disable_AOT = "TRUE")
{
	AOTCONFIG := 0
	MENU, OptionsMenu, Disable, AlwaysOnTop
	IniWrite, %AOTCONFIG%, TCU.ini, config, AOT
}
if (disable_TouchPad = "TRUE")
{
	TouchPadCONFIG := 0
	MENU, OptionsMenu, Disable, TouchPad
	MENU, Tray, Disable, TouchPadToggle
	IniWrite, %TouchPadCONFIG%, TCU.ini, config, TouchPad
}

; ******************** HOTKEY ACTIONS ********************

; Only perform actions when set to "on"
#IF (AOTCONFIG = 1)
	^!+Space::Winset, Alwaysontop, , A
#IF TouchPadCONFIG = 1
	^F2::Gosub, TouchPadAction
if (SpecCharsCONFIG = 1) {
	Gosub, SpecCharsAction
}
#IF

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
return

; Set checkmark, write to .ini file for TouchPad
TouchPadCONFIG:
	TouchPadCONFIG := !TouchPadCONFIG
	MENU, OptionsMenu, ToggleCheck, TouchPad
	IniWrite, %TouchPadCONFIG%, TCU.ini, config, TouchPad
	FileRead, lastFileContent, TCU.ini
return

SpecCharsCONFIG:
	SpecCharsCONFIG := !SpecCharsCONFIG
	MENU, OptionsMenu, ToggleCheck, SpecChars
	IniWrite, %SpecCharsCONFIG%, TCU.ini, config, SpecChars
	FileRead, lastFileContent, TCU.ini
return

; ******************** OTHER ACTIONS ********************

TouchPadAction:
	Run % "SystemSettingsAdminFlows.exe EnableTouchPad " . (touchpadEnabled := !touchpadEnabled),, UseErrorLevel
	MENU, Tray, ToggleCheck, TouchPadToggle
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
	#Include *i gosub.txt
return

; ******************** GENERAL FUNCTIONS ********************

OpenDirectory:
	Run, %A_scriptdir%
return
exit
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
		#Include *i SpecChars.txt
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
