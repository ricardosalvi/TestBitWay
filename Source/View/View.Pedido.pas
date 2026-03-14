unit View.Pedido;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Model.Cliente,
  Model.Produto,
  Model.Pedido,
  Model.PedidoItem,
  Service.Pedido;

type
  TfrmPedido = class(TForm)
    pnlCliente: TPanel;
    pnlItem: TPanel;
    pnlGrid: TPanel;
    pnlRodape: TPanel;

    lblTituloCliente: TLabel;
    lblCodigoCliente: TLabel;
    edtCodigoCliente: TEdit;
    lblNomeLabel: TLabel;
    lblNome: TLabel;
    lblCidadeLabel: TLabel;
    lblCidade: TLabel;
    lblUFLabel: TLabel;
    lblUF: TLabel;

    lblTituloItem: TLabel;
    lblCodigoProduto: TLabel;
    edtCodigoProduto: TEdit;
    lblDescricao: TLabel;
    lblDescricaoValor: TLabel;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    lblVlrUnit: TLabel;
    edtVlrUnit: TEdit;
    lblVlrItem: TLabel;
    lblVlrItemValor: TLabel;
    btnAdicionarItem: TButton;
    btnLimparItem: TButton;

    lblTituloItens: TLabel;
    grdItens: TDBGrid;
    dsItens: TDataSource;
    mtItens: TFDMemTable;
    mtItensID: TIntegerField;
    mtItensCodigoProduto: TIntegerField;
    mtItensDescricao: TStringField;
    mtItensQuantidade: TFloatField;
    mtItensVlrUnitario: TCurrencyField;
    mtItensVlrTotal: TCurrencyField;

    lblObservacao: TLabel;
    memObservacao: TMemo;
    lblTotalLabel: TLabel;
    lblTotal: TLabel;

    btnNovo: TButton;
    btnGravar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtVlrUnitExit(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnLimparItemClick(Sender: TObject);
    procedure grdItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);

  private
    FService: TPedidoService;
    FClienteAtual: TCliente;
    FProdutoAtual: TProduto;

    procedure InicializarMemTable;
    procedure LimparCamposCliente;
    procedure LimparCamposItem;
    procedure LimparTudo;
    procedure RecalcularTotal;
    procedure CarregarItemParaEdicao;
    procedure ExcluirItemSelecionado;
    procedure AtualizarLabelVlrItem;

    function ValidarCamposItem: Boolean;
  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.dfm}

uses
  System.StrUtils;

{ TfrmPedido }

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  FService := TPedidoService.Create;
  FClienteAtual := nil;
  FProdutoAtual := nil;

  InicializarMemTable;
  LimparTudo;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FClienteAtual);
  FreeAndNil(FProdutoAtual);
  FService.Free;
end;

procedure TfrmPedido.InicializarMemTable;
begin
  mtItens.Open;
end;

procedure TfrmPedido.LimparCamposCliente;
begin
  edtCodigoCliente.Clear;
  lblNome.Caption    := '';
  lblCidade.Caption  := '';
  lblUF.Caption      := '';
  FreeAndNil(FClienteAtual);
end;

procedure TfrmPedido.LimparCamposItem;
begin
  edtCodigoProduto.Clear;
  lblDescricaoValor.Caption := '';
  edtQuantidade.Clear;
  edtVlrUnit.Clear;
  lblVlrItemValor.Caption := 'R$ 0,00';
  FreeAndNil(FProdutoAtual);
end;

procedure TfrmPedido.LimparTudo;
begin
  LimparCamposCliente;
  LimparCamposItem;
  mtItens.EmptyDataSet;
  memObservacao.Clear;
  lblTotal.Caption := 'R$ 0,00';
end;

procedure TfrmPedido.RecalcularTotal;
var
  LTotal: Currency;
begin
  LTotal := 0;
  mtItens.First;
  while not mtItens.Eof do
  begin
    LTotal := LTotal + mtItensVlrTotal.AsCurrency;
    mtItens.Next;
  end;
  lblTotal.Caption := FormatCurr('"R$" #,##0.00', LTotal);
end;

procedure TfrmPedido.AtualizarLabelVlrItem;
var
  LQtd: Double;
  LUnit: Currency;
begin
  try
    LQtd  := StrToFloatDef(edtQuantidade.Text, 0);
    LUnit := StrToCurrDef(edtVlrUnit.Text, 0);
    lblVlrItemValor.Caption :=
      FormatCurr('"R$" #,##0.00', FService.CalcularTotalItem(LQtd, LUnit));
  except
    lblVlrItemValor.Caption := 'R$ 0,00';
  end;
end;

procedure TfrmPedido.edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmPedido.edtCodigoClienteExit(Sender: TObject);
var
  LCodigo: Integer;
begin
  if Trim(edtCodigoCliente.Text) = '' then
    Exit;

  LCodigo := StrToIntDef(edtCodigoCliente.Text, 0);
  if LCodigo <= 0 then
  begin
    ShowMessage('Código de cliente inválido.');
    edtCodigoCliente.SetFocus;
    Exit;
  end;

  FreeAndNil(FClienteAtual);
  try
    FClienteAtual := FService.ValidarCliente(LCodigo);
    lblNome.Caption   := FClienteAtual.Nome;
    lblCidade.Caption := FClienteAtual.Cidade;
    lblUF.Caption     := FClienteAtual.UF;
  except
    on E: EArgumentException do
    begin
      ShowMessage(E.Message);
      LimparCamposCliente;
      edtCodigoCliente.SetFocus;
    end;
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar cliente: ' + E.Message);
      LimparCamposCliente;
      edtCodigoCliente.SetFocus;
    end;
  end;
end;

procedure TfrmPedido.edtCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmPedido.edtCodigoProdutoExit(Sender: TObject);
var
  LCodigo: Integer;
begin
  if Trim(edtCodigoProduto.Text) = '' then
    Exit;

  LCodigo := StrToIntDef(edtCodigoProduto.Text, 0);
  if LCodigo <= 0 then
  begin
    ShowMessage('Código de produto inválido.');
    edtCodigoProduto.SetFocus;
    Exit;
  end;

  FreeAndNil(FProdutoAtual);
  try
    FProdutoAtual := FService.BuscarProduto(LCodigo);
    lblDescricaoValor.Caption := FProdutoAtual.Descricao;
    edtVlrUnit.Text := FormatFloat('0.00', FProdutoAtual.PrecoVenda);
    AtualizarLabelVlrItem;
    edtQuantidade.SetFocus;
  except
    on E: EArgumentException do
    begin
      ShowMessage(E.Message);
      LimparCamposItem;
    end;
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar produto: ' + E.Message);
      LimparCamposItem;
    end;
  end;
end;

procedure TfrmPedido.edtQuantidadeExit(Sender: TObject);
begin
  AtualizarLabelVlrItem;
end;

procedure TfrmPedido.edtVlrUnitExit(Sender: TObject);
begin
  AtualizarLabelVlrItem;
end;

function TfrmPedido.ValidarCamposItem: Boolean;
begin
  Result := False;

  if not Assigned(FClienteAtual) then
  begin
    ShowMessage('Informe e valide o cliente antes de adicionar itens.');
    edtCodigoCliente.SetFocus;
    Exit;
  end;

  if not Assigned(FProdutoAtual) then
  begin
    ShowMessage('Informe e valide o produto.');
    edtCodigoProduto.SetFocus;
    Exit;
  end;

  if StrToFloatDef(edtQuantidade.Text, 0) <= 0 then
  begin
    ShowMessage('A quantidade deve ser maior que zero.');
    edtQuantidade.SetFocus;
    Exit;
  end;

  if StrToCurrDef(edtVlrUnit.Text, 0) <= 0 then
  begin
    ShowMessage('O valor unitário deve ser maior que zero.');
    edtVlrUnit.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmPedido.btnAdicionarItemClick(Sender: TObject);
var
  LQtd: Double;
  LUnit: Currency;
  LTotal: Currency;
begin
  if not ValidarCamposItem then
    Exit;

  LQtd   := StrToFloat(edtQuantidade.Text);
  LUnit  := StrToCurr(edtVlrUnit.Text);
  LTotal := FService.CalcularTotalItem(LQtd, LUnit);

  mtItens.Append;
  try
    mtItensCodigoProduto.AsInteger := FProdutoAtual.Codigo;
    mtItensDescricao.AsString      := FProdutoAtual.Descricao;
    mtItensQuantidade.AsFloat      := LQtd;
    mtItensVlrUnitario.AsCurrency  := LUnit;
    mtItensVlrTotal.AsCurrency     := LTotal;
    mtItens.Post;
  except
    mtItens.Cancel;
    raise;
  end;

  RecalcularTotal;
  LimparCamposItem;
end;

procedure TfrmPedido.btnLimparItemClick(Sender: TObject);
begin
  LimparCamposItem;
end;

procedure TfrmPedido.CarregarItemParaEdicao;
begin
  if mtItens.IsEmpty then
    Exit;

  FreeAndNil(FProdutoAtual);
  FProdutoAtual             := TProduto.Create;
  FProdutoAtual.Codigo      := mtItensCodigoProduto.AsInteger;
  FProdutoAtual.Descricao   := mtItensDescricao.AsString;
  FProdutoAtual.PrecoVenda  := mtItensVlrUnitario.AsCurrency;

  edtCodigoProduto.Text         := IntToStr(mtItensCodigoProduto.AsInteger);
  lblDescricaoValor.Caption     := mtItensDescricao.AsString;
  edtQuantidade.Text            := FloatToStr(mtItensQuantidade.AsFloat);
  edtVlrUnit.Text               := FormatFloat('0.00', mtItensVlrUnitario.AsCurrency);
  lblVlrItemValor.Caption       := FormatCurr('"R$" #,##0.00', mtItensVlrTotal.AsCurrency);

  mtItens.Delete;
  RecalcularTotal;

  edtQuantidade.SetFocus;
end;

procedure TfrmPedido.ExcluirItemSelecionado;
begin
  if mtItens.IsEmpty then
    Exit;

  if MessageDlg('Deseja excluir o item selecionado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    mtItens.Delete;
    RecalcularTotal;
  end;
end;

procedure TfrmPedido.grdItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin
      CarregarItemParaEdicao;
      Key := 0;
    end;
    VK_DELETE: begin
      ExcluirItemSelecionado;
      Key := 0;
    end;
  end;
end;

procedure TfrmPedido.btnNovoClick(Sender: TObject);
begin
  if (not mtItens.IsEmpty) then
    if MessageDlg('Deseja iniciar um novo pedido? Os dados não salvos serão perdidos.', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  LimparTudo;
end;

procedure TfrmPedido.btnGravarClick(Sender: TObject);
var
  LPedido: TPedido;
  LItem: TPedidoItem;
begin
  if not Assigned(FClienteAtual) then
  begin
    ShowMessage('Informe e valide o cliente.');
    edtCodigoCliente.SetFocus;
    Exit;
  end;

  if mtItens.IsEmpty then
  begin
    ShowMessage('Adicione ao menos um item ao pedido.');
    edtCodigoProduto.SetFocus;
    Exit;
  end;

  LPedido := TPedido.Create;
  try
    LPedido.DataEmissao   := Now;
    LPedido.CodigoCliente := FClienteAtual.Codigo;
    LPedido.Observacao    := Trim(memObservacao.Text);

    mtItens.First;
    while not mtItens.Eof do
    begin
      LItem                  := TPedidoItem.Create;
      LItem.CodigoProduto    := mtItensCodigoProduto.AsInteger;
      LItem.DescricaoProduto := mtItensDescricao.AsString;
      LItem.Quantidade       := mtItensQuantidade.AsFloat;
      LItem.VlrUnitario      := mtItensVlrUnitario.AsCurrency;
      LItem.VlrTotal         := mtItensVlrTotal.AsCurrency;
      LPedido.Itens.Add(LItem);
      mtItens.Next;
    end;

    LPedido.ValorTotal := FService.CalcularTotalPedido(LPedido.Itens);

    FService.GravarPedido(LPedido);

    ShowMessage(Format(
      'Pedido nº %d gravado com sucesso!' + sLineBreak +
      'Total: %s',
      [LPedido.NumeroPedido,
       FormatCurr('"R$" #,##0.00', LPedido.ValorTotal)]));

    LimparTudo;
  except
    on E: EInvalidOpException do
      ShowMessage(E.Message);
    on E: Exception do
      ShowMessage('Erro ao gravar pedido: ' + E.Message);
  end;
  LPedido.Free;
end;

end.
