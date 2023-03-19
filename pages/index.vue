<template>
  <div id="app">
    <div class="container mx-auto pt-10 pb-10">
      <div class="mx-auto max-w-screen-lg">
        <div v-if="currentAccount" class="row flex items-center justify-end">
          <div id="disconnect-wallet" class="flex justify-end columns-12 columns-md-9 columns-sm-6 align-center">
            <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded font-medium" @click="disconnectWallet">
              Disconnect wallet
            </button>
          </div>
        </div>
        <h1 class="font-medium text-center">
          Mint NFT Syneido Lab
        </h1>
        <div class="mx-auto pt-10 items-center justify-center">
          <div class="row flex items-center justify-center pb-10">
            <img src="/logo_syneido_lab.png" alt="Logo Syneido Lab" style="width: 75%;">
          </div>
          <div v-if="!currentAccount" class="row items-center justify-center">
            <div class="flex justify-center columns-12 columns-md-9 columns-sm-6 align-center">
              <button
                id="connectButton"
                :disabled="connecting"
                class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded font-medium"
                @click="connectWallet"
              >
                {{ (!connecting) ? 'Connect Metamask' : 'Connecting ... ' }}
              </button>
            </div>
          </div>

          <div v-if="currentAccount">
            <div class="row items-center justify-center">
              <div id="withdraw-all-eth" class="flex justify-center columns-12 columns-md-9 columns-sm-6 align-center">
                <p class="font-medium">
                  Address : {{ currentAccount }} <br><br>
                  Wallet amount : {{ currentWalletAmount }} ETH
                </p>
              </div>
            </div>

            <div class="row items-center justify-center pt-8 pb-5">
              <div id="withdraw-all-eth" class="flex justify-center columns-12 columns-md-9 columns-sm-6 align-center">
                <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded font-medium" @click="mintNFT">
                  Mint NFT
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ethers } from 'ethers'
import ContractAbi from '../artifacts/contracts/SyneidoLab.sol/SyneidoLab.json'
export default {
  name: 'IndexPage',
  components: {
  },
  data () {
    return {
      contract: null,
      loading: false,
      connecting: false,
      contractInitialised: false,
      currentAccount: null,
      currentWalletAmount: 0
    }
  },
  mounted () {
    // metamask
    const { ethereum } = window
    // initialise contract
    if (ethereum) {
      ethereum.on('accountsChanged', (e) => {
        if (this.connecting) {
          if (e.length > 0) {
            this.currentAccount = e[0]
            this.checkWallet()
          } else {
            this.handleDisconnect()
          }
        }
      })
      const provider = new ethers.providers.Web3Provider(ethereum)
      const signer = provider.getSigner()
      const contract = new ethers.Contract(
        '0xb76C1510721D8398844a9CF74f689477a3950BdB', // change this when deploy new contract
        ContractAbi.abi,
        signer
      )
      this.contract = Object.freeze(contract)
      console.log('Contract initialised')
    } else {
      this.contractInitialised = false
    }
    if (!ethereum) {
      console.log('Metamask not detected')
    }
  },
  methods: {
    // eslint-disable-next-line require-await
    async handleDisconnect () {
      this.currentAccount = null
      this.connecting = false
      this.currentWalletAmount = 0
    },
    // eslint-disable-next-line require-await
    async disconnectWallet () {
      this.handleDisconnect()
    },
    // connect metamask wallet
    async connectWallet () {
      try {
        const { ethereum } = window
        // check if metamask is found
        if (!ethereum) {
          console.log('Metamask not detected')
          return
        }
        // get accounts
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
        const message = 'Welcome !\n\nClick to sign in and login\n\nThis request will not trigger a blockchain transaction or cost any gas fees.\n\nWallet address:'+accounts[0]
        const nonce = 116986840436272384689823124477
        await ethereum.request({ method: 'personal_sign', params: [accounts[0], message + '\n\nNonce : ' + nonce] })
          .then((res) => {
            const signature = this.contract.verify(accounts[0], message, nonce, res)
            if (signature) {
              this.connecting = true
              this.currentAccount = accounts[0] // set first account to currentAccount
              // check balance of account
              this.checkWallet()
            } else {
              this.disconnectWallet()
            }
          })
          .catch(
            this.disconnectWallet()
          )
      } catch (error) {
        this.connecting = false
        console.log('Error connecting to metamask', error)
      }
    },
    // eslint-disable-next-line require-await
    async checkWallet () {
      this.loading = true
      try {
        const { ethereum } = window
        // check if metamask is found
        if (!ethereum) {
          console.log('Metamask not detected')
          return
        }
        const provider = new ethers.providers.Web3Provider(ethereum)
        provider.getBalance(this.currentAccount).then((balance) => {
          this.currentWalletAmount = ethers.utils.formatEther(balance)
        })
        this.loading = false
      } catch (e) {
        console.log(e)
        this.loading = false
        alert('Failed to check wallet')
      }
    },
    async mintNFT () {
      console.log('test')
      try {
        this.loading = true
        await this.contract.freeMint(this.currentAccount)
        this.loading = false
      } catch (e) {
        console.log(e)
        this.loading = false
        alert('Failed to mint NFT')
      }
    }
  }
}
</script>
