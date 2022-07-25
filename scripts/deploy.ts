import { ethers } from "hardhat";

async function main() {
  const EIPEditorNFT = await ethers.getContractFactory("EIPEditorNFT");
  const eipEditorNft = await EIPEditorNFT.deploy({ value: 0 });
  await eipEditorNft.deployed();

  console.log("EIP Editor NFT deployed to", eipEditorNft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
