; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Rhomicom ERP V1 (Community Edition)"
#define MyAppPatchName "Rhomicom ERP V1.2.3 (Community Edition)"
#define MyAppVersion "1"
#define MyAppPublisher "Rhomicom Systems Technologies Ltd."
#define MyAppURL "http://www.rhomicomgh.com/"
#define MyAppExeName "Rhomicom ERP V1.0.0.exe"
#define MyDBCnfgName "Database Setup"
#define MyDBCnfgExeName "DBConfig.exe"
#define MinJRE "1.6"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{33F35EBD-89EF-48AA-97DE-2191660C6A48}}
AppName={#MyAppPatchName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppPatchName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={sd}\RhomicomERP_V1_Community
DefaultGroupName={#MyAppName}
OutputBaseFilename=REMS V1.2.3 (CE) Setup
SourceDir=C:\1_DESIGNS\MYAPPS\RHO_ERP_DESKTOP\Supported_Setup\REMS.V1.P23.Setup.Community.Edition
OutputDir=C:\1_DESIGNS\MYAPPS\RHO_ERP_DESKTOP\Supported_Setup\REMS.V1.P23.Setup.Community.Edition
;SetupIconFile=F:\MY_SETUPS\Org_Setup\ROMS V1 P6 Setup\ROMS_Data\4.ico
Compression=lzma
SolidCompression=yes
LicenseFile=license.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "REMS_Data\Rhomicom ERP V1.0.0.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{src}\REMS_Data\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs external
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyDBCnfgName}"; Filename: "{app}\{#MyDBCnfgExeName}"  
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Registry]
Root: HKLM; Subkey: "SOFTWARE\Rhomicom ERP V1-Free"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Permissions: admins-full; Flags: uninsdeletekey createvalueifdoesntexist
Root: HKLM; Subkey: "SOFTWARE\Rhomicom ERP V1-Free"; ValueType: string; ValueName: "Executable"; ValueData: "{#MyAppExeName}"; Permissions: admins-full; Flags: uninsdeletekey createvalueifdoesntexist

[Run]
Filename: "{app}\prereq\64bitPrereq\x64\vs_bsln.exe";Check: IsLike64Arch ;  Flags: runascurrentuser
Filename: "{app}\prereq\NDP451-KB2858728-x86-x64-AllOS-ENU.exe";Check: Framework45IsNotInstalled ;  Flags: runascurrentuser
Filename: "{app}\prereq\vcredist_x64\vcredist_x64.exe";Check: IsLike64Arch;  Flags: runascurrentuser
Filename: "{app}\prereq\vcredist_x86\vcredist_x86.exe";Check: IsOtherArch ;  Flags: runascurrentuser
Filename: "{app}\prereq\jre-8u101-windows-x64.exe";Check: IsLike64Arch and isJavaVerBlw6;  Flags: runascurrentuser
Filename: "{app}\prereq\jre-8u101-windows-i586.exe";Check: IsOtherArch and isJavaVerBlw6;  Flags: runascurrentuser
Filename: "{app}\{#MyDBCnfgExeName}";  Flags: runascurrentuser
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall runascurrentuser skipifsilent

[Code]
//Description: "{cm:LaunchProgram,{#StringChange(MyDBCnfgName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
function IsX64: Boolean;
begin
  Result := Is64BitInstallMode or (ProcessorArchitecture = paX64) or IsWin64;
end;

function IsIA64: Boolean;
begin
  Result := Is64BitInstallMode and (ProcessorArchitecture = paIA64);
end;

function IsOtherArch: Boolean;
begin
  Result := not IsX64 and not IsIA64;
end;

function IsLike64Arch: Boolean;
begin
  Result := IsX64 or IsIA64;
end;
function dotNet2NotExst: Boolean;
begin
  if IsOtherArch then 
    begin
    Result :=not RegValueExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727\Install', '1');
    end;
  if IsLike64Arch then 
    begin
    Result :=not RegValueExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v2.0.50727\Install', '1');
  end;
   // The value exists HKEY_CURRENT_USER, 'Software\pgAdmin III\Servers\1\ServiceID', 'postgresql-9.1'
   //HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v2.0.50727
end;

function Framework45IsNotInstalled(): Boolean;
var
  bSuccess: Boolean;
  regVersion: Cardinal;
begin
  Result := True;

  bSuccess := RegQueryDWordValue(HKLM, 'Software\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release', regVersion);
  if (True = bSuccess) and (regVersion >= 378389) then begin
    Result := False;
  end;
end;

//Both DecodeVersion and CompareVersion functions where taken from the  wiki
procedure DecodeVersion (verstr: String; var verint: array of Integer);
var
  i,p: Integer; s: string;
begin
  // initialize array
  verint := [0,0,0,0];
  i := 0;
  while ((Length(verstr) > 0) and (i < 4)) do
  begin
    p := pos ('.', verstr);
    if p > 0 then
    begin
      if p = 1 then s:= '0' else s:= Copy (verstr, 1, p - 1);
      verint[i] := StrToInt(s);
      i := i + 1;
      verstr := Copy (verstr, p+1, Length(verstr));
    end
    else
    begin
      verint[i] := StrToInt (verstr);
      verstr := '';
    end;
  end;

end;

function CompareVersion (ver1, ver2: String) : Integer;
var
  verint1, verint2: array of Integer;
  i: integer;
begin

  SetArrayLength (verint1, 4);
  DecodeVersion (ver1, verint1);

  SetArrayLength (verint2, 4);
  DecodeVersion (ver2, verint2);

  Result := 0; i := 0;
  while ((Result = 0) and ( i < 4 )) do
  begin
    if verint1[i] > verint2[i] then
      Result := 1
    else
      if verint1[i] < verint2[i] then
        Result := -1
      else
        Result := 0;
    i := i + 1;
  end;

end;

var 
 jreVersion: String;
 envPathVal: String;
function isJavaVerBlw6(): Boolean;                             
   begin
       Result := True; 
       envPathVal :=  GetEnv('Path');
       //MsgBox(IntToStr(Pos('Java',envPathVal)) + '/' +envPathVal, mbConfirmation, MB_YESNO); 
       if Pos('Java',envPathVal)>0 then begin
             Result := False;
       end else begin
             Result := True; 
       end;
       if Result = True then begin
         RegQueryStringValue(HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', jreVersion);
         //MsgBox(jreVersion + '/' + envPathVal, mbInformation, MB_OK); 
         Result := True;
          if Length( jreVersion ) > 0 then begin
            if CompareVersion(jreVersion,'1.6') >= 0 then begin
              Result :=  False;
            end else begin 
              Result := True;
            end;
          end; 
       end;        
   end;

var
  dirChecked: Boolean;
  dirCheckResult: Boolean;
function DirCheck(): Boolean;
begin
dirChecked := DirExists(ExpandConstant('{app}'));
  if not dirChecked then begin
    dirCheckResult := CreateDir(ExpandConstant('{app}'));
  end;
  Result := DirExists(ExpandConstant('{app}'));
end;
