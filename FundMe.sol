// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmoundFunded;

    function fund() public payable {
        // Allow users to send $ (have a minimum $ sent)
        require(msg.value.getConversionRate() > minimumUsd, "Not enough USD sent");
        funders.push(msg.sender);
        addressToAmoundFunded[msg.sender] += msg.value;
    }
}