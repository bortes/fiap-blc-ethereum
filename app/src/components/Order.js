import React, { Component } from 'react';
import { connect } from 'react-redux';

/**
 * Componente responsavel por exibir as informacoes da ordem.
 *
 * @author bortes
 */
class Order extends Component {
    /**
     * Renderiza o componente.
     *
     * @author bortes
     */
    render() {
        const {
            seller,
            buyer,
            amount,
            operation,
        } = this.props;

        return (
            <h2 className="text-warning text-lowercase">[ { seller } ]</h2>
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

export default connect(mapStateToProps)(Order);