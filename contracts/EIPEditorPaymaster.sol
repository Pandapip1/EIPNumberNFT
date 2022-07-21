//SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol";
import "@opengsn/gsn/contracts/BasePaymaster.sol";

/// A paymaster that pays for everything done by EIP Editors
contract EIPEditorPaymaster is BasePaymaster {
    ERC721Enumerable public eipEditorNFT;

    constructor (ERC721Enumerable _eipEditorNFT)  {
        eipEditorNFT = _eipEditorNFT;
    }

    function versionPaymaster() external view override virtual returns (string memory){
        return "2.2.0+pandapip1.eipnumbernft.eipeditorpaymaster";
    }

    function preRelayedCall(
        GsnTypes.RelayRequest calldata relayRequest,
        bytes calldata signature,
        bytes calldata approvalData,
        uint256 maxPossibleGas
    )
    external
    override
    virtual
    returns (bytes memory context, bool revertOnRecipientRevert) {
        require(eipEditorNFT.balanceOf(relayRequest.sender) > 0);
        return ("", false);
    }

    function postRelayedCall(
        bytes calldata context,
        bool success,
        uint256 gasUseWithoutPost,
        GsnTypes.RelayData calldata relayData
    ) external override virtual {
        (context, success, gasUseWithoutPost, relayData);
    }
}