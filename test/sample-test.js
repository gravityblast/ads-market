const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BN } = require('../lib/utils')

const day = 60 * 60 * 24;

describe("AdsMarket", function() {
  before(async function() {
    const TestERC20 = await ethers.getContractFactory("TestERC20");
    this.token = await TestERC20.deploy();
    await this.token.deployed();

    [this.owner, ...this.accounts] = await ethers.getSigners();
    this.taxPerc = 10_000; // 10%
    this.taxPeriod = 100 * day; // 100 days

    const AdsMarket = await ethers.getContractFactory("AdsMarket", this.owner);
    this.am = await AdsMarket.deploy("Ads Market Test", "AMT", this.taxPerc, this.taxPeriod, this.token.address);
    await this.am.deployed();
  });
});
