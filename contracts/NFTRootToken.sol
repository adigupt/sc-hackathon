// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./NFTToken.sol";

contract NFTRootToken is NFTToken {

    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");

    constructor (string memory name, string memory symbol, string memory contractUri_, address mintableERC721Proxy) NFTToken(name,symbol,contractUri_) {
        _grantRole(PREDICATE_ROLE,mintableERC721Proxy);
    }

    /**
 * @dev See {IMintableERC721-mint}.
     */
    function mint(address user, uint256 tokenId) external  onlyRole(PREDICATE_ROLE) {
        _mint(user, tokenId);
    }
    /**
     * @dev See {IMintableERC721-mint}.
     *
     * If you're attempting to bring metadata associated with token
     * from L2 to L1, you must implement this method
     */
    function mint(address user, uint256 tokenId, bytes calldata metaData) external onlyRole(PREDICATE_ROLE) {
        _mint(user, tokenId);
    }

    function exists(uint256 tokenId) external view  returns (bool) {
        return _exists(tokenId);
    }
}