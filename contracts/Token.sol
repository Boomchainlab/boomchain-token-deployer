// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address private _deployer;
    uint256 private _fid;
    string private _image;
    string private _castHash;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        address deployer_,
        uint256 fid_,
        string memory image_,
        string memory castHash_
    ) ERC20(name_, symbol_) {
        _deployer = deployer_;
        _fid = fid_;
        _image = image_;
        _castHash = castHash_;
        _mint(msg.sender, maxSupply_);
    }

    function fid() public view returns (uint256) {
        return _fid;
    }

    function deployer() public view returns (address) {
        return _deployer;
    }

    function image() public view returns (string memory) {
        return _image;
    }

    function castHash() public view returns (string memory) {
        return _castHash;
    }
}
