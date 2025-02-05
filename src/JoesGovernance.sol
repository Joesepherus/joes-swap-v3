// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {JoesSwapV3} from "./JoesSwapV3.sol";
import {JoesSwapFactory} from "../src/JoesSwapFactory.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title JoesGovernance
 * @author Joesepherus
 * @dev A governance contract for managing proposals related to pool creation and fee changes on the JoesSwap platform.
 * This contract allows token holders to create proposals, vote on them, and execute approved proposals.
 */
contract JoesGovernance {
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

    event ProposalCreated(
        uint256 indexed id,
        string indexed description,
        address indexed proposer
    );
    event Voted(uint256 indexed proposalId, address indexed voter);

    /**
     * @dev Initializes the governance contract with the token address for voting.
     * @param _token The address of the token used for voting.
     */
    constructor(address _token) {
        joesSwapFactory = new JoesSwapFactory();
        token = IERC20(_token);
    }

    /**
     * @dev Allows users to create a new proposal.
     * @param description The description of the proposal.
     * @param _proposalType The type of the proposal (CREATE_POOL or CHANGE_FEE).
     * @param data The data related to the proposal (e.g., addresses for pool creation or fee value).
     */
    function createProposal(
        string memory description,
        ProposalType _proposalType,
        bytes memory data
    ) external {
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

    /**
     * @dev Allows users to vote on a proposal.
     * @param proposalId The ID of the proposal to vote on.
     * Requirements:
     * - User must not have voted already on the proposal.
     * - Proposal must not have been executed.
     * - Voting must be within the voting period.
     * - User must own tokens to vote.
     */
    function vote(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(
            !voted[proposalId][msg.sender],
            "Can't vote twice on the same proposal."
        );
        require(!proposal.executed, "Proposal has already been executed.");
        require(block.timestamp <= proposal.deadline, "Voting is over.");
        uint256 balance = token.balanceOf(msg.sender);
        require(balance > 0, "You have to own tokens to vote.");

        proposal.voteCount += balance;
        voted[proposalId][msg.sender] = true;

        emit Voted(proposalId, msg.sender);
    }

    /**
     * @dev Executes the proposal if it has received enough votes.
     * @param proposalId The ID of the proposal to execute.
     * Requirements:
     * - Proposal must have received at least the quorum percentage of votes.
     * - Proposal type determines the action to be executed (e.g., pool creation or fee change).
     */
    function executeProposal(uint256 proposalId) external {
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

    /**
     * @dev Retrieves a proposal by its ID.
     * @param proposalId The ID of the proposal.
     * @return The Proposal struct containing proposal details.
     */
    function getProposal(
        uint256 proposalId
    ) external view returns (Proposal memory) {
        return proposals[proposalId];
    }
}
