// Refresh an existing desktop shortcut even when the optional task is deselected.
function UpdateExistingDesktopShortcut(): Boolean;
begin
  Result := (not WizardIsTaskSelected('DesktopIcon')) and
    FileExists(ExpandConstant('{userdesktop}\Augment.lnk'));
end;

procedure WriteInstallId();
begin
  SaveStringToFile(ExpandConstant('{app}\install_id.txt'), IntToStr(Random($7fffffff)), false)
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  rlUpgrade: String;
  exePath: String;
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then begin
    WriteInstallId();

    rlUpgrade := GetEnv('RUNELITE_UPGRADE');
    if rlUpgrade <> '' then begin
      exePath := ExpandConstant('{app}\Augment.exe');
      Exec(exePath, GetEnv('RUNELITE_UPGRADE_PARAMS'), '', SW_SHOW, ewNoWait, ResultCode);
    end;
  end;
end;