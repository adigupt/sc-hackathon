// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./NFTToken.sol";

contract NFTRootMintableToken is NFTToken{
    bytes32 public constant TRANSACTOR_ROLE = keccak256("TRANSACTOR_ROLE");
    constructor (string memory name, string memory symbol,string memory contractUri_) NFTToken(name,symbol,contractUri_) {}

    function safeMint(address to, uint256 tokenId) public onlyRole(TRANSACTOR_ROLE) {
        _safeMint(to, tokenId);
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