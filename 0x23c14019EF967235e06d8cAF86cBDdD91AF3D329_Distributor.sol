{{
  "language": "Solidity",
  "sources": {
    "contracts/StakingDistributor.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-or-later\n\npragma solidity >=0.4.22 <0.9.0;\n\nlibrary SafeERC20 {\n    using SafeMath for uint256;\n    using Address for address;\n\n    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n    }\n\n    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n    }\n\n    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n\n        require((value == 0) || (token.allowance(address(this), spender) == 0),\n            \"SafeERC20: approve from non-zero to non-zero allowance\"\n        );\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n    }\n\n    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n    }\n\n    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n        uint256 newAllowance = token.allowance(address(this), spender)\n            .sub(value, \"SafeERC20: decreased allowance below zero\");\n        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n    }\n\n    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n\n        bytes memory returndata = address(token).functionCall(data, \"SafeERC20: low-level call failed\");\n        if (returndata.length > 0) { // Return data is optional\n            // solhint-disable-next-line max-line-length\n            require(abi.decode(returndata, (bool)), \"SafeERC20: ERC20 operation did not succeed\");\n        }\n    }\n}\n\nlibrary SafeMath {\n\n    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n        uint256 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    function add32(uint32 a, uint32 b) internal pure returns (uint32) {\n        uint32 c = a + b;\n        require(c >= a, \"SafeMath: addition overflow\");\n\n        return c;\n    }\n\n    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n        return sub(a, b, \"SafeMath: subtraction overflow\");\n    }\n\n    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b <= a, errorMessage);\n        uint256 c = a - b;\n\n        return c;\n    }\n\n    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n\n        if (a == 0) {\n            return 0;\n        }\n\n        uint256 c = a * b;\n        require(c / a == b, \"SafeMath: multiplication overflow\");\n\n        return c;\n    }\n\n    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n        return div(a, b, \"SafeMath: division by zero\");\n    }\n\n    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b > 0, errorMessage);\n        uint256 c = a / b;\n        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n\n        return c;\n    }\n\n    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n        return mod(a, b, \"SafeMath: modulo by zero\");\n    }\n\n    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n        require(b != 0, errorMessage);\n        return a % b;\n    }\n\n    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n    function sqrrt(uint256 a) internal pure returns (uint c) {\n        if (a > 3) {\n            c = a;\n            uint b = add( div( a, 2), 1 );\n            while (b < c) {\n                c = b;\n                b = div( add( div( a, b ), b), 2 );\n            }\n        } else if (a != 0) {\n            c = 1;\n        }\n    }\n\n    function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {\n        return div( mul( total_, percentage_ ), 1000 );\n    }\n\n    function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {\n        return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );\n    }\n\n    function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {\n        return div( mul(part_, 100) , total_ );\n    }\n\n    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n        // (a + b) / 2 can overflow, so we distribute\n        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n    }\n\n    function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {\n        return sqrrt( mul( multiplier_, payment_ ) );\n    }\n\n  function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {\n      return mul( multiplier_, supply_ );\n  }\n}\n\ninterface IERC20 {\n\n    function totalSupply() external view returns (uint256);\n\n    function balanceOf(address account) external view returns (uint256);\n\n    function transfer(address recipient, uint256 amount) external returns (bool);\n\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n}\n\nlibrary Address {\n\n    function isContract(address account) internal view returns (bool) {\n        // This method relies in extcodesize, which returns 0 for contracts in\n        // construction, since the code is only stored at the end of the\n        // constructor execution.\n\n        uint256 size;\n        // solhint-disable-next-line no-inline-assembly\n        assembly { size := extcodesize(account) }\n        return size > 0;\n    }\n\n    function sendValue(address payable recipient, uint256 amount) internal {\n        require(address(this).balance >= amount, \"Address: insufficient balance\");\n\n        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n        (bool success, ) = recipient.call{ value: amount }(\"\");\n        require(success, \"Address: unable to send value, recipient may have reverted\");\n    }\n\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n      return functionCall(target, data, \"Address: low-level call failed\");\n    }\n\n    function functionCall(\n        address target, \n        bytes memory data, \n        string memory errorMessage\n    ) internal returns (bytes memory) {\n        return _functionCallWithValue(target, data, 0, errorMessage);\n    }\n\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");\n    }\n\n    function functionCallWithValue(\n        address target, \n        bytes memory data, \n        uint256 value, \n        string memory errorMessage\n    ) internal returns (bytes memory) {\n        require(address(this).balance >= value, \"Address: insufficient balance for call\");\n        require(isContract(target), \"Address: call to non-contract\");\n\n        // solhint-disable-next-line avoid-low-level-calls\n        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n        return _verifyCallResult(success, returndata, errorMessage);\n    }\n\n    function _functionCallWithValue(\n        address target, \n        bytes memory data, \n        uint256 weiValue, \n        string memory errorMessage\n    ) private returns (bytes memory) {\n        require(isContract(target), \"Address: call to non-contract\");\n\n        // solhint-disable-next-line avoid-low-level-calls\n        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n        if (success) {\n            return returndata;\n        } else {\n            // Look for revert reason and bubble it up if present\n            if (returndata.length > 0) {\n                // The easiest way to bubble the revert reason is using memory via assembly\n\n                // solhint-disable-next-line no-inline-assembly\n                assembly {\n                    let returndata_size := mload(returndata)\n                    revert(add(32, returndata), returndata_size)\n                }\n            } else {\n                revert(errorMessage);\n            }\n        }\n    }\n\n    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n        return functionStaticCall(target, data, \"Address: low-level static call failed\");\n    }\n\n    function functionStaticCall(\n        address target, \n        bytes memory data, \n        string memory errorMessage\n    ) internal view returns (bytes memory) {\n        require(isContract(target), \"Address: static call to non-contract\");\n\n        // solhint-disable-next-line avoid-low-level-calls\n        (bool success, bytes memory returndata) = target.staticcall(data);\n        return _verifyCallResult(success, returndata, errorMessage);\n    }\n\n    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n        return functionDelegateCall(target, data, \"Address: low-level delegate call failed\");\n    }\n\n    function functionDelegateCall(\n        address target, \n        bytes memory data, \n        string memory errorMessage\n    ) internal returns (bytes memory) {\n        require(isContract(target), \"Address: delegate call to non-contract\");\n        (bool success, bytes memory returndata) = target.delegatecall(data);\n        return _verifyCallResult(success, returndata, errorMessage);\n    }\n\n    function _verifyCallResult(\n        bool success, \n        bytes memory returndata, \n        string memory errorMessage\n    ) private pure returns(bytes memory) {\n        if (success) {\n            return returndata;\n        } else {\n            if (returndata.length > 0) {\n                assembly {\n                    let returndata_size := mload(returndata)\n                    revert(add(32, returndata), returndata_size)\n                }\n            } else {\n                revert(errorMessage);\n            }\n        }\n    }\n\n    function addressToString(address _address) internal pure returns(string memory) {\n        bytes32 _bytes = bytes32(uint256(_address));\n        bytes memory HEX = \"0123456789abcdef\";\n        bytes memory _addr = new bytes(42);\n\n        _addr[0] = '0';\n        _addr[1] = 'x';\n\n        for(uint256 i = 0; i < 20; i++) {\n            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];\n            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];\n        }\n\n        return string(_addr);\n\n    }\n}\n\n\ninterface IPolicy {\n\n    function policy() external view returns (address);\n\n    function renouncePolicy() external;\n  \n    function pushPolicy( address newPolicy_ ) external;\n\n    function pullPolicy() external;\n}\n\ncontract Policy is IPolicy {\n    \n    address internal _policy;\n    address internal _newPolicy;\n\n    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n\n    constructor () {\n        _policy = msg.sender;\n        emit OwnershipTransferred( address(0), _policy );\n    }\n\n    function policy() public view override returns (address) {\n        return _policy;\n    }\n\n    modifier onlyPolicy() {\n        require( _policy == msg.sender, \"Ownable: caller is not the owner\" );\n        _;\n    }\n\n    function renouncePolicy() public virtual override onlyPolicy() {\n        emit OwnershipTransferred( _policy, address(0) );\n        _policy = address(0);\n    }\n\n    function pushPolicy( address newPolicy_ ) public virtual override onlyPolicy() {\n        require( newPolicy_ != address(0), \"Ownable: new owner is the zero address\");\n        _newPolicy = newPolicy_;\n    }\n\n    function pullPolicy() public virtual override {\n        require( msg.sender == _newPolicy );\n        emit OwnershipTransferred( _policy, _newPolicy );\n        _policy = _newPolicy;\n    }\n}\n\ninterface ITreasury {\n    function mintRewards( address _recipient, uint _amount ) external;\n}\n\ncontract Distributor is Policy {\n    using SafeMath for uint;\n    using SafeMath for uint32;\n    using SafeERC20 for IERC20;\n    \n    \n    \n    /* ====== VARIABLES ====== */\n\n    address public immutable Bash;\n    address public immutable treasury;\n    \n    uint32 public immutable epochLength;\n    uint32 public nextEpochTime;\n    \n    mapping( uint => Adjust ) public adjustments;\n    \n    \n    /* ====== STRUCTS ====== */\n        \n    struct Info {\n        uint rate; // in ten-thousandths ( 5000 = 0.5% )\n        address recipient;\n    }\n    Info[] public info;\n    \n    struct Adjust {\n        bool add;\n        uint rate;\n        uint target;\n    }\n    \n    \n    \n    /* ====== CONSTRUCTOR ====== */\n\n    constructor( address _treasury, address _Bash, uint32 _epochLength, uint32 _nextEpochTime ) {        \n        require( _treasury != address(0) );\n        treasury = _treasury;\n        require( _Bash != address(0) );\n        Bash = _Bash;\n        epochLength = _epochLength;\n        nextEpochTime = _nextEpochTime;\n    }\n    \n    \n    \n    /* ====== PUBLIC FUNCTIONS ====== */\n    \n    /**\n        @notice send epoch reward to staking contract\n     */\n    function distribute() external returns ( bool ) {\n        if ( nextEpochTime <= uint32(block.timestamp) ) {\n            nextEpochTime = nextEpochTime.add32( epochLength ); // set next epoch time\n            \n            // distribute rewards to each recipient\n            for ( uint i = 0; i < info.length; i++ ) {\n                if ( info[ i ].rate > 0 ) {\n                    ITreasury( treasury ).mintRewards( // mint and send from treasury\n                        info[ i ].recipient, \n                        nextRewardAt( info[ i ].rate ) \n                    );\n                    adjust( i ); // check for adjustment\n                }\n            }\n            return true;\n        } else { \n            return false; \n        }\n    }\n    \n    \n    \n    /* ====== INTERNAL FUNCTIONS ====== */\n\n    /**\n        @notice increment reward rate for collector\n     */\n    function adjust( uint _index ) internal {\n        Adjust memory adjustment = adjustments[ _index ];\n        if ( adjustment.rate != 0 ) {\n            if ( adjustment.add ) { // if rate should increase\n                info[ _index ].rate = info[ _index ].rate.add( adjustment.rate ); // raise rate\n                if ( info[ _index ].rate >= adjustment.target ) { // if target met\n                    adjustments[ _index ].rate = 0; // turn off adjustment\n                }\n            } else { // if rate should decrease\n                info[ _index ].rate = info[ _index ].rate.sub( adjustment.rate ); // lower rate\n                if ( info[ _index ].rate <= adjustment.target ) { // if target met\n                    adjustments[ _index ].rate = 0; // turn off adjustment\n                }\n            }\n        }\n    }\n    \n    \n    \n    /* ====== VIEW FUNCTIONS ====== */\n\n    /**\n        @notice view function for next reward at given rate\n        @param _rate uint\n        @return uint\n     */\n    function nextRewardAt( uint _rate ) public view returns ( uint ) {\n        return IERC20( Bash ).totalSupply().mul( _rate ).div( 1000000 );\n    }\n\n    /**\n        @notice view function for next reward for specified address\n        @param _recipient address\n        @return uint\n     */\n    function nextRewardFor( address _recipient ) public view returns ( uint ) {\n        uint reward;\n        for ( uint i = 0; i < info.length; i++ ) {\n            if ( info[ i ].recipient == _recipient ) {\n                reward = nextRewardAt( info[ i ].rate );\n            }\n        }\n        return reward;\n    }\n    \n    \n    \n    /* ====== POLICY FUNCTIONS ====== */\n\n    /**\n        @notice adds recipient for distributions\n        @param _recipient address\n        @param _rewardRate uint\n     */\n    function addRecipient( address _recipient, uint _rewardRate ) external onlyPolicy() {\n        require( _recipient != address(0) );\n        info.push( Info({\n            recipient: _recipient,\n            rate: _rewardRate\n        }));\n    }\n\n    /**\n        @notice removes recipient for distributions\n        @param _index uint\n        @param _recipient address\n     */\n    function removeRecipient( uint _index, address _recipient ) external onlyPolicy() {\n        require( _recipient == info[ _index ].recipient );\n        info[ _index ].recipient = address(0);\n        info[ _index ].rate = 0;\n    }\n\n    /**\n        @notice set adjustment info for a collector's reward rate\n        @param _index uint\n        @param _add bool\n        @param _rate uint\n        @param _target uint\n     */\n    function setAdjustment( uint _index, bool _add, uint _rate, uint _target ) external onlyPolicy() {\n        adjustments[ _index ] = Adjust({\n            add: _add,\n            rate: _rate,\n            target: _target\n        });\n    }\n}"
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
