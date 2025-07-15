import { task } from "hardhat/config";
import { ethers } from "ethers";
import "dotenv/config";

task("send:eth", "Sends ETH on Tenderly Virtual Base")
  .addParam("to", "Recipient address")
  .addParam("amount", "Amount in ETH")
  .setAction(async ({ to, amount }, hre) => {
    const RPC_URL = hre.network.config.url as string;
    const EXPLORER_BASE = "https://dashboard.tenderly.co/tx/base/";
    const PRIVATE_KEY = process.env.PRIVATE_KEY!;
    
    const provider = new ethers.JsonRpcProvider(RPC_URL);
    const signer = new ethers.Wallet(PRIVATE_KEY, provider);

    // Fund the address with 1 ETH on the virtual chain
    await provider.send("tenderly_setBalance", [
      [signer.address],
      "0xDE0B6B3A7640000" // 1 ETH in wei
    ]);

    const tx = await signer.sendTransaction({
      to,
      value: ethers.parseEther(amount),
    });

    console.log("TX Sent:", tx.hash);
    console.log(`Explorer (if available): ${EXPLORER_BASE}${tx.hash}`);
  });
