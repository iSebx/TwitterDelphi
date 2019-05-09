unit uFrmAddContact;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtDlgs, JPEG, UDatos;

type
  TfrmAddUser = class(TForm)
    pnlHead: TPanel;
    btnClose: TImage;
    edtNick: TLabeledEdit;
    Panel2: TPanel;
    imgUser: TImage;
    edtNombre: TLabeledEdit;
    edtApellido: TLabeledEdit;
    edtMail: TLabeledEdit;
    edtPass: TLabeledEdit;
    edtRePass: TLabeledEdit;
    btnCancelar: TBitBtn;
    btnRegistrar: TBitBtn;
    Label1: TLabel;
    opd: TOpenPictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure imgUserDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    move: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddUser: TfrmAddUser;

implementation

{$R *.dfm}

procedure TfrmAddUser.BitBtn1Click(Sender: TObject);
var
  pos2: Integer;
begin
  pos2:= GetUserID(edtMail.Text);
  showmessage(IntToStr(pos2));
end;

procedure TfrmAddUser.btnCancelarClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
  close;
end;

procedure TfrmAddUser.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAddUser.btnRegistrarClick(Sender: TObject);
var
  _usr: TUsers;
  pos: Integer;
begin
  _usr:= TUsers.Create;
  with _usr do begin
    Nombre    := edtNombre.Text;
    Nick      := edtNick.Text;
    Apellido  := edtApellido.Text;
    Mail      := edtMail.Text;
    Pass      := edtPass.Text
  end;
  _usr.AddUserToDB(imgUser);
  pos:= GetUserID(_usr.Mail);
  AddContact(pos, pos); //Siempre el Usuario registrado se sigue a el mismo
  ModalResult:= mrOk;
  close;
end;

procedure TfrmAddUser.FormCreate(Sender: TObject);
begin
  move:= false;
end;

procedure TfrmAddUser.imgUserDblClick(Sender: TObject);
var
  bmp: TJPEGImage;
begin
  if opd.Execute then begin
    bmp:= TJPEGImage.Create;
    bmp.LoadFromFile(opd.FileName);
    imgUser.Picture.Assign(bmp);
  end;
end;

procedure TfrmAddUser.pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:= true;
end;

procedure TfrmAddUser.pnlHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if move then begin
    self.Left:= Mouse.CursorPos.X - (self.Width div 2);
    self.Top:= Mouse.CursorPos.Y - (self.pnlHead.Height div 2);
  end;
end;

procedure TfrmAddUser.pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move:=false;
end;

end.
