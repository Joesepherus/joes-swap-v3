// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {console} from "forge-std/Test.sol";
import {JoesSwapV3} from "./JoesSwapV3.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract FlashloanReceiver {
    JoesSwapV3 joesSwapV3;
    uint256 immutable FEE = 3;

    constructor(address _joesSwapV3) {
        require(_joesSwapV3 != address(0), "Not a valid address.");
        joesSwapV3 = JoesSwapV3(_joesSwapV3);
    }

    function flashloan(uint256 amount, address token) external {
        joesSwapV3.flashloan(amount, token);
    }

    function flashloan_receive(uint256 amount, address token) external {
        console.log("amount", amount);
        uint256 fee = (amount * FEE) / 100;
        console.log("fee", fee);
        console.log("amount + fee", amount + fee);

        IERC20(token).transfer(address(joesSwapV3), amount + fee);
    }
}
