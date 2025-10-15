// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract WheelXGMContract {
    event WheelXGM(address indexed sender);

    address public immutable recipient;
    uint256 public immutable minimalFee;

    mapping(address => uint256) public dates;

    error TransferFailed(bytes data);
    error AlreadyGmToday();

    constructor(address _recipient, uint256 _minimalFee) {
        recipient = _recipient;
        minimalFee = _minimalFee;
    }

    function gm() public payable {
        require(msg.value >= minimalFee, "Insufficient fee");

        // convert timestamp to date
        uint date = block.timestamp / 86400;
        if (dates[msg.sender] == date) {
            revert AlreadyGmToday();
        }
        dates[msg.sender] = date;

        (bool success, bytes memory data) = recipient.call{value: msg.value}("");
        if (!success) {
            revert TransferFailed(data);
        }

        emit WheelXGM(msg.sender);
    }
}
