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


  const contractABI = [{ "type": "constructor", "inputs": [{ "name": "_token", "type": "address", "internalType": "address" }], "stateMutability": "nonpayable" }, { "type": "function", "name": "QUORUM", "inputs": [], "outputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }], "stateMutability": "view" }, { "type": "function", "name": "createProposal", "inputs": [{ "name": "description", "type": "string", "internalType": "string" }, { "name": "_proposalType", "type": "uint8", "internalType": "enum JoesGovernance.ProposalType" }, { "name": "data", "type": "bytes", "internalType": "bytes" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "executeProposal", "inputs": [{ "name": "proposalId", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "getProposal", "inputs": [{ "name": "proposalId", "type": "uint256", "internalType": "uint256" }], "outputs": [{ "name": "", "type": "tuple", "internalType": "struct JoesGovernance.Proposal", "components": [{ "name": "id", "type": "uint256", "internalType": "uint256" }, { "name": "description", "type": "string", "internalType": "string" }, { "name": "proposalType", "type": "uint8", "internalType": "enum JoesGovernance.ProposalType" }, { "name": "voteCount", "type": "uint256", "internalType": "uint256" }, { "name": "executed", "type": "bool", "internalType": "bool" }, { "name": "proposer", "type": "address", "internalType": "address" }, { "name": "deadline", "type": "uint256", "internalType": "uint256" }, { "name": "data", "type": "bytes", "internalType": "bytes" }] }], "stateMutability": "view" }, { "type": "function", "name": "joesSwapFactory", "inputs": [], "outputs": [{ "name": "", "type": "address", "internalType": "contract JoesSwapFactory" }], "stateMutability": "view" }, { "type": "function", "name": "token", "inputs": [], "outputs": [{ "name": "", "type": "address", "internalType": "contract IERC20" }], "stateMutability": "view" }, { "type": "function", "name": "vote", "inputs": [{ "name": "proposalId", "type": "uint256", "internalType": "uint256" }], "outputs": [], "stateMutability": "nonpayable" }, { "type": "function", "name": "voted", "inputs": [{ "name": "", "type": "uint256", "internalType": "uint256" }, { "name": "", "type": "address", "internalType": "address" }], "outputs": [{ "name": "", "type": "bool", "internalType": "bool" }], "stateMutability": "view" }, { "type": "event", "name": "ProposalCreated", "inputs": [{ "name": "id", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "description", "type": "string", "indexed": true, "internalType": "string" }, { "name": "proposer", "type": "address", "indexed": true, "internalType": "address" }], "anonymous": false }, { "type": "event", "name": "Voted", "inputs": [{ "name": "proposalId", "type": "uint256", "indexed": true, "internalType": "uint256" }, { "name": "voter", "type": "address", "indexed": true, "internalType": "address" }], "anonymous": false }]


const contract = new ethers.Contract('0x7100E77832A39125A5C81862166058E164b93b54', contractABI, wallet);

async function createProposal() {
  // The description for the proposal
  const description = "add token pair JGT:JUSDT";

  // Set the ProposalType (e.g., "CREATE_POOL" could be mapped to a uint8)
  const proposalType = 0; // Assuming "CREATE_POOL" corresponds to uint8 0. Update accordingly.

  // Replace with actual deployed token addresses (ETH and USD tokens in your test)
  const JGTAddress = '0x5527b10aCDcE4117EDe752df720070db812dB10E';  // Replace with actual token address
  const JUSDTAddress = '0x7Eba7023307750b5C24f0d5B70caD1d158125E52';  // Replace with actual token address

  // Encode data like `abi.encode(ETH, USD)` in Solidity
  const abiCoder = new ethers.AbiCoder();
  const data = abiCoder.encode(
    ["address", "address"],
    [JGTAddress, JUSDTAddress]
  );

  const tx = await contract.createProposal(description, proposalType, data);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}


async function getProposal(index) {
  const proposal = await contract.getProposal(index);
  console.log("proposal", proposal);
}


async function vote(index) {
  const tx = await contract.vote(index);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}


async function executeProposal(index) {
  const tx = await contract.executeProposal(index);
  console.log("tx", tx);

  const receipt = await tx.wait();

  console.log("Transaction mined:", receipt);
}

async function main() {
  getProposal(1);
//  createProposal();
//  vote(1);
//  executeProposal(1);
}

main();


