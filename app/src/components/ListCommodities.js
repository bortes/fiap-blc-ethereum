import React, { Component } from 'react';
import { connect } from 'react-redux';

import Commodity from './Commodity';

import SugarCard from '../assets/images/img_lp_acucar.jpg';
import CornCard from '../assets/images/img_lp_milho.jpg';
import SoyCard from '../assets/images/img_lp_soja.jpg';

/**
 * Componente responsavel por listar as mercadorias disponiveis.
 *
 * @author bortes
 */
class ListCommodities extends Component {
    state = {
        commodities: [{
            code: 'ACF',
            name: 'Açúcar Cristal',
            image: SugarCard,
            id: 0, // igual ao numerado do smartcontract
        }, {
            code: 'CCM',
            name: 'Milho',
            image: CornCard,
            id: 1, // igual ao numerado do smartcontract
        }, {
            code: 'SFI',
            name: 'Soja',
            image: SoyCard,
            id: 2, // igual ao numerado do smartcontract
        }]
    };

    /**
     * Renderiza o componente.
     *
     * @author bortes
     */
    render() {
        const { commodities } = this.state;

        return (
            <div className="container">
                <div className="row"> {
                        commodities.map(o => (
                           <Commodity key={o.id} name={o.name} image={o.image} />
                        ))
                    } </div>
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

export default connect(mapStateToProps)(ListCommodities);