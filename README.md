# SmartContracts

## Token Smart Contract
### Token.sol
This is an ERC-20 smart contract. We would deploy (and mint) this smart contract on the **ETH chain**, then bridge the minted tokens using the polygon POS-bridge to get those on the polygon chain.<br>
This smart contract extends ERC20Votes smart contract as the ERC20 token behaves as a governance token which will be used for voting.<br>
This also is an ownable contract with a capped supply which can be set at the time of initialization.<br>
This smart contract follows UUPS upgradeable pattern as it gives us the flexibility to upgrade smart contracts in case of any bugs. The contract also has a permit based approval.
### RootToken.sol
This is the root ERC-20 smart contract to be deployed on the **Ethereum chain**.Only an owner can call the mint function on Ethereum chain.
### ChildToken.sol
This is the child ERC-20 smart contract to be deployed on the **Polygon chain**. It has some additional functions like withdraw and deposit used by Polygon's childChainManagerProxy to bridge tokens between Eth and Polygon chains. Only a childChainManagerProxy can call the deposit function on Polygon chain.
### GameplayToken.sol
This is an ERC-20 smart contract. We would deploy (and mint) this smart contract on the **Polygon chain**.<br>
This smart contract extends ERC20Burnable smart contract which allows burning of tokens.<br> 
This also is an ownable contract with an infinite supply.<br>
This smart contract follows UUPS upgradeable pattern as it gives us the flexibility to upgrade smart contracts in case of any bugs.
### GameplayRootToken.sol
This is the root ERC-20 smart contract to be deployed on the **Ethereum chain** and introduces a new predicate role used by MintableProxy to transfer tokens from Polygon (child) chain to Eth (root) chain.
### GameplayChildToken.sol
This is the child ERC-20 smart contract which is deployed on the Polygon chain (child chain) and only this contract has mint functionality. Has an additional despositor role to be used by PolygonChildChainManager to transfer tokens from Eth (root) to Polygon (child) chain.

## RoyaltyStandard
This is a royalty smart contract, which follows ERC2981 royalty standard. It takes an additional contract URI which has properties related to the contract(as mentioned in the opensea developer documentation).

## NFT Smart Contract
**For NFT's we will create ERC-721 contracts.**
### NFTToken.sol:
**NFTToken** is an ERC-721 smart contract. This extends **AccessControl** contract for managing different roles.
We would deploy the root smart contract on the ETH chain and deploy the child ERC-721 smart contract on the polygon chain.
It extends RoyaltyStandard in order to support royalty for NFT tokens. Only the owner can change the royalty info which applies to all the nft tokens of this contract.
### Child-chain minted NFTs:
These are NFT contracts which allows a transactor role to mint tokens on the polygon chain and then bridge these tokens using the POS-bridge on the ETH chain.
#### NFTRootToken.sol:
**NFTRootToken** is deployed on Eth chain (root chain) and it introduces a new predicate role used by MintableProxy to transfer tokens from Polygon (child) chain to Eth (root) chain.
#### NFTChildMintableToken.sol:
**NFTChildMintableToken** is deployed on Polygon chain (child chain) and only this contract has mint functionality. 
Has an additional despositor role to be used by PolygonChildChainManager to transfer tokens from Eth (root) to Polygon (child) chain.
Mint is either called internally by transactors or by users for a specified price. 
This contract also allows rotation of transactors by existing transactors or by admin for added security.
### Root-chain minted NFTs:
These are NFT contracts which allows a transactor role to mint tokens on the Eth chain and then bridge these tokens using the POS-bridge on the polygon chain.
#### NFTRootMintableToken.sol:
**NFTRootMintableToken** is deployed on Eth chain (root chain) and has the mint (and rotate transactor) functionality.
It introduces mintableProxy to transfer tokens from Polygon (child) chain to Eth (root) chain.
#### NFTChildToken.sol:
**NFTChildToken** is deployed on Polygon chain (child chain). It has an additional childChainManagerProxy to be used to transfer tokens from Eth (root) to Polygon (child) chain.

## Interfaces

### IERC20Burnable
Provides the interface for burning ERC20 tokens for other contracts.
### IMintableERC721
Provides the interface for minting NFT tokens for other contracts.
### IWMATIC
Provides the interface of withdrawing MATIC by depositing WMATIC tokens to the WMATIC contract.
