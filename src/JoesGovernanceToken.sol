// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title JoesGovernanceToken
 * @author Joesepherus
 * @dev An ERC-20 governance token with a fixed supply, owned by the deployer.
 * Implements OpenZeppelin's ERC-20 standard and Ownable contract.
 */
contract JoesGovernanceToken is ERC20, Ownable {
    /**
     * @notice Deploys the JoesGovernanceToken contract.
     * @dev Mints the initial supply to the deployer's address.
     * @param initialSupply The amount of tokens to mint, before applying decimals.
     */
    constructor(uint256 initialSupply) ERC20("Joes Governance Token", "JGT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
