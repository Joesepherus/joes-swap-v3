// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JoesGovernanceToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("Joes Governance Token", "JGT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
