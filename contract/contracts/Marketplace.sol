pragma solidity ^0.5.8;

contract Marketplace {
    //
    // ENUMERADORES / ESTRUTURAS
    //
    enum Operations {
        BUY, // compra de commodity
        SELL // venda de commodity
    }

    enum Commodities {
        SUGAR, // futuro de acucar cristal com liquidacao financeira
        CORN, // futuro de milho com liquidacao financeira
        SOY // futuro de soja com liquidacao financeira
    }

    struct Order {
        address payable seller;
        address payable buyer;
        Commodities commodity;
        Operations operation;
        uint256 amount;
        bool executed;
    }

    struct OrderList {
        bool initialized;
        uint256[] itens;
    }

    //
    // EVENTOS
    //


    /**
     * @dev evento disparado quando um novo negociante for registrado
     * @param throwedBy address que disparou o evento
     * @author bortes
     */
    event NewTraderEvent(address indexed throwedBy);


    /**
     * @dev evento disparado quando uma nova ordem for registrada
     * @param operation operacao desejada
     * @param commodity mercadoria desejada
     * @param amount quantidade desejada
     * @param throwedBy address que disparou o evento
     * @author bortes
     */
    event NewOrderEvent(Operations indexed operation, Commodities indexed commodity, uint256 amount, address indexed throwedBy);


    /**
     * @dev evento disparado quando ocorrer uma venda
     * @param index indice da ordem
     * @param seller endereco do vendedor
     * @param buyer endereco do comprador
     * @param commodity mercadoria negociada
     * @param amount quantidade negociada
     * @param throwedBy address que disparou o evento
     * @author bortes
     */
    event NewSellEvent(uint256 index, address seller, address buyer, Commodities indexed commodity, uint256 amount, address indexed throwedBy);


    /**
     * @dev evento disparado quando ocorrer uma compra
     * @param index indice da ordem
     * @param seller endereco do vendedor
     * @param buyer endereco do comprador
     * @param commodity mercadoria negociada
     * @param amount quantidade negociada
     * @param throwedBy address que disparou o evento
     * @author bortes
     */
    event NewBuyEvent(uint256 index, address seller, address buyer, Commodities indexed commodity, uint256 amount, address indexed throwedBy);

    //
    // MODIFICADORES
    //

    /**
     * @dev consiste endereco nao cadastrado
     * @param trader endereco do comerciante
     * @author bortes
     */
    modifier onlyNewTrader(
        address trader
    ) {
        // consistencias
        require(trader != address(0x0), "invalid trader address");
        require(!tradersOrders[trader].initialized, "address already registred as trader");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste operacao valida
     * @param operation operacao desejada
     * @author bortes
     */
    modifier onlyOperations(
        Operations operation
    ) {
        // consistencias
        require(operation == Operations.BUY || operation == Operations.SELL, "invalid operation");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste mercadoria valida
     * @param commodity mercadoria desejada
     * @author bortes
     */
    modifier onlyCommodities(
        Commodities commodity
    ) {
        // consistencias
        require(commodity == Commodities.SUGAR || commodity == Commodities.CORN || commodity == Commodities.SOY, "invalid commodity");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste endereco ja cadastrado
     * @param trader endereco do comerciante
     * @author bortes
     */
    modifier onlyTraders(
        address trader
    ) {
        // consistencias
        require(trader != address(0x0), "invalid trader address");
        require(tradersOrders[trader].initialized, "address not registred as trader");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste ordem
     * @param index indice da ordem de compra
     * @author bortes
     */
    modifier onlyOrders(
        uint256 index
    ) {
        // consistencias
        require(orders.length > index, "order not found");

        // prossegue com a analise dos modificadores
        _;
    }

    //
    // ATRIBUTOS
    //
    address private owner;

    mapping(address => OrderList) private tradersOrders;

    address[] private traders;

    Order[] private orders;

    //
    // CONSTRUTOR
    //

    /**
     * @dev inicializa uma nova versao do contrato
     * @author bortes
     */
    constructor () public {
        init();
    }

    //
    // METODOS PUBLICOS
    //

    /*
     * @dev adiciona um novo negociante
     * @param trader endereco do comerciante
     * @author bortes
     */
    function addNewTrader() onlyNewTrader(msg.sender) public {
        traders.push(msg.sender);
        tradersOrders[msg.sender].initialized = true;

        emit NewTraderEvent(msg.sender);
    }

    /*
     * @dev adiciona uma nova ordem para uma mercadoria disponivel
     * @param operation operacao desejada
     * @param commodity mercadoria desejada
     * @param amount quantidade desejada
     * @author bortes
     */
    function addNewOrder (Operations operation, Commodities commodity, uint256 amount) onlyTraders(msg.sender) onlyOperations(operation) onlyCommodities(commodity) public {
        Order memory newOrder = Order({
            operation: operation,
            commodity: commodity,
            amount: amount,
            seller: address(0x0),
            buyer: address(0x0),
            executed: false
        });

        if( operation == Operations.BUY ){
            newOrder.buyer = msg.sender;
        }else{
            newOrder.seller = msg.sender;
        }

        orders.push(newOrder);

        tradersOrders[msg.sender].itens.push(orders.length - 1);

        emit NewOrderEvent(newOrder.operation, newOrder.commodity, newOrder.amount, msg.sender);
    }

    /*
     * @dev consulta todos as ordens disponiveis para uma mercadoria
     * @param commodity mercadoria das ordens procuradas
     * @author bortes
     */
     function getAllOrdersByCommodity (Commodities commodity) onlyTraders(msg.sender) onlyCommodities(commodity) public view returns (uint256[] memory indexes) {
         uint256 length = orders.length;
         uint256 count = 0;

         indexes = new uint256[](length);

         for(uint256 index = 0; index < length; index++) {
             if(orders[index].commodity == commodity){
                indexes[count] = index;
                 count++;
             }
         }

         return indexes;
     }

    /*
     * @dev consulta a ordem
     * @param index indice da ordem
     * @author bortes
     */
     function getOrderByIndex (uint256 index) onlyTraders(msg.sender) onlyOrders(index) view public returns (address, address, Commodities, Operations, uint256, bool) {
        Order memory order = orders[index];

        return (order.seller, order.buyer, order.commodity, order.operation, order.amount, order.executed);
     }

    /*
     * @dev executa a ordem informada
     * @param index indice da ordem de compra
     * @author bortes
     */
     function executeOrder(uint256 index) onlyTraders(msg.sender) onlyOrders(index) payable public {
        Order storage order = orders[index];
        address payable sender;

        require(!order.executed, "order already executed");

        if( order.operation == Operations.BUY ){
            order.executed = true;
            order.seller = msg.sender;

            sender = order.buyer;

            emit NewSellEvent(index, order.seller, order.buyer, order.commodity, order.amount, msg.sender);
        }else{
            order.executed = true;
            order.buyer = msg.sender;

            sender = order.seller;

            emit NewBuyEvent(index, order.seller, order.buyer, order.commodity, order.amount, msg.sender);
        }

        (bool success, ) = sender.call.value(msg.value)("");
        require(success, "failed to transfer");
     }

    //
    // METODOS PRIVADOS
    //

    function init () private {
        owner = msg.sender;
    }
}