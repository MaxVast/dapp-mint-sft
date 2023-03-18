# dapp-mint-nft

## Build Setup

```bash
# install dependencies
$ yarn install

# serve with hot reload at localhost:3000
$ yarn dev

# build for production and launch server
$ yarn build
$ yarn start

# generate static project
$ yarn generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

# Hardhat

## Build Setup

```bash
# install project harhart if u need init this
$ npx hardhat
```

## Open file hardhat.config.js

Add this config
========================

module.exports = {
solidity: "0.8.9",
networks: {
hardhat: {
chainId: 1337
}
}
};

=======================

## Command Hardhat

```bash
# Compile Smart Contract
$ npx hardhat compile 

# Open new console for init new accounts/wallet test
$ npx hardhat node

# Open new console for start Blockchain on localhost
$ npx hardhat run scripts/deploy.js --network localhost

```
