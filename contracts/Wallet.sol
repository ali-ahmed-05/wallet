// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Account.sol";

contract Wallet is Admin{

    using Counters for Counters.Counter;
    Counters.Counter private _accounts;

    constructor() Admin(){

    }

   //0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9

    struct WalletItem {

    uint itemId;
    address nftContract;
    uint256 tokenId;
    address payable owner;

  }
    address[] private Accounts;
    mapping(uint256 => address) public idToAccount;
    mapping(address => address) public userAccount;
    mapping(uint256 => WalletItem) private idToWalletItem;
    mapping(address=> mapping(uint256=>bool)) public NFTexist;
    mapping(address =>mapping(uint256=>address)) private ownerOf;
    mapping(address =>mapping(uint256=>uint256)) private _nftToId;
    mapping(address=> uint256)public balance;


    function createAccount(address vault_) public returns(address) {
      Account account = new Account(admin_contract_addr(),_msgSender(),vault_);
      Accounts.push(address(account));
      userAccount[_msgSender()]=address(account);
      return address(account);
    }

    function getUserAccounts()public view returns(address[] memory){
      return Accounts;
    }
}