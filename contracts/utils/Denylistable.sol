// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (utils/Denylistable.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title Denylistable v1.0.0
* @author @DirtyCajunRice
*/
abstract contract Denylistable is Initializable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    EnumerableSetUpgradeable.AddressSet private _denylist;

    modifier notDenylisted(address user) {
        require(!_denylist.contains(user), "Denylistable::Denylisted address");
        _;
    }

    function __Denylistable_init() internal onlyInitializing {
    }

    function _addDenylisted(address user) internal virtual {
        _denylist.add(user);
    }

    function _removeDenylisted(address user) internal virtual {
        _denylist.remove(user);
    }

    function isDenylisted(address user) public view virtual returns(bool) {
        return _denylist.contains(user);
    }

    function denylisted() public view virtual returns(address[] memory) {
        return _denylist.values();
    }

    uint256[49] private __gap;
}