const Marketplace = artifacts.require('Marketplace.sol'); 

contract('Marketplace', async (accounts) => {
    const ENUM_OPERATIONS = {
        BUY: 0,
        SELL: 1,
    }

    const ENUM_COMMODITIES = {
        SUGAR: 0,
        CORN: 1,
        SOY: 2,
    }

    const EVENT_NEW_TRADER_EVENT = 'NewTraderEvent';
    const EVENT_NEW_ORDER_EVENT = 'NewOrderEvent';
    const EVENT_NEW_SELL_EVENT = 'NewSellEvent';
    const EVENT_NEW_BUY_EVENT = 'NewBuyEvent';

    it('deve adicionar novo negociante', async() => {
        // referencia para o contrato
        let marketplace = await Marketplace.new();

        // valores esperados
        let expectedExecutor_1 = {from: accounts[0]};
        let expectedNewAddress = expectedExecutor_1.from;

        let result, event;

        // adiciona negociante
        result = await marketplace.addNewTrader(expectedExecutor_1);
        event = result.logs.find( log => log.event == EVENT_NEW_TRADER_EVENT );

        // verificacoes
        assert.equal(event.args.throwedBy, expectedNewAddress, 'nao foi possivel recuperar o negociante adicionado');
    });

    it('deve adicionar nova ordem', async() => {
        // referencia para o contrato
        let marketplace = await Marketplace.new();

        // valores esperados
        let expectedExecutor_1 = {from: accounts[1]};
        let expectedBuyerAddress = expectedExecutor_1.from;

        let expectedExecutor_2 = {from: expectedBuyerAddress};
        let expectedOperation = ENUM_OPERATIONS.BUY;
        let expectedCommodity = ENUM_COMMODITIES.CORN;
        let expectedAmount = 100;

        let result, event;

        // adiciona negociante
        result = await marketplace.addNewTrader(expectedExecutor_1);

        // adiciona ordem
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_2);
        event = result.logs.find( log => log.event == EVENT_NEW_ORDER_EVENT );
        
        // verificacoes
        assert.equal(event.args.operation, expectedOperation, 'nao foi possivel recuperar a operaco adicionada');
        assert.equal(event.args.commodity, expectedCommodity, 'nao foi possivel recuperar a mercadoria adicionada');
        assert.equal(event.args.amount, expectedAmount, 'nao foi possivel recuperar a quantidade adicionada');
        assert.equal(event.args.throwedBy, expectedBuyerAddress, 'nao foi possivel recuperar o executor');
    });

    it('deve consultar ordens de venda', async() => {
        // referencia para o contrato
        let marketplace = await Marketplace.new();

        // valores esperados
        let expectedExecutor_1 = {from: accounts[2]};
        let expectedBuyerAddress = expectedExecutor_1.from;

        let expectedExecutor_2 = {from: expectedBuyerAddress};
        let expectedOperation = ENUM_OPERATIONS.BUY;
        let expectedCommodity = ENUM_COMMODITIES.CORN;
        let expectedAmount = 200;

        let expectedExecutor_3 = {from: expectedBuyerAddress};
        let expectedResultLength = 3;

        let result, event;

        // adiciona negociante
        result = await marketplace.addNewTrader(expectedExecutor_1);

        // adiciona ordens
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_2);
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_2);
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_2);

        // consulta ordens
        result = await marketplace.getAllOrdersByCommodity(expectedCommodity, expectedExecutor_3);

        // verificacoes
        assert.equal(result.length, expectedResultLength, 'nao foi possivel recuperar a lista de indices das ordens adicionadas');
    });

    it('deve adicionar um novo vendedor para uma ordem de compra', async() => {
        // referencia para o contrato
        let marketplace = await Marketplace.new();

        // valores esperados
        let expectedExecutor_1 = {from: accounts[3]};
        let expectedBuyerAddress = expectedExecutor_1.from;

        let expectedExecutor_2 = {from: accounts[4]};
        let expectedSellerAddress = expectedExecutor_2.from;

        let expectedExecutor_3 = {from: expectedBuyerAddress};
        let expectedOperation = ENUM_OPERATIONS.BUY;
        let expectedCommodity = ENUM_COMMODITIES.CORN;
        let expectedAmount = 300;

        let expectedExecutor_4 = {from: expectedSellerAddress, value: 1000};
        let expectedOrderIndex = 0;

        let result, event;

        // adiciona negociantes: comprador e vendedor
        result = await marketplace.addNewTrader(expectedExecutor_1);
        result = await marketplace.addNewTrader(expectedExecutor_2);

        // adiciona ordem de compra
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_3);

        // adiciona vendedor
        result = await marketplace.executeOrder(expectedOrderIndex, expectedExecutor_4);
        event = result.logs.find( log => log.event == EVENT_NEW_SELL_EVENT );

        // verificacoes
        assert.equal(event.args.seller, expectedSellerAddress, 'nao foi possivel recuperar o vendedor');
        assert.equal(event.args.buyer, expectedBuyerAddress, 'nao foi possivel recuperar o comprador');
        assert.equal(event.args.commodity, expectedCommodity, 'nao foi possivel recuperar a comprada');
        assert.equal(event.args.amount, expectedAmount, 'nao foi possivel recuperar a quantidade comprada');
    });

    it('deve adicionar um novo comprador para uma ordem de venda', async() => {
        // referencia para o contrato
        let marketplace = await Marketplace.new();

        // valores esperados
        let expectedExecutor_1 = {from: accounts[4]};
        let expectedBuyerAddress = expectedExecutor_1.from;

        let expectedExecutor_2 = {from: accounts[5]};
        let expectedSellerAddress = expectedExecutor_2.from;

        let expectedExecutor_3 = {from: expectedSellerAddress};
        let expectedOperation = ENUM_OPERATIONS.SELL;
        let expectedCommodity = ENUM_COMMODITIES.SUGAR;
        let expectedAmount = 400;

        let expectedExecutor_4 = {from: expectedBuyerAddress, value: 2000};
        let expectedOrderIndex = 0;

        let result, event;

        // adiciona negociantes: comprador e vendedor
        result = await marketplace.addNewTrader(expectedExecutor_1);
        result = await marketplace.addNewTrader(expectedExecutor_2);

        // adiciona ordem de venda
        result = await marketplace.addNewOrder(expectedOperation, expectedCommodity, expectedAmount, expectedExecutor_3);

        // adiciona comprador
        result = await marketplace.executeOrder(expectedOrderIndex, expectedExecutor_4);
        event = result.logs.find( log => log.event == EVENT_NEW_BUY_EVENT );

        // verificacoes
        assert.equal(event.args.seller, expectedSellerAddress, 'nao foi possivel recuperar o vendedor');
        assert.equal(event.args.buyer, expectedBuyerAddress, 'nao foi possivel recuperar o comprador');
        assert.equal(event.args.commodity, expectedCommodity, 'nao foi possivel recuperar a comprada');
        assert.equal(event.args.amount, expectedAmount, 'nao foi possivel recuperar a quantidade comprada');
    });
});