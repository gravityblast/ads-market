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

  it("sets the config data from the constructor", async function() {
    expect(await this.am.name()).to.equal("Ads Market Test");
    expect(await this.am.symbol()).to.equal("AMT");
    expect(await this.am.taxPerc()).to.equal(this.taxPerc);
    expect(await this.am.taxPeriod()).to.equal(this.taxPeriod);
    expect(await this.am.token()).to.equal(this.token.address);
    expect(await this.am.owner()).to.equal(this.owner.address);
  });

});
