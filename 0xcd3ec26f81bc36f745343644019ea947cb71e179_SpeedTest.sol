// SPDX-License-Identifier: Unlicense

pragma solidity >=0.4.22 <0.9.0;

contract SpeedTest {

    address owner;
    bool active = false;

    constructor () {
        owner = msg.sender;
    }

    function setActive() external {
        require(msg.sender == owner);
        active = true;
    }

    function purchase() external {
        require(active);

        active = false;
    }

}
