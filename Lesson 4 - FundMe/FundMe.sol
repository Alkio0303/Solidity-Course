// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract FundMe{
    
    uint256 public minimalUsd = 5;
    
    function fund() public payable{
        require(msg.value > minimalUsd, "Did not send enough ETH!");
    }

    function withdraw() public{

    }
}
