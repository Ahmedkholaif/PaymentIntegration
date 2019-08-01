import React,{useEffect} from 'react'
import {Redirect} from 'react-router';

function Thanks(props) {

    useEffect(() => {
        setTimeout(()=>{
            props.history.push('/');
        },3000);
    }, []);

    setTimeout(()=>{
        return(
            <Redirect to='/' />
        )
    },3000);
    return (
        <div className='container'>
            <h2>
                Thanks For Completing Your Shopping

                We Hope You've Enjoyed
            </h2>
            <p>
                you will be redirected
            </p>
        </div>
    )
}

export default Thanks