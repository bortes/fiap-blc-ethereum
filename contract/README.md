# sobre o contrato

O objetivo do contrato construído é apresentar, de maneira extramamente simples, um balcão de negociação.

Nele um `negociante` podem regsitrar ofertas de compra e venda.

Apenas usuários cadastrados como `negociante` podem registrar ofertas.

Qualquer `negociante` pode comprar e vender, inclusive é possível comprar ou vender sua própria oferta.

Foram habilitadas as seguintes mercadorias:

+ açucar cristal
+ milho
+ soja

## 1. funcionalidades

As funcionalidades **públicas** estão acessíveis por meio do **ABI** do [contrato](./contracts/Marketplace.sol).

Apenas endereços registrados como `NEGOCIANTE` podem acessar consultar, registrar ou executar as ofertas disponíveis.

Qualquer usuário pode se auto registrar por meio da funcionalidade **adiciona um novo negociante**.

Considere a seguinte relação chave-valor para os enumeradores abaixo utilizados pelo contrato.

**enumerador tipo de ordem**

|Chave|Valor|Ordem|
|:-:|---|---|
|0|`BUY`|ordem de compra|
|1|`SELL`|ordem de venda|

**enumerador tipo da mercadoria**

|Chave|Valor|Mercadoria|
|:-:|---|---|
|0|`SUGAR`|açucar cristal|
|1|`CORN`|milho|
|2|`SOY`|soja|

### 1.1 adiciona um novo negociante

Registra o endereço que executou a transação como um negociante tornando-o aptor para incluir e executar ofertas de compra e venda.

#### 1.1.1 parâmetros

#### 1.1.2 retorno

### 1.2 adiciona uma nova ordem para uma mercadoria disponível `NEGOCIANTE`

Registra uma nova ordem de compra ou venda para a mercadoria disponível.

#### 1.2.1 parâmetros

1. operation: 8 Bytes - tipo da ordem*
2. commodity: 8 Bytes - tipo da mercadoria**
3. amount: 32 Bytes - quantidade ofertada da mercadoria informada

#### 1.2.2 retorno

\* _consulte o enumerador tipo de ordem para identificar os valores_
\*\* _consulte o enumerador tipo da mercadoria para identificar os valores_

### 1.3 consulta todos as ordens disponiveis para uma mercadoria `NEGOCIANTE`

Recupera uma lista com todos os índices das ordens registradas, tanto as executadas quanto as não executadas.

#### 1.3.1 parâmetros

1. commodity: 8 Bytes - tipo da mercadoria*

#### 1.3.2 retorno

1. `indexes`: ARRAY de 32 Bytes - lista índices das ordens registradas.

\* _consulte o enumerador tipo de ordem para identificar os valores_

### 1.4 consulta a ordem `NEGOCIANTE`

Recupera os dados de uma ordem específica por meio do índice informado.

#### 1.4.1 parâmetros

1. index: 32 Bytes - indice da ordem

#### 1.4.2 retorno

1. seller`: 20 Bytes - endereço do sacado associado à nota/título da operação.
2. buyer`: 20 Bytes - endereço do sacado associado à nota/título da operação.
3. commodity: 8 Bytes - tipo da mercadoria*
4. operation: 8 Bytes - tipo da ordem**
5. amount: uint256 - quantidade ofertada da mercadoria informada
6. executed: Boolean - se `true` ordem já executada. se `false` a ordem disponível para execução .

\* _consulte o enumerador tipo de ordem para identificar os valores_
\*\* _consulte o enumerador tipo da mercadoria para identificar os valores_

### 1.5 executa a ordem informada `NEGOCIANTE`

Executa a ordem específicada por meio do índice informado.

#### 1.5.1 parâmetros

1. index: 32 Bytes - indice da ordem

#### 1.5.2 retorno
