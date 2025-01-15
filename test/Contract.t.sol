// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/StakingContract.sol";
import "src/StakingContractV2.sol";
import "src/ProxyContract.sol";

contract TestContract is Test {
    StakingContract c;
    StakingContractV2 c2;
    ProxyContract p;

    function setUp() public {
        c = new StakingContract();
        c2 = new StakingContractV2();
        p = new ProxyContract(address(c2));

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

    function testStake2() public{
        uint val = 10 ether;
        vm.deal(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6, val);
        vm.prank(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6);
        (bool success, ) = address(p).call{value:val}(abi.encodeWithSignature("stake()"));
        assert(success);
        // (bool success2, bytes memory data) = address(p).delegatecall(abi.encodeWithSignature("totalStake()"));
        // assert(success2);
        // console.logBytes(data);
        // uint currentStake = abi.decode(data, (uint256));
        // console.log(currentStake);
        uint total = p.totalStake();
        assert(total == val);
    }

    function testUnStake2() public{
        uint val = 10 ether;
        vm.startPrank(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6);
        vm.deal(0xAfc8bE1D5F0Be644F683f8b3F7Eb140F0f7233a6,val);
        (bool success, ) = address(p).call{value:val}(abi.encodeWithSignature("stake()"));
        assert(success);
        (bool success1, ) = address(p).call(abi.encodeWithSignature("unStake(uint256)",val));
        assert(success);
        assert(p.totalStake() == 0);
    }
}
