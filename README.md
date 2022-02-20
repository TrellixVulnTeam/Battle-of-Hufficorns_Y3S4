# Battle Of Hufficorns!

![alt text](https://gateway.pinata.cloud/ipfs/QmUyJug219uqv9YSrNkksGUbkoXpkRjXUpobnLPj8izjca)

Battle of Hufficorn is a Card game based on Characters and their attributes. The Cards are minted as NFT’s with characters that are generated at random with specific attributes associated with each character. Only the user can see the attributes of their character. User can then, create a game and bet on any one attribute of their character. Any player interested in betting on the same attribute can join the game. The round is over when the creator decides, and the player with highest value of the attribute wins the game.

## Getting Started

Clone this repo. ```npm install``` everywhere.

Build the zk snarks (zk-Snark circuit, proving key and verification key).
```
cd packages/circuits
./scripts/build_snarks.sh
```

Run ```ganache-cli``` in a terminal. Use truffle to compile and deploy the contracts to a network of your choice. 

```
cd packages/contracts
truffle compile && truffle migrate --network testnetHar
```

```
cd frontend
npm run start
```

Finally, connect your Metamask wallet to Localhost 8545 network and try out the app!

You can check out our slide deck [here](https://docs.google.com/presentation/d/1eplkxSCV5jMHYFKnaNfVxd1ZfanmmyLxJ0uz9NGM7Bs/edit?usp=sharing).
