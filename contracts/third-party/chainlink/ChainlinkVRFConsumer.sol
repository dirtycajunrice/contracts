// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import "./ChainlinkVRFConsumerBase.sol";
import "./IChainlinkVRFConsumer.sol";

abstract contract ChainlinkVRFConsumer is Initializable, IChainlinkVRFConsumer, ChainlinkVRFConsumerBase {
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    VRFCoordinatorV2Interface private _coordinator;

    bytes32 private _keyHash;
    uint64 private _subscriptionId;
    uint16 _confirmations;

    // requester address => request
    mapping (address => Request) private _requests;
    EnumerableSetUpgradeable.AddressSet private _requesters;

    // reverse lookup for _requests via request ID;
    EnumerableMapUpgradeable.UintToAddressMap private _idMap;

    function __ChainlinkVRFConsumer_init(
        address coordinator,
        bytes32 keyHash,
        uint64 subscriptionId,
        uint16 confirmations
    ) internal onlyInitializing {
        __ChainlinkVRFConsumerBase_init(coordinator);
        _coordinator = VRFCoordinatorV2Interface(coordinator);
        _subscriptionId = subscriptionId;
        _keyHash = keyHash;
        _confirmations = confirmations;
    }


    function _requestRandom(address requester, uint32 count, uint256[] memory links) internal {
        require(!_requesters.contains(requester), "ChainlinkVRFConsumer::Existing request");
        uint32 gasLimit = (count * 20_000) + 100_000;

        Request storage request = _requests[requester];
        request.id = _coordinator.requestRandomWords(_keyHash, _subscriptionId, _confirmations, gasLimit, count);
        request.links = links;
        _requesters.add(requester);
        _idMap.set(request.id, requester);
    }

    function _fulfillRandom(uint256 id, uint256[] memory words) internal override {
        address requester = _idMap.get(id);
        Request storage request = _requests[requester];
        request.words = words;
        _idMap.remove(id);
    }

    function requestOf(address requester) public view returns (Request memory) {
        require(_requesters.contains(requester), "ChainlinkVRFConsumer::No request");
        return _requests[requester];
    }

    function _consumeRequest(address requester) internal returns (uint256[] memory words, uint256[] memory links) {
        require(_requesters.contains(requester), "ChainlinkVRFConsumer::No request");
        Request storage request = _requests[requester];
        words = request.words;
        links = request.links;
        _requesters.remove(requester);
        delete _requests[requester];
    }

    function _totalPendingRequesters() internal view returns (uint256) {
        return _requesters.length();
    }

    function _allRequests() internal view returns (Request[] memory requests) {
        address[] memory requesters = _requesters.values();
        requests = new Request[](requesters.length);
        for (uint256 i = 0; i < requesters.length; i++) {
            requests[i] = _requests[requesters[i]];
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ChainlinkVRFConsumerBase) returns (bool) {
        return interfaceId == type(IChainlinkVRFConsumer).interfaceId || super.supportsInterface(interfaceId);
    }

    uint256[43] private __gap;
}
