// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC721/extensions/ERC721URITokenJSON.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


/**
 * @dev Extension of {ERC721} that adds a cap to the supply of tokens.
 *
 * @custom:storage-size 51
 */
abstract contract ERC721Capped is Initializable, ERC721EnumerableUpgradeable {
    uint256 private _cap;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    function __ERC721Capped_init(uint256 cap_) internal onlyInitializing {
        __ERC721Capped_init_unchained(cap_);
    }

    function __ERC721Capped_init_unchained(uint256 cap_) internal onlyInitializing {
        require(cap_ > 0, "ERC721Capped::cap is 0");
        _cap = cap_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_mint}.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual override {
        require(ERC721EnumerableUpgradeable.totalSupply() + 1 <= cap(), "ERC721Capped: cap exceeded");
        super._safeMint(to, tokenId);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}