; bzip2 is a lot smaller
SetCompressor bzip2


;--------------------------------
;Product Info
!define VER_MAJOR 6
!define VER_MINOR 6
!define VER_MICRO 0
!define VER_BUILD 0
!define VER_DISPLAY "6.6 STEAM"
!define VER_BETA "STEAM"
!define GAMEDIR "ag"
!define STEAMDIR ""

Name "Adrenaline Gamer" ;Define your own software name here
Caption "Adrenaline Gamer ${VER_DISPLAY} Setup"
BrandingText "bullit@planethalflife.com"

 !include "MUI.nsh"

 
;--------------------------------
;Configuration
 
   ;General
   OutFile "ag_${VER_MAJOR}${VER_MINOR}${VER_BETA}.exe"

  ;Folder selection page
   InstallDir "$PROGRAMFILES"

;Remember install folder
InstallDirRegKey HKCU "Software\Adrenaline Gamer" ""

; Detail colors
InstallColors FFFF00 8F8F8F

; The icon of installer
Icon "install.ico"

; Show details when installation
ShowInstDetails show

; Write over current files.
SetOverwrite on

;--------------------------------
;Pages
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

 !define MUI_ABORTWARNING

 
;--------------------------------
 ;Language
 
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------
 ;Language Strings
 
  ;Descriptions
 LangString DESC_SecCore ${LANG_English} "Adrenaline Gamer Core"
 LangString DESC_SecCTF ${LANG_English} "Adds Capture The Flag maps"
 LangString DESC_SecHUD ${LANG_English} "Adds Digital Head Up Display"
 LangString DESC_SecCrosshairs ${LANG_English} "Adds www.tolon.net Crosshairs"
 LangString DESC_SecModels ${LANG_English} "Adds High FPS weapon models"
 LangString DESC_SecMaps ${LANG_English} "Adds additional maps"
 LangString DESC_SecSkin ${LANG_English} "Adds skin"
 LangString DESC_SecShortcuts ${LANG_English} "Adds icons to your start menu and your desktop for easy access"
 LangString DESC_SecUninstall ${LANG_English} "Adds uninstaller"
;Data

 
;--------------------------------

;Installer Sections
     
Section "Core Files (required)" SecCore

  SetDetailsPrint textonly
  DetailPrint "Installing Core Files..."
  SetDetailsPrint listonly

  SectionIn 1 2 3 RO
  SetOutPath $INSTDIR
  File /r "${GAMEDIR}"
  File license.txt	

SectionEnd

; CTF section
Section "Capture The Flag Maps" SecCTF

  SetDetailsPrint textonly
  DetailPrint "Installing CTF Maps..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR	
  File /r "ctf maps\ag"

SectionEnd ; end the section


Section "Digital Head Up Display" SecHUD

  SetDetailsPrint textonly
  DetailPrint "Installing Digital Head Up Display..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR	
  File /r "Hud\${GAMEDIR}"
SectionEnd

Section "Optimized Crosshairs" SecCrosshairs

  SetDetailsPrint textonly
  DetailPrint "Installing Optimized Crosshairs..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR
  File /r "Crosshairs\${GAMEDIR}"
SectionEnd

Section "High FPS Models" SecModels 

  SetDetailsPrint textonly
  DetailPrint "Installing High FPS Models..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
    SetOutPath $INSTDIR
    File /r "HighFps\${GAMEDIR}"
SectionEnd

!ifndef MINIMAL
; Maps section
Section "Additional Maps" SecMaps

  SetDetailsPrint textonly
  DetailPrint "Installing Additional Maps..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
  SetOutPath $INSTDIR	
  File /r "maps\ag"

SectionEnd ; end the section
!endif

!ifndef MINIMAL
; Maps section
Section "Skin by abla" SecSkin

  SetDetailsPrint textonly
  DetailPrint "Installing Skin..."
  SetDetailsPrint listonly

  SectionIn 1 2 3
 
  ReadRegStr $0 HKLM "SOFTWARE\Valve\Steam" "InstallPath"
  
  SetOutPath $0 	
  File /r "steam\skins"
  WriteRegStr HKCU "Software\Valve\Steam" "Skin" "aghl"

SectionEnd ; end the section
!endif



Section "Shortcuts" SecShortcuts
CreateDirectory "$SMPROGRAMS\Adrenaline Gamer"
WriteIniStr "$INSTDIR\${GAMEDIR}\Adrenaline Gamer.url" "InternetShortcut" "URL" "http://www.planethalflife.com/agmod"
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Adrenaline Gamer.lnk" "$INSTDIR\${GAMEDIR}\Adrenaline Gamer.url" "" "$INSTDIR\${GAMEDIR}\Adrenaline Gamer.url" 0


CreateDirectory "$SMPROGRAMS\Adrenaline Gamer"
CreateShortCut "$DESKTOP\AG Manual.lnk" "$INSTDIR\${GAMEDIR}\docs\documentation.htm" "" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\AG Manual.lnk" "$INSTDIR\${GAMEDIR}\docs\documentation.htm" "" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start Server (port 27015).lnk" "$INSTDIR\hlds.exe" "-game ${GAMEDIR} -port 27015 +map datacore +maxplayers 12" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start CTF Server (port 27016).lnk" "$INSTDIR\hlds.exe" "-game ${GAMEDIR} -port 27016 +map agctf_infinity +maxplayers 20 +servercfgfile server_ctf.cfg +mapcyclefile mapcycle_ctf.txt" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start LMS Server (port 27017).lnk" "$INSTDIR\hlds.exe" "-game ${GAMEDIR} -port 27017 +map boot_camp +maxplayers 6 +servercfgfile server_lms.cfg" "$INSTDIR\${GAMEDIR}\game.ico" 0

IfFileExists $INSTDIR\hl.exe Standard cstrike
Standard:
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Play AG.lnk" "$INSTDIR\hl.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$DESKTOP\Play AG.lnk" "$INSTDIR\hl.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$QUICKLAUNCH\Play AG.lnk" "$INSTDIR\hl.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
goto endshortcuts
cstrike:
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Play AG.lnk" "$INSTDIR\cstrike.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$DESKTOP\Play AG.lnk" "$INSTDIR\cstrike.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
CreateShortCut "$QUICKLAUNCH\Play AG.lnk" "$INSTDIR\cstrike.exe" "-game ${GAMEDIR} -console" "$INSTDIR\${GAMEDIR}\game.ico" 0
endshortcuts:

SectionEnd

Section "Uninstaller" SecUninstall
CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Uninstall.lnk" "$INSTDIR\${GAMEDIR}\uninst.exe" "" "$INSTDIR\${GAMEDIR}\uninst.exe" 0
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer" "DisplayName" "Adrenaline Gamer"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer" "DisplayVersion" "${VER_DISPLAY}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer" "URLInfoAbout" "http://www.planethalflife.com/agmod"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer" "Publisher" "bullit@planethalflife.com"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer" "UninstallString" "$INSTDIR\${GAMEDIR}\Uninst.exe"
WriteRegStr HKCU "Software\AdrenalineGamer" "" $INSTDIR
WriteUninstaller "$INSTDIR\${GAMEDIR}\Uninst.exe"
 
 
SectionEnd
 
;--------------------------------  
;Descriptions 
                                    
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCTF} $(DESC_SecCTF)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecHUD} $(DESC_SecHUD)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecModels} $(DESC_SecModels)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCrosshairs} $(DESC_SecCrosshairs)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMaps} $(DESC_SecMaps)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSkin} $(DESC_SecSkin)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecUninstall} $(DESC_SecUninstall)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecShortcuts} $(DESC_SecShortcuts)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
 
 
;--------------------------------
    
;Uninstaller Section
   
Section "Uninstall" 
 
  
  ;Delete Start Menu Shortcuts
  Delete "$SMPROGRAMS\Adrenaline Gamer\*.*"
  RmDir "$SMPROGRAMS\Adrenaline Gamer"
  ;Delete Uninstaller And Unistall Registry Entries
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Adrenaline Gamer"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Adrenaline Gamer"
  RMDir /r "$INSTDIR"
DeleteRegKey /ifempty HKCU "Software\Adrenaline GAmer"
             
SectionEnd
               
; The default installation directory
Function .onInit
	SectionSetFlags 2 0
	SectionSetFlags 3 0
	SectionSetFlags 4 0

    ReadRegStr $INSTDIR HKCU "SOFTWARE\Valve\Steam" "ModInstallPath"
	StrCmp $INSTDIR "" TestServerInstallation
	goto done
	TestServerInstallation:
		ReadRegStr $INSTDIR HKCU "SOFTWARE\Valve\HLServer" "InstallPath"
		StrCmp $INSTDIR "" TestWeirdInstallation
		goto done
		TestWeirdInstallation:
			ReadRegStr $INSTDIR HKCU "SOFTWARE\Valve\Half-Life" "InstallPath"
			StrCmp $INSTDIR "" Failed
			goto done
			Failed:
				StrCpy $INSTDIR "C:\Sierra\Half-Life"
	done:
FunctionEnd

; Verify installation directory
Function .onVerifyInstDir
    ;IfFileExists $INSTDIR\hl.exe PathGood
	;	IfFileExists $INSTDIR\cstrike.exe PathGood
	;		IfFileExists $INSTDIR\hlds.exe PathGood
	;			Abort ; if $INSTDIR is not a winamp directory, don't let us install there
    ;PathGood:
FunctionEnd
   
Function .onInstSuccess
   ExecShell open "$INSTDIR\${GAMEDIR}\docs\documentation.htm"
FunctionEnd

;--------------------------------
;Version Information
  VIProductVersion "${VER_MAJOR}.${VER_MINOR}.${VER_MICRO}.${VER_BUILD}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Adrenaline Gamer"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "Pure Half-Life DeathMatch Pleasure!"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "bullit@planethalflife.com"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "Adrenaline Gamer is a trademark of bullit@planethalflife.com"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© bullit@planethalflife.com"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "www.planethalflife.com/agmod"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VER_MAJOR}.${VER_MINOR}.${VER_MICRO}.${VER_BUILD}"

;--------------------------------


;eof

