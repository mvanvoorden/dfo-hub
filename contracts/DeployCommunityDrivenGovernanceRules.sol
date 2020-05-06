/* Description:
 * DFOHub - Setup the Community-Driven Governance.
 * This specific DFOHub functionality is called when choosing to create a DFO with this specific governance model.
 * The Functionality Manager is created using the Open Basic governance rules, which is the standard.
 * The new StateHolder is filled up with the number of Voting Tokens.
 * Every proposer will automatically receive Tokens in case of a Successful Proposal Survey.
 * To let every proposer receive its eventual reward, the proposalEnd well-known functionality is also set up.
 * It will be triggered every time a new Proposal Survey ends and will execute the reward business logic.
 */
/* Discussion:
 * https://gitcoin.co/grants/154/decentralized-flexible-organization
 */
pragma solidity ^0.6.0;

contract DeployCommunityDrivenGovernanceRules {

    address private _sourceLocation = 0x9784B427Ecb5275c9300eA34AdEF57923Ab170af;

    uint256 private _communityDrivenGovernanceLocationId = 48;
    address private _communityDrivenGovernanceFunctionalityAddress = 0x6FF93F88dE579c4e158b772eA680573c7A012F08;

    uint256 private _getSurveySingleRewardSourceLocationId = 49;

    function onStart(address newSurvey, address oldSurvey) public {
    }

    function onStop(address newSurvey) public {
    }

    function deployCommunityDrivenGovernanceRules(
        address sender, uint256 value,
        uint256 minimumBlockNumber,
        uint256 emergencyBlockNumber,
        uint256 emergencyStaking,
        uint256 quorum,
        uint256 surveySingleReward) public returns (IMVDFunctionalitiesManager mvdFunctionalitiesManager) {
        (mvdFunctionalitiesManager = IMVDFunctionalitiesManager(abi.decode(IMVDProxy(msg.sender).submit("deployOpenBasicGovernanceRules", abi.encode(
            address(0),
            0,
            minimumBlockNumber,
            emergencyBlockNumber,
            emergencyStaking,
            quorum)), (address))))
            .addFunctionality("proposalEnd", _sourceLocation, _communityDrivenGovernanceLocationId, _communityDrivenGovernanceFunctionalityAddress, true, "proposalEnd(address,bool)", "[]", false, false);
            mvdFunctionalitiesManager.addFunctionality("getSurveySingleReward", _sourceLocation, _getSurveySingleRewardSourceLocationId, address(new GetUint256Value(surveySingleReward * (10 ** 18))), false, "getValue()", '["uint256"]', false, false);
    }
}

interface IMVDProxy {
    function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
}

interface IMVDFunctionalitiesManager {
    function addFunctionality(string calldata codeName, address sourceLocation, uint256 sourceLocationId, address location, bool submitable, string calldata methodSignature, string calldata returnAbiParametersArray, bool isInternal, bool needsSender) external;
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