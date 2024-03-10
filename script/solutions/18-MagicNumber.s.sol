// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here

contract MagicNumberSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x2132C7bc11De7A90B87375f282d36100a29f97a9;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        bytes memory code = "\x69\x60\x2a\x60\x00\x52\x60\x20\x60\x00\xf3\x60\x00\x52\x60\x0a\x60\x16\xf3";
        address solver;
        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }

        challengeInstance.call(abi.encodeWithSignature("setSolver(address)", address(solver)));

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(18));
    }
}
