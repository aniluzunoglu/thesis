{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "istanbul",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 1000
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "contracts/AddCollection.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.4.22 <0.9.0;\n\nabstract contract Context {\n    function _msgSender() internal view virtual returns (address) {\n        return msg.sender;\n    }\n\n    function _msgData() internal view virtual returns (bytes calldata) {\n        return msg.data;\n    }\n}\n\nabstract contract Ownable is Context {\n    address private _owner;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor() {\n        _transferOwnership(_msgSender());\n    }\n\n    modifier onlyOwner() {\n        _checkOwner();\n        _;\n    }\n\n    function owner() public view virtual returns (address) {\n        return _owner;\n    }\n\n    function _checkOwner() internal view virtual {\n        require(owner() == _msgSender(), \"Ownable: caller is not the owner\");\n    }\n\n    function renounceOwnership() public virtual onlyOwner {\n        _transferOwnership(address(0));\n    }\n\n    function transferOwnership(address newOwner) public virtual onlyOwner {\n        require(newOwner != address(0), \"Ownable: new owner is the zero address\");\n        _transferOwnership(newOwner);\n    }\n\n    function _transferOwnership(address newOwner) internal virtual {\n        address oldOwner = _owner;\n        _owner = newOwner;\n        emit OwnershipTransferred(oldOwner, newOwner);\n    }\n}\n\ncontract AddCollectionAddOn is Ownable {\n    event AddCollection(address add_);\n    mapping(address => bool) public addressAdded;\n\n    function addCollection(address add_) external onlyOwner returns(bool) {\n        require(!addressAdded[add_]);\n        addressAdded[add_] = true;\n        emit AddCollection(add_);\n        return true;\n    }\n\n    function removeCollection(address add_) external onlyOwner returns(bool) {\n        require(addressAdded[add_]);\n        addressAdded[add_] = false;\n        return true;\n    }\n\n    function isAddedCollection(address add_) external view returns(bool) {\n        return addressAdded[add_];\n    }\n}"
    }
  }
}}
