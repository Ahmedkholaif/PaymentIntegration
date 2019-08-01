import React, {createContext,useEffect, useState } from 'react';
import axios from 'axios';

export const MyContext = createContext({});


const App = props => {

    const [cart, setCart] = useState([]);
    const [cartCount, setCartCount] = useState(cart.length);
    
    useEffect(() => {
        const fetchData = async()=>{
            try {
                const res = await axios.get(`/api/Customers/5d3ea7a3489ac61c3c0fdb60/shopcartcount?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd`);
                console.log(res);
                const {data: {count}} = res;
                setCartCount(count);
            } catch (error) {
                console.log(error);
            }
        };
        fetchData();  
        console.log('fetch');
    }, []);
    const ctx = {
        cart,setCart,
        cartCount,setCartCount,
    }
    console.log('object');
    return(
        <MyContext.Provider value={ctx}>
            {props.children}
        </MyContext.Provider>
    )   
};
export default App;