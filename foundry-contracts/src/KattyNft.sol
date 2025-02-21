// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";

contract KattyNft is ERC721 {
    /////////////////////////////////
    ///         ERRORS           ///
    ///////////////////////////////
    error KattyNft__NotEnoughEth(uint256 ethAmount);

    /////////////////////////////////
    ///     STATE VARIABLES      ///
    ///////////////////////////////
    string private s_sleepingKattyUri;
    string private s_walkingKattyUri;
    string private s_dancingKattyUri;
    uint256 private s_tokenCounter;
    
    address public s_owner;

    mapping(uint256 => KattyState) private s_tokenIdToKattyState;
    mapping(uint256 => bool) private _tokenExists;

    uint256 private constant REQUIRED_ETH_AMOUNT = 1e15; // 0.001 ETH

    enum KattyState {
        SLEEPING,
        WALKING,
        DANCING
    }

    /////////////////////////////////
    ///        MODIFIERS         ///
    ///////////////////////////////
    modifier onlyOwner {
        require(msg.sender == s_owner, "Not the owner");
        _;
    }

    /////////////////////////////////
    ///        FUNCTIONS         ///
    ///////////////////////////////
    constructor(
        string memory sleepingKattyUri,
        string memory walkingKattyUri,
        string memory dancingKattyUri
        ) 
        ERC721("Cute Kat", "Katty")
    {
        s_owner = msg.sender;
        s_tokenCounter = 0;
        s_sleepingKattyUri = sleepingKattyUri;
        s_walkingKattyUri = walkingKattyUri;
        s_dancingKattyUri = dancingKattyUri;
    }

    function mintNft() public payable {
        if (msg.value < REQUIRED_ETH_AMOUNT) {
            revert KattyNft__NotEnoughEth(msg.value);
        }
        _safeMint(msg.sender, s_tokenCounter);
        approveUser(msg.sender, s_tokenCounter);
        _tokenExists[s_tokenCounter] = true;
        s_tokenIdToKattyState[s_tokenCounter] = KattyState.SLEEPING;
        s_tokenCounter++;
    }

    function approveUser(address _user, uint256 tokenId) public {
        approve(_user, tokenId);
    }

    function flipKattyState(uint256 tokenId) public {
        address tokenOwner = ownerOf(tokenId);
        _checkAuthorized(tokenOwner, msg.sender, tokenId);

        if(s_tokenIdToKattyState[tokenId] == KattyState.SLEEPING) {
            s_tokenIdToKattyState[tokenId] = KattyState.WALKING;
        } 
        else if (s_tokenIdToKattyState[tokenId] == KattyState.WALKING) {
            s_tokenIdToKattyState[tokenId] = KattyState.DANCING;
        }
        else {
            s_tokenIdToKattyState[tokenId] = KattyState.SLEEPING;
        }
    }

    function withdraw() public onlyOwner {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        if (!success) {
            revert("Withdraw failed");
        }
    }

    function transferOwnership(address _to) public onlyOwner {
        s_owner = _to;
    }

    /////////////////////////////////
    ///      VIEW FUNCTIONS      ///
    ///////////////////////////////
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenExists[tokenId];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (s_tokenIdToKattyState[tokenId] == KattyState.SLEEPING) {
            return s_sleepingKattyUri;
        } else if (s_tokenIdToKattyState[tokenId] == KattyState.WALKING) {
            return s_walkingKattyUri;
        } else {
            return s_dancingKattyUri;
        }
    }
}