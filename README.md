# JoesSwap Protocol

The JoesSwap protocol is a decentralized finance (DeFi) ecosystem that provides an automated market maker (AMM) for swapping tokens, creating liquidity pools, and enabling governance through a decentralized voting system. The protocol is designed to be modular, with multiple smart contracts that handle different functionalities of the platform.

## Components

The protocol consists of the following main components:

### 1. **JoesGovernance**

The `JoesGovernance` contract allows token holders to participate in the governance of the JoesSwap platform. It enables users to create proposals, vote on them, and execute approved proposals. Proposals can relate to pool creation and fee adjustments on the platform. The voting system requires token ownership, and proposals can be executed once the required quorum of votes is achieved.

- **Proposal Types**: 
  - Pool creation (`CREATE_POOL`)
  - Fee changes (`CHANGE_FEE`)
  
- **Voting**: Token holders can vote on proposals, and proposals are executed if they reach the required quorum (70% of votes).

- **Contract Location**: [`JoesGovernance.sol`](./src/JoesGovernance.sol)
- **Documentation**: [JoesGovernance Documentation](./docs/JoesGovernance.md)

### 2. **JoesSwapFactory**

The `JoesSwapFactory` contract is responsible for managing the creation of liquidity pools and adjusting fees within the JoesSwap ecosystem. It enables the creation of new pools with specified token pairs and manages platform fees.

- **Functions**:
  - Create liquidity pools for token pairs.
  - Change platform fees for swaps.

- **Contract Location**: [`JoesSwapFactory.sol`](./src/JoesSwapFactory.sol)
- **Documentation**: [JoesSwapFactory Documentation](./docs/JoesSwapFactory.md)

### 3. **JoesSwapV3**

The `JoesSwapV3` contract implements the core AMM (Automated Market Maker) functionality of the JoesSwap protocol. It facilitates token swaps, ensuring that liquidity is provided by users in the form of pools. It calculates prices and executes token swaps based on the liquidity available in the pools.

- **Features**:
  - Swap tokens using the AMM model.
  - Provide liquidity to pools and earn fees.

- **Contract Location**: [`JoesSwapV3.sol`](./src/JoesSwapV3.sol)
- **Documentation**: [JoesSwapV3 Documentation](./docs/JoesSwapV3.md)

## How the Protocol Works

The JoesSwap protocol enables token holders to interact with a decentralized exchange where they can create and manage pools for token swaps. The governance mechanism allows the community to propose and vote on changes to the platform, such as creating new pools or modifying platform fees.

### Key Features:
- **Liquidity Pools**: Users can create and trade on token pairs.
- **Governance**: Token holders vote on platform changes.
- **Fee Management**: Proposals can change platform fees.

## Installation

To deploy and interact with the JoesSwap protocol, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/joes-swap/joes-swap.git
   cd joes-swap
   ```

2. Install the necessary dependencies (if applicable).

3. Deploy the contracts to your preferred Ethereum network.

## Contributing

Contributions are welcome! If you have ideas for improving the protocol or fixing bugs, please open an issue or submit a pull request.

## License

This protocol is licensed under the [UNLICENSED](./LICENSE) license.

