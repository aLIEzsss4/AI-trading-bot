// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./interface/ITrading.sol";
import "./interface/IBotSwap.sol";
import "./interface/IWETH.sol";

import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract Trading is ITrading {
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    address public constant WETH10 = 0x8f17245f874183a201D61a78188A8e8580304aEa;

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

        IWETH10(WETH10).deposit{value: msg.value}();
        // balances[msg.sender] += amount;
        wethBalances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
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
}
