// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC1155/extensions/ERC1155AttributeStorage.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title ERC1155 Attribute Storage v1.0.0
* @author @DirtyCajunRice
* @dev On chain storage contract for NFT Metadata
*/
abstract contract ERC1155AttributeStorage is Initializable {
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToUintMap;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    // tokenId > attributeId > value
    mapping(uint256 => EnumerableMapUpgradeable.UintToUintMap) private _store;
    // tokenId > attributeId > name
    // id 1000 is always name, and id 1001 is always description, which do not map to _store
    mapping(uint256 => mapping(uint256 => string)) private _storeNames;

    event ValueUpdated(uint256 indexed tokenId, uint256 attributeId, uint256 value);
    event ValuesUpdated(uint256 indexed tokenId, uint256[] attributeIds, uint256[] values);
    event NameUpdated(uint256 indexed tokenId, uint256 attributeId, string name);
    event NamesUpdated(uint256 indexed tokenId, uint256[] attributeIds, string[] names);

    function __ERC1155AttributeStorage_init() internal onlyInitializing {
    }


    function _setAttribute(uint256 tokenId, uint256 attributeId, uint256 value) internal {
        _store[tokenId].set(attributeId, value);
        emit ValueUpdated(tokenId, attributeId, value);
    }

    function _batchSetAttribute(
        uint256 tokenId,
        uint256[] memory attributeIds,
        uint256[] memory values
    ) internal {
        for (uint256 i = 0; i < attributeIds.length; i++) {
            _store[tokenId].set(attributeIds[i], values[i]);
        }
        emit ValuesUpdated(tokenId, attributeIds, values);
    }

    function getAttribute(uint256 tokenId, uint256 attributeId) public view returns (uint256) {
        return _store[tokenId].get(attributeId);
    }


    function batchGetAttribute(uint256 tokenId, uint256[] memory attributeIds) public view returns (uint256[] memory) {
        uint256[] memory attributes = new uint256[](attributeIds.length);
        for (uint256 i = 0; i < attributeIds.length; i++) {
            attributes[i] = _store[tokenId].get(attributeIds[i]);
        }
        return attributes;
    }

    function _getAllAttributes(uint256 tokenId) internal view returns (uint256[] memory, uint256[] memory, string[] memory) {
        uint256 count = _store[tokenId].length();
        uint256[] memory attributeIds = new uint256[](count);
        uint256[] memory attributeValues = new uint256[](count);
        string[] memory attributeNames = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            (attributeIds[i], attributeValues[i]) = _store[tokenId].at(i);
            attributeNames[i] = _storeNames[tokenId][attributeIds[i]];
        }
        return (attributeIds, attributeValues, attributeNames);
    }

    function _getAttributeName(uint256 tokenId, uint256 attributeId) internal view returns (string memory) {
        return _storeNames[tokenId][attributeId];
    }
    function _batchGetAttributeName(uint256 tokenId, uint256[] memory attributeIds) internal view returns (string[] memory) {
        string[] memory attributeNames = new string[](attributeIds.length);
        for (uint256 i = 0; i < attributeIds.length; i++) {
            attributeNames[i] = _storeNames[tokenId][attributeIds[i]];
        }
        return attributeNames;
    }

    function _setAttributeName(
        uint256 tokenId,
        uint256 attributeId,
        string memory name
    ) internal {
        _storeNames[tokenId][attributeId] = name;
        emit NameUpdated(tokenId, attributeId, name);
    }

    function _batchSetAttributeNameOf(
        uint256 tokenId,
        uint256[] memory attributeIds,
        string[] memory names
    ) internal {
        for (uint256 i = 0; i < attributeIds.length; i++) {
            _storeNames[tokenId][attributeIds[i]] = names[i];
        }
        emit NamesUpdated(tokenId, attributeIds, names);
    }

    function _batchSetAttributeName(
        uint256[] calldata tokenIds,
        uint256[] calldata attributeIds,
        string[] calldata names
    ) internal {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _storeNames[tokenIds[i]][attributeIds[i]] = names[i];
        }
    }
    uint256[48] private __gap;
}