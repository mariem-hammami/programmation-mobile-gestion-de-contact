import React from "react";
import {BrowserRouter as Router, Routes, Route} from "react-router-dom";
import "./App.css";
import Header from "./components/Header";
import NavBar from "./components/NavBar";
import Home from "./pages/Home";
import Weather from "./pages/Weather";
import About from "./pages/About";


function App() {
  return (
    <Router>
        <div className = "app">
          <Header/>
          <NavBar />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/weather" element={<Weather />} />
            <Route path="/about" element={<About />} />
          </Routes>  
      </div>

    </Router>
  
  
);
}

export default App;
