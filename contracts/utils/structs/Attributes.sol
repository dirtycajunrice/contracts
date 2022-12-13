// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (utils/structs/Attributes.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

/**
* @title Attributes v1.0.0
* @author @DirtyCajunRice
* @dev Attribute storage library for NFTs
*/
library Attributes {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    struct AttributeStore {
        EnumerableSetUpgradeable.UintSet _treeIds;
        // treeId => skillId;
        mapping(uint256 => EnumerableSetUpgradeable.UintSet) _skillIds;
        // tokenId => treeId => skillId => value
        mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))  _values;
        // treeId => skillId => skillValue => name
        mapping(uint256 => mapping(uint256 => mapping(uint256 => string))) _names;
        // treeId => skillId => name
        mapping(uint256 => mapping(uint256 => string)) _skillNames;
        // treeId => name
        mapping(uint256 => string) _treeNames;
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
    function getValue(
        AttributeStore storage store,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId
    ) internal view returns (uint256) {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        return store._values[tokenId][treeId][skillId];
    }

    function getSkillIds(AttributeStore storage store, uint256 treeId) internal view returns (uint256[] memory) {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        return store._skillIds[treeId].values();
    }

    function getTreeIds(AttributeStore storage store) internal view returns (uint256[] memory) {
        return store._treeIds.values();
    }

    function getName(
        AttributeStore storage store,
        uint256 treeId,
        uint256 skillId,
        uint256 value
    ) internal view returns (string memory) {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        return store._names[treeId][skillId][value];
    }

    function getSkillName(
        AttributeStore storage store,
        uint256 treeId,
        uint256 skillId
    ) internal view returns (string memory) {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        return store._skillNames[treeId][skillId];
    }

    function getTreeName(AttributeStore storage store, uint256 treeId) internal view returns (string memory) {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        return store._treeNames[treeId];
    }

    /**
    * @dev Update a single skill to value
    *
    * @param tokenId ID of the NFT
    * @param treeId ID of the storage tree
    * @param skillId ID of the skill
    * @param value new skill value
    */
    function setValue(
        AttributeStore storage store,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId,
        uint256 value
    ) internal {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        store._values[tokenId][treeId][skillId] = value;
    }

    function setName(
        AttributeStore storage store,
        uint256 treeId,
        uint256 skillId,
        uint256 value,
        string memory name
    ) internal {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        store._names[treeId][skillId][value] = name;
    }

    function addSkill(AttributeStore storage store, uint256 treeId, uint256 skillId, string memory name) internal {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].add(skillId), "Attributes::SkillId already exists");
        store._skillNames[treeId][skillId] = name;
    }

    function setSkillName(AttributeStore storage store, uint256 treeId, uint256 skillId, string memory name) internal {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        require(store._skillIds[treeId].contains(skillId), "Attributes::Non-existent skillId");
        store._skillNames[treeId][skillId] = name;
    }

    function addTree(AttributeStore storage store, uint256 treeId, string memory name) internal {
        require(store._treeIds.add(treeId), "Attributes::TreeId already exists");
        store._treeNames[treeId] = name;
    }

    function setTreeName(AttributeStore storage store, uint256 treeId, string memory name) internal {
        require(store._treeIds.contains(treeId), "Attributes::Non-existent treeId");
        store._treeNames[treeId] = name;
    }

    struct StringStore {
        EnumerableSetUpgradeable.UintSet _stringIds;
        // tokenId > stringId  > value
        mapping(uint256 => mapping(uint256 => string))  _values;
        // stringId > name
        mapping(uint256 => string)  _names;
        // tokenId > name
        mapping(uint256 => string)  _tokenNames;
    }

    function getValue(
        StringStore storage store,
        uint256 tokenId,
        uint256 stringId
    ) internal view returns (string memory) {
        require(store._stringIds.contains(stringId), "Attributes::Non-existent stringId");
        return store._values[tokenId][stringId];
    }

    function getName(StringStore storage store, uint256 stringId) internal view returns (string memory) {
        require(store._stringIds.contains(stringId), "Attributes::Non-existent stringId");
        return store._names[stringId];
    }

    function getStringIds(StringStore storage store) internal view returns (uint256[] memory) {
        return store._stringIds.values();
    }

    function getTokenName(StringStore storage store, uint256 tokenId) internal view returns (string memory) {
        return store._tokenNames[tokenId];
    }

    function setValue(StringStore storage store, uint256 tokenId, uint256 stringId, string memory value) internal {
        require(store._stringIds.contains(stringId), "Attributes::Non-existent stringId");
        store._values[tokenId][stringId] = value;
    }

    function setName(StringStore storage store, uint256 stringId, string memory value) internal {
        require(store._stringIds.contains(stringId), "Attributes::Non-existent stringId");
        store._names[stringId] = value;
    }

    function setTokenName(StringStore storage store, uint256 tokenId, string memory value) internal {
        store._names[tokenId] = value;
    }
}