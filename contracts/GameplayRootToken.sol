// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./GameplayToken.sol";

contract GameplayRootToken is GameplayToken{

    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");

    function initialize(string memory name,string memory symbol,address mintableERC20Proxy) external{
        super.initialize(name, symbol);
        _grantRole(PREDICATE_ROLE,mintableERC20Proxy);
    }


    function mint(address user, uint256 amount) external  onlyRole(PREDICATE_ROLE) {
        _mint(user, amount);
    }

}