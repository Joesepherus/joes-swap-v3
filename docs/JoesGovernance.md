# JoesGovernance Contract

## Overview

The `JoesGovernance` contract allows token holders to manage proposals for the JoesSwap platform, including pool creation and fee changes. This contract enables the creation of proposals, voting, and execution of approved proposals based on a quorum of token votes.

## Contract Details

- **Version:** Solidity 0.8.20
- **Dependencies:**
  - `JoesSwapV3`
  - `JoesSwapFactory`
  - `ERC20`
  - `SafeERC20`

## Contract: JoesGovernance

The `JoesGovernance` contract allows users to create proposals, vote on them, and execute them if enough votes are obtained. The contract uses the ERC20 token for voting and interacts with the `JoesSwapFactory` for pool creation and fee management.

### State Variables

- **joesSwapFactory:** A reference to the `JoesSwapFactory` contract.
- **token:** The ERC20 token used for voting.
- **QUORUM:** The minimum percentage of votes required for a proposal to be executed (set to 70%).
- **VOTING_DURATION:** Duration of the voting period (set to 7 days).
- **proposalCount:** Counter for the total number of proposals.

### Structs

- **Proposal:**
  - `id`: Unique identifier for the proposal.
  - `description`: Description of the proposal.
  - `proposalType`: Type of the proposal (`CREATE_POOL` or `CHANGE_FEE`).
  - `voteCount`: Number of votes received for the proposal.
  - `executed`: Boolean indicating whether the proposal has been executed.
  - `proposer`: Address of the proposer.
  - `deadline`: Timestamp of the proposal's voting deadline.
  - `data`: Data associated with the proposal (e.g., addresses for pool creation or fee value).

### Events

- **ProposalCreated:** Emitted when a new proposal is created.
- **Voted:** Emitted when a user votes on a proposal.

### Functions

#### constructor

```solidity
constructor(address _token)
```

Initializes the governance contract with the token address used for voting.

#### createProposal

```solidity
function createProposal(string memory description, ProposalType _proposalType, bytes memory data) external
```

Allows users to create a new proposal with a description, type, and associated data.

#### vote

```solidity
function vote(uint256 proposalId) external
```

Allows users to vote on a proposal. The user must not have voted already, and the proposal must be within the voting period and not executed.

#### executeProposal

```solidity
function executeProposal(uint256 proposalId) external
```

Executes the proposal if it has received enough votes. The action depends on the proposal type (e.g., pool creation or fee change).

#### getProposal

```solidity
function getProposal(uint256 proposalId) external view returns (Proposal memory)
```

Retrieves the details of a proposal by its ID.

## Error Handling

- **Can't vote twice on the same proposal:** Ensures that users can't vote more than once on a proposal.
- **Proposal has already been executed:** Ensures that already executed proposals can't be voted on again.
- **Voting is over:** Ensures that voting is done within the specified duration.
- **You have to own tokens to vote:** Ensures that only token holders can vote on proposals.
- **Need at least 70% of votes:** Ensures that a proposal needs at least 70% of the votes to be executed.
- **Pool creation failed:** Ensures that the pool creation process was successful.

## Author
Joesepherus

## License
This contract is licensed under the UNLICENSED SPDX identifier.

