pragma solidity >=0.4.22 <0.9.0;

abstract contract Setter {
    function modifyParameters(bytes32, uint256) external virtual;
    function modifyParameters(bytes32, int256) external virtual;
    function modifyParameters(bytes32, address) external virtual;
    function modifyParameters(bytes32, bytes32, address) external virtual;
    function modifyParameters(address, bytes32, uint) virtual external;
    function modifyParameters(address, bytes32, address) virtual external;
    function modifyParameters(address, bytes4, bytes32, uint256) virtual external;
    function connectSAFESaviour(address) virtual external;
    function disconnectSAFESaviour(address) virtual external;
    function transferERC20(address, address, uint256) external virtual;
    function restartRedemptionRate() virtual external;
    function changePriceSource(address) virtual external;
    function updateResult(uint256) virtual external;
    function addFundingReceiver(address, bytes4, uint256, uint256, uint256) virtual external;
    function addFundingReceiver(address, bytes4, uint256, uint256, uint256, uint256) virtual external;
    function removeFundingReceiver(address, bytes4) virtual external;
    function addRewardAdjuster(address) virtual external;
    function removeRewardAdjuster(address) virtual external;
    function addFundedFunction(address, bytes4, uint256) virtual external;
    function removeFundedFunction(address, bytes4) virtual external;
    function createStream(address, uint256, address, uint256, uint256) virtual external;
    function cancelStream() virtual external;
    function mint() virtual external;
}

// @notice Contract to be used by GEB DAO allowing changes in all RAI parameters that were not ungoerned
// @dev Supposed to be delegatecalled into by the RAI Ungovernor
contract GebDaoGovernanceActions {

    function modifyParameters(address target, bytes32 param, uint256 val) external {
        Setter(target).modifyParameters(param, val);
    }

    function modifyParameters(address target, bytes32 param, int256 val) external {
        Setter(target).modifyParameters(param, val);
    }

    function modifyParameters(address target, bytes32 param, address val) external {
        Setter(target).modifyParameters(param, val);
    }

    function modifyParameters(address target, bytes32 collateralType, bytes32 parameter, address data) external {
        Setter(target).modifyParameters(collateralType, parameter, data);
    }

    function modifyParameters(address target, address reimburser, bytes32 parameter, uint256 data) external {
        Setter(target).modifyParameters(reimburser, parameter, data);
    }

    function modifyParameters(address target, address reimburser, bytes32 parameter, address data) external {
        Setter(target).modifyParameters(reimburser, parameter, data);
    }

    function modifyParameters(address target, address fundingTarget, bytes4 fundedFunction, bytes32 parameter, uint256 data) external {
        Setter(target).modifyParameters(fundingTarget, fundedFunction, parameter, data);
    }

    function connectSAFESaviour(address target, address saviour) external {
        Setter(target).connectSAFESaviour(saviour);
    }

    function disconnectSAFESaviour(address target, address saviour) external {
        Setter(target).disconnectSAFESaviour(saviour);
    }

    function transferERC20(address target, address token, address dst, uint256 amount) external {
        Setter(target).transferERC20(token, dst, amount);
    }

    function restartRedemptionRate(address target) external {
        Setter(target).restartRedemptionRate();
    }

    function changePriceSource(address target, address source) external {
        Setter(target).changePriceSource(source);
    }

    function updateResult(address target, uint256 result) external {
        Setter(target).updateResult(result);
    }

    function addFundingReceiver(
        address target,
        address receiver,
        bytes4  targetFunctionSignature,
        uint256 updateDelay,
        uint256 gasAmountForExecution,
        uint256 fixedRewardMultiplier
    ) external {
        Setter(target).addFundingReceiver(
            receiver,
            targetFunctionSignature,
            updateDelay,
            gasAmountForExecution,
            fixedRewardMultiplier
        );
    }

    function addFundingReceiver(
        address target,
        address receiver,
        bytes4  targetFunctionSignature,
        uint256 updateDelay,
        uint256 gasAmountForExecution,
        uint256 baseRewardMultiplier,
        uint256 maxRewardMultiplier
    ) external {
        Setter(target).addFundingReceiver(
            receiver,
            targetFunctionSignature,
            updateDelay,
            gasAmountForExecution,
            baseRewardMultiplier,
            maxRewardMultiplier
        );
    }

    function removeFundingReceiver(address target, address receiver, bytes4  targetFunctionSignature) external {
        Setter(target).removeFundingReceiver(receiver,targetFunctionSignature);
    }

    function addRewardAdjuster(address target, address adjuster) external {
        Setter(target).addRewardAdjuster(adjuster);
    }

    function removeRewardAdjuster(address target, address adjuster) external {
        Setter(target).removeRewardAdjuster(adjuster);
    }

    function addFundedFunction(address target, address targetContract, bytes4 targetFunction, uint256 latestExpectedCalls) external {
        Setter(target).addFundedFunction(targetContract, targetFunction, latestExpectedCalls);
    }

    function removeFundedFunction(address target, address targetContract, bytes4 targetFunction) external {
        Setter(target).removeFundedFunction(targetContract, targetFunction);
    }

    function createStream(
        address target,
        address recipient,
        uint256 deposit,
        address tokenAddress,
        uint256 startTime,
        uint256 stopTime
    ) external {
        Setter(target).createStream(recipient, deposit, tokenAddress, startTime, stopTime);
    }

    function cancelStream(address target) external {
        Setter(target).cancelStream();
    }

    function mint(address target) external {
        Setter(target).mint();
    }
}
