import {createStore, applyMiddleware, compose} from 'redux';
import thunk from 'redux-thunk';
import RootReducer from './reducers';

const mw = [thunk];
const initialState={};

const store = createStore(
        RootReducer,
        initialState,
        compose(
            applyMiddleware(...mw),
            window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ && window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__()
            ),
    );

export default store;