import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
// reference: https://docs.uniswap.org/contracts/v3/reference/deployments/optimism-deployments

const BotSwapModule = buildModule("BotSwap", (m) => {

  const swap = m.contract("BotSwap", ['0x94cC0AaC535CCDB3C01d6787D6413C739ae12bc4']);

  return { swap };
});

export default BotSwapModule;
