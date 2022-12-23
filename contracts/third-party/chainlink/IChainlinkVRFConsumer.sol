// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IChainlinkVRFConsumerBase.sol";

interface IChainlinkVRFConsumer {

    struct Request {
        uint256 id;
        uint256[] links;
        uint256[] words;
    }

    function fulfillRandomWords(uint256 id, uint256[] memory words) external;
    function requestOf(address requester) external view returns (Request memory);
}