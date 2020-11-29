; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "XClipper"
#define MyAppVersion "0.15.0"
#define MyAppPublisher "KP'S TV, Inc."
#define MyAppURL "https://kaustubhpatange.github.io/XClipper"
#define MyAppExeName "XClipper.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{DB5A588F-B349-4534-9294-A186D233E37A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=license.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=out
OutputBaseFilename=XClipper-Setup-x64-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Source: "D:\VisualStudioProjects\XClipper\XClipper.App\bin\Release\XClipper.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "../XClipper.App/bin/Release/XClipper.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "../XClipper.App/bin/Release/*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
procedure OpenBrowser(Url: string);
var
  ErrorCode: Integer;
begin
  ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure WatchButtonOnClick(Sender: TObject);
begin
  OpenBrowser('https://kaustubhpatange.github.io/XClipper/docs/#/introduction'); 
end;

var
  GSLabel: TLabel;
  WatchPage: TOutputMsgWizardPage;
procedure InitializeWizard;
begin
  { Create custom pages }
  GSLabel := TLabel.Create(WizardForm);
  GSLabel.Parent := WizardForm;
  GSLabel.Left := ScaleX(16);
  GSLabel.Top := ScaleY(402);
  GSLabel.Width := WizardForm.NextButton.Width;
  GSLabel.Height := WizardForm.NextButton.Height;
  GSLabel.Caption := 'Getting Started';
  GSLabel.Font.Style := GSLabel.Font.Style + [fsUnderline];
  GSLabel.Font.Color := clBlue;
  GSLabel.Cursor := crHand;
  GSLabel.OnClick := @WatchButtonOnClick;

  WatchPage := CreateOutputMsgPage(wpLicense, 'Getting Started', 'This might be important for you!'
  , 'Using a product correctly by the end user is what every developer dreamed of!'#13#13 +
    'That''s why there is a link to ''Getting started'' tutorial at the bottom of the installer which also contains '+
    'a video that demonstrates the excellent use of XClipper.');

{  WatchPage := CreateCustomPage(wpLicense, 'Test Title', 'Test Description');   }

end;