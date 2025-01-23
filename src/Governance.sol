// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {console} from "forge-std/Test.sol";
import {JoesSwapV3} from "./JoesSwapV3.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Governance {
    uint256 public immutable QUORUM = 70;
    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        bool executed;
        address proposer;
    }
    mapping(uint256 => Proposal) proposals;
    mapping(uint256 => mapping(address => bool)) public voted;
    uint256 immutable VOTING_DURATION = 7 days;
    uint256 proposalCount = 0;

    event ProposalCreated(uint256 id, string description, address proposer);

    function createProposal(string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            voteCount: 0,
            executed: false,
            proposer: msg.sender
        });
        emit ProposalCreated(proposalCount, description, msg.sender);
    }


    function getProposal(
        uint256 proposalId
    ) public view returns (Proposal memory) {
        return proposals[proposalId];
    }
}
