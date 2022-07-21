// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./EIPEditorGovernor.sol";
import "./EIPNumberNFT.sol";
import "./EIPEditorPaymaster.sol";

contract EIPEditorToken is ERC721, ERC721Enumerable, ERC721Burnable, Ownable, EIP712, ERC721Votes {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    EIPEditorGovernor public multisig;
    EIPNumberNFT public eipNumberNft;
    EIPEditorPaymaster eipEditorPaymaster;

    constructor()
        ERC721("EIP Editor Token", "EIP-EDITOR")
        EIP712("EIP Editor Token", "1")
    {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_msgSender(), tokenId); // Immediately make the _msgSender() dictator :)

        multisig = new EIPEditorGovernor(this);
        _transferOwnership(multisig); // Make the multisig the owner of the contract

        eipNumberNft = new EIPNumberNFT(this);
        eipEditorPaymaster = new EIPEditorPaymaster(this);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function burnFrom(address from) public onlyOwner {
        _burn(tokenOfOwnerByIndex(from, 0));
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}