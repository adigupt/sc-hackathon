pragma solidity 0.8.7;

import "./Token.sol";

contract RootToken is Token {

    function mint(address account, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= cap, "ERC20Capped: cap exceeded");
        _mint(account, amount);
    }

}
