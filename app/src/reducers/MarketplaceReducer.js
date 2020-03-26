// import * as NewsActions from '../actions/NewsActions';

/**
 * Atualiza o estado da aplicacao em funcao das acoes solicitadas.
 *
 * @author bortes
 */
const NewsReducer = (state = [], action) => {
    switch (action.type) {
        // case NewsActions.CREATE_NEWS:
        //     return [action.payload].concat(state);

        // case NewsActions.READ_NEWS:
        //     return state.map(o => o.when === action.payload.when ? { ...o, editing: false } : o);

        // case NewsActions.UPDATE_NEWS:
        //     return state.map(o =>  o.when === action.payload.when ? action.payload : o )

        // case NewsActions.DELETE_NEWS:
        //     return state.filter(o => o.when !== action.payload.when);

        // case NewsActions.EDIT_NEWS:
        //     return state.map(o => o.when === action.payload.when ? { ...o, editing: true } : o);

        default:
            return state;
    }
}

export default NewsReducer;