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

  it("normal users cannot call setConfig", async function() {
    await expect(
      this.am.connect(this.accounts[0]).setConfig(1, 1)
    ).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("owner can call setConfig", async function() {
    expect(await this.am.taxPerc()).to.equal(this.taxPerc);
    expect(await this.am.taxPeriod()).to.equal(this.taxPeriod);

    await this.am.connect(this.owner).setConfig(77, 88);

    expect(await this.am.taxPerc()).to.not.equal(this.taxPerc);
    expect(await this.am.taxPeriod()).to.not.equal(this.taxPeriod);

    expect(await this.am.taxPerc()).to.equal(77);
    expect(await this.am.taxPeriod()).to.equal(88);
  });

  it("normal users cannot mint", async function() {
    await expect(
      this.am.connect(this.accounts[0]).mint("hello world")
    ).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("owner can mint", async function() {
    expect(await this.am.totalSupply()).to.equal(0);

    await this.am.connect(this.owner).mint("FIRST");

    expect(await this.am.totalSupply()).to.equal(1);
    expect(await this.am.ownerOf(0)).to.equal(this.owner.address);
    expect(await this.am.tokenDescriptions(0)).to.equal("FIRST");

    // const item = await this.am.tokenItems(0);
    // expect();
  });
});
