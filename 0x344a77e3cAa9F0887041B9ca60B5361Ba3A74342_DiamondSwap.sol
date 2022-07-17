// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
contract DiamondSwap {
    function buyNFT(address gemSwapAddress, bytes calldata callData) external payable {
        (bool success, ) = gemSwapAddress.delegatecall(callData);
        require(success);
    }
}
