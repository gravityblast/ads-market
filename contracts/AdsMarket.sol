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
}

