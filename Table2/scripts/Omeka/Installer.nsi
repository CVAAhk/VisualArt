;UPDATE NAME ATTRIBUTE TO MATCH THE NAME OF THE FD PROJECT
!define NAME "OmekaTable2"  ;Assign project name w/out spaces
!define QT_APP "1" ;Uncomment if the project is a QT Quick application. Your file structure should have the QT application .exe in the Executable folder

;example folder structure
;Project Holder 
; -files
;----------Unity------------------
;	->App.exe
;	->App_Data
;----------QT Quick---------------
; 	->Executable
;		-->App.exe
;	->ApplicationContent
;---------------------------------
; -watchdog
; 	->WatchDog.exe
;	->watchdogconfig.xml
;---------------------------------


;--------------SETUP-------------------
;Include Modern UI
!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "winmessages.nsh"
!include "logiclib.nsh"

;Icon file
!define MUI_ICON "installer_icon.ico"

!ifdef QT_APP
	!define PATH "$INSTDIR\${NAME}\Executable";Use if using QtQuick
!else 
	!define PATH "$INSTDIR\${NAME}"
!endif

;Path to executable
!define EXE "${PATH}\${NAME}.exe" 
 
;Extra installation features
!define WATCHDOG_EXE "${PATH}\WatchDog.exe"
!define WATCHDOG_CONFIG "${PATH}\WatchDog-Config.lnk"
!define WATCHDOG_CONFIG_PATH "$DOCUMENTS\Ideum\WatchDog\${Name}"
!define WATCHDOG_CONFIG_FILE "${WATCHDOG_CONFIG_PATH}\watchdogconfig.xml"
!define WATCHDOG_PATH "\${WATCHDOG_EXE}"

;Dependency Installers
!define DEPENDECY_PATH "$INSTDIR\${Name}\dependencies"

; Installer attributes
AllowRootDirInstall true ; required to 'install' to root dir
ShowInstDetails show ; automatically show install details

; The name of the installer
Name "${NAME}"

; The file to write
OutFile "${NAME}_Installer.exe"

; The default installation directory
InstallDir "$PROGRAMFILES32\Ideum"

; Registry key to check for directory (so if you install again, it will overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${NAME}" "Install_Dir"

; Request application privileges for Windows Vista+
RequestExecutionLevel admin

;--------------MACROS------------------

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS

;WatchDog Page
;Page custom CheckWatchDog ExitWatchDogPage
!insertmacro MUI_PAGE_INSTFILES 

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start ${NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language
!insertmacro MUI_LANGUAGE "English"

;--------------------------------

;Variables
Var PIN_CODE
var PIN_INPUT
var dialog
var hwnd
var label
var INSTALL_WATCHDOG 

; The stuff to install
Section "Install ${NAME}" 

  ;Required
  SectionIn RO  
  
  ; Set output path to the installation directory.
  SetOutPath "$INSTDIR\${NAME}"
  
  ; Default path to exe
  StrCpy $0 "${EXE}"

  ;StrCpy $1 "${WATCHDOG_EXE}"
  
  ; Project files
  File /r "files\*"

;	${If} $INSTALL_WATCHDOG = "1"	
;		SetOutPath "${PATH}"
;		File "watchdog\WatchDog.exe"		
;		
;		;Create Watchdog config shortcut with commands
;		CreateShortcut "${PATH}\WatchDog-Config.lnk" "$1" "/c" "$INSTDIR\${NAME}\icon.ico" 0
		
;		SetOutPath "${WATCHDOG_CONFIG_PATH}"
;		File "watchdog\watchdogconfig.xml"
		
;		FileOpen $4 "$DOCUMENTS\Ideum\WatchDog\${Name}\watchdogpin.txt" w ; Generate pin code token
;		FileWrite $4 $PIN_CODE
;		FileClose $4 
;	${EndIf}

	; Write the installation path into the registry
	  WriteRegStr HKLM SOFTWARE\${NAME} "Install_Dir" "$INSTDIR"

	  ; Write the uninstall keys for Windows
	  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayName" "${NAME}"
	  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "UninstallString" "$INSTDIR\${NAME}\${NAME}_Uninstaller.exe"  
	  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoModify" 1
	  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoRepair" 1
	  WriteUninstaller "$INSTDIR\${NAME}\${NAME}_Uninstaller.exe"	
SectionEnd

;dependencies
;Section -Dependencies
;	SetOutPath "${DEPENDECY_PATH}"
;	File /r "dependencies\*" 	
	
;	ExecWait "${DEPENDECY_PATH}\K-Lite_Codec_Pack_1290_Basic.exe"
;	Goto kLiteDependency
;	kLiteDependency:	
	
;	ExecWait "${DEPENDECY_PATH}\vcredist_x64.exe"
;	Goto netDependency
;	netDependency:
	
;	RMDir /r ${DEPENDECY_PATH}
;SectionEnd

; Optional section to generate desktop shorcuts(can be disabled by the user)
Section "Desktop Shortcuts" DesktopShorcuts
	SetOutPath "${PATH}" 
	
	${If} $INSTALL_WATCHDOG = "1"	
		CreateShortcut "$DESKTOP\${NAME}.lnk" "$1" "" "$INSTDIR\${NAME}\icon.ico" 0
	${Else}
		CreateShortcut "$DESKTOP\${NAME}.lnk" "$0" "" "$INSTDIR\${NAME}\icon.ico" 0
	${EndIf}
SectionEnd
LangString ShortcutDesc ${LANG_ENGLISH} "Adds a shortcut to the desktop"

; Optional section to generate start up shortcuts(can be disabled by the user)
Section "Start Application on Startup" StartUpShortcuts
	SetOutPath "${PATH}"
	${If} $INSTALL_WATCHDOG = "1"
		CreateShortCut "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\${NAME}.lnk" "$1" "" "$INSTDIR\${NAME}\icon.ico" 0
	${Else}
		CreateShortCut "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\${NAME}.lnk" "$0" "" "$INSTDIR\${NAME}\icon.ico" 0
	${EndIf}
SectionEnd	
LangString StartupDesc ${LANG_ENGLISH} "Registers the application to automatically run on startup"

;Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${DesktopShorcuts} $(ShortcutDesc)
!insertmacro MUI_DESCRIPTION_TEXT ${StartUpShortcuts} $(StartupDesc)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
;--------------------------------

; Uninstaller
Section "Uninstall"

  ; Remove shortcuts and uninstaller
  Delete "$DESKTOP\${NAME}.lnk"
  Delete "$DESKTOP\${NAME} Image Directory.lnk"
  Delete "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\${NAME}.lnk"    


    ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
  DeleteRegKey HKLM SOFTWARE\${NAME}
  
  ; Remove installation directory
  RMDir /r "$INSTDIR"
  RMDir /r "${WATCHDOG_CONFIG_PATH}"
SectionEnd

;Launch shortcut on complete
Function LaunchLink
;${If} $INSTALL_WATCHDOG = "1"
;	ExecShell "" "${WATCHDOG_EXE}"
;${Else}
	ExecShell "" "$0"
;${EndIf}
FunctionEnd

;------------------------------------------------

;Component Functions
;Function CheckWatchDog
;	nsDialogs::Create 1018
;	StrCpy $INSTALL_WATCHDOG "1"
;	Pop $dialog
;	${NSD_CreateCheckbox} 0 0 50% 6% "Enable Kiosk Mode using WatchDog"
;		Pop $hwnd
;		${NSD_OnClick} $hwnd OnCheckbox
;
;	${NSD_Check} $hwnd
; 
;	${NSD_CreateLabel} 0% 15% 10% 10% "Pin Code"
;		Pop $label
;		EnableWindow $label 1
;			
;	${NSD_CreateText} 0% 25% 25% 10% "0000"
;		Pop $PIN_INPUT
;		EnableWindow $PIN_INPUT 1 # start out disabled
		
;	nsDialogs::Show
;FunctionEnd

Function OnCheckbox
Pop $hwnd
	${NSD_GetState} $hwnd $0
	${If} $0 == 1
		StrCpy $INSTALL_WATCHDOG "1"
		EnableWindow $PIN_INPUT 1
		EnableWindow $label 1
	${Else}
		StrCpy $INSTALL_WATCHDOG "0"
		EnableWindow $PIN_INPUT 0
		EnableWindow $label 0
	${EndIf}
FunctionEnd

Function ExitWatchDogPage
${NSD_GetText} $PIN_INPUT $PIN_CODE

StrLen $9 $PIN_CODE

${IfNot} $9 = 4
MessageBox mb_ok "Pin has to be 4 digits"
Abort
${EndIf} 

Push "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ `Â¬Â¦!$\"Â£$$%^&*()_-+={[]}:;@'~#<>,.?/\| $\t"
Push $PIN_CODE
Call StrCSpn
Pop $R0
StrCmp $R0 "" +3
MessageBox MB_OK|MB_ICONEXCLAMATION 'Pin must only be numbers'
Abort

FunctionEnd

;Helper Functions
Function StrCSpn
 Exch $R0 ; string to check
 Exch
 Exch $R1 ; string of chars
 Push $R2 ; current char
 Push $R3 ; current char
 Push $R4 ; char loop
 Push $R5 ; char loop
 
  StrCpy $R4 -1
 
  NextChar:
  StrCpy $R2 $R1 1 $R4
  IntOp $R4 $R4 - 1
   StrCmp $R2 "" StrOK
 
   StrCpy $R5 -1
 
   NextCharCheck:
   StrCpy $R3 $R0 1 $R5
   IntOp $R5 $R5 - 1
    StrCmp $R3 "" NextChar
    StrCmp $R3 $R2 0 NextCharCheck
     StrCpy $R0 $R2
     Goto Done
 
 StrOK:
 StrCpy $R0 ""
 
 Done:
 
 Pop $R5
 Pop $R4
 Pop $R3
 Pop $R2
 Pop $R1
 Exch $R0
FunctionEnd