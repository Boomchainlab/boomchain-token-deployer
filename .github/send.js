const { ethers } = require("ethers");
const fs = require("fs");

// CONFIGURATION
const RPC_URL = "https://virtual.base.rpc.tenderly.co/4b84ea0d-6c63-49ac-b7e8-20a73a19202b";
const EXPLORER = "https://dashboard.tenderly.co/explorer/vnet/4b84ea0d-6c63-49ac-b7e8-20a73a19202b/tx/";
const PRIVATE_KEY = "0xf2fb82b350cbf5a09b60a0e89ccbc766c59d1e1a66d9747041f864353b76dfde";
const RECEIVER = "0x0a7ec711da824f0C10578793ccda9298C03ec09e"; // Destination

async function main() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  // Inject 1 BOOM
  await provider.send("tenderly_setBalance", [
    [wallet.address],
    "0xDE0B6B3A7640000"
  ]);

  // Send 0.01 BOOM
  const tx = await wallet.sendTransaction({
    to: RECEIVER,
    value: ethers.parseEther("0.01"),
  });

  const log = `✅ Sent 0.01 BOOM from ${wallet.address} to ${RECEIVER}\nTX: ${tx.hash}\n🔗 ${EXPLORER}${tx.hash}\n`;
  fs.writeFileSync("tx-log.txt", log);
  console.log(log);
}

main().catch(console.error);
