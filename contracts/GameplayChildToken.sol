// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./GameplayToken.sol";
contract GameplayChildToken is GameplayToken {

    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

    function initialize(string memory name, string memory symbol, address childChainManagerProxy) external {
        super.initialize(name,symbol);
        _grantRole(DEPOSITOR_ROLE,childChainManagerProxy);
    }

    function deposit(address user, bytes calldata depositData) external onlyRole(DEPOSITOR_ROLE)
    {
        uint256 amount = abi.decode(depositData, (uint256));
        _mint(user, amount);
    }

    function withdraw(uint256 amount) external {
        _burn(_msgSender(), amount);
    }

    function mint(address account, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(amount > 0, "Tokens to be minted should be non-zero");
        _mint(account, amount);
    }

}