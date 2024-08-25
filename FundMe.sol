// SPDX-License-Identifier: MIT
pragma solidity *0.8.18;

contract FundMe {
    function fund() public payable {
        // Allow users to send $ (have a minimum $ sent)
        require(msg.value > 1e18, "Not enough ETH sent"); // 1e18 = 1 ETH = 10^9 gwei = 10^18 wei
    }
}