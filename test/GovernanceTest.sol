// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Governance} from "../src/Governance.sol";

contract JoesSwapV3Test is Test {
    Governance governance;

    address USER = address(0x4eFF9F6DBb11A3D9a18E92E35BD4D54ac4E1533a);
    address USER2 = address(2);

    function setUp() public {
        governance = new Governance();
    }

    function test_createProposal() public {
        governance.createProposal("Increase fee to 5%.");
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
    }

}
