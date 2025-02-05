// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

/**
 * @title IFlashloanReceiver
 * @author Joesepherus
 * @dev Interface for contracts that receive flash loans.
 */
interface IFlashloanReceiver {
    /**
     * @notice Called by the flash loan provider when the loan is issued.
     * @dev The receiver contract must implement this function to handle the flash loan.
     * @param amount The amount of tokens borrowed in the flash loan.
     * @param token The address of the token being borrowed.
     */
    function flashloan_receive(uint256 amount, address token) external;
}
