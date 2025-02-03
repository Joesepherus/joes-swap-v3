// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/JoesGovernanceToken.sol";

contract DeployJoesGovernanceToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        new JoesGovernanceToken(1_000_000); // 1 million tokens
        vm.stopBroadcast();
    }
}
