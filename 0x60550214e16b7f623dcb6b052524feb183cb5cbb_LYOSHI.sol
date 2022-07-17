/**
LYOSHIINU.COM

*/

// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;


interface IBEP20 {
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
}
contract LYOSHI is IBEP20 {
    string private constant _name = 'TEST';
    string private constant _symbol = 'TNT';

    constructor() {}

    function name() public pure returns (string memory) {return _name;}
    function symbol() public pure returns (string memory) {return _symbol;}

}
