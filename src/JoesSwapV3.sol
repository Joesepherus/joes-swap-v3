// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IFlashloanReceiver} from "./IFlashloanReceiver.sol";

/**
 * @title JoesSwapV3
 * @author Joesepherus
 * @dev Decentralized token swapping contract with liquidity provision and fee management.
 */
contract JoesSwapV3 is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public liquidity;
    uint256 accumulatedFeePerLiquidityUnitToken0;
    uint256 accumulatedFeePerLiquidityUnitToken1;
    bool public poolInitialized = false;

    mapping(address => uint256) public lpBalances;
    mapping(address => uint256) public userEntryFeePerLiquidityUnitToken0;
    mapping(address => uint256) public userEntryFeePerLiquidityUnitToken1;

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS 
    //////////////////////////////////////////////////////////////*/
    uint256 immutable PRECISION = 1e18;
    uint256 immutable FEE = 3;
    uint256 immutable ONE_HUNDRED = 100;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event PoolInitialized(
        address indexed sender,
        uint256 indexed amount0,
        uint256 indexed amount1
    );
    event AddLiquidity(
        address indexed sender,
        uint256 indexed amount0,
        uint256 indexed amount1
    );
    event RemoveLiquidity(
        address indexed sender,
        uint256 liquidityToRemove,
        uint256 indexed amount0,
        uint256 indexed amount1
    );
    event Swap(
        address indexed sender,
        uint256 indexed amount0,
        uint256 indexed amount1
    );
    event WithdrawFees(address indexed sender, uint256 indexed feeAmount);
    event Flashloan(
        address indexed sender,
        uint256 indexed amount,
        uint256 indexed fee,
        address token
    );

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error InsufficentFeesBalance();
    error InsufficentLiquidity();
    error PoolAlreadyInitialized();
    error PoolNotInitialized();

    constructor(address _token0, address _token1) Ownable(msg.sender) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes the pool with the provided liquidity amounts of token0 and token1.
     * @dev This function can be called by anyone but only once.
     *      It transfers the specified amounts of token0 and token1 from the caller to the contract,
     *      calculates the new liquidity, updates reserves, and records the user's entry per liquidity unit.
     *      Emits a `PoolInitialized` event upon successful execution.
     * @param amount0 The amount of token0 to add to the pool.
     * @param amount1 The amount of token1 to add to the pool.
     * @custom:revert PoolAlreadyInitialized if the pool has already been initialized.
     */
    function setupPoolLiquidity(
        uint256 amount0,
        uint256 amount1
    ) external {
        if (poolInitialized) revert PoolAlreadyInitialized();
        uint256 amount0Scaled = amount0 * PRECISION;
        uint256 amount1Scaled = amount1 * PRECISION;
        uint256 newLiquidity = sqrt(amount0Scaled * amount1Scaled);

        reserve0 += amount0;
        reserve1 += amount1;

        userEntryFeePerLiquidityUnitToken0[
            msg.sender
        ] = accumulatedFeePerLiquidityUnitToken0;
        userEntryFeePerLiquidityUnitToken1[
            msg.sender
        ] = accumulatedFeePerLiquidityUnitToken1;
        liquidity += newLiquidity;
        lpBalances[msg.sender] += newLiquidity;
        poolInitialized = true;

        emit PoolInitialized(msg.sender, amount0, amount1);

        token0.safeTransferFrom(msg.sender, address(this), amount0);
        token1.safeTransferFrom(msg.sender, address(this), amount1);
    }

    /**
     * @notice Adds liquidity to the pool with the provided amount of token0 and token1 is then calculated.
     * @dev The function scales up the amount of token0 by PRECISION.
     *      It calls getAmountOut to get the correct amount of token1 in proportion to token0.
     *      Calculates the liquidity, updates reserves, handles transfers from user to the pool.
     *      Sets up liquidity balance and entry point for the caller.
     *      Emits a `AddLiquidity` event upon successful execution.
     * @param amount0 The amount of token0 to add to the pool.
     * @custom:modifier nonReentrant Function cannot be re-entered
     */
    function addLiquidity(uint256 amount0) external nonReentrant {
        if (!poolInitialized) revert PoolNotInitialized();

        uint256 amount0Scaled = amount0 * PRECISION;

        uint256 amount1Scaled = getAmountOut(amount0Scaled);
        uint256 amount1 = amount1Scaled / PRECISION;

        uint256 newLiquidity = sqrt(amount0Scaled * amount1Scaled);

        reserve0 += amount0;
        reserve1 += amount1;

        userEntryFeePerLiquidityUnitToken0[
            msg.sender
        ] = accumulatedFeePerLiquidityUnitToken0;
        userEntryFeePerLiquidityUnitToken1[
            msg.sender
        ] = accumulatedFeePerLiquidityUnitToken1;
        liquidity += newLiquidity;
        lpBalances[msg.sender] += newLiquidity;

        emit AddLiquidity(msg.sender, amount0, amount1);

        token0.safeTransferFrom(msg.sender, address(this), amount0);
        token1.safeTransferFrom(msg.sender, address(this), amount1);
    }

    /**
     * @notice Removes all liquidity the caller has in the pool.
     * @dev The functions gets the correct amount of token0 and token1 to send to the user.
     *      Handles transfers from the pool to the caller.
     *      Updates reserves, liquidity of the pool.
     *      Updates lp balance of the caller.
     *      Emits a `RemoveLiquidity` event upon successful execution.
     * @custom:modifier nonReentrant Function cannot be re-entered.
     * @custom:revert InsufficentLiquidity if the caller has no liquidity in the pool.
     */
    function removeLiquidity() external nonReentrant {
        uint256 liquidityToRemove = lpBalances[msg.sender];
        if (liquidityToRemove <= 0) {
            revert InsufficentLiquidity();
        }
        uint256 amount0 = (reserve0 * liquidityToRemove) / liquidity;
        uint256 amount1 = (reserve1 * liquidityToRemove) / liquidity;

        reserve0 -= amount0;
        reserve1 -= amount1;

        liquidity -= liquidityToRemove;
        lpBalances[msg.sender] -= liquidityToRemove;

        emit RemoveLiquidity(msg.sender, liquidityToRemove, amount0, amount1);

        token0.safeTransfer(msg.sender, amount0);
        token1.safeTransfer(msg.sender, amount1);
    }

    /**
     * @notice Swaps amount of token0 for an amount of token1
     * @dev The function calculates the proper amount of token1 and swaps it with
     *      the caller for his provided amount of token0.
     *      It calls getAmountOut to get the correct amount of token1 in proportion to token0.
     *      Rounds this result down and calculates the correct amout of token0 to be traded for the amount.
     *      This way the swap is fair and there is minimal slippage.
     *      Calculates the fee amount and updates the fee pool.
     *      Transfers amount token0 to the pool and transfers amount token1 to the caller.
     *      Updates reserves of the pool.
     *      Emits a `Swap` event upon successful execution.
     * @param amountIn The amount of token0 to add to the pool.
     * @param amountInMax Maximum amount of token0 to send to the pool.
     * @custom:modifier nonReentrant Function cannot be re-entered
     * @custom:revert "Invalid output amount" if the calculated amount of token1 is less than 0
     * @custom:revert "Slippage free amountIn too big" if the calculated amount of token0 is more than amountInMax
     */
    function swapToken0Amount(uint256 amountIn, uint256 amountInMax) external nonReentrant {
        if (!poolInitialized) revert PoolNotInitialized();
        uint256 scaledAmountIn = amountIn * PRECISION;

        uint256 amountOutScaled = getAmountOut(scaledAmountIn);
        if (amountOutScaled < PRECISION) revert("Amount out too small");
        uint256 amountOutRounded = roundDownToNearestWhole(amountOutScaled);
        uint256 amountOut = amountOutRounded / PRECISION;

        uint256 amountInCorrect = getAmountIn(amountOutRounded);

        uint256 feeAmount = (amountInCorrect * FEE) / ONE_HUNDRED;
        uint256 amountInAfterFee = amountInCorrect + feeAmount;

        uint256 amountInRouded = roundUpToNearestWhole(amountInAfterFee);
        uint256 amountInSlippageFree = amountInRouded / PRECISION;

        if(amountInSlippageFree > amountInMax) revert("Slippage free amountIn too big");
        if (amountOut <= 0) revert("Invalid output amount");

        accumulatedFeePerLiquidityUnitToken0 +=
            (feeAmount * PRECISION) /
            liquidity;

        reserve0 += scaledAmountIn / PRECISION;
        reserve1 -= amountOut;

        emit Swap(msg.sender, amountInSlippageFree, amountOut);

        token0.safeTransferFrom(
            msg.sender,
            address(this),
            amountInSlippageFree
        );
        token1.safeTransfer(msg.sender, amountOut);
    }

    /**
     * @notice Swaps amount of token1 for an amount of token0
     * @dev The function calculates the proper amount of token0 and swaps it with
     *      the caller for his provided amount of token1.
     *      It calls getAmountIn to get the correct amount of token0 in proportion to token1.
     *      Rounds this result down and calculates the correct amout of token1 to be traded for the amount.
     *      This way the swap is fair and there is minimal slippage.
     *      Calculates the fee amount and updates the fee pool.
     *      Transfers amount token1 to the pool and transfers amount token0 to the caller.
     *      Updates reserves of the pool.
     *      Emits a `Swap` event upon successful execution.
     * @param amountIn The amount of token1 to add to the pool.
     * @param amountInMax Maximum amount of token1 to send to the pool.
     * @custom:modifier nonReentrant Function cannot be re-entered
     * @custom:revert "Invalid output amount" if the calculated amount of token1 is less than 0
     * @custom:revert "Slippage free amountIn too big" if the calculated amount of token1 is more than amountInMax
     */
    function swapToken1Amount(
        uint256 amountIn,
        uint256 amountInMax
    ) external nonReentrant {
        if (!poolInitialized) revert PoolNotInitialized();
        uint256 scaledAmountIn = amountIn * PRECISION;

        uint256 amountOutScaled = getAmountIn(scaledAmountIn);
        if (amountOutScaled < PRECISION) revert("Amount out too small");
        uint256 amountOutRounded = roundDownToNearestWhole(amountOutScaled);
        uint256 amountOut = amountOutRounded / PRECISION;

        uint256 amountInCorrect = getAmountOut(amountOutRounded);

        uint256 feeAmount = (amountInCorrect * FEE) / ONE_HUNDRED;
        uint256 amountInAfterFee = amountInCorrect + feeAmount;

        uint256 amountInRouded = roundUpToNearestWhole(amountInAfterFee);
        uint256 amountInSlippageFree = amountInRouded / PRECISION;

        if(amountInSlippageFree > amountInMax) revert("Slippage free amountIn too big");
        if (amountOut <= 0) revert("Invalid output amount");

        accumulatedFeePerLiquidityUnitToken1 +=
            (feeAmount * PRECISION) /
            liquidity;

        reserve1 += scaledAmountIn / PRECISION;
        reserve0 -= amountOut;

        emit Swap(msg.sender, amountInSlippageFree, amountOut);

        token1.safeTransferFrom(
            msg.sender,
            address(this),
            amountInSlippageFree
        );
        token0.safeTransfer(msg.sender, amountOut);
    }

    /**
     * @notice Withdraws collected fees of the caller
     * @dev The function calculates the callers share of the fee pool and
     *      transfers the fees from the pool to the caller.
     *      Updates the liquidity entry point for the the caller so he can't double spend.
     *      Emits a `WithdrawFees` event upon successful execution.
     * @custom:modifier nonReentrant Function cannot be re-entered
     * @custom:revert InsufficentFeesBalance if the calculated fee share is less than 0
     */
    function withdrawFees() external nonReentrant {
        uint256 liquidityToRemove = lpBalances[msg.sender];

        uint256 feeShareScaledToken0 = ((accumulatedFeePerLiquidityUnitToken0 -
            userEntryFeePerLiquidityUnitToken0[msg.sender]) *
            liquidityToRemove) / PRECISION;
        uint256 feeShareToken0 = feeShareScaledToken0 / PRECISION;

        uint256 feeShareScaledToken1 = ((accumulatedFeePerLiquidityUnitToken1 -
            userEntryFeePerLiquidityUnitToken1[msg.sender]) *
            liquidityToRemove) / PRECISION;
        uint256 feeShareToken1 = feeShareScaledToken1 / PRECISION;

        if (feeShareToken0 <= 0 && feeShareToken1 <= 0) {
            revert InsufficentFeesBalance();
        }

        if (feeShareToken0 > 0) {
            userEntryFeePerLiquidityUnitToken0[
                msg.sender
            ] = accumulatedFeePerLiquidityUnitToken0;
            emit WithdrawFees(msg.sender, feeShareToken0);
            token0.safeTransfer(msg.sender, feeShareToken0);
        }

        if (feeShareToken1 > 0) {
            userEntryFeePerLiquidityUnitToken1[
                msg.sender
            ] = accumulatedFeePerLiquidityUnitToken1;

            emit WithdrawFees(msg.sender, feeShareToken0);

            token1.safeTransfer(msg.sender, feeShareToken1);
        }
    }

    /**
     * @notice Calls _executeFlashloan with the correct token.
     * @dev The function checks if the amount is greater than zero and validates the token address.
     *      If both checks pass, it calls the internal function `_executeFlashloan` with the correct token.
     *
     * @param amount The amount of tokens to be loaned.
     * @param token The token address to be used for the flash loan. It must be either `token0` or `token1`.
     *
     * @custom:modifier nonReentrant Ensures the function cannot be re-entered.
     * @custom:revert "Amount has to be more than zero." if the amount is less than or equal to zero.
     * @custom:revert "Invalid token address." if the token is neither `token0` nor `token1`.
     */
    function flashloan(uint256 amount, address token) external nonReentrant {
        require(amount > 0, "Amount has to be more than zero");
        if (token == address(token0)) {
            _executeFlashLoan(amount, token0, reserve0);
        } else if (token == address(token1)) {
            _executeFlashLoan(amount, token1, reserve1);
        } else {
            revert("Invalid token address");
        }
    }

    /**
     * @notice Flash loans a specified amount of tokens to the caller.
     * @dev The function checks if the requested amount is less than the protocol's token reserve.
     *      If the check passes, it sends the requested amount to the caller and triggers the
     *      `flashloan_receive` function on the caller's contract.
     *      Once the `flashloan_receive` function is complete, the caller is expected to repay the loan 
     *      amount plus the fee. If the loan is not repaid as expected, the transaction will revert. 
     *      On successful repayment, a `Flashloan` event is emitted.
     *
     * @param amount The amount of tokens to be loaned to the caller.
     * @param token The token that will be loaned to the caller.
     * @param reserve The protocol's reserve of the token.
     *
     * @custom:revert "Not enough funds in the pool to loan out." if the requested amount exceeds
     *                the protocol's token reserve.
     * @custom:revert "You need to pay back the loan and the fee." if the loan amount plus fee 
     *                is not repaid by the caller.
     * 
     * Emits a `Flashloan` event upon successful execution.
     */
    function _executeFlashLoan(
        uint256 amount,
        IERC20 token,
        uint256 reserve
    ) internal {
        require(amount < reserve, "Not enough funds in the pool to loan out.");
        token.safeTransfer(msg.sender, amount);
        IFlashloanReceiver flashloanReceiver = IFlashloanReceiver(msg.sender);

        flashloanReceiver.flashloan_receive(amount, address(token));

        uint256 fee = (amount * FEE) / ONE_HUNDRED;
        uint256 balanceAfter = token.balanceOf(address(this));

        if (balanceAfter < reserve + fee) {
            revert("You need to pay back the loan and the fee.");
        }
        emit Flashloan(msg.sender, amount, fee, address(token));
    }

    /**
     * @notice Gets amount of token1 compared to amount token0
     * @param amountIn The amount of token0
     * @dev The function calculates and returns the token1 compared to token0 amount
     */
    function getAmountOut(uint256 amountIn) internal view returns (uint256) {
        uint256 k = reserve0 * PRECISION * reserve1 * PRECISION;
        uint256 newReserve0 = reserve0 * PRECISION + amountIn;
        uint256 newReserve1 = k / newReserve0;

        return reserve1 * PRECISION - newReserve1;
    }

    /**
     * @notice Gets amount of token0 compared to amount token1
     * @dev The function calculates and returns the token0 compared to token1 amount
     * @param amountOut The amount of token1
     */
    function getAmountIn(uint256 amountOut) internal view returns (uint256) {
        uint256 k = reserve0 * PRECISION * reserve1 * PRECISION;
        uint256 newReserve1 = reserve1 * PRECISION - amountOut;
        uint256 newReserve0 = k / newReserve1;

        return newReserve0 - reserve0 * PRECISION;
    }

    /**
     * @notice Helper function for rounding up numbers
     * @dev The function rounds up the provided number and returns it
     * @param value The amount of token0
     */
    function roundUpToNearestWhole(
        uint256 value
    ) internal pure returns (uint256) {
        // If there's any remainder when dividing by PRECISION, round up
        if (value % PRECISION != 0) {
            return ((value / PRECISION) + 1) * PRECISION;
        }
        return value;
    }

    /**
     * @notice Helper function for rounding up numbers
     * @dev The function rounds down the provided number and returns it
     * @param value The amount of token0
     */
    function roundDownToNearestWhole(
        uint256 value
    ) internal pure returns (uint256) {
        // Divide and multiply to get the rounded down value
        return (value / PRECISION) * PRECISION;
    }

    /**
     * @notice Helper function for calculating the square root of a number
     * @dev The function rounds up the provided number and returns it
     * @param x The number to calculate the square root for
     */
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        y = x;
        uint256 z = (x + 1) / 2;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
