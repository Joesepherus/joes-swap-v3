// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// Interface of the other contract
interface IFlashloanReceiver {
    function flashloan_receive(uint256 amount, address token) external;
}
