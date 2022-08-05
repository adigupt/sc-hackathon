// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
/// @title Interface for WMATIC
interface IWMATIC is IERC20 {
    /// @notice Deposit matic to get wrapped matic
    function deposit() external payable;

    /// @notice Withdraw wrapped matic to get matic
    function withdraw(uint256) external;
}