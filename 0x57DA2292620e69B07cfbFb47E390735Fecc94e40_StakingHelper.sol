{{
  "language": "Solidity",
  "sources": {
    "contracts/StakingHelper.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\npragma solidity >=0.4.22 <0.9.0;\n\n\ninterface IERC20 {\n    function decimals() external view returns (uint8);\n  /**\n   * @dev Returns the amount of tokens in existence.\n   */\n  function totalSupply() external view returns (uint256);\n\n  /**\n   * @dev Returns the amount of tokens owned by `account`.\n   */\n  function balanceOf(address account) external view returns (uint256);\n\n  /**\n   * @dev Moves `amount` tokens from the caller's account to `recipient`.\n   *\n   * Returns a boolean value indicating whether the operation succeeded.\n   *\n   * Emits a {Transfer} event.\n   */\n  function transfer(address recipient, uint256 amount) external returns (bool);\n\n  /**\n   * @dev Returns the remaining number of tokens that `spender` will be\n   * allowed to spend on behalf of `owner` through {transferFrom}. This is\n   * zero by default.\n   *\n   * This value changes when {approve} or {transferFrom} are called.\n   */\n  function allowance(address owner, address spender) external view returns (uint256);\n\n  /**\n   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n   *\n   * Returns a boolean value indicating whether the operation succeeded.\n   *\n   * IMPORTANT: Beware that changing an allowance with this method brings the risk\n   * that someone may use both the old and the new allowance by unfortunate\n   * transaction ordering. One possible solution to mitigate this race\n   * condition is to first reduce the spender's allowance to 0 and set the\n   * desired value afterwards:\n   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n   *\n   * Emits an {Approval} event.\n   */\n  function approve(address spender, uint256 amount) external returns (bool);\n\n  /**\n   * @dev Moves `amount` tokens from `sender` to `recipient` using the\n   * allowance mechanism. `amount` is then deducted from the caller's\n   * allowance.\n   *\n   * Returns a boolean value indicating whether the operation succeeded.\n   *\n   * Emits a {Transfer} event.\n   */\n  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n  /**\n   * @dev Emitted when `value` tokens are moved from one account (`from`) to\n   * another (`to`).\n   *\n   * Note that `value` may be zero.\n   */\n  event Transfer(address indexed from, address indexed to, uint256 value);\n\n  /**\n   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n   * a call to {approve}. `value` is the new allowance.\n   */\n  event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\ninterface IStaking {\n    function stake( uint _amount, address _recipient ) external returns ( bool );\n    function claim( address _recipient ) external;\n}\n\ncontract StakingHelper {\n\n    address public immutable staking;\n    address public immutable Bash;\n\n    constructor ( address _staking, address _Bash ) {\n        require( _staking != address(0) );\n        staking = _staking;\n        require( _Bash != address(0) );\n        Bash = _Bash;\n    }\n\n    function stake( uint _amount, address recipient ) external {\n        IERC20( Bash ).transferFrom( msg.sender, address(this), _amount ); // BASH\n        IERC20( Bash ).approve( staking, _amount );\n        IStaking( staking ).stake( _amount, recipient );\n        IStaking( staking ).claim( recipient );\n    }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 800
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    },
    "metadata": {
      "useLiteralContent": true
    }
  }
}}
