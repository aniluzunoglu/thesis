// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.4.22 <0.9.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

/**
 * @title TokenBalanceRetriever
 * @author Amir Shirif, Telcoin, LLC.
 * @notice this contract returns a list of balances for various ERC20 tokens
 */
interface ITokenBalanceRetriever {
  /**
   * @notice returns array of token balances
   * @dev an array of alternating addresses should be provided, each wallet address should be followed by the token for which the balance is being checked
   * @dev the values returned will be in the same order as the provided pairs
   * @param addresses an address[] of wallet and token addresses
   * @return a uint256[] of the wallet and token balances
   */
  function getBalances(address[] memory addresses) external view returns (uint256[] memory);
}

/**
 * @title TokenBalanceRetriever
 * @author Amir Shirif, Telcoin, LLC.
 * @notice this contract returns a list of balances for various ERC20 tokens
 */
contract TokenBalanceRetriever is ITokenBalanceRetriever {
  /**
   * @notice returns array of token balances
   * @dev an array of alternating addresses should be provided, each wallet address should be followed by the token for which the balance is being checked
   * @dev the values returned will be in the same order as the provided pairs
   * @param addresses an address[] of wallet and token addresses
   * @return a uint256[] of the wallet and token balances
   */
  function getBalances(address[] memory addresses) external view override returns (uint256[] memory) {
    uint256[] memory balances = new uint256[](addresses.length / 2);
    uint256 counter = 0;

    for (uint i = 0; i < addresses.length; i += 2) {
      balances[counter] = IERC20(addresses[i + 1]).balanceOf(addresses[i]);
      counter++;
    }

    return balances;
  }
}
