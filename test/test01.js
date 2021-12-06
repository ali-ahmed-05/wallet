const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Wallet", function () {

    let NFT;
    let nft;
    let Wallet;
    let wallet;
    let Account;
    let account



    let [_, person1, person2] = [1, 1, 1]


    it("Should deploy NFT minter and Wallet contract", async function () {
        [_, person1, person2] = await ethers.getSigners()

         Wallet = await ethers.getContractFactory("Wallet");
         wallet = await Wallet.deploy();
        await wallet.deployed();

         NFT = await ethers.getContractFactory("NFT");
         nft = await NFT.deploy(wallet.address);
        await nft.deployed();  

        Account = await ethers.getContractFactory("Account");

    });
    it("Create NFT", async function () {    
         let Tx = await nft.createToken("asd");
        Tx.wait()

        let balance =await nft.balanceOf(_.address);
        balance = await ethers.BigNumber.from(balance).toString()
        expect(balance).to.equal('1');

    });
    it("Create Account", async function () {

       Tx = await wallet.connect(person1).createAccount();
       Tx.wait()
       let user = await wallet.userAccount(person1.address)
       account =await Account.attach(user)
       let owner = await account.owner()
       expect(person1.address).to.equal(owner)
        console.log("new account : ",user)
        console.log("account owner : ",owner)
        console.log("Account creator : ",person1.address)
        console.log("Wallet : ",wallet.address)
 
   });

it("Run function only owner", async function () {

    
    let user = await wallet.userAccount(person1.address)
    account =await Account.attach(user)
    let owner = await account.owner()
    let play = await account.connect(person1).play()
    console.log(play)
    expect(person1.address).to.equal(owner)
});
// it("Run function only owner when Paused :: fail ", async function () {

    
//     let user = await wallet.userAccount(person1.address)
//     let tx = await wallet.pause()
//     account =await Account.attach(user)
//     let owner = await account.owner()
//     let play = await account.connect(person1).play()
//     console.log(play)
//     expect(person1.address).to.equal(owner)
// });

   it("transfer NFT to new account", async function () {
    let user = await wallet.userAccount(person1.address)
    Tx = await nft.transferFrom(
        _.address,
        user,
        1)
    Tx.wait()
    let balance =await nft.balanceOf(user);
        balance = await ethers.BigNumber.from(balance).toString()
        expect(balance).to.equal('1');
//       Tx.wait()
});
it("transfer NFT back to orignal owner", async function () {
    let user = await wallet.userAccount(person1.address)
    account =await Account.attach(user)
    Tx = await account.connect(person1).transferFrom(_.address,nft.address,1)
    Tx.wait()
    let balance =await nft.balanceOf(_.address);
        balance = await ethers.BigNumber.from(balance).toString()
        expect(balance).to.equal('1');
//       Tx.wait()
});
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('1');

// });
// it("transfer Paused", async function () {
//     Tx = await wallet.pause();
//     Tx.wait()
// });
// it("Lock second NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,2);
//     Tx.wait()
    
// //       Tx.wait()
// });
// it("transfer NFT :: must fail", async function () {
//     Tx = await wallet.SendNFT(nft.address,2,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('1');
// //       Tx.wait()
// });

// it("transfer unPaused", async function () {
//     Tx = await wallet.unpause();
//     Tx.wait()
// });
// it("transfer second NFT ", async function () {
//     Tx = await wallet.SendNFT(nft.address,2,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('2');
// //       Tx.wait()
// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('1');

// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//    Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('2');

// });
// it("Create another NFT", async function () {    
//     Tx = await nft.createToken("asd");
//     Tx.wait()

//    let balance =await nft.balanceOf(_.address);
//    balance = await ethers.BigNumber.from(balance).toString()
//    expect(balance).to.equal('3');

// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,3);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,3);
//      console.log(Tx)
// //       Tx.wait()
// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,4);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,4);
//      console.log(Tx)
// //       Tx.wait()
// });
// it("Lock NFT", async function () {
//     Tx = await wallet.LockItem(nft.address,5);
//     Tx.wait()
//      Tx = await wallet.NFTexist(nft.address,5);
//      console.log(Tx)
// //       Tx.wait()
// });

// it("Fetch my NFts", async function () {    
//     let items = await wallet.fetchMyNFTs()
//     items = await Promise.all(items.map(async i => {
//       let item = {
//         itemId: i.itemId.toString(),
//         nftaddress: i.nftContract
//       }
//       return item
//     }))
//     console.log('items: ', items)

// });
// it("transfer Third NFT ", async function () {
//     Tx = await wallet.SendNFT(nft.address,3,person1.address);
//     Tx.wait()
//     let balance =await nft.balanceOf(person1.address);
//         balance = await ethers.BigNumber.from(balance).toString()
//         expect(balance).to.equal('3');
// //       Tx.wait()
// });

// it("Fetch my NFts after transfer", async function () {    
//     let items = await wallet.fetchMyNFTs()
//     items = await Promise.all(items.map(async i => {
//       let item = {
//         itemId: i.itemId.toString(),
//         nftaddress: i.nftContract
//       }
//       return item
//     }))
//     console.log('items: ', items)

// });
   
    
    
});
