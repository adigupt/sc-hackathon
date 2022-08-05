// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// This token will be used to deploy on Ethereum
contract Token is ERC20VotesUpgradeable, OwnableUpgradeable, UUPSUpgradeable {

    uint256 public cap;
    /**
      * Sets the value of {name}  {symbol}for the token.
      */
    function initialize(string memory name, string memory symbol, uint256 cap_) public initializer {
        __ERC20_init(name, symbol);
        __ERC20Permit_init(name);
        __Ownable_init();
        __UUPSUpgradeable_init();
        cap = cap_;
    }

    function renounceOwnership() public override view onlyOwner {
        revert("can't renounceOwnership here");
    }

    //Used for uups proxies.
    function _authorizeUpgrade(address) internal override onlyOwner {}

}
