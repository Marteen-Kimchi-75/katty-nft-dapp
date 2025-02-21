// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";

contract KattyNft is ERC721 {
    /////////////////////////////////
    ///     STATE VARIABLES      ///
    ///////////////////////////////
    string private s_walkingKattyUri;
    string private s_sleepingKattyUri;
    string private s_dancingKattyUri;
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    enum KattyState {
        Walking,
        Sleeping,
        Dancing
    }

    /////////////////////////////////
    ///        FUNCTIONS         ///
    ///////////////////////////////
    constructor(
        string memory walkingKattyUri,
        string memory sleepingKattyUri,
        string memory dancingKattyUri
        ) 
        ERC721("Cute Kat", "Katty")
    {
        s_tokenCounter = 0;
        s_walkingKattyUri = walkingKattyUri;
        s_sleepingKattyUri = sleepingKattyUri;
        s_dancingKattyUri = dancingKattyUri;
    }
}