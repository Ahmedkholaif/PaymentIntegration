import React from 'react';
import './App.css';
import Navbar from './components/Navbar';
import Main from './components/Main';
import ContextProvider from './components/ContextApi';

function App() {
  return (
    <ContextProvider>
      <div className="App">
        <Navbar />
        <br />
        <Main />
      </div>
    </ContextProvider>
  );
}

export default App;
