# futuresonic.nsi

!include "WordFunc.nsh"
!include "MUI.nsh"

!insertmacro VersionCompare

# The name of the installer
Name "FutureSonic"

# The icon of the installer
Icon "futuresonic.ico"



# The default installation directory
InstallDir C:\futuresonic

# Registry key to check for directory (so if you install again, it will
# overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FutureSonic" "Install_Dir"

#--------------------------------
#Interface Configuration

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Getting Started.html"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "View Getting Started document"
!define MUI_WELCOMEFINISHPAGE
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\arrow.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

!define INSTALLSIZE 80000

#--------------------------------
# Pages

# This page checks for JRE
Page custom CheckInstalledJRE

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Languages
!insertmacro MUI_LANGUAGE "English"

Section "FutureSonic"

  SectionIn RO
  
  # Install for all users
  SetShellVarContext "all"

  # Take backup of existing futuresonic-service.exe.vmoptions
  CopyFiles /SILENT $INSTDIR\futuresonic-service.exe.vmoptions $TEMP\futuresonic-service.exe.vmoptions

  # Silently uninstall existing version.
  ExecWait '"$INSTDIR\uninstall.exe" /S _?=$INSTDIR'

  # Remove previous Jetty temp directory.
  RMDir /r "c:\futuresonic\jetty"

  # Backup database.
  RMDir /r "c:\futuresonic\db.backup"
  CreateDirectory "c:\futuresonic\db.backup"
  CopyFiles /SILENT "c:\futuresonic\db\*" "c:\futuresonic\db.backup"

  # Set output path to the installation directory.
  SetOutPath $INSTDIR

  # Write files.
  File ..\..\..\target\futuresonic-agent.exe
  File ..\..\..\target\futuresonic-agent.exe.vmoptions
  File ..\..\..\target\futuresonic-agent-elevated.exe
  File ..\..\..\target\futuresonic-agent-elevated.exe.vmoptions
  File ..\..\..\target\futuresonic-service.exe
  File ..\..\..\target\futuresonic-service.exe.vmoptions
  File /oname=futuresonic-booter.jar ..\..\..\..\futuresonic-booter\target\futuresonic-booter-jar-with-dependencies.jar 
  File ..\..\..\..\futuresonic-main\README.TXT
  File ..\..\..\..\futuresonic-main\LICENSE.TXT
  File "..\..\..\..\futuresonic-main\Getting Started.html"
  File ..\..\..\..\futuresonic-main\target\futuresonic.war
  File ..\..\..\..\futuresonic-main\target\classes\version.txt
  File ..\..\..\..\futuresonic-main\target\classes\build_number.txt

  # Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FutureSonic "Install_Dir" "$INSTDIR"

  # Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FutureSonic" "DisplayName" "FutureSonic"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FutureSonic" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FutureSonic" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FutureSonic" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

  # Restore futuresonic-service.exe.vmoptions
  CopyFiles /SILENT  $TEMP\futuresonic-service.exe.vmoptions $INSTDIR\futuresonic-service.exe.vmoptions
  Delete $TEMP\futuresonic-service.exe.vmoptions

  # Write transcoding pack files.
  SetOutPath "c:\futuresonic\transcode"
  File ..\..\..\..\futuresonic-transcode\windows\*.*

  # Add Windows Firewall exception.
  # (Requires NSIS plugin found on http://nsis.sourceforge.net/NSIS_Simple_Firewall_Plugin to be installed
  # as NSIS_HOME/Plugins/SimpleFC.dll)
  SimpleFC::AddApplication "FutureSonic Service" "$INSTDIR\futuresonic-service.exe" 0 2 "" 1
  SimpleFC::AddApplication "FutureSonic Agent" "$INSTDIR\futuresonic-agent.exe" 0 2 "" 1
  SimpleFC::AddApplication "FutureSonic Agent (Elevated)" "$INSTDIR\futuresonic-agent-elevated.exe" 0 2 "" 1

  # Install and start service.
  ExecWait '"$INSTDIR\futuresonic-service.exe" -install'
  ExecWait '"$INSTDIR\futuresonic-service.exe" -start'

  # Start agent.
  Exec '"$INSTDIR\futuresonic-agent-elevated.exe" -balloon'

SectionEnd


Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\FutureSonic"
  CreateShortCut "$SMPROGRAMS\FutureSonic\Open FutureSonic.lnk"          "$INSTDIR\futuresonic.url"         ""         "$INSTDIR\futuresonic-agent.exe"  0
  CreateShortCut "$SMPROGRAMS\FutureSonic\FutureSonic Tray Icon.lnk"     "$INSTDIR\futuresonic-agent.exe"   "-balloon" "$INSTDIR\futuresonic-agent.exe"  0
  CreateShortCut "$SMPROGRAMS\FutureSonic\Start FutureSonic Service.lnk" "$INSTDIR\futuresonic-service.exe" "-start"   "$INSTDIR\futuresonic-service.exe"  0
  CreateShortCut "$SMPROGRAMS\FutureSonic\Stop FutureSonic Service.lnk"  "$INSTDIR\futuresonic-service.exe" "-stop"    "$INSTDIR\futuresonic-service.exe"  0
  CreateShortCut "$SMPROGRAMS\FutureSonic\Uninstall FutureSonic.lnk"     "$INSTDIR\uninstall.exe"        ""         "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\FutureSonic\Getting Started.lnk"        "$INSTDIR\Getting Started.html" ""         "$INSTDIR\Getting Started.html" 0

  CreateShortCut "$SMSTARTUP\FutureSonic.lnk"                         "$INSTDIR\futuresonic-agent.exe"   ""         "$INSTDIR\futuresonic-agent.exe"  0

SectionEnd


# Uninstaller

UninstallIcon "futuresonic.ico"

Section "Uninstall"

  # Uninstall for all users
  SetShellVarContext "all"

  # Stop and uninstall service if present.
  ExecWait '"$INSTDIR\futuresonic-service.exe" -stop'
  ExecWait '"$INSTDIR\futuresonic-service.exe" -uninstall'

  # Stop agent by killing it.
  # (Requires NSIS plugin found on http://nsis.sourceforge.net/Processes_plug-in to be installed
  # as NSIS_HOME/Plugins/Processes.dll)
  Processes::KillProcess "futuresonic-agent"
  Processes::KillProcess "futuresonic-agent-elevated"
  Processes::KillProcess "Audioffmpeg"
  Processes::KillProcess "ffmpeg"
  Processes::KillProcess "lame"

  # Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FutureSonic"
  DeleteRegKey HKLM SOFTWARE\FutureSonic

  # Remove files.
  Delete "$SMSTARTUP\FutureSonic.lnk"
  RMDir /r "$SMPROGRAMS\FutureSonic"
  Delete "$INSTDIR\build_number.txt"
  Delete "$INSTDIR\elevate.exe"
  Delete "$INSTDIR\Getting Started.html"
  Delete "$INSTDIR\LICENSE.TXT"
  Delete "$INSTDIR\README.TXT"
  Delete "$INSTDIR\futuresonic.url"
  Delete "$INSTDIR\futuresonic.war"
  Delete "$INSTDIR\futuresonic-agent.exe"
  Delete "$INSTDIR\futuresonic-agent.exe.vmoptions"
  Delete "$INSTDIR\futuresonic-agent-elevated.exe"
  Delete "$INSTDIR\futuresonic-agent-elevated.exe.vmoptions"
  Delete "$INSTDIR\futuresonic-booter.jar"
  Delete "$INSTDIR\futuresonic-service.exe"
  Delete "$INSTDIR\futuresonic-service.exe.vmoptions"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\version.txt"
  
  Delete "$INSTDIR\futuresonic.ico"
  
  RMDir /r "$INSTDIR\log"
  RMDir "$INSTDIR"

  # Remove Windows Firewall exception.
  # (Requires NSIS plugin found on http://nsis.sourceforge.net/NSIS_Simple_Firewall_Plugin to be installed
  # as NSIS_HOME/Plugins/SimpleFC.dll)
  SimpleFC::RemoveApplication "$INSTDIR\elevate.exe"
  SimpleFC::RemoveApplication "$INSTDIR\futuresonic-service.exe"
  SimpleFC::RemoveApplication "$INSTDIR\futuresonic-agent.exe"
  SimpleFC::RemoveApplication "$INSTDIR\futuresonic-agent-elevated.exe"

SectionEnd


Function CheckInstalledJRE
    # Read the value from the registry into the $0 register
	
#	!include x64.nsh
#	${If} ${RunningX64} 
#		SetRegView 64
#	    DetailPrint "Installer running on 64-bit host"
#		ReadRegStr $0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
#	${Else}   
#		SetRegView 32
#	    DetailPrint "Installer running on 32-bit host"
		ReadRegStr $0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
#	${EndIf}
	

    # Check JRE version. At least 1.7 is required.
    #   $1=0  Versions are equal
    #   $1=1  Installed version is newer
    #   $1=2  Installed version is older (or non-existent)
    ${VersionCompare} $0 "1.7" $1
    IntCmp $1 2 InstallJRE 0 0
    Return

    InstallJRE:
      # Launch Java web installer.
      MessageBox MB_OK "Java 7 was not found and will now be installed."
#      File /oname=$TEMP\jre-setup.exe jre-7u45-windows-i586-iftw.exe
#      ExecWait '"$TEMP\jre-setup.exe"' $0
#      Delete "$TEMP\jre-setup.exe"

FunctionEnd
