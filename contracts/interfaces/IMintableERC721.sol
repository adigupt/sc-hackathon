// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IMintableERC721{
    function safeMint(address to, uint256 tokenId) external;
}