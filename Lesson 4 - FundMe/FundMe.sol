// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{
    using PriceConverter for uint256;

    uint256 public minimalUsd = 5e18;

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    address public owner;
    
    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= minimalUsd, "Did not send enough ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
           address funder = funders[funderIndex];
           addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        //Transfer
        payable(msg.sender).transfer(address(this).balance);

        //Send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send Failed");

        //Call
        (bool callSuccess,) =payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");

    }

    modifier onlyOwner()
    {
        require(msg.sender == owner, "Not Owner");
        _;
    }
    
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
