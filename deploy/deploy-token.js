const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying from:", deployer.address);

  const tokenDeployer = await hre.ethers.getContractAt(
    "TokenDeployer",
    "0xYourDeployerContractAddress"
  );

  const tx = await tokenDeployer.deployToken([
    {
      name: "Thanks Brian Amstrong",
      symbol: "TBA",
      salt: "0x000000000000000000000000000000008bec97171b5eccc4207452c6d3ec55ce",
      imageURI: "https://imagedelivery.net/BXluQx4ige9GuW0Ia56BHw/41bd6b56-4e02-4fad-32ca-a877a2c77a00/original",
      metadata: '{"description":"A token to honor contributions","socialMediaUrls":["https://farcaster.xyz/~/profile/455962"],"auditUrls":[]}',
      source: '{"interface":"clanker","platform":"farcaster","messageId":"0x12c49acf05a87eb2a10ab29a83128ebc10f2157a","id":"455962"}',
      chainId: 8453
    },
    {
      initialMint: 0,
      cap: 0
    },
    {
      feeToken: "0x4200000000000000000000000000000000000006",
      feeAmount: 230400
    },
    {
      initialTreasury: 10000,
      rewardRate: 0
    },
    {
      owner: "0x184bb27def036b32b420750f147af0d56ce72309",
      minter: "0x184bb27def036b32b420750f147af0d56ce72309",
      feeRecipient: "0xEea96d959963EaB488A3d4B7d5d347785cf1Eab8",
      platformFeeCollector: "0x1eaf444ebDf6495C57aD52A04C61521bBf564ace"
    }
  ]);

  console.log("TX Hash:", tx.hash);
  await tx.wait();
  console.log("✅ Token successfully deployed.");
}

main().catch((err) => {
  console.error("❌ Deployment failed:", err);
  process.exit(1);
});
