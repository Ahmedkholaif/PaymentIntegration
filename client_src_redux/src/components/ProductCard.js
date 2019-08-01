import React,{ useContext} from 'react';
import './../styles/productCard.css';
import { MyContext } from './ContextApi';
import axios from 'axios';


export default function (props) {
    
    const {setCartCount} = useContext(MyContext);

    const {product :{...product}} = props
    return (
        <div className="card">
        <div className="card-image">
        <button 
        onClick={async()=>{
            try {
                const res= await axios
                .post(`/api/Customers/5d3ea7a3489ac61c3c0fdb60/addtocart?access_token=DEJRwPxxJ6sKLaBVj78Ag9d2ydx2uJ6FJonWtsmBeHgLklM8GZGaPro52K7ZQ4gd`,{
                    productId :product.id,
                    quantity:1
                });
                if(res.status === 200) setCartCount(res.data.cartCount);
                console.log(res.statusText)
            } catch (error) {
                console.log(error);
            }
            // setCart([...cart,product]);
        }}
        className="btn-floating halfway-fab waves-effect waves-light red">
        <i className="material-icons">add</i></button>
        <img src={product.img} alt="img" width='50px' height='100px'/>
        </div>
        <div className="card-content">
        <h4>{product.name}</h4>
        <h5>{product.price}</h5>
            </div>
        </div>
    )
}
