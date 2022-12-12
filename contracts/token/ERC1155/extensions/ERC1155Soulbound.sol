// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (token/ERC1155/extensions/ERC1155Soulbound.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/structs/BitMapsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title ERC1155 Soulbound v1.0.0
* @author @DirtyCajunRice
* @dev Contract to conditionally lock tokens to wallets
*/
abstract contract ERC1155Soulbound is Initializable, ERC1155Upgradeable {
     using BitMapsUpgradeable for BitMapsUpgradeable.BitMap;

    BitMapsUpgradeable.BitMap private _soulbound;
    // 0 / 1 (false, true) on whether to consider the soulboundExemption function
    bool private useExemptionFunction;

    modifier notSoulbound(uint256[] memory tokenIds, address from, address to) {
        // Allow minting & burning
        if (from != address(0) && to != address(0)) {
            for (uint256 i = 0; i < tokenIds.length; i++) {
                bool allowed = !_soulbound.get(tokenIds[i]);
                if (useExemptionFunction) {
                    allowed = allowed || soulboundExemption(tokenIds, from, to);
                }
                require(allowed, "ERC1155Soulbound::Token is soulbound");
            }
        }
        _;
    }
    function __ERC1155Soulbound_init(bool _useExemptionFunction) internal onlyInitializing {
        useExemptionFunction = _useExemptionFunction;
    }

    //
    function soulboundExemption(
        uint256[] memory, // tokenIds
        address, // from
        address // to
    ) internal virtual returns (bool) {
       return false;
    }

    function setSoulbound(uint256 tokenId) internal {
        _soulbound.set(tokenId);
    }

    function unsetSoulbound(uint256 tokenId) internal {
        _soulbound.unset(tokenId);
    }

    function isSoulbound(uint256 tokenId) public view returns (bool) {
        return _soulbound.get(tokenId);
    }

    function setUseExemptions(bool _useExemptionFunction) internal {
        useExemptionFunction = _useExemptionFunction;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal notSoulbound(ids, from, to) override(ERC1155Upgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    uint256[46] private __gap;
}