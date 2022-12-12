// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC721/extensions/ERC721URITokenJSON.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721BurnableV2 is Initializable, ERC721BurnableUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    EnumerableSetUpgradeable.UintSet private _burned;

    function __ERC721BurnableV2_init() internal onlyInitializing {
        __ERC721Burnable_init();
    }

    function __ERC721BurnableV2_init_unchained() internal onlyInitializing {
    }

    function burn(uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721BurnableV2: caller is not token owner nor approved");
        _burned.add(tokenId);
        super._burn(tokenId);
    }



    function _removeBurnedId(uint256 tokenId) internal virtual {
        _burned.remove(tokenId);
    }

    uint256[49] private __gap;
}