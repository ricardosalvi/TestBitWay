unit Repository.Cliente;

{
  DAO para a tabela CLIENTE.
  Todas as queries utilizam parâmetros nomeados — nenhuma concatenação de string.
}

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.DApt,
  FireDAC.Stan.Param,
  Model.Cliente,
  Repository.Conexao;

type
  TClienteRepository = class
  public
    function BuscarPorCodigo(ACodigo: Integer): TCliente;
  end;

implementation

{ TClienteRepository }

function TClienteRepository.BuscarPorCodigo(ACodigo: Integer): TCliente;
var
  LQuery: TFDQuery;
begin
  Result := nil;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := TConexao.GetInstance.Connection;
    LQuery.SQL.Text := 'SELECT CODIGO, NOME, CIDADE, UF ' +
                       'FROM   CLIENTE ' +
                       'WHERE  CODIGO = :pCodigo';
    LQuery.ParamByName('pCodigo').AsInteger := ACodigo;
    LQuery.Open;

    if not LQuery.IsEmpty then
    begin
      Result          := TCliente.Create;
      Result.Codigo   := LQuery.FieldByName('CODIGO').AsInteger;
      Result.Nome     := LQuery.FieldByName('NOME').AsString;
      Result.Cidade   := LQuery.FieldByName('CIDADE').AsString;
      Result.UF       := LQuery.FieldByName('UF').AsString;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
