// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Governance} from "../src/Governance.sol";
import {ERC20Mock} from "./ERC20Mock.sol";
import {JoesSwapFactory} from "../src/JoesSwapFactory.sol";

contract GovernanceTest is Test {
    Governance governance;
    ERC20Mock token;

    address OWNER = address(0x4eFF9F6DBb11A3D9a18E92E35BD4D54ac4E1533a);
    address USER = address(1);
    address USER2 = address(2);

    uint256 STARTING_AMOUNT = 1_000;

    function setUp() public {
        token = new ERC20Mock("Token", "T");
        governance = new Governance(address(token));

        token.mint(USER, STARTING_AMOUNT);
    }

    function test_createProposal() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
    }

    function test_voteOnce() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.prank(USER);
        governance.vote(1);
    }

    function test_voteTwice() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.startPrank(USER);
        governance.vote(1);
        vm.expectRevert("Can't vote twice on the same proposal.");
        governance.vote(1);
    }

    function test_voteAfterDeadline() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.warp(8 days);
        vm.startPrank(USER);
        vm.expectRevert("Voting is over.");
        governance.vote(1);
    }

    function test_executeProposal() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.startPrank(USER);
        governance.vote(1);
        governance.executeProposal(1);
    }

    function test_executeProposalFail() public {
        uint256 fee = 5;
        bytes memory data = abi.encode(fee);
        governance.createProposal(
            "Increase fee to 5%.",
            Governance.ProposalType.CHANGE_FEE,
            data
        );
        token.mint(USER2, STARTING_AMOUNT);
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.startPrank(USER);
        governance.vote(1);
        vm.expectRevert("Need atleast 70% of votes.");
        governance.executeProposal(1);
    }

    function test_executeProposalCreatePool() public {
        ERC20Mock ETH = new ERC20Mock("Ethereum", "ETH");
        ERC20Mock USD = new ERC20Mock("US dolla", "USD");
        bytes memory data = abi.encode(ETH, USD);
        governance.createProposal(
            "Create new pool for ETH:USD.",
            Governance.ProposalType.CREATE_POOL,
            data
        );
        Governance.Proposal memory proposal = governance.getProposal(1);
        console.log("proposal", proposal.description);
        vm.startPrank(USER);
        governance.vote(1);
        governance.executeProposal(1);
        JoesSwapFactory joesSwapFactory = governance.joesSwapFactory();
        address ETHUSDPool = joesSwapFactory.getPool(
            address(ETH),
            address(USD)
        );
        assert(ETHUSDPool != address(0));
    }
}
