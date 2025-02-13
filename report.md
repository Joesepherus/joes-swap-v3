# Aderyn Analysis Report

This report was generated by [Aderyn](https://github.com/Cyfrin/aderyn), a static analysis tool built by [Cyfrin](https://cyfrin.io), a blockchain security company. This report is not a substitute for manual audit or security review. It should not be relied upon for any purpose other than to assist in the identification of potential security vulnerabilities.
# Table of Contents

- [Summary](#summary)
  - [Files Summary](#files-summary)
  - [Files Details](#files-details)
  - [Issue Summary](#issue-summary)
- [Low Issues](#low-issues)
  - [L-1: Centralization Risk for trusted owners](#l-1-centralization-risk-for-trusted-owners)
  - [L-2: PUSH0 is not supported by all chains](#l-2-push0-is-not-supported-by-all-chains)
  - [L-3: Empty Block](#l-3-empty-block)


# Summary

## Files Summary

| Key | Value |
| --- | --- |
| .sol Files | 7 |
| Total nSLOC | 424 |


## Files Details

| Filepath | nSLOC |
| --- | --- |
| src/FlashloanReceiver.sol | 22 |
| src/IFlashloanReceiver.sol | 4 |
| src/JoesGovernance.sol | 95 |
| src/JoesGovernanceToken.sol | 8 |
| src/JoesSwapFactory.sol | 27 |
| src/JoesSwapV3.sol | 260 |
| src/JoesUSDTToken.sol | 8 |
| **Total** | **424** |


## Issue Summary

| Category | No. of Issues |
| --- | --- |
| High | 0 |
| Low | 3 |


# Low Issues

## L-1: Centralization Risk for trusted owners

Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

<details><summary>5 Found Instances</summary>


- Found in src/JoesGovernanceToken.sol [Line: 13](src/JoesGovernanceToken.sol#L13)

	```solidity
	contract JoesGovernanceToken is ERC20, Ownable {
	```

- Found in src/JoesSwapFactory.sol [Line: 13](src/JoesSwapFactory.sol#L13)

	```solidity
	contract JoesSwapFactory is Ownable {
	```

- Found in src/JoesSwapFactory.sol [Line: 39](src/JoesSwapFactory.sol#L39)

	```solidity
	    ) external onlyOwner returns (address pool) {
	```

- Found in src/JoesSwapFactory.sol [Line: 57](src/JoesSwapFactory.sol#L57)

	```solidity
	    function changeFee(uint256 fee) external onlyOwner() {}
	```

- Found in src/JoesUSDTToken.sol [Line: 13](src/JoesUSDTToken.sol#L13)

	```solidity
	contract JoesUSDTToken is ERC20, Ownable {
	```

</details>



## L-2: PUSH0 is not supported by all chains

Solc compiler version 0.8.20 switches the default target EVM version to Shanghai, which means that the generated bytecode will include PUSH0 opcodes. Be sure to select the appropriate EVM version in case you intend to deploy on a chain other than mainnet like L2 chains that may not support PUSH0, otherwise deployment of your contracts will fail.

<details><summary>7 Found Instances</summary>


- Found in src/FlashloanReceiver.sol [Line: 2](src/FlashloanReceiver.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/IFlashloanReceiver.sol [Line: 2](src/IFlashloanReceiver.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/JoesGovernance.sol [Line: 2](src/JoesGovernance.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/JoesGovernanceToken.sol [Line: 2](src/JoesGovernanceToken.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/JoesSwapFactory.sol [Line: 2](src/JoesSwapFactory.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/JoesSwapV3.sol [Line: 2](src/JoesSwapV3.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

- Found in src/JoesUSDTToken.sol [Line: 2](src/JoesUSDTToken.sol#L2)

	```solidity
	pragma solidity 0.8.20;
	```

</details>



## L-3: Empty Block

Consider removing empty blocks.

<details><summary>1 Found Instances</summary>


- Found in src/JoesSwapFactory.sol [Line: 57](src/JoesSwapFactory.sol#L57)

	```solidity
	    function changeFee(uint256 fee) external onlyOwner() {}
	```

</details>



