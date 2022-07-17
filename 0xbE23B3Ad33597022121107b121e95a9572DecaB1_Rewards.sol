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
      "enabled": false,
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
    "contracts/Rewards.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity >=0.4.22 <0.9.0;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address) external view returns (uint256);\n\n    function transferFrom(\n        address,\n        address,\n        uint256\n    ) external;\n\n    function transfer(address, uint256) external;\n\n    function mint(address, uint256) external;\n}\n\ncontract Rewards {\n    IERC20 public immutable reward;\n    IERC20 public immutable lp;\n\n    mapping(address => uint256) public userStaked;\n    mapping(address => uint256) public userPaid;\n\n    uint256 public totalStaked; // Total amount of lp staked\n    uint256 public accRewardsPerLP; // Accumulated rewards per staked LP\n    uint256 public emission; // Token being emitted per second\n    uint256 public lastUpdate; // Last time updatePool() was called\n\n    uint256 public totalClaimed;\n    uint256 public totalEmitted;\n\n    address public admin;\n\n    constructor(address _lp, address _reward) public {\n        lp = IERC20(_lp);\n        reward = IERC20(_reward);\n        admin = msg.sender;\n    }\n\n    function deposit(uint256 amount) external {\n        address user = msg.sender;\n        _claim(user);\n        lp.transferFrom(user, address(this), amount);\n        userStaked[user] += amount;\n        totalStaked += amount;\n        userPaid[user] = (accRewardsPerLP * userStaked[user]) / 1e18;\n    }\n\n    function withdraw(uint256 amount) external {\n        address user = msg.sender;\n        _claim(user);\n        if (userStaked[user] < amount) amount = userStaked[user];\n        userStaked[user] -= amount;\n        totalStaked -= amount;\n        lp.transfer(user, amount);\n        userPaid[user] = (accRewardsPerLP * userStaked[user]) / 1e18;\n    }\n\n    function claim() external {\n        _claim(msg.sender);\n    }\n\n    function _claim(address user) private {\n        updatePool();\n        uint256 amount = ((userStaked[user] * accRewardsPerLP) / 1e18) -\n            userPaid[user];\n        userPaid[user] += amount;\n        if (amount > 0) {\n            reward.mint(user, amount);\n        }\n        totalClaimed += amount;\n    }\n\n    function updatePool() private {\n        uint256 time = block.timestamp;\n        if (totalStaked > 0) {\n            uint256 totalEmission = emission * (time - lastUpdate);\n            accRewardsPerLP += (totalEmission * 1e18) / totalStaked;\n            totalEmitted += totalEmission;\n        }\n        lastUpdate = time;\n    }\n\n    function setAdmin(address _admin) external {\n        require(_admin != address(0), \"Zero address\");\n        require(msg.sender == admin, \"!Permission\");\n        admin = _admin;\n    }\n\n    function setEmission(uint256 _emission) external {\n        require(msg.sender == admin, \"!Permission\");\n        updatePool();\n        emission = _emission;\n    }\n\n    function pending(address user) external view returns (uint256) {\n        if (totalStaked == 0) return 0;\n        return\n            ((userStaked[user] *\n                (accRewardsPerLP +\n                    ((emission * (block.timestamp - lastUpdate) * 1e18) /\n                        totalStaked))) / 1e18) - userPaid[user];\n    }\n\n    function totalEmittedAndPending() public view returns (uint256) {\n        return totalEmitted + emission * (block.timestamp - lastUpdate);\n    }\n\n    function totalUnclaimed() external view returns (uint256) {\n        return totalEmittedAndPending() - totalClaimed;\n    }\n}\n"
    }
  }
}}
