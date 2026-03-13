unit Repository.Pedido;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Model.Pedido,
  Model.PedidoItem,
  Repository.Conexao;

type
  TPedidoRepository = class
  public
    procedure Gravar(APedido: TPedido);
  end;

implementation

{ TPedidoRepository }

procedure TPedidoRepository.Gravar(APedido: TPedido);
var
  LQuery: TFDQuery;
  LItem: TPedidoItem;
  LNumeroPedido: Integer;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := TConexao.GetInstance.Connection;

    LQuery.SQL.Text := 'SELECT GEN_ID(GEN_PEDIDO, 1) AS NOVO_NUM FROM RDB$DATABASE';
    LQuery.Open;
    LNumeroPedido := LQuery.FieldByName('NOVO_NUM').AsInteger;
    LQuery.Close;

    APedido.NumeroPedido := LNumeroPedido;

    LQuery.SQL.Text := 'INSERT INTO PEDIDO (NUMERO_PEDIDO, DATA_EMISSAO, CODIGO_CLIENTE, VALOR_TOTAL, OBSERVACAO) ' +
                       'VALUES (:pNumeroPedido, :pDataEmissao, :pCodigoCliente, :pValorTotal, :pObservacao)';

    LQuery.ParamByName('pNumeroPedido').AsInteger   := APedido.NumeroPedido;
    LQuery.ParamByName('pDataEmissao').AsDate       := APedido.DataEmissao;
    LQuery.ParamByName('pCodigoCliente').AsInteger  := APedido.CodigoCliente;
    LQuery.ParamByName('pValorTotal').AsCurrency    := APedido.ValorTotal;
    LQuery.ExecSQL;

    LQuery.Close;
    LQuery.SQL.Text := 'INSERT INTO PEDIDO_ITEM (NUMERO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, VLR_UNITARIO, VLR_TOTAL) ' +
                       'VALUES (:pNumeroPedido, :pCodigoProduto, :pQuantidade, :pVlrUnitario, :pVlrTotal)';

    for LItem in APedido.Itens do
    begin
      LQuery.ParamByName('pNumeroPedido').AsInteger   := APedido.NumeroPedido;
      LQuery.ParamByName('pCodigoProduto').AsInteger  := LItem.CodigoProduto;
      LQuery.ParamByName('pQuantidade').AsFloat       := LItem.Quantidade;
      LQuery.ParamByName('pVlrUnitario').AsCurrency   := LItem.VlrUnitario;
      LQuery.ParamByName('pVlrTotal').AsCurrency      := LItem.VlrTotal;
      LQuery.ExecSQL;
    end;
    LQuery.Close;
  finally
    LQuery.Free;
  end;
end;

end.
