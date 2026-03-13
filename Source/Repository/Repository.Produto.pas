unit Repository.Produto;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Model.Produto,
  Repository.Conexao;

type
  TProdutoRepository = class
  public
    function BuscarPorCodigo(ACodigo: Integer): TProduto;
  end;

implementation

{ TProdutoRepository }

function TProdutoRepository.BuscarPorCodigo(ACodigo: Integer): TProduto;
var
  LQuery: TFDQuery;
begin
  Result := nil;

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := TConexao.GetInstance.Connection;
    LQuery.SQL.Text := 'SELECT CODIGO, DESCRICAO, PRECO_VENDA ' +
                       'FROM   PRODUTO ' +
                       'WHERE  CODIGO = :pCodigo';
    LQuery.ParamByName('pCodigo').AsInteger := ACodigo;
    LQuery.Open;

    if not LQuery.IsEmpty then
    begin
      Result             := TProduto.Create;
      Result.Codigo      := LQuery.FieldByName('CODIGO').AsInteger;
      Result.Descricao   := LQuery.FieldByName('DESCRICAO').AsString;
      Result.PrecoVenda  := LQuery.FieldByName('PRECO_VENDA').AsCurrency;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
