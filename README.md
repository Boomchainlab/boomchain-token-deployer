---

### 5. **`contracts/TokenRegistry.sol`**

**Path:** `contracts/`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenRegistry {
    mapping(bytes32 => address) public deployedTokens;
    address public factory;

    constructor(address _factory) {
        factory = _factory;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, "Not authorized");
        _;
    }

    function register(bytes32 salt, address token) external onlyFactory {
        deployedTokens[salt] = token;
    }
}

This repository enables secure and automated deployment of ERC-20 compatible tokens on the [Base](https://base.org) network using Hardhat and GitHub Actions.

Built by **Boomchainlab**, it supports:

- ✅ GitHub Actions CI/CD
- ✅ Manual or automated deployment to Base
- ✅ Multisig-compatible calldata generation
- ✅ Optional on-chain TokenRegistry contract
- ✅ Contract ownership assigned to a secure address

---

## 🔑 Owner Address

All tokens deployed using this repo are controlled by:
0x184bb27def036b32b420750f147af0d56ce72309
This wallet will be the:
- **Owner**
- **Minter**

Ensure it is a Gnosis Safe or a secure address before production deployment.

---

## 🛠 Setup

### 1. Configure GitHub Secrets

| Secret Name             | Description                                |
|-------------------------|--------------------------------------------|
| `DEPLOYER_PRIVATE_KEY`  | Private key (no `0x`) of deployer wallet   |
| `BASE_RPC_URL`          | RPC endpoint (e.g., Infura, Alchemy)       |

### 2. Deploy Token

- Manual trigger via **GitHub → Actions → "Deploy Token"**
- Or use CLI:
  ```bash
  npx hardhat run deploy/deploy-token.js --network base
  Multisig Mode (Safe Compatible)

  Use the script below to generate calldata:
  npx hardhat run scripts/generate-calldata.js --network base
  🧱 Optional: Token Registry

Supports an optional TokenRegistry.sol smart contract to register and index deployed token addresses on-chain.

⸻

📦 Technologies
	•	Hardhat
	•	GitHub Actions
	•	Ethers.js
	•	dotenv
	•	Base Network

🏷 License

MIT © Boomchainlab
