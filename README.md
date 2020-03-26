# fiap-blc-ethereum

Repositório para o projeto de _Smart Contracts Ethereum_ utilizando [Truffle Suite](https://www.trufflesuite.com/).

+ Smart Contract conter pelo menos um método pago e um não pago
+ Smart Contract conter pelo menos uma struct, um mapping e um array
+ Smart Contract conter pelo menos um Oracle (contrato oraclezado ou acesso via smart contract)
+ Deploy na rede Ropsten via truffle
+ Smart Contract(s) verificado(s)
+ ENS para o(s) Smart Contract(s)
+ App-web utilizando MetaMask
+ Deploy app no Swarm
+ ENS para a app
+ Projeto documentado e entrege no github

## 1. sobre o repositório

O repositório possui a seguinte estrutura:

+ [LICENSE](./LICENSE), licença aplicado ao projeto
+ [README.md](./README.md), documentação básica sobre o repositório

A estrutura básica foi criada utilizando os commandos `npm init`, `truffle init` e `npx create-react-app app`.

### 1.1 configuração ambiente

Tanto para codificação quanto execução precisamos apenas do:

+ [NodeJS](https://nodejs.org/) 10.17.0 ou superior
+ [Node.js Package Manager](https://www.npmjs.com/) 6.11.3 ou superior
+ [Node.js Package Runner](https://github.com/npm/npx/) 6.11.3 ou superior
+ [Truffle](https://www.trufflesuite.com/truffle/) 5.0.38 ou superior
+ [Solidity](https://solidity.readthedocs.io/en/latest/) 0.5.8 ou superior
+ [Ganache](https://www.trufflesuite.com/ganache/) 6.7.0 ou superior
+ _demais dependências em [package.json](./package.json)_
