// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
import { DenialAttacker } from  "../../src/20-DenialAttacker.sol";

contract DenialSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x2427aF06f748A6adb651aCaB0cA8FbC7EaF802e6;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = 0xf5Bae522910CAf85E8a1B659DBc0e20BF41254A5; // Hard coding

        // YOUR SOLUTION HERE
        DenialAttacker attacker = new DenialAttacker(challengeInstance);
        attacker.attack();

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(20));
    }
}
