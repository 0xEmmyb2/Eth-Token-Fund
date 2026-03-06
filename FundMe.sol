// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;
    
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    address public owner;

    constructor() {
        owner = msg.sender;
    }


    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function withdraw() public onlyOwner {
        //Using for loop
        //We want to get all the money funded

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            funders[funderIndex];
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //Resetting Arrays
        funders = new address[](0);
        //Withdraw the funds

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        //call 
       (bool callSuccess,) = payable (msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call failed");

    }


    //Use of modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }

}