unit Service.Pedido;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Model.Cliente,
  Model.Produto,
  Model.Pedido,
  Model.PedidoItem,
  Repository.Conexao,
  Repository.Cliente,
  Repository.Produto,
  Repository.Pedido;

type
  TPedidoService = class
  private
    FClienteRepo: TClienteRepository;
    FProdutoRepo: TProdutoRepository;
    FPedidoRepo: TPedidoRepository;
  public
    constructor Create;
    destructor Destroy; override;

    function ValidarCliente(ACodigo: Integer): TCliente;
    function BuscarProduto(ACodigo: Integer): TProduto;
    function CalcularTotalItem(AQuantidade: Double; AVlrUnitario: Currency): Currency;
    function CalcularTotalPedido(AItens: TObjectList<TPedidoItem>): Currency;
    procedure GravarPedido(APedido: TPedido);
  end;

implementation

{ TPedidoService }

constructor TPedidoService.Create;
begin
  inherited;
  FClienteRepo := TClienteRepository.Create;
  FProdutoRepo := TProdutoRepository.Create;
  FPedidoRepo  := TPedidoRepository.Create;
end;

destructor TPedidoService.Destroy;
begin
  FClienteRepo.Free;
  FProdutoRepo.Free;
  FPedidoRepo.Free;
  inherited;
end;

function TPedidoService.ValidarCliente(ACodigo: Integer): TCliente;
begin
  Result := FClienteRepo.BuscarPorCodigo(ACodigo);
  if not Assigned(Result) then
    raise EArgumentException.CreateFmt('Cliente com código %d não encontrado.', [ACodigo]);
end;

function TPedidoService.BuscarProduto(ACodigo: Integer): TProduto;
begin
  Result := FProdutoRepo.BuscarPorCodigo(ACodigo);
  if not Assigned(Result) then
    raise EArgumentException.CreateFmt('Produto com código %d não encontrado.', [ACodigo]);
end;

function TPedidoService.CalcularTotalItem(AQuantidade: Double; AVlrUnitario: Currency): Currency;
begin
  Result := AQuantidade * AVlrUnitario;
end;

function TPedidoService.CalcularTotalPedido(AItens: TObjectList<TPedidoItem>): Currency;
var
  LItem: TPedidoItem;
begin
  Result := 0;
  for LItem in AItens do
    Result := Result + LItem.VlrTotal;
end;

procedure TPedidoService.GravarPedido(APedido: TPedido);
begin
  if APedido.Itens.Count = 0 then
    raise EInvalidOpException.Create('O pedido deve conter ao menos um item.');

  TConexao.GetInstance.Connection.StartTransaction;
  try
    FPedidoRepo.Gravar(APedido);
    TConexao.GetInstance.Connection.Commit;
  except
    on e:exception do
    begin
      TConexao.GetInstance.Connection.Rollback;
      raise Exception.Create('Erro ao inserir pedido!' + sLineBreak + e.Message);
    end;
  end;
end;

end.
