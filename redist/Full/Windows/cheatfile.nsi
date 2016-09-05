
Section "Updated Cheat file"
	; pack the dll in the install file
	File /oname=$TEMP\nsdtmp09.dll nsisdl.dll

	; make the call to download
	Push "http://www.planethalflife.com/agmod/cheats/cheats.dat"
	Push "$INSTDIR\aghl\cheats.dat"
	CallInstDLL $TEMP\nsdtmp09.dll download_quiet ; for a quiet install, use download_quiet

	; delete DLL from temporary directory
	Delete $TEMP\nsdtmp09.dll

	; check if download succeeded
	  StrCmp $0 "success" successful
	  StrCmp $0 "cancel" cancelled

	; we failed
	DetailPrint "Download of cheat file failed: $0"
	goto done

	cancelled:
	DetailPrint "Download of cheat file cancelled"
	goto done
	successful:
	DetailPrint "Download of cheat file successful"
	goto done
	done:
SectionEnd ; end the section