unit Repository.Conexao;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client;

type
  TConexao = class
  private
    class var FInstance: TConexao;
    FConnection: TFDConnection;
    FDriverFB: TFDPhysFBDriverLink;
    constructor Create;
    procedure CarregarConfiguracao;
    function GetConnection: TFDConnection;
  public
    destructor Destroy; override;
    class function GetInstance: TConexao;
    class procedure ReleaseInstance;

    property Connection: TFDConnection read GetConnection;
  end;

implementation

{ TConexao }

constructor TConexao.Create;
begin
  inherited;
  FDriverFB := TFDPhysFBDriverLink.Create(nil);
  FConnection := TFDConnection.Create(nil);
  CarregarConfiguracao;
end;

destructor TConexao.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
  FConnection.Free;
  FDriverFB.Free;
  inherited;
end;

procedure TConexao.CarregarConfiguracao;
var
  LIni: TIniFile;
  LIniPath: string;
begin
  LIniPath := TPath.GetFullPath(TPath.Combine(GetCurrentDir, '..\..', 'Settings', 'config.ini'));

  if not FileExists(LIniPath) then
    raise Exception.CreateFmt('Arquivo de configuração não encontrado: %s', [LIniPath]);

  LIni := TIniFile.Create(LIniPath);
  try
    FDriverFB.VendorHome  := ExcludeTrailingPathDelimiter(ExtractFilePath(LIni.ReadString('Database', 'ClientLibrary', '')));
    FDriverFB.VendorLib   := ExtractFileName(LIni.ReadString('Database', 'ClientLibrary', ''));

    FConnection.DriverName := 'FB';
    FConnection.Params.Clear;
    FConnection.Params.Values['DriverID']        := 'FB';
    FConnection.Params.Values['Server']          := LIni.ReadString('Database', 'Server',        'localhost');
    FConnection.Params.Values['Port']            := LIni.ReadString('Database', 'Port',          '3050');
    FConnection.Params.Values['Database']        := LIni.ReadString('Database', 'Database',      '');
    FConnection.Params.Values['User_Name']       := LIni.ReadString('Database', 'Username',      'SYSDBA');
    FConnection.Params.Values['Password']        := LIni.ReadString('Database', 'Password',      'masterkey');
    FConnection.Params.Values['CharacterSet']    := 'UTF8';
    FConnection.Connected := True;
  finally
    LIni.Free;
  end;
end;

function TConexao.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

class function TConexao.GetInstance: TConexao;
begin
  if not Assigned(FInstance) then
    FInstance := TConexao.Create;
  Result := FInstance;
end;

class procedure TConexao.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

initialization
  TConexao.GetInstance;

finalization
  TConexao.ReleaseInstance;

end.


