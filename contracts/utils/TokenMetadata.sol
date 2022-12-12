// SPDX-License-Identifier: MIT
// DirtyCajunRice Contracts (last updated v1.0.0) (utils/TokenMetadata.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

/**
 * @dev Metadata operations.
 */
library TokenMetadata {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;
    using Base64Upgradeable for bytes;
    using TokenMetadata for TokenType;
    using TokenMetadata for Attribute[];

    enum TokenType {
        ERC20,
        ERC1155,
        ERC721
    }

    struct Attribute {
        string name;
        string displayType;
        string value;
        bool isNumber;
    }

    function toBase64(string memory json) internal pure returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", bytes(json).encode()));
    }

    function makeMetadataJSON(
        uint256 tokenId,
        address owner,
        string memory name,
        string memory imageURI,
        string memory description,
        TokenType tokenType,
        Attribute[] memory attributes
    ) internal pure returns(string memory) {
        string memory metadataJSON = makeMetadataString(tokenId, owner, name, imageURI, description, tokenType);
        return string(abi.encodePacked('{', metadataJSON, attributes.toJSONString(), '}'));
    }

    function makeMetadataString(
        uint256 tokenId,
        address owner,
        string memory name,
        string memory imageURI,
        string memory description,
        TokenType tokenType
    ) internal pure returns(string memory) {
        return string(abi.encodePacked(
                '"name":"', name, '",',
                '"tokenId":"', tokenId.toString(), '",',
                '"description":"', description, '",',
                '"image":"', imageURI, '",',
                '"owner":"', owner.toHexString(), '",',
                '"type":"', tokenType.toString(), '",'
            ));
    }

    function toJSONString(Attribute[] memory attributes) internal pure returns(string memory) {
        string memory attributeString = "";
        for (uint256 i = 0; i < attributes.length; i++) {
            string memory comma = i == (attributes.length - 1) ? '' : ',';
            string memory quote = attributes[i].isNumber ? '' : '"';
            string memory value = string(abi.encodePacked(quote, attributes[i].value, quote));
            string memory displayType = bytes(attributes[i].displayType).length == 0
            ? ''
            : string(abi.encodePacked('"display_type":"', attributes[i].displayType, '",'));
            string memory newAttributeString = string(
                abi.encodePacked(
                    attributeString,
                    '{"trait_type":"', attributes[i].name, '",', displayType, '"value":', value, '}',
                    comma
                )
            );
            attributeString = newAttributeString;
        }
        return string(abi.encodePacked('"attributes":[', attributeString, ']'));
    }

    function toString(TokenType tokenType) internal pure returns(string memory) {
        return tokenType == TokenType.ERC721 ? "ERC721" : tokenType == TokenType.ERC1155 ? "ERC1155" : "ERC20";
    }

    function makeContractURI(
        string memory name,
        string memory description,
        string memory imageURL,
        string memory externalLinkURL,
        uint256 sellerFeeBasisPoints,
        address feeRecipient
    ) internal pure returns(string memory) {
        return string(abi.encodePacked(
                '{"name":"', name, '",',
                '"description":"', description, '",',
                '"image":"', imageURL, '",',
                '"external_link":"', externalLinkURL, '",',
                '"seller_fee_basis_points":', sellerFeeBasisPoints.toString(), ',',
                '"fee_recipient":"', feeRecipient.toHexString(), '"}'
            ));
    }
}