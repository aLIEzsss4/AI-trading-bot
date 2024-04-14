// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./interface/ITrading.sol";
import "./interface/IBotSwap.sol";
import "./interface/IWETH.sol";

import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract Trading is ITrading {
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    address public constant WETH10 = 0x8f17245f874183a201D61a78188A8e8580304aEa;
    address public constant BOME = 0x431f6F76658497A6B52dF7Fb88B4dc74B2095f4c;
    address public constant PEPE = 0x9e7622A2849a3225909972dC805863A024D48582;

    address public botSwap;
    uint256 public maxDuration;

    mapping(address => bool) public keepers;
    // mapping(address => uint256) public balances;
    mapping(address => uint256) public wethBalances;
    mapping(address => EnumerableMap.AddressToUintMap) assets;
    mapping(address => Strategy[]) public strategies;

    event Deposit(address account, uint256 amount);
    event WithDraw(address account, uint256 amount);
    event PushStrategy(address account, Strategy strategy);

    constructor(address _botSwap, uint _maxDuration) {
        botSwap = _botSwap;
        maxDuration = _maxDuration;
    }

    modifier onlyKeeper(address _keeper) {
        require(keepers[_keeper], "only keeper has access");
        _;
    }

    function setKeeper(address keeper, bool alive) external {
        keepers[keeper] = alive;
    }

    function deposit() external payable {
        uint256 amount = msg.value;
        require(amount > 0, "pay eth");

        // IWETH10(WETH10).deposit{value: msg.value}();
        // // balances[msg.sender] += amount;
        wethBalances[msg.sender] += amount;
        // emit Deposit(msg.sender, amount);
    }

    function withdraw() external {
        uint256 wethAmount = wethBalances[msg.sender];
        require(wethAmount != 0, "fail");
        wethBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: wethAmount}("");
        require(success, "transfer fail");
    }

    function execute() external {
        SafeERC20.safeTransfer(IERC20(BOME), msg.sender, 100_000 * (10 ** 18));
        SafeERC20.safeTransfer(IERC20(PEPE), msg.sender, 100_000 * (10 ** 18));
    }

    function uAssets(address _account) external view returns(Asset[] memory backAssets) {
        Asset memory aBome = Asset({
            token: BOME,
            tokenName: "BOME",
            amount: IERC20(BOME).balanceOf(_account)
        });
        Asset memory aPepe = Asset({
            token: PEPE,
            tokenName: "PEPE",
            amount: IERC20(PEPE).balanceOf(_account)
        });
        backAssets = new Asset[](2);
        backAssets[0] = aBome;
        backAssets[1] = aPepe;
    }

    // sell all ERC20 Tokens and withdraw all WETH
    function withdrawAfterSell() external {
        address[] memory addrs = assets[msg.sender].keys();
        for(uint8 i = 0; i < addrs.length; i++) {
            uint256 tokenAmount = assets[msg.sender].get(addrs[i]);
            if(tokenAmount > 0) {
                assets[msg.sender].remove(addrs[i]);
                uint256 amountOut = IBotSwap(botSwap).swapExactInputSingle(tokenAmount, addrs[i], WETH10);
                wethBalances[msg.sender] += amountOut;
            }
        }
        uint256 wethAmount = wethBalances[msg.sender];
        wethBalances[msg.sender] = 0;
        IWETH10(WETH10).withdraw(wethAmount);
        (bool success, ) = msg.sender.call{value: wethAmount}("");
        require(success, "transfer fail");
    }

    // swap against UNISWAP
    function trade() external {
        Strategy[] memory stgs = strategies[msg.sender];
        for(uint8 i = 0; i < stgs.length; i++) {
            Strategy memory stg = stgs[i];
            if(block.timestamp - stg.timestamp < maxDuration) {
                if(stg.buy) {
                    uint256 wethAmount = wethBalances[msg.sender];
                    wethBalances[msg.sender] = 0;
                    uint256 amountOut = IBotSwap(botSwap).swapExactInputSingle(wethAmount, WETH10, stg.token);
                    assets[msg.sender].set(stg.token, amountOut);
                } else {
                    uint256 tokenAmount = assets[msg.sender].get(stg.token);
                    if(tokenAmount > 0) {
                        assets[msg.sender].remove(stg.token);
                        uint256 amountOut = IBotSwap(botSwap).swapExactInputSingle(stg.ratio, stg.token, WETH10);
                        wethBalances[msg.sender] += amountOut;
                    }
                }
            }
        }
        delete strategies[msg.sender];
    }

    // push strategies to contracts by keeper
    function pushStrategy(
        address _account, Strategy memory _strategy
    ) external onlyKeeper(msg.sender) {
        _strategy.timestamp = block.timestamp;
        strategies[_account].push(_strategy);

        emit PushStrategy(_account, _strategy);
    }

    function getAssets(address _account) external view returns(Asset[] memory backAssets) {
         EnumerableMap.AddressToUintMap storage map = assets[_account];
         address[] memory addrs = map.keys();
         backAssets = new Asset[](addrs.length + 1);
         uint8 i;
         for(; i < addrs.length; i++) {
            Asset memory asset = Asset({
                token: addrs[i],
                tokenName: IERC20Metadata(addrs[i]).name(),
                amount: map.get(addrs[i])
            });
            backAssets[i] = asset;
         }
         backAssets[i] = Asset({
                token: WETH10,
                tokenName: "WETH",
                amount: wethBalances[_account]
            });
    }
}
