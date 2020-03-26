import throttle from 'lodash.throttle';
import { createStore } from 'redux';

import MarketplaceReducer from '../reducers/MarketplaceReducer';

/**
 * Chave utilizada para persistir/recuperar os dados salvos no localStorage.
 *
 * @author bortes
 */
const LOCAL_STORAGE_KEY_NAME = 'main_store';

/**
 * Tempo de espera em milisegundos entre cada solicitacao para salvar os dados.
 *
 * @author bortes
 */
const TIME_BETWEEN_SAVE = 1000;

/**
 * Recupera os dados salvo no localStorage.
 *
 * @author bortes
 */
const loadState = () => {
    try {
        const serialized = localStorage.getItem(LOCAL_STORAGE_KEY_NAME);

        if (serialized !== null)
            return JSON.parse(serialized);
    } catch {
    }

    return undefined;
};

/**
 * Salva os dados no localStorage.
 *
 * @author bortes
 */
const saveState = (state) => {
    try {
        const serialized = JSON.stringify(state);

        localStorage.setItem(LOCAL_STORAGE_KEY_NAME, serialized);
    } catch {
    }
};

/**
 * Cria store que sera utilizado pela aplicacao e tambem ja registra tratamento nao permitir salvar os dados a toda hora.
 *
 * @author bortes
 */
const store = createStore(
    MarketplaceReducer,
    loadState()
);
store.subscribe(throttle(() => saveState(store.getState()), TIME_BETWEEN_SAVE));

export default store;