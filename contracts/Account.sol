// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Admin.sol";
import "./OwnableV1.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./RentVault.sol";


contract Account is OwnableV1 , ERC1155Holder , ERC721Holder{

    Admin private admin;
    
    RentVault vault;

    uint256 public balance;
    uint256 public val;
    bytes public _data;
    uint256 public _id;
    address public _operator;
    address public _from;


    mapping (address => bool) public is1155;
    mapping (address => bool) public is721;


    constructor(address _admin , address owner, address vault_) OwnableV1(owner){
        admin = Admin(_admin);
        vault = RentVault(vault_);
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
    //Ether implementation

    receive() payable external{} 

    function transferETH(address payable to , uint256 amount)public onlyOwner{
        require(amount <= address(this).balance,"ETH amount exceeds");
        to.transfer(amount);
    }
    // ERC721 implementation

    function safeTransferFrom(address to , address nftContract , uint256 tokenId )public whenNotPaused onlyOwner {
        IERC721(nftContract).safeTransferFrom(address(this),to,tokenId);
        balance --;
    }
    
    function safeTransferFrom(address to , address nftContract , uint256 tokenId,bytes calldata data)public whenNotPaused onlyOwner {
        IERC721(nftContract).safeTransferFrom(address(this),to,tokenId,data);
        balance --;
    }
  
    function transferFrom(address to,address nftContract,uint256 tokenId) public whenNotPaused onlyOwner {
        IERC721(nftContract).transferFrom(address(this),to,tokenId);
    }

    function approve(address to,address nftContract, uint256 tokenId) public onlyOwner{
        IERC721(nftContract).approve(to,tokenId);
    }

    //ERC1155 & ERC721  implementation

    function setApprovalForAll(address nftContract ,address operator, bool _approved) public onlyOwner{
        if(is1155[nftContract]==true){
            IERC1155(nftContract).setApprovalForAll(operator,_approved);
        }
        else{
            IERC721(nftContract).setApprovalForAll(operator,_approved);
        }
        
    }


    //ERC1155  implementation

    function safeTransferFrom(address to,address nftContract,uint256 tokenId,uint256 amount,bytes memory data) public whenNotPaused onlyOwner {
        IERC1155(nftContract).safeTransferFrom(address(this),to,tokenId,amount,data);
        balance --;
    }

    function safeBatchTransferFrom(
        address to,
        address nftContract,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public whenNotPaused onlyOwner{
        IERC1155(nftContract).safeBatchTransferFrom(address(this),to,ids,amounts,data);
         for(uint256 i = 0 ; i < amounts.length ; i++){
                balance -= amounts[i];
            }
    }

    //Receiver implementation 1155

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes memory data
    ) public virtual override returns (bytes4) {
        is1155[_msgSender()]=true;
        balance += value;
        if(!IERC1155(_msgSender()).isApprovedForAll(address(this),address(vault))){
                IERC1155(_msgSender()).setApprovalForAll(address(vault),true);
            }
        return ERC1155Holder.onERC1155Received(operator, from, id, value, data);
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
        )
        public override returns(bytes4){
            is1155[_msgSender()]=true;
            for(uint256 i = 0 ; i < values.length ; i++){
                balance += values[i];
            }
            if(!IERC1155(_msgSender()).isApprovedForAll(address(this),address(vault))){
                IERC1155(_msgSender()).setApprovalForAll(address(vault),true);
            }
           return ERC1155Holder.onERC1155BatchReceived(operator,from,ids,values,data);
        }


    //Receiver implementation 721

     function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes memory data
        ) public virtual override returns (bytes4) {
            is721[_msgSender()]=true;
            if (IERC721(_msgSender()).getApproved(id) !=_msgSender()){
                IERC721(_msgSender()).approve(address(vault),id);
            }
            balance += 1;

            return ERC721Holder.onERC721Received(operator,from,id,data);
        }

    //Valut implementation
        function rentNFT(
        address nftContract,
        uint256 tokenId,
        uint256 price,
        uint256 _seconds
            ) public onlyOwner{
        vault.createMarketRentItem(
        nftContract,
        tokenId,
        price,
        _seconds
    );
  }

    function RemoveItemFromVault(uint256 itemId)public onlyOwner{
        vault.RemoveItemFromVault(itemId);
    }
  

}




