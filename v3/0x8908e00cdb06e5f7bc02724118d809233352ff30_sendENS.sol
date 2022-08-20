// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

interface ENSInterface{
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

contract sendENS {

    address owner;
    address ENSAddress = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }

    receive() external payable {
        require(msg.value >= .00001 ether);
        ENSInterface(ENSAddress).safeTransferFrom(owner, msg.sender, 49754312488118326705829723970541145789150618569366273542145124560927170292842);
    }

    function withdraw() external onlyOwner {
        (bool sent, bytes memory data) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to send ETH");
    }
}
