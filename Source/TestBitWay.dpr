program TestBitWay;

uses
  Vcl.Forms,
  Model.Cliente in 'Model\Model.Cliente.pas',
  Model.Produto in 'Model\Model.Produto.pas',
  Model.PedidoItem in 'Model\Model.PedidoItem.pas',
  Model.Pedido in 'Model\Model.Pedido.pas',
  Repository.Conexao in 'Repository\Repository.Conexao.pas',
  Repository.Cliente in 'Repository\Repository.Cliente.pas',
  Repository.Produto in 'Repository\Repository.Produto.pas',
  Repository.Pedido in 'Repository\Repository.Pedido.pas',
  Service.Pedido in 'Service\Service.Pedido.pas',
  View.Pedido in 'View\View.Pedido.pas' {frmPedido};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Casa Construtor - Pedido de Venda';
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
