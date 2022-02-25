// SPDX-License-Identifier:MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract AdsMarket is ERC721Enumerable {
  using SafeERC20 for IERC20;

  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
  }
}

