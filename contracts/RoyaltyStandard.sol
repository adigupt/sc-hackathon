// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

abstract contract RoyaltyStandard is IERC2981, ERC165{
    string private _contractUri;
    struct RoyaltyInfo {
        address receiver;
        uint96 royaltyFraction;
    }

    RoyaltyInfo private _royaltyInfo;
    uint256 constant private FEE_DENOMINATOR = 10000;
    event RoyaltyInfoUpdated(address reciever, uint96 feeNumerator);

    constructor(string memory contractUri_){
        _contractUri = contractUri_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function updateRoyaltyInfo(address receiver, uint96 feeNumerator) internal {
        require(feeNumerator <= FEE_DENOMINATOR, "ERC2981: royalty fee will exceed salePrice");
        require(receiver != address(0), "ERC2981: Invalid address");
        _royaltyInfo = RoyaltyInfo(receiver,feeNumerator);
        emit RoyaltyInfoUpdated(receiver,feeNumerator);
    }

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override virtual returns (address, uint256) {
        RoyaltyInfo memory royalty = _royaltyInfo;
        uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / FEE_DENOMINATOR;
        return (royalty.receiver, royaltyAmount);
    }

    function contractURI() public view returns (string memory) {
        return _contractUri;
    }
}