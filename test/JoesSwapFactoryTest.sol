// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {JoesSwapFactory} from "../src/JoesSwapFactory.sol";
import {ERC20Mock} from "./ERC20Mock.sol";

contract JoesSwapFactoryTest is Test {
    JoesSwapFactory joesSwapFactory;
    address OWNER = address(0x4eFF9F6DBb11A3D9a18E92E35BD4D54ac4E1533a);
    address USER = address(1);
    address USER2 = address(2);

    uint256 STARTING_AMOUNT = 1_000;

    function setUp() public {
        vm.prank(OWNER);
        joesSwapFactory = new JoesSwapFactory();
    }

    function test_createPool() public {
        ERC20Mock ETH = new ERC20Mock("Ethereum", "ETH");
        ERC20Mock USD = new ERC20Mock("US dollar", "USD");
        vm.prank(OWNER);
        joesSwapFactory.createPool(address(ETH), address(USD));
        joesSwapFactory.getPool(address(ETH), address(USD));
        address pool = joesSwapFactory.getPool(address(ETH), address(USD));
        assert(pool != address(0));
    }


    function test_createPoolByNotOwner() public {
        ERC20Mock ETH = new ERC20Mock("Ethereum", "ETH");
        ERC20Mock USD = new ERC20Mock("US dollar", "USD");
        vm.prank(USER);
        vm.expectRevert();
        joesSwapFactory.createPool(address(ETH), address(USD));
        address pool = joesSwapFactory.getPool(address(ETH), address(USD));
        assertEq(pool, address(0));
    }


}
