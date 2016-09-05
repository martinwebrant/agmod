;NSIS Setup Script

!define VER_MAJOR 6
!define VER_MINOR 5b2


;--------------------------------
;Configuration

OutFile ..\ag_${VER_MAJOR}${VER_MINOR}.exe
SetCompressor bzip2

InstType "Full (w/ Source and Contrib)"
InstType "Normal (w/ Contrib, w/o Source)"
InstType "Lite (w/o Source or Contrib)"

ShowInstDetails show
ShowUninstDetails show
SetDateSave on

InstallDir $PROGRAMFILES\NSIS
InstallDirRegKey HKLM SOFTWARE\NSIS ""

;--------------------------------
!ifndef CLASSIC_UI

  ;Include Modern UI Macro's
  !include "${NSISDIR}\Contrib\Modern UI\System.nsh"

  ;--------------------------------
  ;Modern UI Configuration

  ;Names
  !define MUI_PRODUCT "NSIS"
  !define MUI_VERSION "${VER_MAJOR}.${VER_MINOR} (CVS)"

  !define MUI_NAME "Nullsoft Install System ${MUI_VERSION}" ;Installer name

  ;Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
  ;Settings
  !define MUI_ABORTWARNING  
  
  !define MUI_HEADERBITMAP "${NSISDIR}\Contrib\Icons\modern-header.bmp"
  !define MUI_SPECIALBITMAP "${NSISDIR}\Contrib\Icons\modern-wizard nsis llama.bmp"

  !define MUI_COMPONENTSPAGE_SMALLDESC

  !define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Docs\index.html"
  !define MUI_FINISHPAGE_NOREBOOTSUPPORT
  
  ;--------------------------------
  ;Languages

  !define MUI_TEXT_WELCOME_INFO_TEXT "This wizard will guide you through the installation of NSIS, a scriptable win32 installer/uninstaller system that doesn't suck and isn't huge.\r\n\r\n\r\n"

  !insertmacro MUI_LANGUAGE "English"
  
  ;--------------------------------
  ;Reserve Files
  
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
  !insertmacro MUI_RESERVEFILE_SPECIALINI
  !insertmacro MUI_RESERVEFILE_SPECIALBITMAP
  
!endif

;--------------------------------
;Data

LicenseData license.txt

;--------------------------------
;Installer Sections

!define SF_SELECTED 1

Section "Core Files (required)" SecCore

  SetDetailsPrint textonly
  DetailPrint "Installing Core Files..."
  SetDetailsPrint listonly

  SectionIn 1 2 3 RO
  SetOutPath $INSTDIR
  File /r "ag"

SectionEnd

Section "Digital Head Up Display" SecHUD

  SetDetailsPrint textonly
  DetailPrint "Installing Digital Head Up Display..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR	
  File /r "Hud\ag"
SectionEnd

Section "Optimized Crosshairs" SecCrosshairs

  SetDetailsPrint textonly
  DetailPrint "Installing Optimized Crosshairs..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR
  File /r "Crosshairs\ag"
SectionEnd

Section "High FPS Models" SecModels

  SetDetailsPrint textonly
  DetailPrint "Installing High FPS Models..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
    SetOutPath $INSTDIR
    File /r "HighFps\ag"
SectionEnd


!ifndef NO_STARTMENUSHORTCUTS
Section "Start Menu + Desktop Shortcuts" SecIcons

  SetDetailsPrint textonly
  DetailPrint "Installing Start Menu + Desktop Shortcuts..."
  SetDetailsPrint listonly

!else
Section "Desktop Shortcut" SecIcons

  SetDetailsPrint textonly
  DetailPrint "Installing Desktop Shortcut..."
  SetDetailsPrint listonly

!endif
  SectionIn 1 2 3
  SetOutPath $INSTDIR
!ifndef NO_STARTMENUSHORTCUTS

	CreateDirectory "$SMPROGRAMS\Adrenaline Gamer"
    IfFileExists $INSTDIR\hl.exe CreateClient CreateServer
	CreateClient:
	CreateShortCut "$QUICKLAUNCH\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateServer:
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start Server (port 27015).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27015 +map datacore +maxplayers 12" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start CTF Server (port 27016).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27016 +map agctf_infinity +maxplayers 20 +servercfgfile server_ctf.cfg +mapcyclefile mapcycle_ctf.txt" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start LMS Server (port 27017).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27017 +map boot_camp +maxplayers 6 +servercfgfile server_lms.cfg" "$INSTDIR\ag\ag.ICO" 0

	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\AG Manual.lnk" "$INSTDIR\ag\docs\index.htm" "" "$INSTDIR\ag\ag.ICO" 0
!endif
  
    IfFileExists $INSTDIR\hl.exe CreateClientDesktop CreateServerDesktop
	CreateClientDesktop:
	CreateShortCut "$DESKTOP\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$DESKTOP\AG Manual.lnk" "$INSTDIR\ag\docs\index.htm" "" "$INSTDIR\ag\AG.ICO" 0
	CreateServerDesktop:
  
SectionEnd


Section -post

  ; When Modern UI is installed:
  ; * Always install the English language file
  ; * Always install default icons / bitmaps

  SectionGetFlags ${SecContribModernUI} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
	IntCmp $R0 ${SF_SELECTED} "" nomui nomui

      SetDetailsPrint textonly
      DetailPrint "Configurating Modern UI..."
      SetDetailsPrint listonly


    SectionGetFlags ${SecContribLang} $R0
    IntOp $R0 $R0 & ${SF_SELECTED}
    IntCmp $R0 ${SF_SELECTED} langfiles
	
	  SetOutPath "$INSTDIR\Contrib\Modern UI\Language files"
      File "..\Contrib\Modern UI\Language files\English.nsh"
    
    langfiles:
    
    SectionGetFlags ${SecContribGraphics} $R0
    IntOp $R0 $R0 & ${SF_SELECTED}
    IntCmp $R0 ${SF_SELECTED} graphics
    
      SetOutPath $INSTDIR\Contrib\Icons
      File "..\Contrib\Icons\modern-install.ico"
      File "..\Contrib\Icons\modern-uninstall.ico"
      File "..\Contrib\Icons\modern-wizard.bmp"
      
    graphics:
    
  nomui:
  
  SetDetailsPrint textonly
  DetailPrint "Creating Registry Keys..."
  SetDetailsPrint listonly

  SetOutPath $INSTDIR
  
  WriteRegStr HKLM SOFTWARE\NSIS "" $INSTDIR
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "UninstallString" "$INSTDIR\uninst-nsis.exe"
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayName" "Nullsoft Install System"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayIcon" "$INSTDIR\NSIS.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "DisplayVersion" "${MUI_VERSION}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "VersionMajor" "${VER_MAJOR}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "VersionMinor" "${VER_MINOR}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "NoModify" "1"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS" "NoRepair" "1"
  
!ifndef NO_STARTMENUSHORTCUTS
  IfFileExists $SMPROGRAMS\NSIS "" nofunshit

  SetDetailsPrint textonly
  DetailPrint "Creating Shortcuts..."
  SetDetailsPrint listonly

  IfFileExists $INSTDIR\Examples 0 +2
    CreateShortCut "$SMPROGRAMS\NSIS\NSIS Examples Directory.lnk" "$INSTDIR\Examples"

  IfFileExists "$INSTDIR\Source" 0 +2
    CreateShortCut "$SMPROGRAMS\NSIS\MakeNSIS project workspace.lnk" "$INSTDIR\source\makenssi.dsw"

  CreateDirectory $SMPROGRAMS\NSIS\Contrib\Source

  ; MakeNSISW
  CreateDirectory $SMPROGRAMS\NSIS\Contrib
    CreateShortCut "$SMPROGRAMS\NSIS\Contrib\MakeNSISW readme.lnk" "$INSTDIR\contrib\MakeNsisw\readme.txt"

  Push "MakeNSISW"
  Call AddWorkspaceToStartMenu

  ; ExDLL
  Push "ExDLL"
  Call AddWorkspaceToStartMenu

  ; InstallOptions
  Push "InstallOptions\Readme.html"
  Push "InstallOptions Readme"
  Call AddContribToStartMenu

  Push "InstallOptions\io.dsw"
  Push "Source\InstallOptions project workspace"
  Call AddContribToStartMenu

  ; ZIP2EXE
  IfFileExists "$INSTDIR\Bin\zip2exe.exe" 0 +2
    CreateShortCut "$SMPROGRAMS\NSIS\Contrib\ZIP 2 EXE converter.lnk" "$INSTDIR\Bin\zip2exe.exe"

  Push ZIP2EXE
  Call AddWorkspaceToStartMenu

  ; Modern UI
  Push "Modern UI\Readme.html"
  Push "Modern UI Readme"
  Call AddContribToStartMenu

  ; Splash
  Push Splash
  Call AddReadmeToStartMenu

  Push Splash
  Call AddWorkspaceToStartMenu

  ; Advanced splash
  Push AdvSplash
  Call AddReadmeToStartMenu

  Push AdvSplash
  Call AddWorkspaceToStartMenu

  ; NSISdl
  Push NSISdl
  Call AddReadmeToStartMenu

  Push NSISdl
  Call AddWorkspaceToStartMenu

  ; UserInfo
  Push UserInfo
  Call AddWorkspaceToStartMenu

  ; nsExec
  Push nsExec
  Call AddReadmeToStartMenu

  Push nsExec
  Call AddWorkspaceToStartMenu

  ; LangDLL
  Push LangDLL
  Call AddWorkspaceToStartMenu

  ; StartMenu
  Push StartMenu
  Call AddReadmeToStartMenu

  Push StartMenu
  Call AddWorkspaceToStartMenu

  ; BgImage
  Push BgImage
  Call AddReadmeToStartMenu

  Push BgImage
  Call AddWorkspaceToStartMenu

  ; Banner
  Push Banner
  Call AddReadmeToStartMenu

  Push Banner
  Call AddWorkspaceToStartMenu

  ; System
  Push System
  Call AddReadmeToStartMenu

  Push System\Source\System.sln
  Push "Source\System project workspace"
  Call AddContribToStartMenu
  
  ; VPatch
  Push "VPatch\Readme.html"
  Push "VPatch Readme"
  Call AddContribToStartMenu

  nofunshit:
!endif
  
  ; will only be removed if empty
  SetDetailsPrint none
  RMDir $INSTDIR\Contrib\Source
  SetDetailsPrint lastused

  Delete $INSTDIR\uninst-nsis.exe
  WriteUninstaller $INSTDIR\uninst-nsis.exe

  SetDetailsPrint both

SectionEnd

;--------------------------------
;Descriptions

!ifndef CLASSIC_UI

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} "The core files required to play Adrenaline Gamer"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecHUD} "The AG Head Up Display"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecModels} "High FPS weapon models"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCrosshairs} "Crosshairs made by www.tolon.net"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecIcons} "Adds icons to your start menu and your desktop for easy access"
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END
 
!endif

;--------------------------------
;Installer Functions

!macro secSelected SEC
  SectionGetFlags ${SEC} $R7
  IntOp $R7 $R7 & ${SF_SELECTED}
  IntCmp $R7 ${SF_SELECTED} 0 +2 +2
    IntOp $R0 $R0 + 1
!macroend

Function .onSelChange
  ;Plugins are linked to ExDLL
  StrCpy $R0 0
  !insertmacro secSelected ${SecContribSplashTS}
  !insertmacro secSelected ${SecContribBannerS}
  !insertmacro secSelected ${SecContribBgImageS}
  !insertmacro secSelected ${SecContribIOS}
  !insertmacro secSelected ${SecContribLangDLLS}
  !insertmacro secSelected ${SecContribnsExecS}
  !insertmacro secSelected ${SecContribNSISdlS}
  !insertmacro secSelected ${SecContribSplashS}
  !insertmacro secSelected ${SecContribStartMenuS}
  !insertmacro secSelected ${SecContribUserInfoS}
  !insertmacro secSelected ${SecContribDialerS}
  SectionGetFlags ${SecSrcEx} $R7
  StrCmp $R0 0 notRequired
    IntOp $R7 $R7 | ${SF_SELECTED}
    SectionSetFlags ${SecSrcEx} $R7
    SectionSetText ${SecSrcEx} "ExDLL Source (required)"
    Goto done
  notRequired:
    SectionSetText ${SecSrcEx} "ExDLL Source"
  done:
FunctionEnd

!ifndef NO_STARTMENUSHORTCUTS
Function AddContribToStartMenu
  Pop $0 ; link
  Pop $1 ; file
  IfFileExists $INSTDIR\Contrib\$1 0 +2
    CreateShortCut $SMPROGRAMS\NSIS\Contrib\$0.lnk $INSTDIR\Contrib\$1
FunctionEnd

Function AddWorkspaceToStartMenu
  Pop $0
  IfFileExists $INSTDIR\Contrib\$0\$0.dsw 0 done
    Push $0\$0.dsw
    Push "Source\$0 project workspace"
    Call AddContribToStartMenu
  done:
FunctionEnd

Function AddReadmeToStartMenu
  Pop $0
  IfFileExists $INSTDIR\Contrib\$0\$0.txt 0 +3
    Push $0\$0.txt
    Goto create
  IfFileExists $INSTDIR\Contrib\$0\Readme.txt 0 done
    Push $0\Readme.txt
  create:
    Push "$0 Readme"
    Call AddContribToStartMenu
  done:
FunctionEnd
!endif

;--------------------------------
;Uninstaller Section

Section Uninstall

  SetDetailsPrint textonly
  DetailPrint "Uninstalling NSI Development Shell Extensions..."
  SetDetailsPrint listonly

  IfFileExists $INSTDIR\makensis.exe skip_confirmation
    MessageBox MB_YESNO "It does not appear that NSIS is installed in the directory '$INSTDIR'.$\r$\nContinue anyway (not recommended)" IDYES skip_confirmation
    Abort "Uninstall aborted by user"
  skip_confirmation:
  ReadRegStr $1 HKCR ".nsi" ""
  StrCmp $1 "NSISFile" 0 NoOwn ; only do this if we own it
    ReadRegStr $1 HKCR ".nsi" "backup_val"
    StrCmp $1 "" 0 RestoreBackup ; if backup == "" then delete the whole key
      DeleteRegKey HKCR ".nsi"
    Goto NoOwn
    RestoreBackup:
      WriteRegStr HKCR ".nsi" "" $1
      DeleteRegValue HKCR ".nsi" "backup_val"
  NoOwn:

  ReadRegStr $1 HKCR ".nsh" ""
  StrCmp $1 "NSHFile" 0 NoOwn2 ; only do this if we own it
    ReadRegStr $1 HKCR ".nsh" "backup_val"
    StrCmp $1 "" 0 RestoreBackup2 ; if backup == "" then delete the whole key
      DeleteRegKey HKCR ".nsh"
    Goto NoOwn
    RestoreBackup2:
      WriteRegStr HKCR ".nsh" "" $1
      DeleteRegValue HKCR ".nsh" "backup_val"
  NoOwn2:

  SetDetailsPrint textonly
  DetailPrint "Deleting Registry Keys..."
  SetDetailsPrint listonly

  DeleteRegKey HKCR "NSISFile"
  DeleteRegKey HKCR "NSHFile"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\NSIS"
  DeleteRegKey HKLM SOFTWARE\NSIS

  SetDetailsPrint textonly
  DetailPrint "Deleting Files..."
  SetDetailsPrint listonly

  RMDir /r $SMPROGRAMS\NSIS
  Delete "$DESKTOP\Nullsoft Install System.lnk"
  Delete $INSTDIR\makensis.exe
  Delete $INSTDIR\makensisw.exe
  Delete $INSTDIR\makensis.htm
  Delete $INSTDIR\NSIS.exe
  Delete $INSTDIR\license.txt
  Delete $INSTDIR\uninst-nsis.exe
  Delete $INSTDIR\nsisconf.nsi
  Delete $INSTDIR\nsisconf.nsh
  RMDir /r $INSTDIR\Contrib
  RMDir /r $INSTDIR\Menu
  RMDir /r $INSTDIR\Source
  RMDir /r $INSTDIR\Bin
  RMDir /r $INSTDIR\Plugins
  RMDir /r $INSTDIR\Examples
  RMDir /r $INSTDIR\Include
  RMDir /r $INSTDIR\Docs
  RMDir $INSTDIR

  SetDetailsPrint both

SectionEnd
