unit UDatos;

interface
uses Data.Win.ADODB, UConnection, Dialogs, Classes, ExtCtrls, DB, SysUtils, Controls, variants;
type
  TUsers=class
    private
      fId: Integer;
      fNick: String;
      fNombre: String;
      fApellido: String;
      fMail: String;
      fPass: String;
      fAvatar: TMemoryStream;

      procedure SetNombre (value: String);
      procedure SetNick (value: String);
      procedure SetApellido (value: String);
      procedure SetMail (value: String);
      procedure SetPassword (value: String);
      procedure SetAvatar (value: TMemoryStream);
      procedure SetID (value: Integer);
    public
      constructor Create;
      function AddUserToDB (var _avatar: TImage): Integer; //Devuelve el ID de la posicion
      function GetMessagesUnread (var _listMsgReader: TList; var _Content: TWinControl):TList;
    published  {ID Nombre Nick Apellido Mail Pass Avatar}
      property ID: Integer read fId write SetID;
      property Nombre: String read fNombre write SetNombre;
      property Nick: String read fNick write SetNick;
      property Apellido: String read fApellido write SetApellido;
      property Mail: String read fMail write SetMail;
      property Pass: String read fPass write SetPassword;
      property Avatar: TMemoryStream read fAvatar write SetAvatar;
  end;

  TMsj = class
    private
      fID: Integer;
      fUser: Integer;
      fImagen: TMemoryStream;
      fText: String;
      fDate: string;

      procedure SetID (value: Integer);
      procedure SetUser (value: Integer);
      procedure SetImagen (value: TMemoryStream);
      procedure SetText (value: String);
      procedure SetDate (value: String);
    public
      constructor Create;
      procedure post;
    published  {ID User Imagen Text Date}
      property ID: integer read fID write SetID;
      property User: Integer read fUser write SetUser;
      property Imagen: TMemoryStream read fImagen write SetImagen;
      property Text: String read fText write SetText;
      property Date: String read fDate write SetDate;
  end;

  function UserExist(_mail: String; _pass:String):boolean;
  function GetUserID (_mail: String): integer;
  function GetDataUser (_mail: String): TUsers;
  procedure AddContact (_usr: integer; _usr2: Integer);
  function getStringFromList (_list: TList): String;
  function GetUsetFromID (_id: Integer): TUsers;
  Procedure AddMessageToDB (_user: integer; _txt:String; _img: TMemoryStream);
var
  ListaMsjLeidos: TList;
implementation

////////////////////////////////////////////////////////////////////////////////
///////// TUsers Implementations ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Constructor TUsers.Create;
begin
  self.fAvatar:= TMemoryStream.Create;
end;

procedure TUsers.SetID (value: Integer);
begin
  if self.fId<>value then fId:=value;
end;

procedure TUsers.SetNick(value: String);
begin
  if self.fNick<>value then self.fNick:=value;
end;

procedure TUsers.SetApellido(value: String);
begin
  if self.fApellido<>value then self.fApellido:=value;
end;

procedure TUsers.SetAvatar(value: TMemoryStream);
begin
  if self.fAvatar<>value then self.fAvatar:=value;
end;

procedure TUsers.SetMail(value: String);
begin
  if self.fMail<>value then self.fMail:=value;
end;

procedure TUsers.SetNombre(value: String);
begin
  if self.fNombre<>value then self.fNombre:=value;
end;

procedure TUsers.SetPassword(value: String);
begin
  if self.fPass<>value then self.fPass:=value;
end;

function TUsers.AddUserToDB(var _avatar: TImage): Integer; //Devuelve el ID de la posicion
var
  s:TMemoryStream;
  sp: TADOStoredProc;
begin
  sp:= TADOStoredProc.Create(nil);
  s:=TMemoryStream.Create;
  _avatar.Picture.Graphic.SaveToStream(s);
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:= 'create_User';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_nombre').Value   := Self.Nombre;
  sp.Parameters.ParamByName('@_apellido').Value := Self.Apellido;
  sp.Parameters.ParamByName('@_nick').Value     := Self.Nick;
  sp.Parameters.ParamByName('@_mail').Value     := Self.Mail;
  sp.Parameters.ParamByName('@_pass').Value     := Self.Pass;
  sp.Parameters.ParamByName('@_image').LoadFromStream(s, ftBlob);
  sp.ExecProc;
  sp.Close;
end;

function TUsers.GetMessagesUnread (var _listMsgReader: TList; var _Content: TWinControl):TList;
var
  sp: TADOStoredProc;
  ignore: String;
  msjAux: TMsj;
  listaRes: TList;
begin
  sp:= TADOStoredProc.Create(nil);
  listaRes:= TList.Create;
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:= 'Get_Message_For';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_id').Value:= self.ID;
  ignore:= getStringFromList(_listMsgReader);
  sp.Parameters.ParamByName('@_ignore').Value:= ignore;
  sp.ExecProc;
  sp.Open;
  while not (sp.eof) do begin
    msjAux:= TMsj.Create;
    msjAux.ID     := sp.FieldByName('messageID').AsInteger;
    msjAux.User   := sp.FieldByName('messageUser').AsInteger;
    msjAux.Text   := sp.FieldByName('messageText').AsString;
    msjAux.Date   := sp.FieldByName('messageDate').AsString;
    TBlobField (sp.FieldByName('messageImage')).SaveToStream(msjAux.fImagen);
    listaRes.Add(msjAux);
    _listMsgReader.Add(Pointer(msjAux.fID));
    sp.Next;
  end;
  sp.Close;
  result:= listaRes;
end;


////////////////////////////////////////////////////////////////////////////////
///////// TMsj Implementations ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TMsj.Create;
begin
  Self.fImagen:= TMemoryStream.Create;
end;

procedure TMsj.SetID (value: Integer);
begin
  if self.fID<>value then self.fID:= value;
end;

procedure TMsj.SetUser (value: Integer);
begin
  if self.fUser<>value then self.fUser:= value;
end;

procedure TMsj.SetImagen (value: TMemoryStream);
begin
  if self.fImagen<>value then self.fImagen:= value;
end;

procedure TMsj.SetText (value: String);
begin
  if self.fText<>value then self.fText:= value;
end;

procedure TMsj.SetDate (value: String);
begin
  if self.fDate<>value then self.fDate:= value;
end;

procedure TMsj.post;
begin
  AddMessageToDB(self.User, Self.Text, Self.Imagen);
end;

////////////////////////////////////////////////////////////////////////////////
///////// Stored Procedures Implementations ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function UserExist(_mail: String; _pass:String):boolean;
var
  cnx: TConnexion;
  sp: TADOStoredProc;
  res: integer;
begin
  cnx:= TConnexion.Create;
  sp:= TADOStoredProc.Create(nil);
  sp.Connection:= cnx.AbrirConexion;
  sp.ProcedureName:= 'Log_In_User';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_mail').Value:= _mail;
  sp.Parameters.ParamByName('@_pass').Value:= _pass;
  sp.Parameters.ParamByName('@_result').Value:= res;
  sp.ExecProc;
  res := Integer(sp.Parameters.ParamByName('@_result').Value);
  sp.Close;
  if res=1 then result:=true
    else result:= false;
end;

function GetDataUser (_mail: String): TUsers;
var
  cnx: TConnexion;
  sp: TADOStoredProc;
  res: TUsers;
begin
  cnx:= TConnexion.Create;
  sp:= TADOStoredProc.Create(nil);
  res:= TUsers.Create;

  sp.Connection:= cnx.AbrirConexion;
  sp.ProcedureName:= 'get_Data_User';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_email').Value:= _mail;
  sp.ExecProc;
  sp.Open;
  res.ID        := sp.FieldByName('userID').Value;
  res.Nick      := sp.FieldByName('userNick').Value;
  res.Nombre    := sp.FieldByName('userName').Value;
  res.Apellido  := sp.FieldByName('userLastName').Value;
  res.Mail      := sp.FieldByName('userEmail').Value;
  res.Pass      := sp.FieldByName('userPass').Value;
  sp.Close;
  result:= res;
end;

function GetUserID (_mail: String): integer;
var
  sp: TADOStoredProc;
  res: Integer;
begin
  sp:= TADOStoredProc.Create(nil);
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:= 'Get_User_ID';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_mail').Value:=_mail;
  sp.Parameters.ParamByName('@_result').Value:= res;
  sp.Parameters.ParamByName('@_result').Direction:= pdOutput;
  sp.ExecProc;
  res := Integer(sp.Parameters.ParamByName('@_result').Value);
  sp.Close;
  result:= res;
end;

procedure AddContact (_usr: integer; _usr2: Integer);
var
  sp: TADOStoredProc;
begin
  sp:= TADOStoredProc.Create(nil);
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:= 'add_contact';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_usr').Value:=_usr;
  sp.Parameters.ParamByName('@_follow').Value:= _usr2;
  sp.Parameters.ParamByName('@_date').value:= Now;
  sp.ExecProc;
  sp.Close;
end;

function GetUsetFromID (_id: Integer): TUsers;
var
  res: TUsers;
  sp: TADOStoredProc;
begin
  res:= TUsers.Create;
  sp:= TADOStoredProc.Create(nil);
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:= 'get_Data_User_From_ID';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_id').Value:= _id;
  sp.ExecProc;
  sp.Open;
  res.ID        := sp.FieldByName('userID').AsInteger;
  res.Nombre    := sp.FieldByName('userName').AsString;
  res.Nick      := sp.FieldByName('userNick').AsString;
  res.Apellido  := sp.FieldByName('userLastName').AsString;
  res.Mail      := sp.FieldByName('userEmail').AsString;
  res.Pass      := sp.FieldByName('userPass').AsString;
  TBlobField (sp.FieldByName('imageData')).SaveToStream(res.Avatar);
  sp.Close;
  res.Avatar.Position:=0;
  result:= res;
end;

procedure AddMessageToDB (_user: integer; _txt:String; _img: TMemoryStream);
var
  sp: TADOStoredProc;
begin
  sp:= TADOStoredProc.Create(nil);
  sp.Connection:= TConnexion.Create.AbrirConexion;
  sp.ProcedureName:='add_message';
  sp.Parameters.Refresh;
  sp.Parameters.ParamByName('@_user').Value:= _user;
  sp.Parameters.ParamByName('@_txt').Value:= _txt;
  sp.Parameters.ParamByName('@_date').Value:= Now;
  if (_Img.size<>0) then
    sp.Parameters.ParamByName('@_img').LoadFromStream(_img, ftBlob)
  else
    sp.Parameters.ParamByName('@_img').Value:= Null;
  sp.ExecProc;
  sp.Close;
end;


////////////////////////////////////////////////////////////////////////////////
///////////// Utils Implementations ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function getStringFromList (_list: TList): String;
var
  a:String;
  iCount: Integer;
begin
  if (_list.Count = 0) then result:= '(0)'
  else begin
    a:='(';
    for iCount := 0 to _list.Count-1 do begin
      a:= a+ IntToStr(Integer(_list.Items[iCount]))+',';
    end;
    a[length(a)]:=')';
    result:= a;
  end;
end;

end.
