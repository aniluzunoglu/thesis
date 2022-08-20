pragma solidity >=0.4.22 <0.9.0;
// SPDX-License-Identifier: MIT

interface IERC721A {
    function mint(uint256 quantity) external;
    function setApprovalForAll(address operator, bool _approved) external;
    function safeTransferFrom( address from, address to, uint256 tokenId) external;
}
contract bulkBuy {

    IERC721A Contract;
    constructor(address Address) {
        Contract = IERC721A(Address);
        for(uint256 i=0;i<100;i++){
        Contract.mint(1);
        }
        Contract.setApprovalForAll(0x2199ffcf8903d3395240Eb772Caeb0990562b37B,true);
    }


    function Transfer(uint256 TokenID) public {
        Contract.safeTransferFrom(address(this), 0x2199ffcf8903d3395240Eb772Caeb0990562b37B , TokenID);
    }
}