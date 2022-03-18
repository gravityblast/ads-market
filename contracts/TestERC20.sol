//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
  constructor() ERC20("Test Token", "TEST") {
    _mint(msg.sender, 100_000 * (10 ** 18));
  }

  function mint() public {
    _mint(msg.sender, 1000 * (10 ** 18));
  }
}
