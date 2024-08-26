// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmoundFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $ (have a minimum $ sent)
        require(msg.value.getConversionRate() > minimumUsd, "Not enough USD sent");
        funders.push(msg.sender);
        addressToAmoundFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) 
        {
            address funder = funders[funderIndex];
            addressToAmoundFunded[funder] = 0;
        }

        // Reset the array
        funders = new address[](0);

        // Actually withdraw funds

        // // transfer: Reverts if the tx fails (2300 gas cap)
        // payable(msg.sender).transfer(address(this).balance); // msg.sender is of type address; sending native currencies requires a payable address, hence the type casting

        // // send: Doesn't revert by itself, returns a bool (2300 gas cap)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed"); // Revert if send fails

        // Recommended way to send/receive native currencies (ETH, AVAX, etc.)
        // call: Doesn't revert by itself, returns a bool and a bytes object (unused) (no gas cap)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed"); // Revert if call fails
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner to perform this action");
        _; // Order of the underscore matters; determines where the contents of the function with this modifier executes
    }
}