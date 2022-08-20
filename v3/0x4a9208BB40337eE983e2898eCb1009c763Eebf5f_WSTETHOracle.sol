{{
  "language": "Solidity",
  "sources": {
    "contracts/oracles/WSTETHOracle.sol": {
      "content": "// SPDX-License-Identifier: GPL-2.0-or-later\n\npragma solidity >=0.4.22 <0.9.0;\n\n\ninterface IChainlinkAggregatorV2V3 {\n    function decimals() external view returns (uint8);\n    function description() external view returns (string memory);\n    function latestAnswer() external view returns (int256);\n    function latestTimestamp() external view returns (uint256);\n}\n\ninterface IStETH {\n    function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);\n}\n\n/// @notice Provides wstETH/ETH price using stETH/ETH Chainlink oracle and wstETH/stETH exchange rate provided by stETH smart contract\ncontract WSTETHOracle is IChainlinkAggregatorV2V3 {\n    address immutable public stETH;\n    address immutable public chainlinkAggregator;\n\n    constructor(\n        address _stETH, \n        address _chainlinkAggregator\n    ) {\n        //stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;\n        //chainlinkAggregator = 0x86392dC19c0b719886221c78AB11eb8Cf5c52812;\n\n        stETH = _stETH;\n        chainlinkAggregator = _chainlinkAggregator;\n    }\n\n    function decimals() external pure override returns (uint8) {\n        return 18;\n    }\n\n    function description() external pure override returns (string memory) {\n        return \"WSTETH/ETH\";\n    }\n\n    function latestTimestamp() external view override returns (uint256) {\n        return IChainlinkAggregatorV2V3(chainlinkAggregator).latestTimestamp();\n    }\n\n    /// @notice Get wstETH/ETH price. It does not check Chainlink oracle staleness! If staleness check needed, it's recommended to use latestTimestamp() function\n    /// @return answer wstETH/ETH price or 0 if failure\n    function latestAnswer() external view override returns (int256 answer) {\n        // get the stETH/ETH price from Chainlink oracle\n        int256 stETHPrice = IChainlinkAggregatorV2V3(chainlinkAggregator).latestAnswer();\n        if (stETHPrice <= 0) return 0;\n\n        // get wstETH/stETH exchange rate\n        uint256 stEthPerWstETH = IStETH(stETH).getPooledEthByShares(1 ether);\n\n        // calculate wstETH/ETH price\n        return int256(stEthPerWstETH) * stETHPrice / 1e18;\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 1000000
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  }
}}
