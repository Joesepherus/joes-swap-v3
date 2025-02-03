// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/JoesUSDTToken.sol";

contract DeployJoesUSDTToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        new JoesUSDTToken(1_000_000); // 1 million tokens
        vm.stopBroadcast();
    }
}
