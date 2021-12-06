// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Account.sol";

contract Wallet is Admin{

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;

    constructor() Admin(){

    }

   //0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9

    struct WalletItem {

    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable owner;

  }
    

    mapping(address => address) public userAccount;
    mapping(uint256 => WalletItem) private idToWalletItem;
    mapping(address=> mapping(uint256=>bool)) public NFTexist;
    mapping(address =>mapping(uint256=>address)) private ownerOf;
    mapping(address =>mapping(uint256=>uint256)) private _nftToId;
    mapping(address=> uint256)public balance;


    function createAccount() public returns(address) {
      Account account = new Account(admin_contract_addr(),_msgSender());
      userAccount[_msgSender()]=address(account);
      return address(account);
    }

    
  //   function pause() public onlyOwner whenNotPaused {
  //       _pause();
  //   }

  //   function LockItem(
  //   address nftContract,
  //   uint256 tokenId
  // ) public {
  //   require(NFTexist[nftContract][tokenId] == false, "NFT already Exist on the market");
   
  // //  require(msg.value == listingPrice, "Price must be equal to listing price");
  //   NFTexist[nftContract][tokenId] = true;
  //   _itemIds.increment();
  //   uint256 itemId = _itemIds.current();

  //   idToWalletItem[itemId] =  WalletItem(
  //     itemId,
  //     nftContract,
  //     tokenId,
  //     payable(_msgSender())
  //   );
    
  //   balance[_msgSender()] ++; 
  //   ownerOf[nftContract][tokenId] = _msgSender();
  //   _nftToId[nftContract][tokenId] = itemId;
  //   IERC721(nftContract).transferFrom(_msgSender(), address(this), tokenId);

  // }

  // function SendNFT(
  //   address nftContract,
  //   uint256 tokenId,
  //   address to
  // ) public payable whenNotPaused {
  //   require(NFTexist[nftContract][tokenId] == true, "NFT does not Exist on the market");
  //   uint256 id = _nftToId[nftContract][tokenId];

  //   delete idToWalletItem[id];
    
  //   balance[_msgSender()] --;
  //   delete ownerOf[nftContract][tokenId];
  // //  require(msg.value == listingPrice, "Price must be equal to listing price");
  //   IERC721(nftContract).transferFrom(address(this),to, tokenId);

  //    NFTexist[nftContract][tokenId] = false;

  // }

  //   function _ownerOf(address nftContract,uint256 tokenId) public view returns(address){
  //     return ownerOf[nftContract][tokenId];
  //   }
    
  //   function unpause() public  whenPaused {
  //       _unpause();
  //   }

  //   function fetchMyNFTs() public view returns (WalletItem[] memory) {
  //   uint totalItemCount = _itemIds.current();
  //   uint itemCount = 0;
  //   uint currentIndex = 0;

  //   for (uint i = 0; i < totalItemCount; i++) {
  //     if (idToWalletItem[i + 1].owner == _msgSender()) {
  //       itemCount += 1;
  //     }
  //   }

  //   WalletItem[] memory items = new WalletItem[](itemCount);
  //   for (uint i = 0; i < totalItemCount; i++) {
  //     if (idToWalletItem[i + 1].owner == _msgSender()) {
  //       uint currentId = i + 1;
  //       WalletItem storage currentItem = idToWalletItem[currentId];
  //       items[currentIndex] = currentItem;
  //       currentIndex += 1;
  //     }
  //   }
  //   return items;
  // }
}