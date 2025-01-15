// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingContract.sol";

contract TestContract is Test {
    StakingContract c;

    function setUp() public {
        c = new StakingContract();
    }

    function testStake() public{
        uint val = 10 ether;
        c.stake{value: val}();
        assert(c.totalStake() == val);
    }

    function testUnStake() public{
        uint val = 10 ether;
        vm.startPrank(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6);
        vm.deal(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6,val);
        c.stake{value: val}();
        c.unStake(val);
        assert(c.totalStake() == 0);
    }
}
