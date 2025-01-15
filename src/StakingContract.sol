// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract {

    mapping (address => uint) stakeBalances;
    uint public totalStake;
    constructor(){

    }

    function stake() public payable{
        require(msg.value > 0);
        stakeBalances[msg.sender] += msg.value;
        totalStake += msg.value;
    }

    function unStake(uint amount) public{
        uint currentStake = stakeBalances[msg.sender];
        require(amount <= currentStake);
        payable(address(msg.sender)).transfer(amount / 2);
        stakeBalances[msg.sender] -= amount;
        totalStake -= amount;
    }
}
