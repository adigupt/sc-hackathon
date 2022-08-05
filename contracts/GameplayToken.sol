// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";

contract GameplayToken is UUPSUpgradeable, ERC20BurnableUpgradeable,AccessControlEnumerableUpgradeable{

    function initialize(string memory name, string memory symbol) public initializer {
        __ERC20_init(name, symbol);
        __AccessControlEnumerable_init();
        __UUPSUpgradeable_init();
        __ERC20Burnable_init();
        _grantRole(DEFAULT_ADMIN_ROLE,_msgSender());
    }


    //Used for uups proxies.
    function _authorizeUpgrade(address) internal override onlyRole(DEFAULT_ADMIN_ROLE) {}
}
