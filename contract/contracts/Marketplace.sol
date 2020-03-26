pragma solidity ^0.5.8;

contract Marketplace {
    //
    // ENUMERADORES / ESTRUTURAS
    //
    enum Operations {
        BUY,  // compra de commodity
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
     * @param trader endereco do comerciante
     * @param throwedBy address que disparou o evento
     * @author bortes
     */
    event NewTraderEvent(address indexed trader, address indexed throwedBy);


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
    modifier exceptTrader(
        address trader
    ) {
        // consistencias
        require(trader != address(0x0), "invalid trader address");
        require(!tradersOrders[trader].initialized, "address already registred as trader");

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
        require(orders.length > index, "invalid index");

        Order memory order = orders[index];
        require(order.seller != address(0x0) || order.buyer != address(0x0), "order not found");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste ordem de compra
     * @param index indice da ordem de compra
     * @author bortes
     */
    modifier onlyBuyOrders(
        uint256 index
    ) {
        // consistencias
        require(orders.length > index, "invalid index");

        Order memory order = orders[index];
        require(order.seller != address(0x0) || order.buyer != address(0x0), "order not found");
        require(order.operation == Operations.BUY, "buy order not found");

        // prossegue com a analise dos modificadores
        _;
    }

    /**
     * @dev coonsiste ordem de venda
     * @param index indice da ordem de venda
     * @author bortes
     */
    modifier onlySellOrders(
        uint256 index
    ) {
        // consistencias
        require(orders.length > index, "invalid index");

        Order memory order = orders[index];
        require(order.seller != address(0x0) || order.buyer != address(0x0), "order not found");
        require(order.operation == Operations.SELL, "sell order not found");

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
    function addNewTrader(address trader) exceptTrader(trader) public {
        traders.push(trader);
        tradersOrders[trader].initialized = true;

        emit NewTraderEvent(trader, msg.sender);
    }

    /*
     * @dev adiciona uma nova ordem para uma mercadoria disponivel
     * @param operation operacao desejada
     * @param commodity mercadoria desejada
     * @param amount quantidade desejada
     * @author bortes
     */
    function addNewOrder (Operations operation, Commodities commodity, uint256 amount) onlyTraders(msg.sender) public {
        Order memory newOrder = Order({
            operation: operation,
            commodity: commodity,
            amount: amount,
            seller: address(0x0),
            buyer: address(0x0)
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
     function getAllOrdersByCommodity (Commodities commodity) onlyTraders(msg.sender) public view returns (uint256[] memory indexes) {
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
     function getOrderByIndex (uint256 index) onlyTraders(msg.sender) onlyOrders(index) view public returns (address, address, Commodities, Operations, uint256) {
        Order memory order = orders[index];

        return (order.seller, order.buyer, order.commodity, order.operation, order.amount);
     }
    /*
     * @dev adiciona um novo vendedor para a orderm informada
     * @param index indice da ordem de compra
     * @author bortes
     */
     function addNewSeller(uint256 index) onlyTraders(msg.sender) onlyBuyOrders(index) payable public {
        Order storage order = orders[index];

        order.seller = msg.sender;
        order.buyer.transfer(msg.value);

        emit NewSellEvent(index, order.seller, order.buyer, order.commodity, order.amount, msg.sender);
     }

    /*
     * @dev adiciona um novo comprador para a orderm informada
     * @param index indice da ordem de compra
     * @author bortes
     */
     function addNewBuyer(uint256 index) onlyTraders(msg.sender) onlySellOrders(index) payable public {
        Order storage order = orders[index];

        order.buyer = msg.sender;
        order.seller.transfer(msg.value);

        emit NewBuyEvent(index, order.seller, order.buyer, order.commodity, order.amount, msg.sender);
     }

    //
    // METODOS PRIVADOS
    //

    function init () private {
        owner = msg.sender;
    }
}