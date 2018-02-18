!define PRODUCT_NAME "Kingfisher Investigation Toolkit"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "Kingfisher Investigation Toolkit.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\readme.txt"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "KIT Installer.exe"
InstallDir "$PROGRAMFILES\Kingfisher Investigation Toolkit"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "Kingfisher Investigation Toolkit.cmd"

  CreateDirectory "$SMPROGRAMS\Kingfisher Investigation Toolkit"
  CreateShortCut "$SMPROGRAMS\Kingfisher Investigation Toolkit\Kingfisher Investigation Toolkit.lnk" "$INSTDIR\Kingfisher Investigation Toolkit.cmd" "" "$INSTDIR\Kingfisher Investigation Toolkit.ico"
  CreateShortCut "$DESKTOP\Kingfisher Investigation Toolkit.lnk" "$INSTDIR\Kingfisher Investigation Toolkit.cmd" "" "$INSTDIR\Kingfisher Investigation Toolkit.ico"

  File "Kingfisher Investigation Toolkit.ico"
  File "readme.txt"
  SetOutPath "$INSTDIR\bin"
  File "bin\*.*"
  SetOutPath "$INSTDIR\client"
  File /r "client\*.*"
  SetOutPath "$INSTDIR\tools"
  File "tools\*.*"
  CreateDirectory "$INSTDIR\tmp"
SectionEnd

Section "ProgramData" SEC02
  SetOutPath "C:\ProgramData\Kingfisher Investigation Toolkit\config"
  File "config\*.*"
  SetOutPath "C:\ProgramData\Kingfisher Investigation Toolkit"
  File "Target_Host_List.txt"
  CreateDirectory "C:\ProgramData\Kingfisher Investigation Toolkit\logs"
  
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\Kingfisher Investigation Toolkit"
  CreateShortCut "$SMPROGRAMS\Kingfisher Investigation Toolkit\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "C:\ProgramData\Kingfisher Investigation Toolkit\Target_Host_List.txt"
  Delete "C:\ProgramData\Kingfisher Investigation Toolkit\config\*.*"
  Delete "$INSTDIR\tools\*.*"
  Delete "$INSTDIR\tmp\*.*"
  Delete "$INSTDIR\client\*.*"
  Delete "$INSTDIR\client\bin\*.*"
  Delete "$INSTDIR\client\config\*.*"
  Delete "$INSTDIR\client\logs\*.*"
  Delete "$INSTDIR\client\loki\*.*"
  Delete "$INSTDIR\client\loki\config\*.*"
  Delete "$INSTDIR\client\loki\docs\*.*"
  Delete "$INSTDIR\client\loki\LICENSE-doublepulsarcheck\*.*"
  Delete "$INSTDIR\client\loki\LICENSE-PE-Sieve\*.*"
  Delete "$INSTDIR\client\loki\pe-sieve32.exe\*.*"
  Delete "$INSTDIR\client\loki\pe-sieve64.exe\*.*"
  Delete "$INSTDIR\client\loki\signature-base\*.*"
  Delete "$INSTDIR\client\loki\tools\*.*"
  Delete "$INSTDIR\client\loki\signature-base\iocs\*.*"
  Delete "$INSTDIR\client\loki\signature-base\misc\*.*"
  Delete "$INSTDIR\client\loki\signature-base\yara\*.*"
  Delete "$INSTDIR\bin\*.*"
  Delete "$INSTDIR\readme.txt"
  Delete "$INSTDIR\Kingfisher Investigation Toolkit.ico"
  Delete "$INSTDIR\Kingfisher Investigation Toolkit.cmd"
  Delete "$SMPROGRAMS\Kingfisher Investigation Toolkit\Uninstall.lnk"
  Delete "$STARTMENU.lnk"
  Delete "$DESKTOP.lnk"
  Delete "$SMPROGRAMS\Kingfisher Investigation Toolkit\Kingfisher Investigation Toolkit.lnk"
  Delete "$DESKTOP\Kingfisher Investigation Toolkit.lnk"

  RMDir "$SMPROGRAMS\Kingfisher Investigation Toolkit"
  RMDir "$INSTDIR\tools"
  RMDir "$INSTDIR\tmp"
  RMDir "$INSTDIR\client\bin"
  RMDir "$INSTDIR\client\config"
  RMDir "$INSTDIR\client\logs"
  RMDir "$INSTDIR\client\loki\config"
  RMDir "$INSTDIR\client\loki\docs"
  RMDir "$INSTDIR\client\loki\LICENSE-doublepulsarcheck"
  RMDir "$INSTDIR\client\loki\LICENSE-PE-Sieve"
  RMDir "$INSTDIR\client\loki\pe-sieve32.exe"
  RMDir "$INSTDIR\client\loki\pe-sieve64.exe"
  RMDir "$INSTDIR\client\loki\signature-base\iocs"
  RMDir "$INSTDIR\client\loki\signature-base\misc"
  RMDir "$INSTDIR\client\loki\signature-base\yara"
  RMDir "$INSTDIR\client\loki\signature-base"
  RMDir "$INSTDIR\client\loki\tools"
  RMDir "$INSTDIR\client\loki"
  RMDir "$INSTDIR\client"
  RMDir "$INSTDIR\bin"
  RMDir "$INSTDIR"

  RMDir "C:\ProgramData\Kingfisher Investigation Toolkit\config"
  RMDir "C:\ProgramData\Kingfisher Investigation Toolkit\logs\memdump"
  RMDir "C:\ProgramData\Kingfisher Investigation Toolkit\logs"
  RMDir "C:\ProgramData\Kingfisher Investigation Toolkit"

  RMDir ""

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd