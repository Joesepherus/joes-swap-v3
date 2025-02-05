# JoesSwapV3 - A Decentralized Token Swapping and Liquidity Pool Contract

## Overview
JoesSwapV3 is a decentralized token swapping contract that allows users to provide liquidity, swap tokens, and collect fees in a liquidity pool. This contract supports two tokens, `token0` and `token1`, and implements basic features such as liquidity provisioning, token swaps, fee collection, and flash loans.


## Features
- **Liquidity Pool**: Users can add and remove liquidity to/from the pool.
- **Token Swapping**: Swaps between two tokens, `token0` and `token1`.
- **Fee Management**: Users can collect their share of fees based on liquidity provided.
- **Flash Loans**: Support for flash loan functionality.
- **Security**: Built-in reentrancy protection to prevent reentrancy attacks.

## Contract Functions

### 1. `setupPoolLiquidity(uint256 amount0, uint256 amount1)`
- **Description**: Initializes the liquidity pool with an initial amount of `token0` and `token1`.
- **Parameters**:
  - `amount0`: Amount of `token0` to add to the pool.
  - `amount1`: Amount of `token1` to add to the pool.
- **Reverts**: 
  - `PoolAlreadyInitialized`: If the pool has already been initialized.
- **Events**: `PoolInitialized`

### 2. `addLiquidity(uint256 amount0)`
- **Description**: Adds liquidity to the pool by providing `token0`. The contract calculates how much `token1` should be added based on the reserves.
- **Parameters**:
  - `amount0`: Amount of `token0` to add.
- **Reverts**:
  - `PoolNotInitialized`: If the pool has not been initialized.
- **Events**: `AddLiquidity`

### 3. `removeLiquidity()`
- **Description**: Removes liquidity from the pool. The caller's share of `token0` and `token1` is returned based on the liquidity they provided.
- **Reverts**:
  - `InsufficientLiquidity`: If the caller has no liquidity to remove.
- **Events**: `RemoveLiquidity`

### 4. `swapToken0Amount(uint256 amountIn, uint256 amountInMax)`
- **Description**: Swaps a specified amount of `token0` for `token1`. The contract calculates the appropriate amount of `token1` based on the reserves.
- **Parameters**:
  - `amountIn`: The amount of `token0` to swap.
  - `amountInMax`: The maximum allowable amount of `token0` for the swap.
- **Reverts**:
  - `Slippage free amountIn too big`: If the input exceeds the maximum allowed.
  - `Invalid output amount`: If the output amount of `token1` is invalid.
- **Events**: `Swap`

### 5. `swapToken1Amount(uint256 amountIn, uint256 amountInMax)`
- **Description**: Swaps a specified amount of `token1` for `token0`. The contract calculates the appropriate amount of `token0` based on the reserves.
- **Parameters**:
  - `amountIn`: The amount of `token1` to swap.
  - `amountInMax`: The maximum allowable amount of `token1` for the swap.
- **Reverts**:
  - `Slippage free amountIn too big`: If the input exceeds the maximum allowed.
  - `Invalid output amount`: If the output amount of `token0` is invalid.
- **Events**: `Swap`

### 6. `withdrawFees()`
- **Description**: Withdraws the caller's share of the accumulated fees from the liquidity pool.
- **Reverts**:
  - `InsufficientFeesBalance`: If the caller doesn't have any fees to withdraw.
- **Events**: `WithdrawFees`

### 7. `flashloan(address receiver, uint256 amount, uint256 fee)`
- **Description**: Executes a flash loan by borrowing a specified amount of tokens and returning them along with a fee.
- **Parameters**:
  - `receiver`: The address of the flash loan receiver.
  - `amount`: The amount of tokens to borrow.
  - `fee`: The fee to be paid back for the loan.
- **Events**: `Flashloan`

## State Variables
- **token0**: ERC20 token contract address for the first token in the pool.
- **token1**: ERC20 token contract address for the second token in the pool.
- **reserve0**: The amount of `token0` in the pool.
- **reserve1**: The amount of `token1` in the pool.
- **liquidity**: Total liquidity in the pool.
- **accumulatedFeePerLiquidityUnitToken0**: Fee accumulated per liquidity unit for `token0`.
- **accumulatedFeePerLiquidityUnitToken1**: Fee accumulated per liquidity unit for `token1`.
- **poolInitialized**: A flag indicating whether the pool has been initialized.

## Constants
- **PRECISION**: A precision factor used for scaling token amounts.
- **FEE**: The fee percentage for swaps (in basis points, 1/100th of a percent).
- **ONE_HUNDRED**: A constant representing the value 100.

## Events
- **PoolInitialized**: Emitted when the pool is initialized.
- **AddLiquidity**: Emitted when liquidity is added to the pool.
- **RemoveLiquidity**: Emitted when liquidity is removed from the pool.
- **Swap**: Emitted when a swap is performed between `token0` and `token1`.
- **WithdrawFees**: Emitted when fees are withdrawn by a user.
- **Flashloan**: Emitted when a flash loan is executed.

## Errors
- **InsufficentFeesBalance**: Raised when the caller tries to withdraw fees but doesn't have any.
- **InsufficentLiquidity**: Raised when the caller tries to remove liquidity but has none.
- **PoolAlreadyInitialized**: Raised if the pool has already been initialized.
- **PoolNotInitialized**: Raised if the pool is not initialized.

## Installation & Setup

To deploy the contract, ensure you have the following dependencies:

- Solidity 0.8.20 or above
- Forge for testing and contract deployment
- OpenZeppelin Contracts for standard ERC20 and utility functions

### Install Dependencies

```bash
git clone https://github.com/OpenZeppelin/openzeppelin-contracts.git
forge install
```


## What got introduced in v3
1. Add flashloans
2. Add Governance contract for controlling the DEX
3. Add Factory for deploying pools new token pairs of DEX

## Where this can be improved
1. Make the swaps non-linear
2. Hand out LP tokens to liquidity providers
3. Add checks
4. Add natspec to Governance JoesSwapFactory and FlasloanReceiver


## Author
Joesepherus

## License
This contract is licensed under the UNLICENSED SPDX identifier.
