// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ownable} from "./access/Ownable.sol";
import {Token} from "./Token.sol";
import {TickMath} from "./lib/TickMath.sol";
import {Bytes32AddressLib} from "./lib/Bytes32AddressLib.sol";
import {
    INonfungiblePositionManager,
    IUniswapV3Factory,
    ILockerFactory,
    ILocker,
    ISwapRouter,
    ExactInputSingleParams
} from "./interface/Interfaces.sol";

contract Clanker is Ownable {
    using TickMath for int24;
    using Bytes32AddressLib for bytes32;

    error Deprecated();

    address public taxCollector;
    uint64 public defaultLockingPeriod = 33275115461;
    uint8 public taxRate = 25; // 2.5%
    uint8 public lpFeesCut = 50; // 5%
    uint8 public protocolCut = 30; // 3%

    bool public deprecated;
    bool public bundleFeeSwitch;

    address public weth;
    address public swapRouter;
    IUniswapV3Factory public uniswapV3Factory;
    INonfungiblePositionManager public positionManager;
    ILockerFactory public liquidityLocker;

    event TokenCreated(
        address tokenAddress,
        uint256 lpNftId,
        address deployer,
        uint256 fid,
        string name,
        string symbol,
        uint256 supply,
        address lockerAddress,
        string castHash
    );

    constructor(
        address taxCollector_,
        address weth_,
        address locker_,
        address uniswapV3Factory_,
        address positionManager_,
        uint64 defaultLockingPeriod_,
        address swapRouter_,
        address owner_
    ) Ownable(owner_) {
        taxCollector = taxCollector_;
        weth = weth_;
        liquidityLocker = ILockerFactory(locker_);
        uniswapV3Factory = IUniswapV3Factory(uniswapV3Factory_);
        positionManager = INonfungiblePositionManager(positionManager_);
        defaultLockingPeriod = defaultLockingPeriod_;
        swapRouter = swapRouter_;
    }

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply,
        int24 _initialTick,
        uint24 _fee,
        bytes32 _salt,
        address _deployer,
        uint256 _fid,
        string memory _image,
        string memory _castHash
    ) external payable onlyOwner returns (Token token, uint256 tokenId) {
        if (deprecated) revert Deprecated();

        int24 tickSpacing = uniswapV3Factory.feeAmountTickSpacing(_fee);
        require(tickSpacing != 0 && _initialTick % tickSpacing == 0, "Invalid tick");

        token = new Token{salt: keccak256(abi.encode(_deployer, _salt))}(
            _name, _symbol, _supply, _deployer, _fid, _image, _castHash
        );

        require(address(token) < weth, "Invalid salt");

        address pool = uniswapV3Factory.createPool(address(token), weth, _fee);
        uint160 sqrtPriceX96 = _initialTick.getSqrtRatioAtTick();
        INonfungiblePositionManager(pool).initialize(sqrtPriceX96);

        token.approve(address(positionManager), _supply);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: address(token),
            token1: weth,
            fee: _fee,
            tickLower: _initialTick,
            tickUpper: maxUsableTick(tickSpacing),
            amount0Desired: _supply,
            amount1Desired: 0,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        });

        (tokenId,,,) = positionManager.mint(params);

        address lockerAddress = liquidityLocker.deploy(
            address(positionManager),
            _deployer,
            defaultLockingPeriod,
            tokenId,
            lpFeesCut
        );

        positionManager.safeTransferFrom(address(this), lockerAddress, tokenId);
        ILocker(lockerAddress).initializer(tokenId);

        if (msg.value > 0) {
            uint256 buyAmount = msg.value;
            if (bundleFeeSwitch) {
                uint256 fee = (msg.value * taxRate) / 1000;
                buyAmount = msg.value - fee;
                (bool success,) = taxCollector.call{value: fee}("");
                require(success, "Fee transfer failed");
            }

            ExactInputSingleParams memory swapParams = ExactInputSingleParams({
                tokenIn: weth,
                tokenOut: address(token),
                fee: _fee,
                recipient: _deployer,
                amountIn: buyAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            ISwapRouter(swapRouter).exactInputSingle{value: buyAmount}(swapParams);
        }

        emit TokenCreated(
            address(token),
            tokenId,
            _deployer,
            _fid,
            _name,
            _symbol,
            _supply,
            lockerAddress,
            _castHash
        );
    }

    function initialSwapTokens(address token, uint24 fee) public payable {
        ExactInputSingleParams memory params = ExactInputSingleParams({
            tokenIn: weth,
            tokenOut: token,
            fee: fee,
            recipient: msg.sender,
            amountIn: msg.value,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        ISwapRouter(swapRouter).exactInputSingle{value: msg.value}(params);
    }

    function predictToken(
        address deployer,
        uint256 fid,
        string calldata name,
        string calldata symbol,
        string calldata image,
        string calldata castHash,
        uint256 supply,
        bytes32 salt
    ) public view returns (address) {
        bytes32 create2Salt = keccak256(abi.encode(deployer, salt));
        return keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                create2Salt,
                keccak256(
                    abi.encodePacked(
                        type(Token).creationCode,
                        abi.encode(name, symbol, supply, deployer, fid, image, castHash)
                    )
                )
            )
        ).fromLast20Bytes();
    }

    function generateSalt(
        address deployer,
        uint256 fid,
        string calldata name,
        string calldata symbol,
        string calldata image,
        string calldata castHash,
        uint256 supply
    ) external view returns (bytes32 salt, address token) {
        for (uint256 i; ; i++) {
            salt = bytes32(i);
            token = predictToken(deployer, fid, name, symbol, image, castHash, supply, salt);
            if (token < weth && token.code.length == 0) break;
        }
    }

    function toggleBundleFeeSwitch(bool enabled) external onlyOwner {
        bundleFeeSwitch = enabled;
    }

    function setDeprecated(bool value) external onlyOwner {
        deprecated = value;
    }
