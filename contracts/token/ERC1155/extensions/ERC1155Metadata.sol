// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC1155/extensions/ERC1155Metadata.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract ERC1155Metadata is Initializable {
    string public name;
    string public symbol;

    function __ERC1155Metadata_init(string memory _name, string memory _symbol) internal onlyInitializing {
        name = _name;
        symbol = _symbol;
    }

    function setMetadata(string memory _name, string memory _symbol) internal {
        name = _name;
        symbol = _symbol;
    }
    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;
}