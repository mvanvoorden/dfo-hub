/* Description:
 * DFOHub - Setup the Open Basic Governance.
 * This specific DFOHub functionality is called on choosing to create a DFO with this specific governance model.
 * The Functionality Manager uses the 4 basic functionalities provided by the DFO Protocol: the Survey length provider, the emergency Survey length provider, the minimum amount to stake for emergency Surveys, and the Survey result checker.
 * If present, the quorum is also set inside the new StateHolder.
 */
/* Discussion:
 * https://gitcoin.co/grants/154/decentralized-flexible-organization
 */
pragma solidity ^0.6.0;

contract DeployOpenBasicGovernanceRules {

    address private _sourceLocation = 0x6ae6cf934b2BD8c84d932AeE75102Ca2ef1Bf2Ce;

    uint256 private _getMinimumBlockNumberForSurveySourceLocationId = 43;
    uint256 private _getMinimumBlockNumberForEmergencySurveySourceLocationId = 50;
    uint256 private _getEmergencySurveyStakingFunctionalitySourceLocationId = 54;

    uint256 private _surveyResultValidatorSourceLocationId = 41;

    uint256 private _getIndexSourceLocationId = 98;
    uint256 private _getQuorumSourceLocationId = 103;

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function deployOpenBasicGovernanceRules(
        address sender, uint256 value,
        uint256 minimumBlockNumber,
        uint256 emergencyBlockNumber,
        uint256 emergencyStaking,
        uint256 quorum) public returns (IMVDFunctionalitiesManager mvdFunctionalitiesManager) {

        IMVDProxy proxy = IMVDProxy(msg.sender);

        (mvdFunctionalitiesManager = IMVDFunctionalitiesManager(clone(proxy.getMVDFunctionalitiesManagerAddress()))).init(_sourceLocation,
            _getMinimumBlockNumberForSurveySourceLocationId, address(new GetMinimumBlockNumberForSurveyFunctionality(minimumBlockNumber)),
            _getMinimumBlockNumberForEmergencySurveySourceLocationId, address(new GetMinimumBlockNumberForEmergencySurveyFunctionality(emergencyBlockNumber)),
            _getEmergencySurveyStakingFunctionalitySourceLocationId, address(new GetEmergencySurveyStakingFunctionality(emergencyStaking * (10 ** 18))),
            _surveyResultValidatorSourceLocationId, proxy.getFunctionalityAddress("checkSurveyResult"));

        mvdFunctionalitiesManager.addFunctionality("getIndex", _sourceLocation, _getIndexSourceLocationId, proxy.getFunctionalityAddress("getDefaultIndex"), false, "getValue()", '["uint256"]', false, false);

        if(quorum > 0) {
            mvdFunctionalitiesManager.addFunctionality("getQuorum", _sourceLocation, _getQuorumSourceLocationId, address(new GetUint256Value(quorum * (10 ** 18))), false, "getValue()", '["uint256"]', false, false);
        }
        proxy.emitEvent("DFOCollateralContractsCloned(address_indexed,address)", abi.encodePacked(sender), bytes(""), abi.encode(address(mvdFunctionalitiesManager)));
    }

    function clone(address original) private returns(address copy) {
        assembly {
            mstore(0, or(0x5880730000000000000000000000000000000000000000803b80938091923cF3, mul(original, 0x1000000000000000000)))
            copy := create(0, 0, 32)
            switch extcodesize(copy) case 0 { invalid() }
        }
    }
}

interface IMVDProxy {
    function getMVDFunctionalitiesManagerAddress() external view returns(address);
    function getFunctionalityAddress(string calldata codeName) external view returns(address);
    function emitEvent(string calldata eventSignature, bytes calldata firstIndex, bytes calldata secondIndex, bytes calldata data) external;
}

interface IMVDFunctionalitiesManager {
    function init(address sourceLocation,
        uint256 getMinimumBlockNumberSourceLocationId, address getMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencyMinimumBlockNumberSourceLocationId, address getEmergencyMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencySurveyStakingSourceLocationId, address getEmergencySurveyStakingFunctionalityAddress,
        uint256 checkVoteResultSourceLocationId, address checkVoteResultFunctionalityAddress) external;
    function addFunctionality(string calldata codeName, address sourceLocation, uint256 sourceLocationId, address location, bool submitable, string calldata methodSignature, string calldata returnAbiParametersArray, bool isInternal, bool needsSender) external;
}

contract GetMinimumBlockNumberForSurveyFunctionality {

    uint256 private _value;

    constructor(uint256 value) public {
        _value = value;
    }

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function getMinimumBlockNumberForSurvey() public view returns(uint256) {
        return _value;
    }
}

contract GetMinimumBlockNumberForEmergencySurveyFunctionality {

    uint256 private _value;

    constructor(uint256 value) public {
        _value = value;
    }

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function getMinimumBlockNumberForEmergencySurvey() public view returns(uint256) {
        return _value;
    }
}

contract GetEmergencySurveyStakingFunctionality {

    uint256 private _value;

    constructor(uint256 value) public {
        _value = value;
    }

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function getEmergencySurveyStaking() public view returns(uint256) {
        return _value;
    }
}

contract GetUint256Value {

    uint256 private _value;

    constructor(uint256 value) public {
        _value = value;
    }

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function getValue() public view returns(uint256) {
        return _value;
    }
}