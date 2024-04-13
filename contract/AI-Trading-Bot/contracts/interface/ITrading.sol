// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface ITrading {
    struct Strategy {
        address token;
        uint256 ratio; // decimals 6
        bool buy;
        uint256 timestamp; 
    }

    struct Asset {
        address token;
        string tokenName;
        uint256 amount;
    }

    function deposit() external payable;
    function withdrawAfterSell() external;
    function getAssets(address _account) external view returns(Asset[] memory backAssets);

    function setKeeper(address keeper, bool alive) external;
    function trade() external;
    function pushStrategy(address _account, Strategy memory _strategy) external;
}