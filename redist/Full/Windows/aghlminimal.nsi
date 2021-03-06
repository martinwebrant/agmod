; AGHL.nsi
;
; Adrenaline Gamer Mod install script
; Made by bullit@planethalflife.com
;

; The default installation directory
Function .onInit
	SectionSetFlags 2 0
	SectionSetFlags 3 0
	SectionSetFlags 4 0
    ReadRegStr $INSTDIR HKLM "SOFTWARE\Sierra OnLine\Setup\HALFLIFE" "Directory"
	StrCmp $INSTDIR "" TestServerInstallation
	goto done
	TestServerInstallation:
		ReadRegStr $INSTDIR HKLM "SOFTWARE\Sierra OnLine\Setup\HLSERVER" "Directory"
		StrCmp $INSTDIR "" TestWeirdInstallation
		goto done
		TestWeirdInstallation:
			ReadRegStr $INSTDIR HKLM "SOFTWARE\Valve\Half-Life" "InstallPath"
			StrCmp $INSTDIR "" Failed
			goto done
			Failed:
				StrCpy $INSTDIR "C:\Sierra\Half-Life"
	done:
FunctionEnd

; Verify installation directory
Function .onVerifyInstDir
    IfFileExists $INSTDIR\hl.exe PathGood
		IfFileExists $INSTDIR\cstrike.exe PathGood
			IfFileExists $INSTDIR\hlds.exe PathGood
				Abort ; if $INSTDIR is not a winamp directory, don't let us install there
    PathGood:
FunctionEnd

; The name of the installer
Name "Adrenaline Gamer Mod"

; The file to write
OutFile "ag_65.exe"

; The icon of installer
Icon "install.ico"

; The enabled/disabled bitmaps
EnabledBitmap agenabled.bmp
DisabledBitmap agdisabled.bmp

; Head caption
;Caption "Adrenaline Gamer Mod Setup"

; Branding text
BrandingText "[bullit@planethalflife.com]"

; Show details when installation
ShowInstDetails show

; Write over current files.
SetOverwrite on

; Detail colors
InstallColors FFFF00 8F8F8F

; Gradiant background. Looks ugly ;)
; BGGradient 000000 8F8F8F FFFF00

; The text to prompt the user to enter a directory
ComponentText "This will install the Adrenaline Gamer Mod on your computer. Select which optional things you want installed."
DirText "This will install the Adrenaline Gamer Mod on your computer." "Choose the Half-Life directory" 

; The stuff to install
Section "Mod files (required)"
	SectionIn 1
	SetOutPath $INSTDIR
	File /r "ag"
SectionEnd ; end the section


; Crosshair section
Section "Optimized Crosshairs"
	SectionIn 3
    SetOutPath $INSTDIR
    File /r "Crosshairs\ag"
SectionEnd ; end the section

; Hud section
Section "Digital Hud"
	SectionIn 4
    SetOutPath $INSTDIR
    File /r "Hud\ag"
SectionEnd ; end the section

; High FPS models
Section "High FPS Models"
	SectionIn 5
    SetOutPath $INSTDIR
    File /r "HighFps\ag"
SectionEnd ; end the section

; shortcut section
Section "Start Menu Shortcuts"
  ; Set output path to the installation directory.
	SetOutPath $INSTDIR
	CreateDirectory "$SMPROGRAMS\Adrenaline Gamer"
    IfFileExists $INSTDIR\hl.exe CreateClient CreateServer
	CreateClient:
	CreateShortCut "$DESKTOP\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$DESKTOP\AG Manual.lnk" "$INSTDIR\ag\docs\index.htm" "" "$INSTDIR\ag\AG.ICO" 0
	CreateShortCut "$QUICKLAUNCH\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Play AG.lnk" "$INSTDIR\hl.exe" "-game ag -console" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\AG Manual.lnk" "$INSTDIR\ag\docs\index.htm" "" "$INSTDIR\ag\ag.ICO" 0
	CreateServer:
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start Server (port 27015).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27015 +map datacore +maxplayers 12" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start CTF Server (port 27016).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27016 +map agctf_infinity +maxplayers 20 +servercfgfile server_ctf.cfg +mapcyclefile mapcycle_ctf.txt" "$INSTDIR\ag\ag.ICO" 0
	CreateShortCut "$SMPROGRAMS\Adrenaline Gamer\Start LMS Server (port 27017).lnk" "$INSTDIR\hlds.exe" "-game ag -port 27017 +map boot_camp +maxplayers 6 +servercfgfile server_lms.cfg" "$INSTDIR\ag\ag.ICO" 0
SectionEnd ; end the section

; config section
Section "Copy config"
	SetOutPath $INSTDIR

	IfFileExists $INSTDIR\ag\config.cfg EndConfig

    IfFileExists $INSTDIR\aghl\config.cfg CopyConfigAG CheckConfigValve

	CheckConfigValve:
	IfFileExists $INSTDIR\valve\config.cfg CopyConfigValve EndConfig

	CopyConfigAG:
	CopyFiles $INSTDIR\aghl\config.cfg $INSTDIR\ag
	goto EndConfig

	CopyConfigValve:
	CopyFiles $INSTDIR\valve\config.cfg $INSTDIR\ag
	goto EndConfig

	EndConfig:
	IfFileExists $INSTDIR\ag\autoexec.cfg EndAutoexec


    IfFileExists $INSTDIR\aghl\autoexec.cfg CopyAutoexecAG CheckAutoexecValve

	CheckAutoexecValve:
	IfFileExists $INSTDIR\valve\autoexec.cfg CopyAutoexecValve EndAutoexec

	CopyAutoexecAG:
	CopyFiles $INSTDIR\aghl\autoexec.cfg $INSTDIR\ag
	goto EndAutoexec

	CopyAutoexecValve:
	CopyFiles $INSTDIR\valve\autoexec.cfg $INSTDIR\ag
	goto EndAutoexec

	EndAutoexec:
SectionEnd ; end the section


; eof
