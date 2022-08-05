// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./NFTToken.sol";
contract NFTChildToken is NFTToken {
    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");
    uint256 public constant BATCH_LIMIT = 20;
    event WithdrawnBatch(address indexed user, uint256[] tokenIds);

    constructor(string memory name, string memory symbol, string memory contractUri_, address childChainManagerProxy) NFTToken(name,symbol,contractUri_) {
        _grantRole(DEPOSITOR_ROLE,childChainManagerProxy);
    }

    function deposit(address user, bytes calldata depositData)external onlyRole(DEPOSITOR_ROLE) {
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

}