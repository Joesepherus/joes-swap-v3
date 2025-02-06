// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {JoesSwapV3} from "./JoesSwapV3.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title JoesSwapFactory
 * @author Joesepherus
 * @dev This contract manages the creation of liquidity pools between different token pairs.
 * The owner of the contract can create new pools and manage existing ones.
 */
contract JoesSwapFactory is Ownable {
    mapping(address => mapping(address => address)) public getPool;
    address[] public pools;
    event CreatedPool(
        address indexed tokenA,
        address indexed tokenB,
        address indexed pool
    );


    /**
     * @dev Initializes the contract and sets the owner.
     * @notice The owner is the address that deploys the contract.
     */
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Allows the owner to create a new liquidity pool between two tokens.
     * @param tokenA The address of token A in the pool.
     * @param tokenB The address of token B in the pool.
     * @return pool The address of the newly created liquidity pool.
     * @notice Only the owner can create pools. Pools can only be created if the token pair does not already exist.
     */
    function createPool(
        address tokenA,
        address tokenB
    ) external onlyOwner returns (address pool) {
        require(tokenA != address(0), "Invalid address fot tokenA.");
        require(tokenB != address(0), "Invalid address for tokenB.");
        require(tokenA != tokenB, "Identical tokens.");
        require(getPool[tokenA][tokenB] == address(0), "Pair exists.");

        pool = address(new JoesSwapV3(tokenA, tokenB));
        getPool[tokenA][tokenB] = address(pool);
        pools.push(pool);
        emit CreatedPool(tokenA, tokenB, pool);
    }

    /**
     * @dev Allows the owner to change the fee structure for all pools.
     * @param fee The new fee value (the logic for changing the fee will be added later).
     * @notice This function is not yet implemented and will require further development.
     */
    // fixme Add logic to change the fee and ensure that the existing collected fees are adjusted accordingly.
    function changeFee(uint256 fee) external onlyOwner() {}
}
