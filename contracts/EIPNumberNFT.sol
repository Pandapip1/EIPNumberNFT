// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./EIPEditorNFT.sol";

contract EIPNumberNFT is ERC721, ERC721Burnable, ERC721Enumerable, ERC721URIStorage, Ownable {
    EIPEditorNFT public eipEditorNFT;
    EIPEditorNFT public multisig;

    uint256 private maximumTokenIdx = 0;

    event Redeemed(uint256 tokenId, uint256 prNum);

    constructor(ERC721Enumerable _eipEditorNFT) ERC721("EIP Number NFT", "EIP#NFT") {
        eipEditorNFT = _eipEditorNFT;
        multisig = _eipEditorNFT.multisig();
    }

    function distributeBatch(uint256 tokensEach) onlyOwner {
        // This is the most optimized I could get this function
        uint256 idx = maximumTokenIdx;
        uint256 numEditors = _eipEditorNFT.totalSupply();
        uint256 maximumJ = idx + tokensEach * numEditors;

        for (uint256 i = 0; i < numEditors; i++) {
            address editor = _eipEditorNFT.ownerOf(_eipEditorNFT.tokenByIndex(i));
            
            for (uint256 j = idx; j < maximumJ; j += numEditors) {
                _mint(editor, j);
            }

            idx++;
            maximumJ++;
        }
        maximumTokenIdx = maximumJ - 1;
    }
    
    function forceBurn(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }

    function redeem(uint256 tokenId, uint256 pr) public {
        require(ownerOf(tokenId) == _msgSender(), "Not authorized");
        emit Redeemed(tokenId, prNum);
        _transfer(_msgSender(), multisig, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
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
