/* eslint-disable jsx-a11y/anchor-is-valid */
import React, {useContext, useEffect} from 'react';
import axios from 'axios';
import {MyContext} from './ContextApi';
// import '../styles/checkoutCart.css';

function App() {
    const {cart,
        setCart,
        setCartCount,
        cartCount
    } = useContext(MyContext);
    // console.log(cart);

    useEffect(() => {
        const fetchData = async()=>{const res = await axios.get(`/api/Customers/5d3ea7a3489ac61c3c0fdb60/shopcart?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd`);
        console.log(res);
        const {data: {cart}} = res;
        setCart(cart);}
        fetchData();
    }, []);
    return (
        <div className="container" >
    
        <ul className="collection row" style={{minHeight:'30rem'}}>
        {cart.length > 0 ? null : <h4 style ={{position:'absolute',top:'30%',left:'35%'}}>Cart Is Embty </h4> }
        {cart.map(prod=>(
            <li key={prod.product.id} className="collection-item row col-6">
                <img src={prod.product.img} className='left col-3' width="100px" height="100px" alt="img" />
                <div className='col-9'>
                <h4 className="title">{prod.product.name}
                <span className='right'>
                <a 
                onClick={async ()=>{
                    try {
                        const res = await axios.put(`/api/Customers/5d3ea7a3489ac61c3c0fdb60/editcart?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd`,{
                            productId :prod.product.id,
                            remove:true
                        });
                        if(res.status === 200){
                            await setCart(cart.filter(item=> item.product.id !== prod.product.id ));
                            await setCartCount(res.data.cartCount);
                        }
                        console.log(res);
                    } catch (error) {
                        console.log(error);
                    }
                }}
                className="waves-effect waves-light red">
                <i className="material-icons">delete</i></a>
                </span></h4>
                <p>price : {prod.product.price} <br/>
                quantity : <input type='number' value={prod.quantity} min = '1'
                className='col-4'
                onChange={(e)=>{
                    const {value} =e.target;
                    axios
                    .put(`/api/Customers/5d3ea7a3489ac61c3c0fdb60/editcart?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd`,{
                        productId :prod.product.id,
                        quantity:value,
                    })
                    .then(res=>{
                        if(res.status === 200){
                            setCart(cart.map(item=>(
                                item.product.id === prod.product.id ? {...item,quantity : value} : item
                            )));
                        }
                        console.log(res);
                    })
                    .catch (error=> console.log(error))
                }}
                />
                <br/>
                total : {prod.product.price*prod.quantity}
                </p>
                </div>
            </li>
        ))}
        </ul>
        <div>
        Total = {cart.reduce((total,item)=> total+item.product.price*item.quantity,0)} EGP
        </div>
        <a
        onClick={async()=>{ 
            try {
                const {data:{link}} = await axios.get('/api/Customers/5d3ea7a3489ac61c3c0fdb60/generatepayment?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd');
                console.log(link);
                window.location.replace(link);

            } catch (error) {
                console.log(error);
            }
        }}
        className={`waves-effect waves-light btn-large mb-5 ${cart.length > 0 ? 'tt':'disabled' }`}><i class="material-icons left">credit_card</i>
            Proceed To Checkout
        </a>
    </div>
);
}

export default App;