unit UConnection;

interface

uses
  Data.Win.ADODB;
const
  STRCONNECTION = 'Provider=SQLNCLI11.1;Integrated Security=SSPI;Persist Security Info=False;User ID="";Initial Catalog=PajaritoDB;Data Source=LIOTTA;Initial File Name="";Server SPN=""';
type

  TConnexion = class
    private
      fconexion : TADOConnection;
    public
      Constructor Create;
      Destructor Destoy;
      function AbrirConexion : TADOConnection;
      function CerrarConexion: TADOConnection;
  end;
implementation

{ TConnexion }

function TConnexion.AbrirConexion: TADOConnection;
begin
    self.fconexion.Open('','');
    self.fconexion.Connected:= true;
    result:=self.fconexion;
end;

function TConnexion.CerrarConexion: TADOConnection;
begin
  self.fconexion.Close;
  result:= self.fconexion;
end;

constructor TConnexion.Create;
begin
  self.fconexion:= TADOConnection.Create(nil);
  self.fconexion.ConnectionString:= STRCONNECTION;
end;

destructor TConnexion.Destoy;
begin
  self.fconexion.Destroy;
end;

end.
