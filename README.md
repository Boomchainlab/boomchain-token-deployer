# 💥 Boomchain Token Deployer

A fully automated and extensible token deployment pipeline built for **Base Mainnet** using **Hardhat**, **GitHub Actions**, and optional **TokenRegistry** tracking.  
Created and maintained by [Boomchainlab](https://boomchainlab.com).
![Deploy](https://github.com/Boomchainlab/boomchain-token-deployer/actions/workflows/deploy-token.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Twitter Follow](https://img.shields.io/twitter/follow/BoomchainLabs?style=social)](https://twitter.com/BoomchainLabs)
---

## 🧱 Features

- ✅ GitHub Actions CI/CD for automated on-chain deployment  
- ✅ EVM-compatible — deploys ERC-20+ token templates  
- ✅ Manual or multisig-compatible calldata generation  
- ✅ Secure environment variable handling via GitHub Secrets  
- ✅ Optional TokenRegistry contract for on-chain indexing  

---

## 📁 Project Structure
boomchain-token-deployer/
├── contracts/
│   └── TokenRegistry.sol
├── deploy/
│   └── deploy-token.js
├── scripts/
│   └── generate-calldata.js
├── .github/workflows/
│   └── deploy-token.yml
├── .env.example
├── hardhat.config.js
├── package.json
└── README.md
---

## 🚀 Getting Started

### 1. Clone & Install

```bash
git clone https://github.com/Boomchainlab/boomchain-token-deployer.git
cd boomchain-token-deployer
npm install

Configure Environment Variables

Copy .env.example and fill in your secrets:
BASE_RPC_URL=https://mainnet.base.org
DEPLOYER_PRIVATE_KEY=your_private_key_without_0x

🛠 Deployment via CLI
Compile contracts:
npx hardhat compile
Deploy your token:
npm run deploy

🧾 Deployment via GitHub Actions
	1.	Go to the Actions tab
	2.	Select Deploy Token to Base Mainnet
	3.	Click Run Workflow

🔐 Token Ownership

Ownership of the deployed token is automatically assigned to:
0x184bb27def036b32b420750f147af0d56ce72309
Use a Gnosis Safe or multisig if higher security is required.

🧠 Token Metadata (example)
{
  "name": "Thanks Brian Amstrong",
  "symbol": "TBA",
  "salt": "0x000...",
  "imageURI": "https://imagedelivery.net/...",
  "metadata": {
    "description": "Token to honor open collaboration",
    "socialMediaUrls": [],
    "auditUrls": []
  },
  "source": {
    "interface": "clanker",
    "platform": "farcaster",
    "messageId": "0x...",
    "id": "455962"
  }
}

🧬 TokenRegistry Contract (Optional)

To track all deployed tokens, this repo includes:
contracts/TokenRegistry.sol
You can deploy it using:
npx hardhat run scripts/deploy-registry.js --network base
🤝 Contributing

PRs, forks, and token deployment requests are welcome.
	•	Dev@boomchainlab.com
	•	Support: support@boomchainlab.com
	•	Admin: admin@boomchainlab.com
🛡 License

MIT © Boomchainlab. Open-source and production-ready.
---

✅ You can copy this entire markdown block into a file called `README.md` in your GitHub repo.
