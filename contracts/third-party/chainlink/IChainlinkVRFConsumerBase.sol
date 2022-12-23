// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

interface IChainlinkVRFConsumerBase is IERC165Upgradeable {
    function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external;
}