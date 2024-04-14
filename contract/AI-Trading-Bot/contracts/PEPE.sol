// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PEPE is ERC20, Ownable {

    constructor() ERC20("PEPE AI", "PEPE") Ownable(msg.sender) {}

    function mint(uint amount) external {
        if(_msgSender() == owner()) {
            _mint(_msgSender(), amount);
            return;
        }
    }
}