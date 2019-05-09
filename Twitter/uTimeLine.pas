unit uTimeLine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, MsjPanel, UDatos, uFrmAddFollow, Vcl.ExtDlgs;

type
  TfrmTimeLine = class(TForm)
    pnlHead: TPanel;
    Image2: TImage;
    pnlContainer: TScrollBox;
    pnlPost: TPanel;
    edtMessage: TMemo;
    btnSend: TBitBtn;
    btnAttach: TBitBtn;
    Panel1: TPanel;
    TimerSideBar: TTimer;
    btnFollow: TSpeedButton;
    btnShowSideBar: TImage;
    btnHideSideBar: TImage;
    Image1: TImage;
    tmrGetTimeLine: TTimer;
    pnlMsj: TScrollBox;
    imgAttch: TImage;
    op: TOpenPictureDialog;
    timerImageAttch: TTimer;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnShowSideBarClick(Sender: TObject);
    procedure TimerSideBarTimer(Sender: TObject);
    procedure btnFollowClick(Sender: TObject);
    procedure btnHideSideBarClick(Sender: TObject);
    procedure pnlMsjMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure btnAttachClick(Sender: TObject);
    procedure timerImageAttchTimer(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure tmrGetTimeLineTimer(Sender: TObject);
  private
    move: boolean;
    procedure ClearPost;
  public
    UserActive: TUsers;
  end;

var
  frmTimeLine: TfrmTimeLine;
  mCount: integer;
  ignored:TList;   //Los mensajes ya mostrados serán ignorados en la nueva carga
implementation

{$R *.dfm}

procedure TfrmTimeLine.FormCreate(Sender: TObject);
begin
  move:= false;
  mCount:=0;
  UserActive:= TUsers.Create;
  Panel1.Width:=0;
  pnlPost.Height:=127;
  ignored:= TList.Create;
end;

procedure TfrmTimeLine.Image2Click(Sender: TObject);
begin
  Self.Close;
end;


procedure TfrmTimeLine.btnAttachClick(Sender: TObject);
begin
  if op.Execute then begin
    imgAttch.Picture.LoadFromFile(op.FileName);
    timerImageAttch.Enabled:= true;
  end else
    ClearPost;
end;

procedure TfrmTimeLine.btnHideSideBarClick(Sender: TObject);
begin
  Panel1.Tag := 0;
  TimerSideBar.Enabled:=true;
  btnShowSideBar.Visible:= true;
  btnHideSideBar.Visible:= false;
end;

procedure TfrmTimeLine.ClearPost;
begin
  pnlPost.Height:= 127;
  imgAttch.Picture.Assign(nil);
  edtMessage.Text:='';
end;

procedure TfrmTimeLine.btnSendClick(Sender: TObject);
var
  msj: TMsj;
begin
  msj:= TMsj.Create;
  msj.User:= UserActive.ID;
  msj.Text:= edtMessage.Text;
  if imgAttch.Picture.Graphic<>nil then
    imgAttch.Picture.Graphic.SaveToStream(msj.Imagen);
  msj.post;
  ClearPost;
end;

procedure TfrmTimeLine.btnShowSideBarClick(Sender: TObject);
begin
    Panel1.Tag := 1;
    TimerSideBar.Enabled:= true;
    btnShowSideBar.Visible:= false;
    btnHideSideBar.Visible:= true;
end;

procedure TfrmTimeLine.pnlHeadMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  self.move:=true;
end;

procedure TfrmTimeLine.pnlHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if self.move then begin
    self.Left:= Mouse.CursorPos.X - (self.Width div 2);
    self.Top:= Mouse.CursorPos.Y - (pnlHead.Height div 2);
  end;
end;

procedure TfrmTimeLine.pnlHeadMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  self.move:=false;
end;

procedure TfrmTimeLine.pnlMsjMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if(WheelDelta < 0) then
  begin
    pnlMsj.VertScrollBar.Position := pnlMsj.VertScrollBar.Position + pnlMsj.VertScrollBar.Increment * 2;
  end else begin
    pnlMsj.VertScrollBar.Position := pnlMsj.VertScrollBar.Position - pnlMsj.VertScrollBar.Increment * 2;
  end;

end;

procedure TfrmTimeLine.TimerSideBarTimer(Sender: TObject);
begin
  if(panel1.Tag = 1) then
  begin
      panel1.Width:= panel1.Width+15;
      if (panel1.Width>=233) then TimerSideBar.Enabled:= false;
  end else begin
      panel1.Width:= panel1.Width-15;
      if (panel1.Width<0) then TimerSideBar.Enabled:= false;
  end;
end;

procedure TfrmTimeLine.tmrGetTimeLineTimer(Sender: TObject);
var
  msjResult: TList;
  msj: TPanelContainer;
  iCount: Integer;
begin
  msjResult:= TList.Create;
  msjResult:= UserActive.GetMessagesUnread(ignored, TWinControl(pnlMsj));
  for iCount := 0 to msjResult.Count-1 do begin
    msj:= TPanelContainer.Create(pnlMsj);
    msj.CreateFor(pnlMsj, GetUsetFromID(TMsj(msjResult.Items[iCount]).User), TMsj(msjResult.Items[iCount]));
    msj.Parent:= pnlMsj;

    msj.SetReadOnly(true);
    msj.Left:= ((pnlContainer.Width-msj.Width) div 2)-3;
    msj.Top:= 3+(mCount);
    mCount:=mCount+msj.Height;
    ignored.Add(Pointer(TMsj(msjResult.Items[iCount]).ID));
  end;
end;

procedure TfrmTimeLine.btnFollowClick(Sender: TObject);
var
  wdw: TfrmAddContact;
begin
  wdw:= tfrmAddContact.create(self);
  wdw.id:= UserActive.ID;
  Panel1.Width:=0;
  btnHideSideBar.OnClick(self);
  wdw.setUserActive(Self.UserActive);
  wdw.ShowModal;
end;

procedure TfrmTimeLine.timerImageAttchTimer(Sender: TObject);
begin
  if (pnlPost.Height>=319) then timerImageAttch.Enabled:=false;
  pnlPost.Height:= pnlPost.Height+15;
end;

end.
