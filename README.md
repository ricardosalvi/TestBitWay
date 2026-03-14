# Sistema de Pedido de Venda

## O que foi implementado

Sistema de **Pedido de Venda** em Delphi 12 + FireDAC + Firebird.

---

## Arquivos gerados

### Banco de Dados
| Arquivo | Descrição |
|---|---|
| [setup.sql](file://Database/setup.sql) | DDL completo: generators, triggers, tabelas, FK, índices, seed data |
| [update-observacao.sql](file://Database/update-observacao.sql) | DDL Update: Criação do campo Observação no Pedido |
| [config.ini](file://Settings/config.ini) | Parâmetros de conexão lidos dinamicamente em runtime |

### Model (`Source/Model/`)
| Arquivo | Classe | Campos |
|---|---|---|
| [Model.Cliente.pas](file://Source/Model/Model.Cliente.pas) | `TCliente` | Codigo, Nome, Cidade, UF |
| [Model.Produto.pas](file://Source/Model/Model.Produto.pas) | `TProduto` | Codigo, Descricao, PrecoVenda |
| [Model.PedidoItem.pas](file://Source/Model/Model.PedidoItem.pas) | `TPedidoItem` | ID, NumeroPedido, CodigoProduto, Quantidade, VlrUnitario, VlrTotal |
| [Model.Pedido.pas](file://Source/Model/Model.Pedido.pas) | `TPedido` | NumeroPedido, DataEmissao, CodigoCliente, ValorTotal, Observacao, Itens |

### Repository (`Source/Repository/`)
| Arquivo | Responsabilidade |
|---|---|
| [Repository.Conexao.pas](file://Source/Repository/Repository.Conexao.pas) | Singleton `TConexao`: lê `config.ini`, configura e expõe `TFDConnection` |
| [Repository.Cliente.pas](file://Source/Repository/Repository.Cliente.pas) | `BuscarPorCodigo` — SELECT parametrizado em CLIENTE |
| [Repository.Produto.pas](file://Source/Repository/Repository.Produto.pas) | `BuscarPorCodigo` — SELECT parametrizado em PRODUTO |
| [Repository.Pedido.pas](file://Source/Repository/Repository.Pedido.pas) | `Gravar` — GEN_ID + INSERT no PEDIDO + INSERTs em PEDIDO_ITEM |

### Service (`Source/Service/`)
| Arquivo | Métodos |
|---|---|
| [Service.Pedido.pas](file://Source/Service/Service.Pedido.pas) | `ValidarCliente`, `BuscarProduto`, `CalcularTotalItem`, `CalcularTotalPedido`, `GravarPedido` |

### View (`Source/View/`)
| Arquivo | Descrição |
|---|---|
| [View.Pedido.pas](file://Source/View/View.Pedido.pas) | Lógica do formulário completo |
| [View.Pedido.dfm](file://Source/View/View.Pedido.dfm) | Layout: 4 painéis, TDBGrid + TFDMemTable, labels, botões |

### Projeto
| Arquivo | Descrição |
|---|---|
| [TestBitWay.dpr](file://Source/TestBitWay.dpr) | Project file Delphi 12 registrando todas as units |

---

## Requisitos atendidos

| Requisito | Status | Detalhe |
|---|---|---|
| Tabelas com PKs, FKs, constraints | ✅ | `setup.sql` |
| Generators + Triggers para PKs | ✅ | `GEN_PEDIDO`, `GEN_PEDIDO_ITEM`, `BI_PEDIDO`, `BI_PEDIDO_ITEM` |
| Índices obrigatórios | ✅ | `IDX_PEDIDO_CLIENTE`, `IDX_ITEM_PEDIDO` |
| Seed data ≥ 10 registros | ✅ | 12 CLIENTEs, 12 PRODUTOs |
| Conexão via `config.ini` | ✅ | `Repository.Conexao.CarregarConfiguracao` |
| Queries parametrizadas (sem concatenação) | ✅ | Todos os SQLs usam `:pNome` |
| StartTransaction / Commit / Rollback | ✅ | `Service.Pedido.GravarPedido` |
| Validação de cliente na entrada | ✅ | `edtCodigoClienteExit` → `Service.ValidarCliente` |
| Sugestão de preço do produto | ✅ | `edtCodigoProdutoExit` → preenche `edtVlrUnit` |
| Grid com listagem de itens | ✅ | `TDBGrid` + `TFDMemTable` |
| ENTER no grid carrega item p/ edição | ✅ | `grdItensKeyDown` → `CarregarItemParaEdicao` |
| DEL no grid exclui com confirmação | ✅ | `grdItensKeyDown` → `ExcluirItemSelecionado` |
| Recalcular total imediatamente | ✅ | `RecalcularTotal` chamado após add/del |
| Produtos duplicados em linhas separadas | ✅ | `TFDMemTable.Append` sem restrição de unicidade |
| Arquitetura MVC/Service/Repository | ✅ | 4 camadas separadas, sem SQL na View |

---

## Como executar

### 1. Criar o banco de dados Firebird
Altere o script de criação do banco `..\Database\setup.sql` com as informações necessárias:
```
CREATE DATABASE '<Caminho_Completo_do_Banco>'
USER 'SYSDBA' PASSWORD 'masterkey'
``` 
Rode o script para criar o banco:
```
isql -i 'C:\..\Database\setup.sql';
SQL> EXIT;
```

Rode o script `\Database\update-observacao.sql` para atualizar o campo Observação do pedido:
```
isql -user SYSDBA -password masterkey;
SQL> CONNECT '<CAMINHO_BANCO>';
SQL> INPUT '..\Database\update-observacao.sql';
SQL> EXIT;
```

### 2. Ajustar `config.ini`
Editar `C:\..\Settings\config.ini` para apontar ao caminho correto do `.FDB` e do `fbclient.dll`.

### 3. Abrir o projeto no Delphi 12
Abrir `Source\TestBitWay.dpr` e compilar (`F9`).


### 4. Fluxo de teste sugerido
1. Informar código de cliente (ex: `1`) → Tab → Nome/Cidade/UF preenchidos
2. Informar código de produto (ex: `5`) → Tab → preço sugerido automaticamente
3. Ajustar quantidade → `+ Adicionar Item` → item aparece no grid
4. Selecionar item no grid → pressionar `ENTER` → campos carregados para edição
5. Selecionar item → pressionar `DEL` → confirmação → total recalculado
6. Clicar **Gravar Pedido** → mensagem de sucesso com número do pedido

