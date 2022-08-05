// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./Token.sol";

contract ChildToken is Token {

    address private _childChainManagerProxy;

    function initialize(string memory name, string memory symbol, uint256 cap_,address childChainManagerProxy) external {
        super.initialize(name,symbol,cap_);
        _childChainManagerProxy = childChainManagerProxy;
    }

    function updateChildChainManager(address newChildChainManagerProxy) public onlyOwner {
        require(newChildChainManagerProxy != address(0), "Bad childChainManager proxy");
        _childChainManagerProxy = newChildChainManagerProxy;
    }

    function deposit(address user, bytes calldata depositData)
    external
    {
        require(_childChainManagerProxy == _msgSender(), "Caller is not the depositor");
        uint256 amount = abi.decode(depositData, (uint256));
        _mint(user, amount);
    }

    function withdraw(uint256 amount) external {
        _burn(_msgSender(), amount);
    }

}
