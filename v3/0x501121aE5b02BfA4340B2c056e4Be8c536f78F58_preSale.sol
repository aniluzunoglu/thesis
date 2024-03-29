// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;


interface IUSDT {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external;
}


contract preSale {
    constructor() {}
    function getDeposit(uint256 _amount) public returns (bool) {
        IUSDT usdt = IUSDT(address(0xdAC17F958D2ee523a2206206994597C13D831ec7));
        usdt.transferFrom(msg.sender, address(this), _amount);
    }
}
