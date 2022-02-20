import React, { Component } from "react";
import getWeb3 from "./getWeb3";
import getContractInstance from "./getContractInstance";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";

import Hufficorn from "./contracts/Hufficorn.json";
import HufficornGame from "./contracts/HufficornGame.json";

import "./App.css";

import NavComp from "./components/NavComp";
import Minting from "./components/Minting.js";
import MyNFT from "./components/MyNFT.js";
import CreateGame from "./components/CreateGame.js";
import JoinGame from "./components/JoinGame.js";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      const HufficornContract = await getContractInstance(web3, Hufficorn);
      const HufficornGameContract = await getContractInstance(web3, HufficornGame);

      const userBalance = await HufficornGameContract.methods.userBalance(accounts[0]).call({from: accounts[0]});
      this.setState({
        web3,
        accounts,
        HufficornContract,
        HufficornGameContract,
        userBalance
      });
      console.log(this.state);

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <NavComp
          account={this.state.accounts[0]}
          userBalance={this.state.userBalance}
          HufficornContract={this.state.HufficornContract}
          HufficornGameContract={this.state.HufficornGameContract}
        />
        <Router>
          <Switch>
            <Route
              exact
              path="/"
              component={() => (
                <Minting
                  web3={this.state.web3}
                  account={this.state.accounts[0]}
                  HufficornContract={this.state.HufficornContract}
                  HufficornGameContract={this.state.HufficornGameContract}
                />
              )}
            />
            <Route
              exact
              path="/upload"
              component={() => (
                <MyNFT
                web3={this.state.web3}
                account={this.state.accounts[0]}
                HufficornContract={this.state.HufficornContract}
                HufficornGameContract={this.state.HufficornGameContract}
                />
              )}
            />
            <Route
              exact
              path="/"
              component={() => (
                <CreateGame
                  web3={this.state.web3}
                  account={this.state.accounts[0]}
                  HufficornContract={this.state.HufficornContract}
                  HufficornGameContract={this.state.HufficornGameContract}
                />
              )}
            />
            <Route
              exact
              path="/"
              component={() => (
                <JoinGame
                  web3={this.state.web3}
                  account={this.state.accounts[0]}
                  HufficornContract={this.state.HufficornContract}
                  HufficornGameContract={this.state.HufficornGameContract}
                />
              )}
            />

          </Switch>
        </Router>
      </div>
    );
  }
}

export default App;
