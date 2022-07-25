import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("EIPEditorNFT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshopt in every test.
  async function deploy() {
    // Contracts are deployed using the first signer/account by default
    const [ owner ] = await ethers.getSigners();

    const EIPEditorNFT = await ethers.getContractFactory("EIPEditorNFT");
    const eipEditorNft = await Lock.deploy({ value: 0 });

    return { eipEditorNft, owner };
  }
});
