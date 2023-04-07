require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
      chainId: 1337
    }
    /*goerli : {
      url: "https://goerli.infura.io/v3/f8511e6165adee64fbc9704dde04e322",
      accounts: ['0xPRIVATE-KEY']
    }*/
  }
};