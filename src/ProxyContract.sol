// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


contract ProxyContract {
    address implementation;
    mapping (address => uint) stakeBalances;
    uint public totalStake;
    constructor(address _implementation){
        implementation = _implementation;
    }

    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
        require(success, "Delegate call failed");
    }

    function setImplementation(address _implementation) public{
        implementation = _implementation;
    }
}