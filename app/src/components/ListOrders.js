import React, { Component } from 'react';
import { connect } from 'react-redux';

/**
 * Componente responsavel por listar as ordens disponiveis.
 *
 * @author bortes
 */
class ListOrders extends Component {
    state = {
        orders: [{
            seller: '0x0',
            buyer: '0x0',
            operation: 0,
            amount: 10,
            id: 1,
        }]
    };

    /**
     * Renderiza o componente.
     *
     * @author bortes
     */
    render() {
        const { orders } = this.state;

        return (
            <div className="row"> {
                orders.map(o => (
                    <Order key={o.id} seller={o.seller} buyer={o.buyer} amount={o.amount} operation={o.operation} />
                ))
            } </div>
        );
    }
}


/**
 * Mapeia o estado da aplicacao na propriedade ".props" disponibilizadas dentro dos componentes.
 *
 * @author bortes
 */
const mapStateToProps = (state) => {
    return {
        news: state
    }
}

export default connect(mapStateToProps)(ListOrders);