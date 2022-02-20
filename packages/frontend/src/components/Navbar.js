import React from 'react';
import "./Navbar.css"
import {  Link } from "react-router-dom";
import { Web3ReactProvider } from "@web3-react/core";
import Web3 from "web3";
import getWeb3 from "./getWeb3";

const Navbar= () =>{

   async function getLibrary() {
    const web3 = await getWeb3();
    // Use web3 to get the user's accounts.
    const accounts = await web3.eth.getAccounts();
    console.log(accounts);
  }
  
  return (
    <header className="header">
        <div class="left">
          <a href="#">Hufficorns</a>
        </div>
        <div class="mid">
          <ul class="navbar">
            <li>
              <Link to="/">Mint</Link>
            </li>
            <li>
              <Link to="/cats">Join</Link>
            </li>
            <li>
              <Link to="/sheeps">Create</Link>
            </li>
          </ul>

        </div>
        <div class="right">
          <button onClick={() => getLibrary()}>Connect</button>
        </div>

      </header>
  );
}
export default Navbar;