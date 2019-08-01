import React from 'react';
import './App.css';
import Navbar from './components/Navbar';
import Main from './components/Main';
import ContextProvider from './components/ContextApi';
import Store from './Store';
import { Provider } from 'react-redux';
function App() {

  return (
    <Provider store={ Store }>
      <ContextProvider>
        <div className="App">
          <Navbar />
          <br />
          <Main />
        </div>
      </ContextProvider>
    </Provider>
  );
}

export default App;
