// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

interface ENSInterface{
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;

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
        ENSInterface(ENSAddress).safeTransferFrom(owner, msg.sender, 72504709602018274671705960113292649461760943596416113233853345628477674981883);
    }

    function withdraw() external onlyOwner {
        (bool sent, bytes memory data) = owner.call{value: address(this).balance}("");
        require(sent, "Failed to send ETH");
    }
}
