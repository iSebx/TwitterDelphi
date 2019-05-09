unit MsjPanel;

interface
uses ExtCtrls, Classes, Controls, StdCtrls, Graphics, SysUtils, UDatos, Forms, JPEG, windows;

type
  TErrorCode = (ecNone, ecFileNotExist, ecEmptyString);
  THeadPanel = class (TPanel)
    private
      Imagen: TImage;
      lblNombre: TLabel;
      lblMail: TLabel;
    public
      Constructor Create(AOwner: TWinControl); reintroduce;
      function SetImageFromPath(url: String): TErrorCode;
      function SetUserName (txt: String): TErrorCode;
      function SetUserMail (txt: String): TErrorCode;
  end;

  TImagePanel = class (TPanel)
    private
      Image: TImage;
    public
      constructor Create (AOwner: TWinControl);  reintroduce;
      function SetImageFromPath (url: String): TErrorCode;
  end;

  TMsjPanel = class (TPanel)
    private
      msj: TMemo;
    public
      constructor create (AOwner:TWinControl); reintroduce;
      function setMessage (txt: String): TErrorCode;
      procedure setColor (value: TColor);
  end;
  {Principal}
  TPanelContainer = Class (TFlowPanel)
    private
      head: THeadPanel;
      Image: TImagePanel;
      Msj: TMsjPanel;
    public
      constructor Create(AOwner: TWinControl);  reintroduce; overload;
      procedure CreateFor(AOwner: TWinCOntrol; user: TUsers; msj:TMsj);  reintroduce; overload;
      procedure SetColor (value: TColor);
      procedure SetFontColor (value: TColor);
      procedure SetReadOnly (value: boolean);
      procedure SetUserName (txt: String);
      procedure SetUserMail (txt: String);
      procedure SetMessage (txt: String);
      procedure SetImage ();
  End;

implementation
////////////////////////////////////////////////////////////////////////////////
//////////// TPanelContainer Implementations ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Constructor TPanelContainer.Create (AOwner: TWinControl);
begin
  inherited Create(AOwner);
  self.Parent:= AOwner;
  self.BevelEdges:= [beTop, beBottom];
  self.BevelKind := bkSoft;
  Self.BevelOuter := bvNone;
  self.BevelWidth:=1;
  self.BorderWidth:=1;

  self.AutoSize:=true;
  self.AutoWrap:=false;
  self.FlowStyle:= fsTopBottomLeftRight;

  //Insert Head Panel
  head:= THeadPanel.Create(self);
  head.Parent:= self;

  //Insert MemoPanel
  Msj:= TMsjPanel.create(self);
  Msj.Parent:= self;
  Msj.AutoSize:=true;
  Msj.Top := Head.Height+1;

  //Insert Image Panel
  Image:= TImagePanel.Create(Self);
  Image.Parent:= Self;
  Image.Image.Align:= alClient;
  Image.Constraints.MaxHeight:=105;
  Image.Image.Constraints.MaxHeight:= 105;
  Image.Top:= Msj.Top+Msj.Height+1;
end;

procedure AdjustMemo (_memo: TMemo);
var
  LineHeight: Integer;
  DC: HDC;
  SaveFont : HFont;
  Metrics : TTextMetric;
  Increase: Integer;
  LC: Integer;
begin
  DC := GetDC(_memo.Handle);
  SaveFont := SelectObject(DC, _memo.Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(_memo.Handle, DC);
  LineHeight := Metrics.tmHeight;
  Increase := _memo.Height;
  LC := _memo.Lines.Count;
  _memo.Height := LC * LineHeight + 8;
  _memo.Parent.Height:= _memo.Height;
end;

procedure TPanelContainer.CreateFor (AOwner: TWinCOntrol; user: TUsers; msj: TMsj);
var
  jpg: TJPEGImage;
  Img: TJPEGImage;
begin
  //Cabeza
  self.head.SetUserName(user.Nick);
  self.head.SetUserMail(user.Mail);
  self.head.Imagen.Stretch:= true;

  //Mensaje
  self.Msj.setMessage(msj.Text);
  AdjustMemo(self.Msj.msj);

  //Carga de Imagen
  if user.Avatar.Size<>0 then begin
    jpg:= TJPEGImage.Create;
    jpg.LoadFromStream(user.Avatar);
    self.head.Imagen.Picture.Graphic.Assign(jpg);
  end;
  Img:= TJPEGImage.Create;
  msj.Imagen.Position:=0;
  Img.LoadFromStream(msj.Imagen);
  if Img.Width <> 0 then begin
    Self.Image.Image.Picture.Assign(Img);
    self.Image.Height:= Img.Height;
    self.Image.Image.Height:= Img.Height;
    self.Image.Image.Stretch:=true;
    self.Image.Top:= Self.Msj.Top+self.Msj.Height +1
  end else self.Image.Height:=0;
  self.Height:=self.head.Height+self.Msj.Height+self.Image.Height;
end;

procedure TPanelContainer.SetColor (value: TColor);
begin
  self.Color:= value;
  head.Color:= value;
  Image.Color:= value;
  Msj.Color:= value;
  msj.setColor(value);
end;

procedure TPanelContainer.SetFontColor (value: TColor);
begin
  Head.lblNombre.Font.Color:= value;
  Head.lblMail.Font.Color:= value;
  Msj.Msj.Font.Color:= value;
end;

procedure TPanelContainer.SetReadOnly (value: boolean);
begin
  Msj.msj.ReadOnly:=value;
end;

procedure TPanelContainer.SetUserName (txt: String);
begin
  head.lblNombre.Caption:= txt;
end;

procedure TPanelContainer.SetUserMail (txt: String);
begin
  head.lblMail.Caption:= txt;
end;

procedure TPanelContainer.SetMessage (txt: String);
begin
  Msj.msj.Text:= txt;
end;

procedure TPanelContainer.SetImage ();
begin

end;

////////////////////////////////////////////////////////////////////////////////
//////////// THeadPanel Implementations ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Constructor THeadPanel.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  //Configurando Panel
  self.Align:= alTop;
  Self.BevelEdges:= [];
  self.ParentBackground:= false;
  self.BevelKind:= bkFlat;
  self.BevelOuter:= bvNone;
  self.Color:= clWhite;
  self.Caption:='';
  self.Height:= 45;
  self.Width:= 401;

  // Configurando Imagen
  Self.Imagen := TImage.Create(Self);
  self.Imagen.Parent := self;
  self.Imagen.Picture.LoadFromFile(ExtractFilePath(Paramstr(0))+'/res/userUnknow.bmp');
  self.Imagen.Stretch:= true;
  self.Imagen.Proportional:= true;
  self.Imagen.Width  := 41;
  self.Imagen.Height := 41;
  self.Imagen.Top    := 2;
  self.Imagen.Left   := 16;

  //Configurando Label Titulo
  self.lblNombre:= TLabel.Create(self);
  self.lblNombre.Parent:= self;
  self.lblNombre.Top:= 4;
  self.lblNombre.Left:= 65;
  self.lblNombre.AutoSize:= true;
  self.lblNombre.Caption:= 'User Name';
  self.lblNombre.Font.Name:='Arial Narrow';
  self.lblNombre.Font.Size:= 12;
  self.lblNombre.Font.Style := [fsBold];

  //Configurando Label Mail
  self.lblMail:= TLabel.Create(self);
  self.lblMail.Parent:= self;
  self.lblMail.Top:= 23;
  self.lblMail.Left:= 65;
  self.lblMail.AutoSize:= true;
  self.lblMail.Caption:= 'eMail';
  self.lblMail.Font.Name:='Arial Narrow';
  self.lblMail.Font.Size:= 10;
  self.lblMail.Font.Style := [];
end;

function THeadPanel.SetImageFromPath(url: String): TErrorCode;
begin
  if FileExists(url) then begin
    Imagen.Picture.LoadFromFile(url);
    result:= ecNone;
  end else
    result:= ecFileNotExist;
end;

function THeadPanel.SetUserName (txt: String): TErrorCode;
begin
  if (txt<>'') then begin
    lblNombre.Caption:= txt;
    result := ecNone;
  end else
    result := ecEmptyString;
end;

function THeadPanel.SetUserMail (txt: String): TErrorCode;
begin
  if (txt<>'') then begin
    lblMail.Caption:= txt;
    result := ecNone;
  end else
    result := ecEmptyString;
end;

////////////////////////////////////////////////////////////////////////////////
//////////// TImagePanel Implementations ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TImagePanel.Create (AOwner: TWinControl);
begin
  inherited create(AOwner);
  //Configurando Panel
  Self.BevelEdges:= [];
  self.ParentBackground:= false;
  self.BevelKind:= bkFlat;
  self.BevelOuter:= bvNone;
  self.Color:= clWhite;
  self.Caption:='';
  if Assigned(Image) then
      self.Height:= 136
  else self.Height:=0;
  self.Width:= 401;

  //Configurando Imagen
  self.Image:= TImage.Create(self);
  self.Image.Parent:= self;
  self.Image.Align:= alClient;
  self.Image.Stretch:=true;
  self.Image.Proportional:= true;
end;

function TImagePanel.SetImageFromPath (url: String): TErrorCode;
begin
  if FileExists(url) then begin
    self.Image.Picture.LoadFromFile(url);
    result:= ecNone;
  end else
    result:= ecFileNotExist;
end;
////////////////////////////////////////////////////////////////////////////////
//////////// TMsjPanel Implementations ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

constructor TMsjPanel.create (AOwner:TWinControl);
begin
  inherited create(AOwner);
  //Configurando Panel
  Self.BevelEdges:= [];
  self.ParentBackground:= false;
  self.BevelKind:= bkFlat;
  self.BevelOuter:= bvNone;
  self.Color:= clWhite;
  self.Caption:='';
  self.Height:= 78;
  self.Width:= 401;

  //Configurando Memo
  self.msj:= TMemo.Create(self);
  self.msj.Parent:= self;
  self.msj.Align:= alnone;
  self.msj.Width:= self.Width;
  self.msj.WordWrap:=true;
  self.msj.BorderStyle:= bsNone;
end;

function TMsjPanel.setMessage(txt: String): TErrorCode;
begin
  if txt<>'' then begin
    self.msj.Text:= txt;
    result:= ecNone;
  end else
    result:= ecEmptyString;
end;

procedure TMsjPanel.setColor (value: TColor);
begin
  msj.Color:=value;
end;

end.
