unit Model.PedidoItem;

interface

type
  TPedidoItem = class
  private
    FID: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FDescricaoProduto: string;
    FQuantidade: Double;
    FVlrUnitario: Currency;
    FVlrTotal: Currency;
  public
    property ID               : Integer  read FID                write FID;
    property NumeroPedido     : Integer  read FNumeroPedido      write FNumeroPedido;
    property CodigoProduto    : Integer  read FCodigoProduto     write FCodigoProduto;
    property DescricaoProduto : string   read FDescricaoProduto  write FDescricaoProduto;
    property Quantidade       : Double   read FQuantidade        write FQuantidade;
    property VlrUnitario      : Currency read FVlrUnitario      write FVlrUnitario;
    property VlrTotal         : Currency read FVlrTotal          write FVlrTotal;
  end;

implementation

end.
