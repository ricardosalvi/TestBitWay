object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 720
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 17
  object pnlCliente: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTituloCliente: TLabel
      Left = 8
      Top = 6
      Width = 51
      Height = 17
      Caption = 'CLIENTE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCodigoCliente: TLabel
      Left = 8
      Top = 32
      Width = 46
      Height = 17
      Caption = 'C'#243'digo:'
    end
    object lblNomeLabel: TLabel
      Left = 160
      Top = 32
      Width = 39
      Height = 17
      Caption = 'Nome:'
    end
    object lblNome: TLabel
      Left = 208
      Top = 32
      Width = 260
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCidadeLabel: TLabel
      Left = 480
      Top = 32
      Width = 44
      Height = 17
      Caption = 'Cidade:'
    end
    object lblCidade: TLabel
      Left = 532
      Top = 32
      Width = 180
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUFLabel: TLabel
      Left = 720
      Top = 32
      Width = 18
      Height = 17
      Caption = 'UF:'
    end
    object lblUF: TLabel
      Left = 748
      Top = 32
      Width = 4
      Height = 17
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtCodigoCliente: TEdit
      Left = 64
      Top = 28
      Width = 80
      Height = 25
      MaxLength = 10
      TabOrder = 0
      OnExit = edtCodigoClienteExit
      OnKeyPress = edtCodigoClienteKeyPress
    end
  end
  object pnlItem: TPanel
    Left = 0
    Top = 80
    Width = 1024
    Height = 110
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblTituloItem: TLabel
      Left = 8
      Top = 6
      Width = 31
      Height = 17
      Caption = 'ITEM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCodigoProduto: TLabel
      Left = 8
      Top = 34
      Width = 50
      Height = 17
      Caption = 'Produto:'
    end
    object lblDescricao: TLabel
      Left = 150
      Top = 34
      Width = 60
      Height = 17
      Caption = 'Descri'#231#227'o:'
    end
    object lblDescricaoValor: TLabel
      Left = 218
      Top = 34
      Width = 300
      Height = 17
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblQuantidade: TLabel
      Left = 8
      Top = 70
      Width = 25
      Height = 17
      Caption = 'Qtd:'
    end
    object lblVlrUnit: TLabel
      Left = 168
      Top = 70
      Width = 47
      Height = 17
      Caption = 'Vl. Unit.:'
    end
    object lblVlrItem: TLabel
      Left = 344
      Top = 70
      Width = 46
      Height = 17
      Caption = 'Vl. Item:'
    end
    object lblVlrItemValor: TLabel
      Left = 416
      Top = 70
      Width = 44
      Height = 17
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtCodigoProduto: TEdit
      Left = 72
      Top = 30
      Width = 70
      Height = 25
      MaxLength = 10
      TabOrder = 0
      OnExit = edtCodigoProdutoExit
      OnKeyPress = edtCodigoProdutoKeyPress
    end
    object edtQuantidade: TEdit
      Left = 72
      Top = 66
      Width = 80
      Height = 25
      TabOrder = 1
      Text = '1'
      OnExit = edtQuantidadeExit
    end
    object edtVlrUnit: TEdit
      Left = 228
      Top = 66
      Width = 100
      Height = 25
      TabOrder = 2
      Text = '0,00'
      OnExit = edtVlrUnitExit
    end
    object btnAdicionarItem: TButton
      Left = 560
      Top = 64
      Width = 130
      Height = 29
      Caption = '+ Adicionar Item'
      TabOrder = 3
      OnClick = btnAdicionarItemClick
    end
    object btnLimparItem: TButton
      Left = 698
      Top = 64
      Width = 90
      Height = 29
      Caption = 'Limpar'
      TabOrder = 4
      OnClick = btnLimparItemClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 190
    Width = 1024
    Height = 380
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblTituloItens: TLabel
      Left = 8
      Top = 4
      Width = 36
      Height = 17
      Caption = 'ITENS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object grdItens: TDBGrid
      Left = 8
      Top = 24
      Width = 1008
      Height = 348
      DataSource = dsItens
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = grdItensKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'CODIGO_PRODUTO'
          Title.Caption = 'C'#243'digo'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRICAO'
          Title.Caption = 'Descri'#231#227'o'
          Width = 400
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QUANTIDADE'
          Title.Caption = 'Qtd'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VLR_UNITARIO'
          Title.Caption = 'Vl. Unit.'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VLR_TOTAL'
          Title.Caption = 'Vl. Total'
          Width = 120
          Visible = True
        end>
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 570
    Width = 1024
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lblTotalLabel: TLabel
      Left = 740
      Top = 28
      Width = 86
      Height = 17
      Caption = 'Total do Ped.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotal: TLabel
      Left = 740
      Top = 50
      Width = 66
      Height = 25
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnNovo: TButton
      Left = 740
      Top = 95
      Width = 120
      Height = 36
      Caption = 'Novo Pedido'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnGravar: TButton
      Left = 872
      Top = 95
      Width = 140
      Height = 36
      Caption = 'Gravar Pedido'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnGravarClick
    end
  end
  object dsItens: TDataSource
    DataSet = mtItens
    Left = 944
    Top = 4
  end
  object mtItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 944
    Top = 44
    object mtItensID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtItensCodigoProduto: TIntegerField
      FieldName = 'CODIGO_PRODUTO'
    end
    object mtItensDescricao: TStringField
      FieldName = 'DESCRICAO'
      Size = 150
    end
    object mtItensQuantidade: TFloatField
      FieldName = 'QUANTIDADE'
      DisplayFormat = '#,##0.000'
    end
    object mtItensVlrUnitario: TCurrencyField
      FieldName = 'VLR_UNITARIO'
      DisplayFormat = '"R$" #,##0.00'
    end
    object mtItensVlrTotal: TCurrencyField
      FieldName = 'VLR_TOTAL'
      DisplayFormat = '"R$" #,##0.00'
    end
  end
end
