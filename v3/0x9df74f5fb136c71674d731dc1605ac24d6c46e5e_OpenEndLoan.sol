// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title Represents an ownable resource.
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address previousOwner, address newOwner);

    /**
     * Constructor
     * @param addr The owner of the smart contract
     */
    constructor (address addr) {
        require(addr != address(0), "non-zero address required");
        require(addr != address(1), "ecrecover address not allowed");
        owner = addr;
        emit OwnershipTransferred(address(0), addr);
    }

    /**
     * @notice This modifier indicates that the function can only be called by the owner.
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner requirement");
        _;
    }

    /**
     * @notice Transfers ownership to the address specified.
     * @param addr Specifies the address of the new owner.
     * @dev Throws if called by any account other than the owner.
     */
    function transferOwnership (address addr) public virtual onlyOwner {
        require(addr != address(0), "non-zero address required");
        emit OwnershipTransferred(owner, addr);
        owner = addr;
    }
}

/**
 * @title Defines the interface of a basic pricing oracle.
 * @dev All prices are expressed in USD, with 6 decimal positions.
 */
interface IBasicPriceOracle {
    function updateTokenPrice (address tokenAddr, uint256 valueInUSD) external;
    function bulkUpdate (address[] memory tokens, uint256[] memory prices) external;
    function getTokenPrice (address tokenAddr) external view returns (uint256);
}

interface IERC20NonCompliant {
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address addr) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint8);
}

/**
 * @title Represents an agreement between two parties.
 */
abstract contract Agreement is Ownable {
    // The zero address
    address constant internal ZERO_ADDRESS = address(0);

    uint256 constant public PAYMENT_INTERVAL_DAILY = 1 days;
    uint256 constant public PAYMENT_INTERVAL_WEEKLY = 7 days;
    uint256 constant public PAYMENT_INTERVAL_MONTHLY = 30 days;

    uint8 constant internal INACTIVE = 0;
    uint8 constant internal PREAPPROVED = 1;
    uint8 constant internal FUNDING_REQUIRED = 2;
    uint8 constant internal ACTIVE = 3;
    uint8 constant internal CANCELLED = 4;
    uint8 constant internal LIQUIDATED = 5;
    uint8 constant internal TERMINATED = 6;
    uint8 constant internal CLOSED = 7;

    /**
     * @notice The grace period applicable to payments, no matter what the payment schedule is. This value is measured in seconds.
     * @dev The default value is 5 days which is 432,000 seconds.
     */
    uint256 public gracePeriod = 5 days;

    /**
     * @notice The late fee (percentage) with 2 decimal places
     */
    uint256 public lateFee;

    // The initial collateral ratio. It is zero for unsecured debt.
    uint256 internal immutable _initialCollateralRatio;

    // The maintenance collateral ratio. It is zero for unsecured debt.
    uint256 internal immutable _maintenanceCollateralRatio;

    // The loan amount, expressed in FIAT
    uint256 internal _loanAmountInFiat;

    uint256 public effectiveLoanAmountInFiat;

    // The payment interval, expressed in seconds.
    uint256 internal _paymentIntervalInSeconds;

    // The date of the next payment, grace period excluded.
    uint256 internal _nextPaymentDate;

    /**
     * @notice The address of the borrower per terms and conditions agreed between parties. It cannot be altered.
     */
    address public immutable borrower;

    /**
     * @notice The address of the lender per terms and conditions agreed between parties. It cannot be altered.
     */
    address public immutable lender;

    /**
     * @notice The address of the principal token. It cannot be altered.
     */
    address public immutable principalToken;

    /**
     * @notice The address of the collateral token, if any.
     * @dev The collateral token is the zero address for unsecured loans.
     */
    address public immutable collateralToken;

    /**
     * @notice The oracle for calculating token prices.
     */
    address public priceOracle;

    // The decimal places of the principal token
    uint8 internal immutable _principalDecimals;

    // The decimal places of the collateral token
    uint8 internal immutable _collateralDecimals;

    /**
     * @notice The current state of the loan
     */
    uint8 public loanState;

    /**
     * @notice Constructor.
     * @param ownerAddr The owner of the smart contract.
     * @param borrowerAddr The address of the borrower.
     * @param lenderAddr The address of the lender.
     * @param newOracle The oracle.
     * @param newPrincipalToken The principal token.
     * @param newCollateralToken The collateral token, if any.
     * @param initialCollateralRatio The initial collateral ratio, if any.
     * @param maintenanceCollateralRatio The maintenance collateral ratio, if any.
     * @param lateFeeWithTwoDecimals The late fee (percentage) with 2 decimal places.
     */
    constructor (
        address ownerAddr,
        address borrowerAddr,
        address lenderAddr,
        IBasicPriceOracle newOracle,
        IERC20NonCompliant newPrincipalToken,
        address newCollateralToken,
        uint256 initialCollateralRatio, 
        uint256 maintenanceCollateralRatio,
        uint256 lateFeeWithTwoDecimals
    ) Ownable(ownerAddr) {
        require(borrowerAddr != ZERO_ADDRESS, "Borrower address required");
        require(lenderAddr != ZERO_ADDRESS, "Lender address required");
        require(lateFeeWithTwoDecimals > 0, "Non-zero late fee required");

        // Check the collateralization ratio
        uint8 collatDecimals = 0;
        if (newCollateralToken != ZERO_ADDRESS) {
            // A secured loan requires a collateral, by definition. It would be unsecured otherwise.
            // Thus the initial collateral ratio must be greater than zero.
            // The max ratio is set to 120% per business rules.
            require(initialCollateralRatio > 0 && initialCollateralRatio <= 12000, "Invalid initial collateral");

            // The maintenance collateral ratio cannot exceed 120% per business rules
            require(maintenanceCollateralRatio > 0 && maintenanceCollateralRatio <= 12000, "Invalid maintenance collateral");

            collatDecimals = IERC20NonCompliant(newCollateralToken).decimals();
            require(collatDecimals >= 6, "Invalid collateral token");
        } else {
            require(initialCollateralRatio == 0 && maintenanceCollateralRatio == 0, "Invalid collateral ratio");
        }

        collateralToken = newCollateralToken;
        _collateralDecimals = collatDecimals;
        _initialCollateralRatio = initialCollateralRatio;
        _maintenanceCollateralRatio = maintenanceCollateralRatio;

        uint8 tokenDecimals = newPrincipalToken.decimals();
        require(tokenDecimals >= 6, "Token not supported");

        principalToken = address(newPrincipalToken);
        _principalDecimals = tokenDecimals;

        borrower = borrowerAddr;
        lender = lenderAddr;
        priceOracle = address(newOracle);
        lateFee = lateFeeWithTwoDecimals;
    }

    /**
     * @notice Throws if the caller is not the expected borrower.
     */
    modifier onlyBorrower() {
        require(msg.sender == borrower, "Only borrower");
        _;
    }

    /**
     * @notice Throws if the caller is not the expected lender.
     */
    modifier onlyLender() {
        require(msg.sender == lender, "Only lender");
        _;
    }

    /**
     * @notice Throws if the debt is unsecured
     */
    modifier onlyIfSecuredDebt () {
        // Unsecured loans do not require any collateral, by definition
        require(isSecured(), "This loan is unsecured");
        _;
    }

    /**
     * @notice Throws if the loan was defaulted.
     */
    modifier ifNotDefaulted () {
        require(block.timestamp <= _nextPaymentDate + gracePeriod, "Loan defaulted"); // solhint-disable-line not-rely-on-time
        _;
    }

    /**
     * @notice Throws if the loan was not defaulted.
     */
    modifier onlyIfDefaulted () {
        require(block.timestamp > _nextPaymentDate + gracePeriod, "Loan not defaulted"); // solhint-disable-line not-rely-on-time
        _;
    }

    modifier onlyIfActive () {
        require(loanState == ACTIVE, "Loan is not active yet");
        _;
    }

    /**
     * @notice Changes the oracle that calculates token prices.
     * @param newOracle The new oracle for token prices
     */
    function changeOracle (IBasicPriceOracle newOracle) public virtual onlyOwner {
        require(priceOracle != address(newOracle), "Oracle already set");
        priceOracle = address(newOracle);
    }

    /**
     * @notice Changes the fee applicable to overdue payments.
     * @param lateFeeWithTwoDecimals The late fee (percentage) with 2 decimal places.
     */
    function changeLateFee (uint256 lateFeeWithTwoDecimals) public virtual onlyLender {
        require(lateFeeWithTwoDecimals > 0, "Non-zero late fee required");
        require(lateFee != lateFeeWithTwoDecimals, "Late fee already set");

        lateFee = lateFeeWithTwoDecimals;
    }

    // Initializes the base parameters of a any debt
    function _initializeBaseParameters (
        uint256 newLoanAmountInFiat,
        uint256 newPaymentIntervalInSeconds,
        uint256 originationFeePercent2Decimals
    ) internal {
        // Checks
        require(newLoanAmountInFiat > 0, "Invalid loan amount");

        // The origination fee ranges between 0% and 90%
        require(originationFeePercent2Decimals < 9000, "Origination fee too high");

        uint256 originationFeeInFiat = fromPercentToFiat(originationFeePercent2Decimals, newLoanAmountInFiat);
        require(originationFeeInFiat < newLoanAmountInFiat, "Invalid origination fee");

        require(loanState == INACTIVE, "Invalid loan state");
        require(_isValidPaymentInterval(newPaymentIntervalInSeconds), "Invalid payment interval");

        // State changes
        _loanAmountInFiat = newLoanAmountInFiat;
        effectiveLoanAmountInFiat = newLoanAmountInFiat - originationFeeInFiat;
        _paymentIntervalInSeconds = newPaymentIntervalInSeconds;
    }

    // Deposits the principal into this smart contract
    function _depositPrincipal (uint256 depositAmountInTokens, address senderAddr, uint256 expectedDepositAmountInFiat) internal {
        require(depositAmountInTokens > 0, "Principal required");

        // The current price of the principal token, in FIAT
        uint256 tokenPriceInFiat = IBasicPriceOracle(priceOracle).getTokenPrice(principalToken);
        require(tokenPriceInFiat > 0, "Invalid token price");

        // The principal amount specified converted to FIAT
        uint256 depositAmountInFiat = fromTokenToFiat(depositAmountInTokens, _principalDecimals, tokenPriceInFiat);
        require(depositAmountInFiat == expectedDepositAmountInFiat, "Insufficient principal");

        // Deposit the principal
        _depositToken(IERC20NonCompliant(principalToken), senderAddr, depositAmountInTokens);
    }

    // Deposits the initial collateral into this smart contract
    function _depositInitialCollateral (uint256 collateralDepositAmount, address senderAddr) internal onlyIfSecuredDebt {
        require(collateralDepositAmount > 0, "Collateral required");

        // The current price of the collateral token, in FIAT
        uint256 tokenPriceInFiat = IBasicPriceOracle(priceOracle).getTokenPrice(collateralToken);
        require(tokenPriceInFiat > 0, "Invalid token price");

        // The collateral amount specified converted to FIAT
        uint256 depositAmountInFiat = fromTokenToFiat(collateralDepositAmount, _collateralDecimals, tokenPriceInFiat);
        uint256 expectedCollateralInFiat = fromPercentToFiat(_initialCollateralRatio, _loanAmountInFiat);
        require(depositAmountInFiat == expectedCollateralInFiat, "Insufficient collateral");

        // Deposit the collateral
        _depositToken(IERC20NonCompliant(collateralToken), senderAddr, collateralDepositAmount);
    }

    // Deposits a specific amount of tokens into this smart contract
    function _depositToken (IERC20NonCompliant tokenInterface, address senderAddr, uint256 depositAmount) internal {
        require(depositAmount > 0, "Deposit amount required");

        // Check balance and allowance
        require(tokenInterface.allowance(senderAddr, address(this)) >= depositAmount, "Insufficient allowance");
        require(tokenInterface.balanceOf(senderAddr) >= depositAmount, "Insufficient funds");

        // Calculate the expected outcome, per check-effects-interaction pattern
        uint256 balanceBeforeTransfer = tokenInterface.balanceOf(address(this));
        uint256 expectedBalanceAfterTransfer = balanceBeforeTransfer + depositAmount;

        // Let the borrower deposit the predefined collateral through a partially-compliant ERC20
        tokenInterface.transferFrom(senderAddr, address(this), depositAmount);

        // Check the new balance
        uint256 actualBalanceAfterTransfer = tokenInterface.balanceOf(address(this));
        require(actualBalanceAfterTransfer == expectedBalanceAfterTransfer, "Deposit failed");
    }

    function fromPercentToFiat (uint256 percentWith2Decimals, uint256 fiatAmount) public pure returns (uint256) {
        return percentWith2Decimals * fiatAmount / 1e4;
    }

    function fromTokenToFiat (uint256 numberOfTokens, uint256 tokenDecimals, uint256 tokenPriceInFiat) public pure returns (uint256) {
        return (numberOfTokens / (10 ** (tokenDecimals - 6))) * tokenPriceInFiat / 1e6;
    }

    function fromFiatToToken (uint256 fiatAmount, uint256 tokenPriceInFiat, uint256 tokenDecimals) public pure returns (uint256) {
        /*
        // Version without optimization
        uint256 remainingDecimalsMultiplier = (10 ** (tokenDecimals - 6));
        uint256 tokenPriceScaled = tokenPriceInFiat * remainingDecimalsMultiplier;
        uint256 fiatAmountScaled = fiatAmount * remainingDecimalsMultiplier;
        return fiatAmountScaled * (10 ** tokenDecimals) / tokenPriceScaled;
        */

        // Optimized version
        uint256 remainingDecimalsMultiplier = (10 ** (tokenDecimals - 6));
        return (fiatAmount * remainingDecimalsMultiplier) * (10 ** tokenDecimals) / (tokenPriceInFiat * remainingDecimalsMultiplier);
    }

    /**
     * @notice Indicates whether the loan is secured or not.
     * @return Returns true if the loan represents secured debt.
     */
    function isSecured () public view returns (bool) {
        return collateralToken != ZERO_ADDRESS;
    }

    /**
     * @notice Changes the grace period.
     * @param newGracePeriodInDays The grace period, in days.
     */
    function changeGracePeriod (uint256 newGracePeriodInDays) public virtual onlyLender {
        // Validate the grace period
        uint256 newGracePeriodInSeconds = newGracePeriodInDays * 1 days;
        _validateGracePeriod(newGracePeriodInSeconds, _paymentIntervalInSeconds);

        gracePeriod = newGracePeriodInSeconds;
    }

    // Gets the late fee applicable to the amount specified. Notice that this fee is applicable on a daily basis.
    function _getDailyLateFee (uint256 amount) internal virtual view returns (uint256) {
        return amount * lateFee * 1 days / 1e4 / 365 days;
    }

    // Validates the grace period
    function _validateGracePeriod (uint256 newGracePeriodInSeconds, uint256 paymentIntervalInSeconds) internal view virtual {
        // The grace period must not exceed 30% of the payment interval
        uint256 maxGracePeriodInSeconds = (paymentIntervalInSeconds > PAYMENT_INTERVAL_DAILY) ? paymentIntervalInSeconds / 3 : PAYMENT_INTERVAL_DAILY;

        require(newGracePeriodInSeconds <= maxGracePeriodInSeconds, "Grace period too long");
    }

    // Indicates if the payment interval specified is supported
    function _isValidPaymentInterval (uint256 newPaymentIntervalInSeconds) internal pure virtual returns (bool);
}

/**
 * @title Represents a line of credit.
 * @dev The line of credit could be secured or not.
 */
abstract contract LineOfCredit is Agreement {
    // The remaining debt
    uint256 internal _remainingDebt;

    // The funding deadline. Investors are required to fund the principal before this exact point in time.
    uint256 internal _fundingDeadline;

    /**
     * @notice Constructor.
     * @param ownerAddr The owner of the smart contract.
     * @param borrowerAddr The address of the borrower.
     * @param lenderAddr The address of the lender.
     * @param newOracle The oracle.
     * @param newPrincipalToken The principal token.
     * @param newCollateralToken The collateral token, if any.
     * @param initialCollateralRatio The initial collateral ratio, if any
     * @param maintenanceCollateralRatio The maintenance collateral ratio, if any
     * @param lateFeeWithTwoDecimals The late fee (percentage) with 2 decimal places.
     */
    constructor (
        address ownerAddr,
        address borrowerAddr,
        address lenderAddr,
        IBasicPriceOracle newOracle,
        IERC20NonCompliant newPrincipalToken,
        address newCollateralToken,
        uint256 initialCollateralRatio, 
        uint256 maintenanceCollateralRatio,
        uint256 lateFeeWithTwoDecimals
    ) Agreement (
        ownerAddr, 
        borrowerAddr, 
        lenderAddr, 
        newOracle, 
        newPrincipalToken, 
        newCollateralToken, 
        initialCollateralRatio, 
        maintenanceCollateralRatio, 
        lateFeeWithTwoDecimals
    ) { // solhint-disable-line no-empty-blocks
    }

    /**
     * @notice Accepts a line of credit/loan, as borrower. The borrower commits to honor the terms and conditions of the loan.
     * @dev The deposit amount is zero for unsecured loans.
     * @param collateralDepositAmount The collateral to deposit, if any
     */
    function borrowerCommitment (uint256 collateralDepositAmount) public onlyBorrower {
        // Checks
        require(loanState == PREAPPROVED, "Invalid loan state");

        // Update the state of the loan
        loanState = FUNDING_REQUIRED;

        // Set the deadline for funding the principal
        _fundingDeadline = block.timestamp + fundingPeriod(); // solhint-disable-line not-rely-on-time

        // If the loan is secured, then the borrower is required to deposit the initial collateral ratio in advance.
        if (isSecured()) _depositInitialCollateral(collateralDepositAmount, msg.sender);
    }

    /**
     * @notice Funds this loan with the respective amount of principal, per loan specs.
     * @param principalDepositAmountInTokens The amount of principal to deposit
     */
    function fundLoan (uint256 principalDepositAmountInTokens) public onlyLender {
        require(loanState == FUNDING_REQUIRED, "Invalid loan state");
        require(block.timestamp <= _fundingDeadline, "Funding period elapsed"); // solhint-disable-line not-rely-on-time

        // Update the state of the loan
        loanState = ACTIVE;
        _nextPaymentDate = block.timestamp + _paymentIntervalInSeconds; // solhint-disable-line not-rely-on-time

        // Deposit the exact amount of principal per loan spec
        _depositPrincipal(principalDepositAmountInTokens, msg.sender, effectiveLoanAmountInFiat);
    }

    /**
     * @notice Claims the collateral deposited by the borrower
     */
    function claimCollateral () public onlyBorrower onlyIfSecuredDebt {
        require(loanState == FUNDING_REQUIRED, "Invalid loan state");
        require(block.timestamp > _fundingDeadline, "Funding period elapsed"); // solhint-disable-line not-rely-on-time

        loanState = CANCELLED;

        IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
        uint256 currentBalance = collateralTokenInterface.balanceOf(address(this));
        collateralTokenInterface.transfer(borrower, currentBalance);
        require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral transfer failed");
    }

    function _closeLoan () internal {
        // Checks
        require(loanState == ACTIVE, "Invalid loan state");
        require(_remainingDebt == 0, "Pending debt in place");

        loanState = CLOSED;

        // Return the collateral back to the borrower, if applicable
        if (isSecured()) {
            IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
            uint256 collateralBalanceInTokens = collateralTokenInterface.balanceOf(address(this));
            collateralTokenInterface.transfer(borrower, collateralBalanceInTokens);
            require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral transfer failed");
        }

        // Transfer the principal back to the lender
        IERC20NonCompliant principalTokenInterface = IERC20NonCompliant(principalToken);
        uint256 principalBalanceInTokens = principalTokenInterface.balanceOf(address(this));
        if (principalBalanceInTokens > 0) {
            principalTokenInterface.transfer(lender, principalBalanceInTokens);
            require(principalTokenInterface.balanceOf(address(this)) == 0, "Principal transfer failed");
        }
    }

    function _liquidateAssets () internal {
        // Liquidate the collateral, if applicable
        if (isSecured()) {
            IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
            uint256 collateralBalanceInTokens = collateralTokenInterface.balanceOf(address(this));
            collateralTokenInterface.transfer(lender, collateralBalanceInTokens);
            require(collateralTokenInterface.balanceOf(address(this)) == 0, "Collateral Liquidation failed");
        }

        // Liquidate the principal
        IERC20NonCompliant principalTokenInterface = IERC20NonCompliant(principalToken);
        uint256 principalBalanceInTokens = principalTokenInterface.balanceOf(address(this));
        if (principalBalanceInTokens > 0) principalTokenInterface.transfer(lender, principalBalanceInTokens);
        require(principalTokenInterface.balanceOf(address(this)) == 0, "Principal Liquidation failed");
    }

    // Enforces the maintenance collateral ratio
    function _enforceMaintenanceRatio () internal view {
        if (!isSecured()) return;

        (,,uint256 currentMaintenanceRatio) = getMaintenanceRatio();
        require(_maintenanceCollateralRatio >= currentMaintenanceRatio, "Insufficient maintenance ratio");
    }

    function getMaintenanceRatio () public view returns (uint256 collateralBalanceInFiat, uint256 currentMaintenanceRatioInFiat, uint256 currentMaintenanceRatio) {
        IERC20NonCompliant collateralTokenInterface = IERC20NonCompliant(collateralToken);
        uint256 collateralBalanceInTokens = collateralTokenInterface.balanceOf(address(this));

        // The current price of the collateral token, in FIAT
        uint256 tokenPriceInFiat = IBasicPriceOracle(priceOracle).getTokenPrice(collateralToken);
        require(tokenPriceInFiat > 0, "Invalid token price");

        collateralBalanceInFiat = fromTokenToFiat(collateralBalanceInTokens, _collateralDecimals, tokenPriceInFiat);
        currentMaintenanceRatioInFiat = fromPercentToFiat(_maintenanceCollateralRatio, collateralBalanceInFiat);
        currentMaintenanceRatio = currentMaintenanceRatioInFiat * 1e4 / collateralBalanceInFiat;
    }

    /**
     * @notice Gets the funding period for this line of credit, expressed in seconds.
     * @return Returns the funding period, measured in seconds
     */
    function fundingPeriod () public pure virtual returns (uint256) {
        return 7 days;
    }

    function getApplicableLateFee (uint256 ts) public virtual view returns (uint256) {
        if (ts <= _nextPaymentDate) return 0;

        // Apply a late fee accordingly
        uint256 diffSeconds = _nextPaymentDate - ts;
        uint256 diffDays = (diffSeconds % 86400 == 0) ? diffSeconds / 86400 : (diffSeconds / 86400) + 1;
        return _getDailyLateFee(_remainingDebt) * diffDays;
    }

    function getPaymentAmountWithFees () public virtual view returns (uint256 paymentAmountWithFeesInFiat) {
        uint256 ts = block.timestamp; // solhint-disable-line not-rely-on-time
        uint256 paymentAmountWithoutFees = getPaymentAmountWithoutFees();
        uint256 applicableLateFeeInFiat = getApplicableLateFee(ts);
        paymentAmountWithFeesInFiat = paymentAmountWithoutFees + applicableLateFeeInFiat;
    }

    function getPaymentAmountWithoutFees () public virtual view returns (uint256);
}

/**
 * @title Represents an open-term loan.
 */
contract OpenEndLoan is LineOfCredit {
    uint256 internal _apr;
    uint256 public spent;

    /**
     * @notice The fixed fee (if any) expressed in FIAT currency with 6 decimal places.
     */
    uint256 public fixedFeeInFiat;

    /**
     * @notice Constructor.
     * @param ownerAddr The owner of the smart contract.
     * @param borrowerAddr The address of the borrower.
     * @param lenderAddr The address of the lender.
     * @param newOracle The oracle.
     * @param newPrincipalToken The principal token.
     * @param newCollateralToken The collateral token, if any.
     * @param initialCollateralRatio The initial collateral ratio, if any
     * @param maintenanceCollateralRatio The maintenance collateral ratio, if any
     * @param lateFeeWithTwoDecimals The late fee (percentage) with 2 decimal places.
     * @param fixedFee The fixed fee of the open-ended loan, if any.
     */
    constructor (
        address ownerAddr,
        address borrowerAddr,
        address lenderAddr,
        IBasicPriceOracle newOracle,
        IERC20NonCompliant newPrincipalToken,
        address newCollateralToken,
        uint256 initialCollateralRatio, 
        uint256 maintenanceCollateralRatio,
        uint256 lateFeeWithTwoDecimals,
        uint256 fixedFee
    ) LineOfCredit (ownerAddr, borrowerAddr, lenderAddr, newOracle, newPrincipalToken, newCollateralToken, initialCollateralRatio, maintenanceCollateralRatio, lateFeeWithTwoDecimals) {
        fixedFeeInFiat = fixedFee;
    }

    /**
     * @notice Initializes a loan.
     * @param newLoanAmountInFiat The loan amount, in FIAT
     * @param newAprWithTwoDecimals The APR. It is a percentage with 2 decimal places.
     * @param newPaymentIntervalInSeconds The payment interval, in seconds
     * @param originationFeePercent2Decimals The origination fee. It is a percentage with 2 decimal places.
     * @param newGracePeriodInDays The grace period, in days.
     */
    function initializeLoanParameters (
        uint256 newLoanAmountInFiat, 
        uint256 newAprWithTwoDecimals,
        uint256 newPaymentIntervalInSeconds,
        uint256 originationFeePercent2Decimals,
        uint256 newGracePeriodInDays
    ) public onlyLender {
        // Checks
        require(newAprWithTwoDecimals > 0, "Invalid APR");

        // Validate the grace period
        uint256 newGracePeriodInSeconds = newGracePeriodInDays * 1 days;
        _validateGracePeriod(newGracePeriodInSeconds, newPaymentIntervalInSeconds);

        // Initialize the base/common parameters of the debt
        _initializeBaseParameters(newLoanAmountInFiat, newPaymentIntervalInSeconds, originationFeePercent2Decimals);

        _apr = newAprWithTwoDecimals;
        loanState = PREAPPROVED;
    }

    /**
     * @notice Transfers the principal amount specified to the borrower.
     * @param withdrawalAmountInTokens The withdrawal amount
     */
    function withdraw (uint256 withdrawalAmountInTokens) public onlyBorrower onlyIfActive ifNotDefaulted {
        require(withdrawalAmountInTokens > 0, "Amount required");

        IERC20NonCompliant principalTokenInterface = IERC20NonCompliant(principalToken);
        uint256 currentBalanceAtContract = principalTokenInterface.balanceOf(address(this));
        require(withdrawalAmountInTokens <= currentBalanceAtContract, "Insufficient balance");

        // The current price of the principal token, in FIAT
        uint256 tokenPriceInFiat = IBasicPriceOracle(priceOracle).getTokenPrice(principalToken);
        require(tokenPriceInFiat > 0, "Invalid token price");

        uint256 withdrawalAmountInFiat = fromTokenToFiat(withdrawalAmountInTokens, _principalDecimals, tokenPriceInFiat);
        spent += withdrawalAmountInFiat;

        // The interest-only amount that needs to be paid on each payment cycle
        uint256 interestOnlyAmount = spent * _apr * _paymentIntervalInSeconds / 1e4 / 365 days;
        _remainingDebt = spent + interestOnlyAmount + fixedFeeInFiat;

        // Transfer the funds
        uint256 currentBalanceAtBorrower = principalTokenInterface.balanceOf(borrower);
        uint256 newBalanceAtBorrower = currentBalanceAtBorrower + withdrawalAmountInTokens;
        uint256 newBalanceAtContract = currentBalanceAtContract - withdrawalAmountInTokens;

        principalTokenInterface.transfer(borrower, withdrawalAmountInTokens);

        require(principalTokenInterface.balanceOf(address(this)) == newBalanceAtContract, "Balance check failed");
        require(principalTokenInterface.balanceOf(borrower) == newBalanceAtBorrower, "Borrower transfer check failed");
    }

    /**
     * @notice Repays the debt of the borrower.
     * @param paymentAmountInTokens The payment amount, in tokens
     */
    function repay (uint256 paymentAmountInTokens) public onlyBorrower ifNotDefaulted {
        require(loanState == ACTIVE, "Invalid loan state");
        require(paymentAmountInTokens > 0, "Payment amount required");

        // Enforce the maintenance collateral ratio, if needed
        _enforceMaintenanceRatio();

        // The current price of the principal token, in FIAT
        uint256 tokenPriceInFiat = IBasicPriceOracle(priceOracle).getTokenPrice(principalToken);
        require(tokenPriceInFiat > 0, "Invalid token price");

        // The deposit amount converted to FIAT
        uint256 depositAmountInFiat = fromTokenToFiat(paymentAmountInTokens, _principalDecimals, tokenPriceInFiat);

        uint256 ts = block.timestamp; // solhint-disable-line not-rely-on-time

        // The payment amount (in FIAT) required to be deposited in this contract, including any late fees
        uint256 paymentAmountWithFeesInFiat = getPaymentAmountWithFees();
        require(depositAmountInFiat == paymentAmountWithFeesInFiat, "Invalid payment amount");

        _remainingDebt = 0;
        spent = 0;
        _nextPaymentDate = ts + _paymentIntervalInSeconds;

        // Make the payment (safe transfer from the sender to this contract)
        _depositToken(IERC20NonCompliant(principalToken), msg.sender, paymentAmountInTokens);

        IERC20NonCompliant(principalToken).transfer(lender, paymentAmountInTokens);
    }

    /**
     * @notice Terminates the loan.
     */
    function terminate () public onlyLender {
        require(loanState == ACTIVE, "Invalid loan state");

        // State changes
        loanState = TERMINATED;
        _liquidateAssets();
    }

    function getPaymentAmountWithoutFees () public view override returns (uint256) {
        return _remainingDebt;
    }

    // Indicates if the payment interval specified is supported
    function _isValidPaymentInterval (uint256 newPaymentIntervalInSeconds) internal pure override returns (bool) {
        return (newPaymentIntervalInSeconds == PAYMENT_INTERVAL_MONTHLY);
    }
}
