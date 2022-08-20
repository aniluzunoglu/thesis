{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
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
    "contracts/staking/FeeRegistry.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.4.22 <0.9.0;\n\ncontract FeeRegistry {\n\taddress public owner;\n\n\tuint256 public totalFees = 1500;\n\tuint256 public veSDTPart = 500;\n\tuint256 public multisigPart = 200;\n\tuint256 public accumulatorPart = 800;\n\n\tuint256 public constant MAX_FEES = 2000;\n\tuint256 public constant FEE_DENOMINATOR = 10000;\n\n\taddress public multiSig = address(0xF930EBBd05eF8b25B1797b9b2109DDC9B0d43063);\n\taddress public accumulator = address(0xF980B8A714Ce0cCB049f2890494b068CeC715c3f);\n\taddress public veSDTFeeProxy = address(0x86Ebcd1bC876782670FE0B9ea23d8504569B9ffc);\n\n\tconstructor() {\n\t\towner = msg.sender;\n\t}\n\n\tmodifier onlyOwner() {\n\t\trequire(owner == msg.sender, \"!auth\");\n\t\t_;\n\t}\n\n\t/// @notice set new owner\n\t/// @param _owner new owner address\n\tfunction setOwner(address _owner) external onlyOwner {\n\t\towner = _owner;\n\t}\n\n\t/// @notice set platform fees\n\t/// @param _multi fees for mutlisig part\n\t/// @param _accumulator fees for accumulator part\n\t/// @param _veSDT fees for veSDT part\n\tfunction setFees(\n\t\tuint256 _multi,\n\t\tuint256 _accumulator,\n\t\tuint256 _veSDT\n\t) external onlyOwner {\n\t\ttotalFees = _multi + _accumulator + _veSDT;\n\t\trequire(totalFees <= MAX_FEES, \"fees over\");\n\n\t\tmultisigPart = _multi;\n\t\taccumulatorPart = _accumulator;\n\t\tveSDTPart = _veSDT;\n\t}\n\n\t/// @notice set new address for multisig\n\t/// @param _multi new multisig address\n\tfunction setMultisig(address _multi) external onlyOwner {\n\t\trequire(_multi != address(0), \"!address(0)\");\n\t\tmultiSig = _multi;\n\t}\n\n\t/// @notice set new address for accumulator\n\t/// @param _accumulator new accumulator address\n\tfunction setAccumulator(address _accumulator) external onlyOwner {\n\t\trequire(_accumulator != address(0), \"!address(0)\");\n\t\taccumulator = _accumulator;\n\t}\n\n\t/// @notice set new address for feeProxy\n\t/// @param _feeProxy new feeProxy address\n\tfunction setVeSDTFeeProxy(address _feeProxy) external onlyOwner {\n\t\trequire(_feeProxy != address(0), \"!address(0)\");\n\t\tveSDTFeeProxy = _feeProxy;\n\t}\n}\n"
    }
  }
}}
