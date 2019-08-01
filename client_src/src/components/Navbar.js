import React, {useContext} from 'react'
import {Link} from 'react-router-dom';
import {MyContext} from './ContextApi';

export default function Navbar() {

    const {cartCount} = useContext(MyContext);
    return (
    <div>
        <nav className="nav-fixed blue mb-2">
            <div className="nav-wrapper">
                <a href='/' className="brand-logo left"> Payments</a>
                    <ul id="sidenav"  className="right hide-on-small-only">
                    <li><Link to='/cart'> <i className="fa fa-shopping-cart" aria-hidden="true" />
                    {cartCount} 
                    </Link>
                    </li>
                    <li><Link to='/'> <i className='fa fa-users' /> Products </Link> </li>
                    <li><Link to='/about'> <i className='fa fa-info' /> About </Link> </li>
                </ul>
            </div>
        </nav>
    </div>    
    )
}
