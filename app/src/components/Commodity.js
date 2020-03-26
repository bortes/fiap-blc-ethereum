import React, { Component } from 'react';
import { connect } from 'react-redux';

/**
 * Componente responsavel por exibir as informacoes da mercadoria.
 *
 * @author bortes
 */
class Commodity extends Component {
    /**
     * Renderiza o componente.
     *
     * @author bortes
     */
    render() {
        const {
            name,
            image,
        } = this.props;

        return (
            <div className="col-md-4">
                <div className="text-center">
                    <h2 className="text-warning text-lowercase">[ { name } ]</h2>
                    <img src={ image } width="300" />
                </div>
            </div>
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

export default connect(mapStateToProps)(Commodity);