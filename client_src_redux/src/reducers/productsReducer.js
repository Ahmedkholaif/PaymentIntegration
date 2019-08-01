import {TEST_TEST} from '../actions/types'
import '../styles/products.css';
const initialState = {
    products:[],
}


export default function(state = initialState, action){
    switch(action.type){
        case TEST_TEST:
            return{
                ...state,
                products:action.payload,
            }
        default:
            return state;
    } 
}