// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {JoesGovernance} from "../src/JoesGovernance.sol";

contract DeployJoesGovernance is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        new JoesGovernance(0x5527b10aCDcE4117EDe752df720070db812dB10E);  
        vm.stopBroadcast();
    }
}
