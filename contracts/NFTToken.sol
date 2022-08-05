// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./RoyaltyStandard.sol";

contract NFTToken is ERC721, ERC721Enumerable, AccessControl, RoyaltyStandard {
    string private _tokenBaseUri;
    uint256 internal _tokenIdCounter;

    constructor(string memory name, string memory symbol,string memory contractUri_) ERC721(name, symbol) RoyaltyStandard(contractUri_) {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function setBaseURI(string memory tokenBaseUri) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _tokenBaseUri = tokenBaseUri;
    }

    function _baseURI() internal view override returns (string memory) {
        if (bytes(_tokenBaseUri).length > 0) {
            return _tokenBaseUri;
        }
        return super._baseURI();
    }

    function setRoyalty(address receiver, uint96 feeNumerator) external onlyRole(DEFAULT_ADMIN_ROLE) {
        updateRoyaltyInfo(receiver, feeNumerator);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) virtual public view override(AccessControl, ERC721, ERC721Enumerable, RoyaltyStandard) returns (bool){
        return super.supportsInterface(interfaceId);
    }
}