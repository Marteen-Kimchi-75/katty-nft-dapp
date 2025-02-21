// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {KattyNft} from "../src/KattyNft.sol";

contract DeployKattyNft is Script {
    string public sleepingKattyUri = "ipfs://bafkreihee7st47hz6vdihjlwlmdiuz37l2p3e5cnmdfo6ercjtj2vp2u6a";
    string public walkingKattyUri = "ipfs://bafkreidpwf5mxe3s42wvuyh2azudzc4pnrh4vxljaslyfqwovhthv2zbym";
    string public dancingKattyUri = "ipfs://bafkreiepevrjcnbphpcwbcuny7d2gjhl2vy4kzty2zdldloap5npr6ygqy";

    function run() external returns (KattyNft){
        vm.startBroadcast();
        KattyNft kattyNft = new KattyNft(sleepingKattyUri, walkingKattyUri, dancingKattyUri);
        vm.stopBroadcast();
        return kattyNft;
    }
}