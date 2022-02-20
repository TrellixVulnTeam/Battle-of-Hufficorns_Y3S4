# Battle Of Hufficorns!

![alt text](https://gateway.pinata.cloud/ipfs/QmUyJug219uqv9YSrNkksGUbkoXpkRjXUpobnLPj8izjca)

Battle of Hufficorn is an NFT Card game on Harmony based on characters with superpowers. The cards are minted as NFTs with characters that have randomly generated attributes. User can create a game and bet on any one attribute of their character. Any player interested in betting on the same attribute can join the game. The specific attributes of the NFTs are kept secret using ZK-snarks so only the owner knows them and the round goes to the player(s) with the best card!

Try the game out and let us know what you think!

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

Finally, connect your browser wallet to Harmony testnet and try out the app!

You can check out our slide deck [here](https://docs.google.com/presentation/d/1eplkxSCV5jMHYFKnaNfVxd1ZfanmmyLxJ0uz9NGM7Bs/edit?usp=sharing).
