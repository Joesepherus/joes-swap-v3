const { Alchemy, Network, Wallet, Utils } = require("alchemy-sdk");
require("dotenv").config();
const ethers = require("ethers");

const { API_KEY, PRIVATE_KEY } = process.env;

const settings = {
  apiKey: API_KEY,
  network: Network.ETH_SEPOLIA,
};
const alchemy = new Alchemy(settings);

const provider = new ethers.AlchemyProvider('sepolia', API_KEY);

let wallet = new ethers.Wallet(PRIVATE_KEY, provider);


const contractABI = [{ "type": "constructor", "inputs": [{ "name": "_token0", "type": "address", "internalType": "address" }, { "name": "_token1", "type": "address", "internalType": "address" }], "stateMutability": "nonpayable" }, { "type": "function", "name": "addLiquidity", "inputs": [{ "name": "amount0", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "flashloan", "inputs": [{ "name": "amount", "type": "uint256", "internalType": "uint256" }, { "name": "token", "type": "address", "internalType": "address" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "liquidity", "inputs": [], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "lpBalances", "inputs": [{ "name": "", "type": "address", "internalType": "address" }], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "poolInitialized", "inputs": [], "outputs": [{ "name": "", "type": "bool", "internalType": "bool" }], "stateMutability": "view" }, { "type": "function", "name": "removeLiquidity", "inputs": [], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "reserve0", "inputs": [], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "reserve1", "inputs": [], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "setupPoolLiquidity", "inputs": [{ "name": "amount0", "type": "uint256", "internalType": "uint256" }, { "name": "amount1", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "swapToken0Amount", "inputs": [{ "name": "amountIn", "type": "uint256", "internalType": "uint256" }, { "name": "amountInMax", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "swapToken1Amount", "inputs": [{ "name": "amountIn", "type": "uint256", "internalType": "uint256" }, { "name": "amountInMax", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "token0", "inputs": [], "outputs": [{ "name": "", "type": "address", "internalType": "contract IERC20" }], "stateMutability": "view" }, { "type": "function", "name": "token1", "inputs": [], "outputs": [{ "name": "", "type": "address", "internalType": "contract IERC20" }], "stateMutability": "view" }, { "type": "function", "name": "userEntryFeePerLiquidityUnitToken0", "inputs": [{ "name": "", "type": "address", "internalType": "address" }], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "userEntryFeePerLiquidityUnitToken1", "inputs": [{ "name": "", "type": "address", "internalType": "address" }], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "withdrawFees", "inputs": [], "outputs": [], "stateMutability": "nonpayable" }, { "type": "event", "name": "AddLiquidity", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "amount0", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "amount1", "type": "uint256", "indexed": true, "internalType": "uint256" }], "anonymous": false }, { "type": "event", "name": "Flashloan", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "amount", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "fee", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "token", "type": "address", "indexed": false, "internalType": "address" }], "anonymous": false }, { "type": "event", "name": "PoolInitialized", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "amount0", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "amount1", "type": "uint256", "indexed": true, "internalType": "uint256" }], "anonymous": false }, { "type": "event", "name": "RemoveLiquidity", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "liquidityToRemove", "type": "uint256", "indexed": false, "internalType": "uint256" }, { "name": "amount0", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "amount1", "type": "uint256", "indexed": true, "internalType": "uint256" }], "anonymous": false }, { "type": "event", "name": "Swap", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "amount0", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "amount1", "type": "uint256", "indexed": true, "internalType": "uint256" }], "anonymous": false }, { "type": "event", "name": "WithdrawFees", "inputs": [{ "name": "sender", "type": "address", "indexed": true, "internalType": "address" }, { "name": "feeAmount", "type": "uint256", "indexed": true, "internalType": "uint256" }], "anonymous": false }, { "type": "error", "name": "InsufficentFeesBalance", "inputs": [] }, { "type": "error", "name": "InsufficentLiquidity", "inputs": [] }, { "type": "error", "name": "PoolAlreadyInitialized", "inputs": [] }, { "type": "error", "name": "PoolNotInitialized", "inputs": [] }, { "type": "error", "name": "ReentrancyGuardReentrantCall", "inputs": [] }, { "type": "error", "name": "SafeERC20FailedOperation", "inputs": [{ "name": "token", "type": "address", "internalType": "address" }] }]



const contract = new ethers.Contract('0x59f3562cFA45A8C4DA7343BF70a8BB5F6EE58a67', contractABI, wallet);


async function addLiquidity() {
  const tx = await contract.addLiquidity(100000000000);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}


async function swapToken0Amount() {
  const amount0 = BigInt(50) * BigInt(10 ** 18);
  const amount0Max = BigInt(1230) * BigInt(10 ** 18);
  const tx = await contract.swapToken0Amount(amount0, amount0Max);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}

async function swapToken1Amount() {
  const amount0 = BigInt(1000) * BigInt(10 ** 18);
  const amount0Max = BigInt(10000) * BigInt(10 ** 18);
  const tx = await contract.swapToken1Amount(amount0, amount0Max);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}

async function addLiquidity() {
  const amount0 = BigInt(1000) * BigInt(10 ** 18);
  const tx = await contract.addLiquidity(amount0);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}

async function removeLiquidity() {
  const tx = await contract.removeLiquidity();
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}

async function setupPoolLiquidity() {
  const amount0 = BigInt(10000) * BigInt(10 ** 18);
  const amount1 = BigInt(5000) * BigInt(10 ** 18);
  const tx = await contract.setupPoolLiquidity(amount0, amount1);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}


async function getReserves() {
  const reserve0 = await contract.reserve0();
  const reserve1 = await contract.reserve1();
  console.log("reserve0", reserve0);
  console.log("reserve1", reserve1);
}

async function main() {
//   getReserves();
//  setupPoolLiquidity();
//    addLiquidity();
//    swapToken0Amount();
      removeLiquidity();
}

main();



