// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../contracts/Clanker.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Replace placeholder addresses
        address taxCollector = address(0x123);
        address weth = address(0x456);
        address locker = address(0x789);
        address factory = address(0xABC);
        address manager = address(0xDEF);
        address swapRouter = address(0xCAFEBABE);

        new Clanker(
            taxCollector,
            weth,
            locker,
            factory,
            manager,
            30 days,
            swapRouter,
            msg.sender
        );

        vm.stopBroadcast();
    }
}
