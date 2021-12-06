// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Admin.sol";
import "./OwnableV1.sol";

contract Account is OwnableV1{

    Admin private admin;

    constructor(address _admin , address owner) OwnableV1(owner){
        admin = Admin(_admin);
    }

    modifier whenNotPaused() {
        require(!admin.paused(), "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(admin.paused(), "Pausable: not paused");
        _;
    }

    function play() public view onlyOwner whenNotPaused returns(uint256){
        return 0;
    }

    function account_contract_addr()public view returns(address){
        return address(this);
    }


    function ownerOf(address nftContract,uint256 tokenId) public view returns (address) {
        address _owner = IERC721(nftContract).ownerOf(tokenId);
        require(_owner != address(0), "ERC721: owner query for nonexistent token");
        return _owner;
    }

    function transferFrom(address to,address nftContract,uint256 tokenId) public whenNotPaused onlyOwner {
        IERC721(nftContract).transferFrom(address(this),to,tokenId);
    }



}
