// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {console} from "forge-std/Test.sol";
import {JoesSwapV3} from "./JoesSwapV3.sol";
import {JoesSwapFactory} from "../src/JoesSwapFactory.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract Governance {
    using SafeERC20 for IERC20;
    JoesSwapFactory public joesSwapFactory;
    IERC20 public immutable token;
    uint256 public immutable QUORUM = 70;

    enum ProposalType {
        CREATE_POOL,
        CHANGE_FEE
    }

    struct Proposal {
        uint256 id;
        string description;
        ProposalType proposalType;
        uint256 voteCount;
        bool executed;
        address proposer;
        uint256 deadline;
        bytes data;
    }

    mapping(uint256 => Proposal) proposals;
    mapping(uint256 => mapping(address => bool)) public voted;
    uint256 immutable VOTING_DURATION = 7 days;
    uint256 proposalCount = 0;

    event ProposalCreated(uint256 id, string description, address proposer);
    event Voted(uint256 proposalId, address voter);

    constructor(address _token) {
        joesSwapFactory = new JoesSwapFactory();
        token = IERC20(_token);
    }

    function createProposal(
        string memory description,
        ProposalType _proposalType,
        bytes memory data
    ) public {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            proposalType: _proposalType,
            voteCount: 0,
            executed: false,
            proposer: msg.sender,
            deadline: block.timestamp + VOTING_DURATION,
            data: data
        });

        emit ProposalCreated(proposalCount, description, msg.sender);
    }

    function vote(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(
            !voted[proposalId][msg.sender],
            "Can't vote twice on the same proposal."
        );
        require(block.timestamp <= proposal.deadline, "Voting is over.");
        uint256 balance = token.balanceOf(msg.sender);
        require(balance > 0, "You have to own tokens to vote.");

        proposal.voteCount += balance;
        voted[proposalId][msg.sender] = true;

        emit Voted(proposalId, msg.sender);
    }

    function executeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        uint256 totalSupply = token.totalSupply();
        uint256 minVotesNeeded = (totalSupply * QUORUM) / 100;
        require(
            proposal.voteCount > minVotesNeeded,
            "Need atleast 70% of votes."
        );
        proposal.executed = true;
        if (proposal.proposalType == ProposalType.CREATE_POOL) {
            (address tokenA, address tokenB) = abi.decode(
                proposal.data,
                (address, address)
            );
            address createdPool = joesSwapFactory.createPool(tokenA, tokenB);
            require(createdPool != address(0), "Pool creation failed.");
        } else if (proposal.proposalType == ProposalType.CHANGE_FEE) {
            uint256 fee = abi.decode(proposal.data, (uint256));
            joesSwapFactory.changeFee(fee);
        }
    }

    function getProposal(
        uint256 proposalId
    ) public view returns (Proposal memory) {
        return proposals[proposalId];
    }
}
