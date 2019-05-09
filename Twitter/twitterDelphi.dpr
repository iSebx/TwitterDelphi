program twitterDelphi;

uses
  Vcl.Forms,
  uInitSesion in 'uInitSesion.pas' {frmIniciarSesion},
  uTimeLine in 'uTimeLine.pas' {frmTimeLine},
  MsjPanel in 'units\MsjPanel.pas',
  UConnection in 'units\UConnection.pas',
  UDatos in 'units\UDatos.pas',
  uFrmAddFollow in 'uFrmAddFollow.pas' {frmAddContact},
  uFrmAddContact in 'uFrmAddContact.pas' {frmAddUser};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmIniciarSesion, frmIniciarSesion);
  Application.CreateForm(TfrmTimeLine, frmTimeLine);
  Application.CreateForm(TfrmAddContact, frmAddContact);
  Application.CreateForm(TfrmAddUser, frmAddUser);
  Application.Run;
end.
