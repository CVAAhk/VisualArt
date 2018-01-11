;UPDATE NAME ATTRIBUTE TO MATCH THE NAME OF THE FD PROJECT
!define NAME "OmekaTable2"  ;Assign project name w/out spaces

;--------------SETUP-------------------
;Include Modern UI
!include "MUI2.nsh"

!define MUI_PRODUCT "OmekaTable2 V.1.0.0"
!define MUI_FILE "savefile"
!define MUI_VERSION ""
!define MUI_BRANDINGTEXT "OmekaTable2 V.1.0.0"

;!define MUI_ICON "icon.ico"
;!define MUI_UNICON "icon.ico"
;!define MUI_SPECIALBITMAP "icon.bmp"

; Installer attributes
AllowRootDirInstall true ; required to 'install' to root dir
ShowInstDetails show ; automatically show install details

; The name of the installer
Name "${NAME}"

; The file to write
OutFile "${NAME}_Installer.exe"

; The default installation directory
InstallDir "C:\OmekaTable2"

; Registry key to check for directory (so if you install again, it will overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${NAME}" "Install_Dir"

; Request application privileges for Windows Vista+
RequestExecutionLevel admin

;--------------MACROS------------------

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_INSTFILES

;!define MUI_FINISHPAGE_RUN
;!define MUI_FINISHPAGE_RUN_TEXT "Start ${NAME}"
;!define MUI_FINISHPAGE_RUN_FUNCTION "StartApp"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language
!insertmacro MUI_LANGUAGE "English"
;--------------------------------

; Application and dependencies
Section "Install ${NAME}"
  StrCpy $INSTDIR "C:\OmekaTable2"
  ; Set output path to the installation directory.
  SetOutPath "$INSTDIR\${NAME}"

  File /r "OmekaTable2\*"


  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\${NAME} "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayName" "${NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "UninstallString" "$INSTDIR\${NAME}\${NAME}_Uninstaller.exe"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "NoRepair" 1
  WriteUninstaller "$INSTDIR\${NAME}\${NAME}_Uninstaller.exe"

SectionEnd



SectionGroup "Desktop Shortcuts"
	Section "!Core"
	SetOutPath "$INSTDIR\${NAME}\Executable"
	CreateShortCut "$DESKTOP\${NAME}.lnk" "$INSTDIR\${NAME}\Executable\OmekaTable2.exe"
	SectionEnd
SectionGroupEnd

SectionGroup "Start Menu Shortcuts"
	Section "!Core"
	SetOutPath "$INSTDIR\${NAME}\Executable"
	CreateShortCut "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\${NAME}.lnk" "$INSTDIR\${NAME}\Executable\OmekaTable2.exe"
	SectionEnd
SectionGroupEnd

Section "Uninstall"

  ; Remove shortcuts and uninstaller
  Delete "$DESKTOP\${NAME}.lnk"
  Delete "$APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\${NAME}.lnk"  
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
  DeleteRegKey HKLM SOFTWARE\${NAME}  

  ; Remove installation directory
  RMDir /r "$INSTDIR"

SectionEnd
