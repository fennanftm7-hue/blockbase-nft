# BlockBase NFT Minter (Full-Stack DApp)

A full-stack Decentralized Application (DApp) that allows users to mint custom-named NFTs on the Ethereum Sepolia Testnet. This project is built using Solidity, OpenZeppelin ERC-721 security frameworks, and an Ethers.js frontend interface.

## Deployed Contract Information
- **Network:** Ethereum Sepolia Testnet
- **Contract Address:** `0x6a491A5417903a3569b15D8902fBd2A4088b7B71`

## Implemented Extensions
1. **Global Activity Feed:** Fetches and tracks the last 10 public mints across the entire network via historical block filters.
2. **Dynamic Admin Dashboard:** Reveals custom withdrawal functions only when connected with the verified deployment owner address.
3. **Asset Transfer Module:** Leverages OpenZeppelin `transferFrom` routing logic to send NFTs between wallets smoothly.
4. **Programmatic Supply Tracking:** Enforces a rigid 50-token scarcity ceiling with real-time remaining item tracking metrics.

## Tech Stack
- **Smart Contract:** Solidity, Remix IDE, OpenZeppelin
- **Frontend Panel:** HTML5, CSS3, JavaScript (ES6+), Ethers.js (v5)
- **Wallet Provider:** MetaMask Browser Extension