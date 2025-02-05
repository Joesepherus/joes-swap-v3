# JoesSwapFactory Contract

## Overview
The `JoesSwapFactory` contract manages the creation and management of liquidity pools between token pairs. The owner of the contract can create new pools and manage existing ones. The contract works in conjunction with the `JoesSwapV3` contract to facilitate token swaps and liquidity provision.

## Inheritance
- `Ownable`: The contract inherits from OpenZeppelin's `Ownable`, meaning only the owner (address that deploys the contract) can execute certain functions.

---

## State Variables

### `getPool`
```solidity
mapping(address => mapping(address => address)) public getPool;
```
- **Description**: A mapping that stores the address of the liquidity pool for a given token pair `(tokenA, tokenB)`. The mapping allows quick access to the pool address based on the two tokens.
- **Visibility**: `public`
  
### `pools`
```solidity
address[] public pools;
```
- **Description**: An array that stores the addresses of all liquidity pools created by the contract.
- **Visibility**: `public`

---

## Events

### `CreatedPool`
```solidity
event CreatedPool(
    address indexed tokenA,
    address indexed tokenB,
    address indexed pool
);
```
- **Description**: This event is emitted whenever a new liquidity pool is created. It provides the details of the token pair (`tokenA`, `tokenB`) and the address of the newly created pool.
  
---

## Constructor

### `constructor()`
```solidity
constructor() Ownable(msg.sender);
```
- **Description**: The constructor initializes the contract and sets the owner to the address that deploys the contract, allowing only the owner to perform certain actions.
- **Inherits**: `Ownable` constructor, which sets the contract deployer as the owner.

---

## Functions

### `createPool`
```solidity
function createPool(address tokenA, address tokenB) external onlyOwner returns (address pool);
```
- **Description**: Allows the owner to create a new liquidity pool between two tokens.
- **Parameters**:
  - `tokenA` (address): The address of the first token in the pool.
  - `tokenB` (address): The address of the second token in the pool.
- **Returns**: The address of the newly created liquidity pool.
- **Reverts**:
  - If either `tokenA` or `tokenB` is the zero address (`address(0)`).
  - If `tokenA` and `tokenB` are identical tokens.
  - If a pool already exists for the provided token pair (`getPool[tokenA][tokenB] != address(0)`).
- **Events**: Emits the `CreatedPool` event with the details of the newly created pool.

### `changeFee`
```solidity
function changeFee(uint256 fee) external onlyOwner;
```
- **Description**: Allows the owner to change the fee structure for all liquidity pools. Currently, the logic for fee adjustment is not implemented.
- **Parameters**:
  - `fee` (uint256): The new fee value to be set for all pools (future functionality to be developed).
- **Reverts**: This function is a placeholder and currently does nothing.
- **TODO**: Add logic to modify the fee structure for pools and ensure existing fees are adjusted accordingly.

---

## Modifiers

### `onlyOwner`
- **Description**: This modifier ensures that only the owner of the contract can execute the function. It is inherited from the OpenZeppelin `Ownable` contract, restricting certain actions to the owner only.

---

## Notes
- The `createPool` function allows the owner to create liquidity pools between two distinct tokens. It ensures that a pool is only created if the token pair doesn't already exist, preventing duplicate pools.
- The `changeFee` function is a placeholder for future functionality, which will allow the owner to modify the fee structure for all liquidity pools in the contract.
- The contract uses OpenZeppelin's `Ownable` contract to restrict access to certain functions, ensuring only the owner can perform sensitive operations like pool creation and fee adjustments.

---

## Future Enhancements
- Implement logic for the `changeFee` function to adjust fees for liquidity pools.
- Add additional functions for pool management, such as removing pools or modifying pool parameters.

## Author
Joesepherus

## License
This contract is licensed under the UNLICENSED SPDX identifier.

