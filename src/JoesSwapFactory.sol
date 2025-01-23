pragma solidity ^0.8.0;

import {JoesSwapV3} from "./JoesSwapV3.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract JoesSwapFactory is Ownable {
    mapping(address => mapping(address => address)) public getPool;
    address[] public pools;
    event CreatedPool(address tokenA, address tokenB, address pool);

    constructor() Ownable(msg.sender) {}

    function createPool(
        address tokenA,
        address tokenB
    ) external returns (address pool) {
        require(tokenA != address(0), "Invalid address fot tokenA.");
        require(tokenB != address(0), "Invalid address for tokenB.");
        require(tokenA != tokenB, "Identical tokens.");
        require(getPool[tokenA][tokenB] == address(0), "Pair exists.");

        pool = address(new JoesSwapV3(tokenA, tokenB));
        getPool[tokenA][tokenB] = address(pool);
        pools.push(pool);
        emit CreatedPool(tokenA, tokenB, pool);
    }

    // @FIXME: add changeFee logic and add it in JoesSwapV3 so that the already collected
    // fee is adjusted, not that all of a sudden they get much more than they are supposed to
    function changeFee(uint256 fee) external {
         
    }
}
