// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./IChainlinkVRFConsumerBase.sol";

abstract contract ChainlinkVRFConsumerBase is Initializable, ERC165Upgradeable {
    address private _coordinator;

    modifier onlyCoordinator() {
        require(msg.sender == _coordinator, "ChainlinkVRFConsumerBase::Only coordinator can fulfill");
        _;
    }

    /**
    * @param coordinator address of ChainlinkVRFCoordinator contract
    */
    function __ChainlinkVRFConsumerBase_init(address coordinator) internal onlyInitializing {
        __ERC165_init();
        require(coordinator != address(0), "ChainlinkVRFConsumerBase::Coordinator zero address");
        _coordinator = coordinator;
    }

    /**
    * @notice _fulfillRandom handles the VRF response. Your contract must implement it.
    *
    * @dev ChainlinkVRFConsumerBase expects its subcontracts to have a method with this
    * @dev signature, and will call it once it has verified the proof
    * @dev associated with the randomness. (It is triggered via a call to
    * @dev rawFulfillRandomness, below.)
    *
    * @param id The Id initially returned by requestRandomness
    * @param words the VRF output expanded to the requested number of words
    */
    function _fulfillRandom(uint256 id, uint256[] memory words) internal virtual;

    // rawFulfillRandomWords is called by VRFCoordinator when it receives a valid VRF
    // proof. rawFulfillRandomWords then calls _fulfillRandom, after validating
    // the origin of the call
    function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external onlyCoordinator {
        _fulfillRandom(requestId, randomWords);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable) returns (bool) {
        return interfaceId == type(IChainlinkVRFConsumerBase).interfaceId || super.supportsInterface(interfaceId);
    }

    uint256[49] private __gap;
}