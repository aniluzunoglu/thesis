// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

interface IERC721 {
    function ownerOf(uint256) external view returns (address);
}

contract MulticallOwners {
    /**
     * @dev Returns array of {tokenId} ERC-721 owners from `collection`, ranging from `startId` to `endId`.
     */
    function getOwners(
        address collection,
        uint256 startId,
        uint256 endId
    ) external view returns (address[] memory) {
        IERC721 IContract = IERC721(collection);
        uint256 total = endId - startId + 1;
        address[] memory addresses = new address[](total);
        for (uint256 i = 0; i < total; i++) {
            address a = IContract.ownerOf(startId + i);
            addresses[i] = a;
        }
        return addresses;
    }
}