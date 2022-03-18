// SPDX-License-Identifier:MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AdsMarket is Ownable, ERC721Enumerable {
  using SafeERC20 for IERC20;

  // tax percentage from 0 to 100_000 (10_000 == 10%)
  uint256 public taxPerc;
  // tax duration
  uint256 public taxPeriod;
  address public token;

  struct Item {
    address user;
    uint256 timestamp;
    uint256 taxPerc;
    uint256 taxPeriod;
    uint256 bid;
    bytes32 data;
  }

  // tokenId => description
  mapping(uint256 => string) public tokenDescriptions;

  // tokenId => Item
  mapping(uint256 => Item) public tokenItems;

  constructor(string memory _name, string memory _symbol, uint256 _taxPerc, uint256 _taxPeriod, address _token) ERC721(_name, _symbol) {
    token = _token;
    setConfig(_taxPerc, _taxPeriod);
  }

  function setConfig(uint256 _taxPerc, uint256 _taxPeriod) public onlyOwner {
    require(_taxPerc >= 0 && _taxPerc <= 100_000, "taxPerc must be between 0 and 100_000");
    require(_taxPeriod > 0, "taxPeriod must be greater than 0");
    taxPerc = _taxPerc;
    taxPeriod = _taxPeriod;
  }

  function mint(string memory description) public onlyOwner {
    uint256 id = totalSupply();
    _mint(msg.sender, id);
    tokenDescriptions[id] = description;
  }

  function buy(uint256 tokenID, bytes32 data, uint256 bid) public {
    uint256 prevTimestamp = tokenItems[tokenID].timestamp;
    uint256 prevTaxPerc = tokenItems[tokenID].taxPerc;
    uint256 prevTaxDuration = tokenItems[tokenID].taxPeriod;
    uint256 prevBid = tokenItems[tokenID].bid;
    address prevUser = tokenItems[tokenID].user;

    require(bid > prevBid, "bid must be higher than the current one");

    // new user sends prevBid to prevUser
    IERC20(token).safeTransferFrom(msg.sender, prevUser, prevBid);
    // new owner sends 1 year tax amount to this contract
    uint256 taxAmount = bid * taxPerc / 100;
    IERC20(token).safeTransferFrom(msg.sender, address(this), taxAmount);

    tokenItems[tokenID] = Item(
      msg.sender,
      block.timestamp,
      taxPerc,
      taxPeriod,
      bid,
      data
    );

    // transfer erc20 tokens back to prev owner
    uint256 timePassed = block.timestamp - prevTimestamp;
    uint256 prevTaxAmount = prevBid * prevTaxPerc / 100;

    uint256 amountToPay = prevTaxAmount * timePassed / prevTaxDuration;
    uint256 amountToGivBack = prevTaxAmount - amountToPay;
    if (amountToGivBack > 0) {
      IERC20(token).safeTransfer(prevUser, amountToGivBack);
    }
  }

  // withdraw bid
  // reset when time expires
}
