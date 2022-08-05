// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import './NFTToken.sol';
contract NFTChildMintableToken is NFTToken {
    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");
    bytes32 public constant TRANSACTOR_ROLE = keccak256("TRANSACTOR_ROLE");
    uint256 public constant BATCH_LIMIT = 20;
    uint256 public nftPrice;
    address payable public treasury;
    event WithdrawnBatch(address indexed user, uint256[] tokenIds);
    event NftMinted(address indexed to, uint256 indexed tokenId, string indexed indexedInternalNftId, string internalNftId);

    constructor(string memory name, string memory symbol, string memory contractUri_, address childChainManagerProxy, uint256 initialPrice, address _treasury) NFTToken(name,symbol,contractUri_) {
        require(_treasury != address(0), "The treasury must be a valid address");
        require(initialPrice > 0, "Nft price should be non zero");
        _grantRole(DEPOSITOR_ROLE,childChainManagerProxy);
        nftPrice = initialPrice;
        treasury = payable(_treasury);
    }

    function deposit(address user, bytes calldata depositData) external onlyRole(DEPOSITOR_ROLE) {
        // deposit single
        if (depositData.length == 32) {
            uint256 tokenId = abi.decode(depositData, (uint256));
            _mint(user, tokenId);
            // deposit batch
        } else {
            uint256[] memory tokenIds = abi.decode(depositData, (uint256[]));
            uint256 length = tokenIds.length;
            for (uint256 i; i < length; i++) {
                _mint(user, tokenIds[i]);
            }
        }
    }

    function withdraw(uint256 tokenId) external {
        require(_msgSender() == ownerOf(tokenId), "ChildMintableERC721: INVALID_TOKEN_OWNER");
        _burn(tokenId);
    }

    function withdrawBatch(uint256[] calldata tokenIds) external {
        uint256 length = tokenIds.length;
        require(length <= BATCH_LIMIT, "ChildMintableERC721: EXCEEDS_BATCH_LIMIT");
        // Iteratively burn ERC721 tokens, for performing
        // batch withdraw
        for (uint256 i; i < length; i++) {
            uint256 tokenId = tokenIds[i];
            require(_msgSender() == ownerOf(tokenId), "ChildMintableERC721: INVALID_TOKEN_OWNER");
            _burn(tokenId);
        }
        // At last emit this event, which will be used
        // in MintableERC721 predicate contract on L1
        // while verifying burn proof
        emit WithdrawnBatch(_msgSender(), tokenIds);
    }

    function safeMint(address to, string memory internalNftId) external onlyRole(TRANSACTOR_ROLE) {
        require(bytes(internalNftId).length > 0, "Empty internalNftId");
        _safeMintInternal(to, internalNftId);
    }

    function safeMintBatch(address to, string[] memory internalNftIds) external onlyRole(TRANSACTOR_ROLE) {
        require(internalNftIds.length > 0, "InternalNftIds must be greater than zero");
        for(uint i = 0; i < internalNftIds.length; i++){
            require(bytes(internalNftIds[i]).length > 0, "Empty internalNftId");
            _safeMintInternal(to, internalNftIds[i]);
        }
    }

    function _safeMintInternal(address to, string memory internalNftId) private{
        uint256 tokenId = _tokenIdCounter;
    unchecked{_tokenIdCounter++;}
        _safeMint(to, tokenId);
        emit NftMinted(to, tokenId, internalNftId, internalNftId);
    }

    function safeMintExternal(address to) public payable {
        require(msg.value >= nftPrice,"Nft price is greater than the given price");
        uint256 refund = msg.value - nftPrice;
        if (refund > 0) {
            Address.sendValue(payable(_msgSender()), refund);
        }
        Address.sendValue(treasury, nftPrice);
        _safeMintInternal(to, "");
    }

    function updateNftPrice(uint256 updatedPrice) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(updatedPrice > 0, "Updated NFT price must be non-zero");
        nftPrice = updatedPrice;
    }

    function updateTreasury(address newTreasury) public onlyRole(DEFAULT_ADMIN_ROLE){
        require(newTreasury != address(0), "The treasury must be a valid address");
        treasury = payable(newTreasury);
    }

    function rotateTransactor(address payable newTransactor) external payable onlyRole(TRANSACTOR_ROLE) {
        require(newTransactor != address(0x0), 'Address cannot be empty');
        rotate(newTransactor,_msgSender());
    }

    function rotateTransactorByOwner(address payable newTransactor, address oldTransactor) external payable onlyRole(DEFAULT_ADMIN_ROLE){
        require(hasRole(TRANSACTOR_ROLE,oldTransactor),"The old transactor must have transactor role");
        require(newTransactor != address(0x0), 'Address cannot be empty');
        rotate(newTransactor,oldTransactor);
    }

    function rotate(address payable newTransactor, address oldTransactor) private {
        _grantRole(TRANSACTOR_ROLE, newTransactor);
        _revokeRole(TRANSACTOR_ROLE,oldTransactor);
        newTransactor.transfer(msg.value);
    }
}