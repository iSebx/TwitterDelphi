unit uInitSesion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, uTimeLine, Data.DB, Data.Win.ADODB, UDatos, uFrmAddFollow,
  uFrmAddContact;

type
  TfrmIniciarSesion = class(TForm)
    Image1: TImage;
    edtMail: TLabeledEdit;
    edtPass: TLabeledEdit;
    btnConnect: TBitBtn;
    btnRegister: TBitBtn;
    Panel1: TPanel;
    Image2: TImage;
    ADOStoredProc1: TADOStoredProc;
    procedure Image2Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
  private
    moving: boolean;
  public
    { Public declarations }
  end;

var
  frmIniciarSesion: TfrmIniciarSesion;
  s:TImage;
implementation

{$R *.dfm}

procedure TfrmIniciarSesion.btnConnectClick(Sender: TObject);
var
  wdw: TfrmTimeLine;
begin
  if UserExist(edtMail.Text, edtPass.Text) then begin
    wdw:= TfrmTimeLine.Create(self);
    wdw.UserActive:= GetDataUser(edtMail.Text);
    wdw.pnlHead.caption:= wdw.UserActive.Nick;
    wdw.ShowModal;
  end else
    ShowMessage('Cualca! Escribi Bien Manco!');
end;

procedure TfrmIniciarSesion.btnRegisterClick(Sender: TObject);
begin
  TfrmAddUser.Create(self).ShowModal;
end;

procedure TfrmIniciarSesion.FormCreate(Sender: TObject);

begin
  moving:= false;
end;

procedure TfrmIniciarSesion.Image2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmIniciarSesion.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  moving:= true;
end;

procedure TfrmIniciarSesion.Panel1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if moving then begin
    frmIniciarSesion.Left:= Mouse.CursorPos.X - (frmIniciarSesion.Width div 2);
    frmIniciarSesion.Top:= Mouse.CursorPos.Y - (Panel1.Height div 2);
  end;
end;

procedure TfrmIniciarSesion.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  a:TwinControl;
begin
  moving:= false;
end;

end.
