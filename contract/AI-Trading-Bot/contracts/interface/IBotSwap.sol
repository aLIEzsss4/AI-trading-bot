// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IBotSwap {
    function swapExactInputSingle(uint256 amountIn, address inputToken, address outputToken) external returns (uint256 amountOut);
}