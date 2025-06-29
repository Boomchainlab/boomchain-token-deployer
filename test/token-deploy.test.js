const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token Deployer Simulation", function () {
  let deployer;
  let TokenContract;

  before(async () => {
    [deployer] = await ethers.getSigners();
    console.log("Test running from deployer:", deployer.address);
  });

  it("should deploy a dummy ERC20 token contract", async function () {
    const ERC20 = await ethers.getContractFactory("ERC20Mock");
    TokenContract = await ERC20.deploy("Boom Token", "BOOM", deployer.address, 10000);
    await TokenContract.deployed();

    expect(await TokenContract.name()).to.equal("Boom Token");
    expect(await TokenContract.symbol()).to.equal("BOOM");
    expect(await TokenContract.balanceOf(deployer.address)).to.equal("10000");
  });
});
