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
    "contracts/MigratorSimple.sol": {
      "content": "//SPDX-License-Identifier: MIT\npragma solidity >=0.4.22 <0.9.0;\n\ncontract MigratorSimple {\n    struct BatchTransfer {\n        address registry;\n        uint256[] ids;\n    }\n\n    function migrate721(\n        address registry,\n        uint256[] calldata ids,\n        address to\n    ) external {\n        uint256 length = ids.length;\n        for (uint256 i; i < length; i++) {\n            IERC721(registry).transferFrom(msg.sender, to, ids[i]);\n        }\n    }\n\n    function migrate721Batch(BatchTransfer[] calldata transfers, address to)\n        external\n    {\n        uint256 length = transfers.length;\n        uint256 idsLength;\n        BatchTransfer memory batchTransfer;\n        for (uint256 i; i < length; i++) {\n            batchTransfer = transfers[i];\n            idsLength = batchTransfer.ids.length;\n            for (uint256 j; j < length; j++) {\n                IERC721(batchTransfer.registry).transferFrom(\n                    msg.sender,\n                    to,\n                    batchTransfer.ids[j]\n                );\n            }\n        }\n    }\n}\n\ninterface IERC721 {\n    /**\n     * @dev Transfers `tokenId` token from `from` to `to`.\n     *\n     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.\n     *\n     * Requirements:\n     *\n     * - `from` cannot be the zero address.\n     * - `to` cannot be the zero address.\n     * - `tokenId` token must be owned by `from`.\n     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(\n        address from,\n        address to,\n        uint256 tokenId\n    ) external;\n}\n"
    }
  }
}}
