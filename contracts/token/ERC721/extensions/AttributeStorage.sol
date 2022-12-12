// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC721/extensions/AttributeStorage.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title Attribute Storage v1.0.0
* @author @DirtyCajunRice
* @dev Attribute Storage contract for NFTs
*/
abstract contract AttributeStorage is Initializable {

    // tokenId > treeId  > skillId > value
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) private _store;
    // treeId > skillId > value
    mapping(uint256 => mapping(uint256 => string)) private _storeNames;
    // tokenId > customId  > stringValue
    mapping(uint256 => mapping(uint256 => string)) private _textStore;

    event ValueUpdated(uint256 indexed tokenId, uint256 treeId, uint256 skillId, uint256 value);
    event TextUpdated(uint256 indexed tokenId, uint256 customId, string value);

    function __AttributeStorage_init() internal onlyInitializing {

    }

    /**
    * @dev Update a single skill to value
    *
    * @param tokenId ID of the NFT
    * @param treeId ID of the storage tree
    * @param skillId ID of the skill
    * @param value new skill value
    */
    function _updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) internal {
        _store[tokenId][treeId][skillId] = value;
        emit ValueUpdated(tokenId, treeId, skillId, value);
    }

    function _batchUpdateSkills(
        uint256[] memory tokenIds,
        uint256[] memory treeIds,
        uint256[] memory skillIds,
        uint256[] memory values) internal {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _store[tokenIds[i]][treeIds[i]][skillIds[i]] = values[i];
        }
    }

    function _batchUpdateSkillsOfToken(
        uint256 tokenId,
        uint256 treeId,
        uint256[] memory skillIds,
        uint256[] memory values) internal {
        for (uint256 i = 0; i < skillIds.length; i++) {
            _store[tokenId][treeId][skillIds[i]] = values[i];
        }
    }

    function _updateString(uint256 tokenId, uint256 customId, string memory value) internal {
        _textStore[tokenId][customId] = value;
        emit TextUpdated(tokenId, customId, value);
    }

    function _setSkillName(uint256 treeId, uint256 skillId, string memory name) internal {
        _storeNames[treeId][skillId] = name;
    }

    function _batchSetSkillName(
        uint256 treeId,
        uint256[] memory skillIds,
        string[] memory names
    ) internal {
        for (uint256 i = 0; i < skillIds.length; i++) {
            _storeNames[treeId][skillIds[i]] = names[i];
        }
    }

    /**
    * @dev Get a single skill value
    *
    * @param tokenId ID of the NFT
    * @param treeId ID of the storage tree
    * @param skillId ID of the skill
    *
    * @return value skill value
    */
    function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256) {
        return _store[tokenId][treeId][skillId];
    }

    function getSkillsByTree(
        uint256 tokenId,
        uint256 treeId,
        uint256[] memory skillIds
    ) public view returns (uint256[] memory) {
        uint256[] memory values = new uint256[](skillIds.length);
        for (uint256 i = 0; i < skillIds.length; i++) {
            values[i] = _store[tokenId][treeId][skillIds[i]];
        }
        return values;
    }

    function getString(uint256 tokenId, uint256 customId) public view returns (string memory) {
        return _textStore[tokenId][customId];
    }

    function getStrings(uint256 tokenId, uint256[] memory customIds) public view returns (string[] memory) {
        string[] memory values = new string[](customIds.length);
        for (uint256 i = 0; i < customIds.length; i++) {
            values[i] = _textStore[tokenId][customIds[i]];
        }
        return values;
    }

    function getStringOfTokens(uint256[] memory tokenIds, uint256 customId) public view returns (string[] memory) {
        string[] memory values = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            values[i] = _textStore[tokenIds[i]][customId];
        }
        return values;
    }

    function getSkillName(uint256 treeId, uint256 skillId) public view returns (string memory) {
        return _storeNames[treeId][skillId];
    }

    uint256[47] private __gap;
}