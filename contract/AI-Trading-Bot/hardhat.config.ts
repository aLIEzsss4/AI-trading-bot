import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config();

const ALK_API_KEY = process.env.ALK_API_KEY;
const API_URL_ASEPO = `https://opt-sepolia.g.alchemy.com/v2/${ALK_API_KEY}`;
const SEPOLIA_PRIVATE_KEY = process.env.SEPO_PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: API_URL_ASEPO,
      accounts: [SEPOLIA_PRIVATE_KEY!]
    }
  }
};

export default config;
