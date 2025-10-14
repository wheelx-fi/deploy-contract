// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract WheelXGMContract {
    event WheelXGM(address indexed sender);

    address public immutable recipient;
    uint256 public immutable minimalFee;

    constructor(address _recipient, uint256 _minimalFee) {
        recipient = _recipient;
        minimalFee = _minimalFee;
    }

    function deploy() public payable {
        require(msg.value >= minimalFee, "Insufficient fee");

        (bool success, ) = recipient.call{value: msg.value}("");
        require(success, "Fee transfer failed");

        emit WheelXGM(msg.sender);
    }
}

