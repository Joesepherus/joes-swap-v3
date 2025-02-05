// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {console} from "forge-std/Test.sol";
import {JoesSwapV3} from "./JoesSwapV3.sol";
import {IFlashloanReceiver} from "./IFlashloanReceiver.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title FlashloanReceiver
 * @author Joesepherus
 * @dev Implements the IFlashloanReceiver interface to receive and repay flash loans.
 */
contract FlashloanReceiver is IFlashloanReceiver{
    using SafeERC20 for IERC20;

    // @notice The instance of JoesSwapV3 used for flash loans.
    JoesSwapV3 joesSwapV3;

    // @notice The fixed flash loan fee (3%).
    uint256 immutable FEE = 3;

    /**
     * @dev Sets the JoesSwapV3 contract address.
     * @param _joesSwapV3 The address of the JoesSwapV3 contract.
     */
    constructor(address _joesSwapV3) {
        require(_joesSwapV3 != address(0), "Not a valid address.");
        joesSwapV3 = JoesSwapV3(_joesSwapV3);
    }

    
    /**
     * @notice Initiates a flash loan from JoesSwapV3.
     * @dev Calls the flashloan function of JoesSwapV3.
     * @param amount The amount of tokens to borrow.
     * @param token The address of the token to borrow.
     */
    function flashloan(uint256 amount, address token) external {
        joesSwapV3.flashloan(amount, token);
    }

    /**
     * @notice Handles the flash loan callback, repaying the borrowed amount plus fees.
     * @dev Transfers the borrowed amount plus a 3% fee back to the JoesSwapV3 contract.
     * @param amount The amount borrowed.
     * @param token The address of the borrowed token.
     */
    function flashloan_receive(uint256 amount, address token) external {
        uint256 fee = (amount * FEE) / 100;

        IERC20(token).safeTransfer(address(joesSwapV3), amount + fee);
    }
}
