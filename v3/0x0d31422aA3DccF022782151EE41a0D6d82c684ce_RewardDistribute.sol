// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract RewardDistribute {
    address owner;
    
    constructor() {
        owner = msg.sender;
    }

    fallback() payable external {
    }

    receive() payable external {
    }

    function withdraw() public {
        require(msg.sender == owner, "not owner");
        payable(msg.sender).transfer(address(this).balance);
    }
}
