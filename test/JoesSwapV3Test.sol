// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {JoesSwapV3} from "../src/JoesSwapV3.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Mock} from "./ERC20Mock.sol";
import {WeirdERC20Mock} from "./WeirdERC20Mock.sol";
import {FlashloanReceiver} from "../src/FlashloanReceiver.sol";

contract JoesSwapV3Test is Test {
    JoesSwapV3 joesSwapV3;
    FlashloanReceiver flashloanReceiver;
    ERC20Mock token0;
    ERC20Mock token1;

    uint256 immutable PRECISION = 1e18;

    address owner = address(0x4eFF9F6DBb11A3D9a18E92E35BD4D54ac4E1533a);
    address owner2 = address(2);

    function setUp() public {
        token0 = new ERC20Mock("Token0", "T0");
        token1 = new ERC20Mock("Token1", "T1");

        uint256 STARTING_AMOUNT = 1_000_000 * PRECISION;

        vm.deal(owner, STARTING_AMOUNT);
        vm.deal(owner2, STARTING_AMOUNT);

        token0.mint(owner, STARTING_AMOUNT);
        token1.mint(owner, STARTING_AMOUNT);

        token0.mint(owner2, STARTING_AMOUNT);
        token1.mint(owner2, STARTING_AMOUNT);

        vm.prank(owner);
        joesSwapV3 = new JoesSwapV3(address(token0), address(token1));

        vm.startPrank(owner);
        token0.approve(address(joesSwapV3), STARTING_AMOUNT);
        token1.approve(address(joesSwapV3), STARTING_AMOUNT);
        vm.stopPrank();

        vm.startPrank(owner2);
        token0.approve(address(joesSwapV3), STARTING_AMOUNT);
        token1.approve(address(joesSwapV3), STARTING_AMOUNT);
        vm.stopPrank();

        uint256 amount0 = 10000 * PRECISION;
        uint256 amount1 = 1000 * PRECISION;
        vm.prank(owner);
        joesSwapV3.setupPoolLiquidity(amount0, amount1);
        console.log("initialized", joesSwapV3.poolInitialized());

        flashloanReceiver = new FlashloanReceiver(address(joesSwapV3));
        token0.mint(address(flashloanReceiver), STARTING_AMOUNT);
        token1.mint(address(flashloanReceiver), STARTING_AMOUNT);
    }

    function test_weirdERC20() public {
        WeirdERC20Mock weirdERC20 = new WeirdERC20Mock("Weird", "W");
        vm.expectRevert();
        joesSwapV3 = new JoesSwapV3(address(weirdERC20), address(token1));
    }

    function test_initializePoolTwice() public {
        uint256 amount0 = 10000 * PRECISION;
        uint256 amount1 = 1000 * PRECISION;

        console.log("initialized", joesSwapV3.poolInitialized());
        console.log("liquidity", joesSwapV3.liquidity());
        vm.prank(owner);
        vm.expectRevert();
        joesSwapV3.setupPoolLiquidity(amount0, amount1);
    }

    function test_addLiquidity() public {
        uint256 amount0 = 500 * PRECISION;
        uint256 reserve0Before = joesSwapV3.reserve0();

        vm.prank(owner);
        joesSwapV3.addLiquidity(amount0);

        assertEq(joesSwapV3.reserve0(), reserve0Before + amount0);
    }

    function test_removeLiquidity() public {
        uint256 liquidityBefore = joesSwapV3.liquidity();

        vm.prank(owner);
        joesSwapV3.removeLiquidity();
        uint256 liquidityAfter = joesSwapV3.liquidity();
        assertGt(liquidityBefore, liquidityAfter);
    }

    function test_swapToken0Amount() public {
        uint256 swapAmount = 1000 * PRECISION;

        vm.prank(owner);
        joesSwapV3.swapToken0Amount(swapAmount, 1100 * PRECISION);

        vm.prank(owner);
        joesSwapV3.removeLiquidity();
    }

    function test_swapToken1Amount_1() public {
        uint256 swapAmount = 10 * PRECISION;

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 123 * PRECISION);

        vm.prank(owner);
        joesSwapV3.removeLiquidity();
    }

    function test_swapToken1Amount_2() public {
        uint256 swapAmount = 333 * PRECISION;

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 10000 * PRECISION);

        vm.prank(owner);
        joesSwapV3.withdrawFees();
    }

    function test_swapToken1Amount_3() public {
        uint256 swapAmount = 100 * PRECISION;
        uint256 amount0 = 10000 * PRECISION;

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 10000 * PRECISION);

        vm.prank(owner2);
        joesSwapV3.addLiquidity(amount0);

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 10000 * PRECISION);

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 10000 * PRECISION);

        vm.prank(owner);
        joesSwapV3.withdrawFees();
        vm.prank(owner2);
        joesSwapV3.withdrawFees();
        vm.prank(owner);
        joesSwapV3.removeLiquidity();

        vm.prank(owner);
        joesSwapV3.swapToken1Amount(swapAmount, 10000 * PRECISION);

        vm.prank(owner2);
        joesSwapV3.withdrawFees();

        vm.prank(owner);
        vm.expectRevert();
        joesSwapV3.withdrawFees();
    }

    function test_withdrawFeesBeforeSwap() public {
        vm.prank(owner);
        vm.expectRevert();
        joesSwapV3.withdrawFees();
    }

    function test_flashloan() public {
        flashloanReceiver.flashloan(300 * PRECISION, address(token0));
        flashloanReceiver.flashloan(100 * PRECISION, address(token1));
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        y = x;
        uint256 z = (x + 1) / 2;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
