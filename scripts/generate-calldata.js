const hre = require("hardhat");

async function main() {
  const tokenDeployer = await hre.ethers.getContractAt(
    "TokenDeployer",
    "0xYourDeployerContractAddress"
  );

  const txData = tokenDeployer.interface.encodeFunctionData("deployToken", [[ /* config */ ]]);

  console.log("Calldata:", txData);
}

main().catch(console.error);
