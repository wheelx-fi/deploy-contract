// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract WheelXGMContract {
    event WheelXGM(address indexed sender);

    address public immutable recipient;
    uint256 public immutable minimalFee;

    error TransferFailed(bytes data);

    constructor(address _recipient, uint256 _minimalFee) {
        recipient = _recipient;
        minimalFee = _minimalFee;
    }

    function gm() public payable {
        require(msg.value >= minimalFee, "Insufficient fee");

        (bool success, bytes memory data) = recipient.call{value: msg.value}("");
        if (!success) {
            revert TransferFailed(data);
        }

        emit WheelXGM(msg.sender);
    }
}
