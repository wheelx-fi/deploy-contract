// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MinimalContract {
    // 一个最简单的合约，只包含一个空函数
    function initialize() public {}
}

contract Deployer {
    event ContractCreated(address indexed contractAddress);

    address public immutable recipient;
    uint256 public immutable minimalFee;
    mapping(address => uint256) public counts;

    constructor(address _recipient, uint256 _minimalFee) {
        recipient = _recipient;
        minimalFee = _minimalFee;
    }

    function deploy() public payable {
        require(msg.value >= minimalFee, "Insufficient fee");

        (bool success, ) = recipient.call{value: msg.value}("");
        require(success, "Fee transfer failed");

        MinimalContract newContract = new MinimalContract();
        newContract.initialize();

        emit ContractCreated(address(newContract));
        counts[msg.sender]++;
    }
}

