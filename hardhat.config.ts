import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as tenderly from "@tenderly/hardhat-tenderly";
import "dotenv/config";

tenderly.setup({ automaticVerifications: true });

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    virtual_base: {
      url: "https://virtual.base.rpc.tenderly.co/4b84ea0d-6c63-49ac-b7e8-20a73a19202b",
      chainId: 8453,
    },
  },
  tenderly: {
    project: "boomchain-tenderly-core",
    username: "Boomchain",
  },
};

export default config;
