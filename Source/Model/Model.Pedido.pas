unit Model.Pedido;

interface

uses
  System.Generics.Collections,
  Model.PedidoItem;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FObservacao: string;
    FItens: TObjectList<TPedidoItem>;
  public
    constructor Create;
    destructor Destroy; override;

    property NumeroPedido  : Integer               read FNumeroPedido  write FNumeroPedido;
    property DataEmissao   : TDate                 read FDataEmissao   write FDataEmissao;
    property CodigoCliente : Integer               read FCodigoCliente write FCodigoCliente;
    property ValorTotal    : Currency              read FValorTotal    write FValorTotal;
    property Observacao    : string                read FObservacao    write FObservacao;
    property Itens         : TObjectList<TPedidoItem> read FItens;
  end;

implementation

uses
  System.SysUtils;

{ TPedido }

constructor TPedido.Create;
begin
  inherited;
  FItens := TObjectList<TPedidoItem>.Create(True);
  FDataEmissao := Now;
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

end.
