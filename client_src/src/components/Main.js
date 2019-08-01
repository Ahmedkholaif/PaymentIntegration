import React from 'react'
import { Switch, Route} from 
'react-router-dom';

import Products from './Products';
import About from './About';
import Thanks from './Thanks';
import CheckoutCart from './CheckoutCart';

// import Details from './MeetUpDetails';
// import AddMeetUp from './MeetUpAdd';
// import EditMeetUp from './MeetUpEdit';

export default function Main() {
    return (
        <main>
            <Switch>
            <Route exact path='/' component={Products} />
                <Route exact path='/about' component={About} />
                <Route exact path='/cart' component={CheckoutCart} />
                <Route exact path='/thanks' render={(props)=> <Thanks {...props} /> } />
            </Switch>
        </main>
    )
}