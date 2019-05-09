unit uFrmAddFollow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, UDatos;

type
  TfrmAddContact = class(TForm)
    pnlHead: TPanel;
    Image2: TImage;
    edtMail: TLabeledEdit;
    btnFollow: TSpeedButton;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnFollowClick(Sender: TObject);
  private
    move: boolean;
    UserActive: TUsers;
  public
    id: integer;
    procedure setUserActive(user: TUsers);
  end;

var
  frmAddContact: TfrmAddContact;

implementation

{$R *.dfm}

procedure TfrmAddContact.FormCreate(Sender: TObject);
begin
  move:= false;
  UserActive:= TUsers.Create;
end;

procedure TfrmAddContact.Image2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmAddContact.pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:= true;
end;

procedure TfrmAddContact.pnlHeadMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if move then begin
    self.Left := Mouse.CursorPos.X - (self.Width div 2);
    self.Top  := Mouse.CursorPos.Y - (pnlHead.Height div 2);
  end;

end;

procedure TfrmAddContact.pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:= false;
end;

procedure TfrmAddContact.setUserActive(user: TUsers);
begin
  UserActive:= user;
end;

procedure TfrmAddContact.btnFollowClick(Sender: TObject);
var
  id2: Integer;
begin
  id2:= GetUserID(edtMail.Text);
  if id2=-1 then ShowMessage('Usuario No Registrado')
    else  begin
      AddContact(Self.id, GetUserID(edtMail.Text));
      ShowMessage('Comenzo a seguir a '+edtMail.Text);
      close;
    end;
end;

end.
