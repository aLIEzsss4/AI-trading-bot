// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface ITrading {
    struct Strategy {
        address token;
        uint256 ratio; // decimals 6
        bool buy;
        uint256 timestamp; 
    }

    function setKeeper(address keeper, bool alive) external;
    function deposit() external payable;
    function withdrawAfterSell() external;
    function trade() external;
    function pushStrategy(address _account, Strategy memory _strategy) external;
}