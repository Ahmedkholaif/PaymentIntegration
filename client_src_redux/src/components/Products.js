import React,{useState, useEffect, useCallback} from 'react'
import ProductCard from './ProductCard';
import axios from 'axios';
import '../styles/products.css'
import PropTypes from 'prop-types';
import {connect} from 'react-redux';
import {testt} from '../actions/productsActions';
// let currentPage = 0;
const perPage = 6;

const Products = function (props) {
    
    const [currentPage, setCurrentPage] = useState(0);
    const [total, setTotal] = useState(0);

    console.log(props);
    const renderProducts = ()=>{
        
        const {products} = props;
        return products.map(product=>(
            <ProductCard key={product.id} className="card" product={product} />
        ));
    };
    
    const moveForward= async ()=>{
            if(currentPage < total/perPage) {
                await setCurrentPage(currentPage+1);
                await fetchData();
            };
    }
    const moveBack= async ()=>{
        if(currentPage > 0) {
            await setCurrentPage(currentPage - 1);
            await fetchData();
        };
    }

    
    const fetchData = useCallback(async()=> {
        const res = await axios.get(`/api/products?filter[limit]=${perPage}&filter[skip]=${currentPage*perPage}`);
        const {data: products} = res;
        props.testt(products);
        console.log(props);

        const countRes = await axios.get('/api/products/count');
        const {count} = countRes.data;
        setTotal(count);
    }, [currentPage]); 

    useEffect(() => {
        fetchData();
    },[fetchData]);
    
    return (
        <div className="container">
        { 
            total > 0 ?  
            ( <div className="products" >
                {renderProducts()}
                </div>
                )   : 
                <div className='loader'>
                <div className="preloader-wrapper big active">
                <div className="spinner-layer spinner-blue">
                    <div className="circle-clipper left">
                        <div className="circle"></div>
                    </div>
                    <div className="gap-patch">
                        <div className="circle"></div>
                    </div>
                    <div className="circle-clipper right">
                        <div className="circle"></div>
                    </div>
                </div>
                </div>
                </div>
            }
            <ul className="pagination">
            <li className="waves-effect" onClick={moveBack}><a href="#!"><i className="material-icons">chevron_left</i></a></li>
                {[...Array(Math.floor(total/perPage)+1)].map((p, i) => (
                    <li
                    onClick={async()=>{await setCurrentPage(i); fetchData()}}
                    className={ currentPage === i ? 'active waves-effect' :'waves-effect'} 
                    key={i}> <a href="#!">{i+1}</a> </li>
                ))}
            <li className="waves-effect" onClick={moveForward}><a href="#!"><i className="material-icons">chevron_right</i></a></li>
            </ul>
        </div>
    )
} 

Products.propTypes={
    testt: PropTypes.func.isRequired,
    products: PropTypes.array.isRequired,
}

function mapStateToProps(state) {
    const { products } = state.productsReducer
    return { products }
}

export default connect(
    mapStateToProps,
    {testt}
)(Products)