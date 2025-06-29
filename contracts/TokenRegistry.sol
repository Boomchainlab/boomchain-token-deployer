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
