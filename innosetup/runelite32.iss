[Setup]
AppName=Augment Launcher
AppPublisher=Augment
UninstallDisplayName=Augment
AppVersion=${project.version}
AppSupportURL=https://augmentps.io
DefaultDirName={localappdata}\Augment

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${project.projectDir}/innosetup/runelite_small_55.bmp,${project.projectDir}/innosetup/runelite_small_64.bmp,${project.projectDir}/innosetup/runelite_small_83.bmp,${project.projectDir}/innosetup/runelite_small_110.bmp,${project.projectDir}/innosetup/runelite_small_128.bmp,${project.projectDir}/innosetup/runelite_small_166.bmp
SetupIconFile=${project.projectDir}/innosetup/runelite.ico
UninstallDisplayIcon={app}\augment-${iconHash}.ico
ChangesAssociations=yes

Compression=lzma2
SolidCompression=yes

OutputDir=${project.projectDir}
OutputBaseFilename=AugmentSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${project.projectDir}\innosetup\runelite.ico"; DestDir: "{app}"; DestName: "augment-${iconHash}.ico"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x86\Augment.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x86\Augment.jar"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x86\launcher_x86.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "${project.projectDir}\build\win-x86\config.json"; DestDir: "{app}"
Source: "${project.projectDir}\build\win-x86\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Augment\Augment"; Filename: "{app}\Augment.exe"; IconFilename: "{app}\augment-${iconHash}.ico"
Name: "{userprograms}\Augment\Augment (configure)"; Filename: "{app}\Augment.exe"; Parameters: "--configure"; IconFilename: "{app}\augment-${iconHash}.ico"
Name: "{userprograms}\Augment\Augment (safe mode)"; Filename: "{app}\Augment.exe"; Parameters: "--safe-mode"; IconFilename: "{app}\augment-${iconHash}.ico"
Name: "{userdesktop}\Augment"; Filename: "{app}\Augment.exe"; Check: UpdateExistingDesktopShortcut; IconFilename: "{app}\augment-${iconHash}.ico"
Name: "{userdesktop}\Augment"; Filename: "{app}\Augment.exe"; Tasks: DesktopIcon; IconFilename: "{app}\augment-${iconHash}.ico"

[Run]
Filename: "{app}\Augment.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Augment.exe"; Description: "&Open Augment"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\Augment.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.Augment\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: ""; ValueData: "URL:runelite-jav Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\runelite-jav\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Augment.exe"" ""%1"""; Flags: uninsdeletekey

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"
