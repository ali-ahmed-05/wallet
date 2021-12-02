// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Wallet is Pausable{
    uint256 private id;

    struct owner{
        address nftContract;
        uint256 id;
    }

    mapping(address=> mapping(uint256=>bool)) public NFTexist;
    mapping(address =>mapping(uint256=>address)) private ownerOf;
    mapping(address=> uint256)public balance;

    function update() public whenNotPaused returns(uint256){
        id++;
        return id;
    }
    function pause() public whenNotPaused {
        _pause();
    }

    function LockItem(
    address nftContract,
    uint256 tokenId
  ) public {
    require(NFTexist[nftContract][tokenId] == false, "NFT already Exist on the market");
   
  //  require(msg.value == listingPrice, "Price must be equal to listing price");
    NFTexist[nftContract][tokenId] = true;
    
    balance[_msgSender()] ++; 
    ownerOf[nftContract][tokenId] = _msgSender();
    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

  }

  function SendNFT(
    address nftContract,
    uint256 tokenId,
    address to
  ) public payable whenNotPaused {
    require(NFTexist[nftContract][tokenId] == true, "NFT does not Exist on the market");
    
    balance[_msgSender()] --;
    ownerOf[nftContract][tokenId] = address(0);
  //  require(msg.value == listingPrice, "Price must be equal to listing price");
    IERC721(nftContract).transferFrom(address(this),to, tokenId);

     NFTexist[nftContract][tokenId] = false;

  }

  function _ownerOf(address nftContract,uint256 tokenId) public view returns(address){
    return ownerOf[nftContract][tokenId];
  }
    /*
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unpause() public  whenPaused {
        _unpause();
    }
}