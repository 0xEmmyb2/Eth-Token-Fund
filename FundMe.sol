// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";


error NotOwner();
error MinimumNotReached();

//814618 gas
contract FundMe {
    using PriceConverter for uint256;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;
    
    uint256 public constant  MINIMUM_USD = 5 * 10 ** 18;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }


    function fund() public payable  minimum{
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
    modifier  onlyOwner {
        if(msg.sender != i_owner) revert NotOwner();
        _;
    }

    modifier  minimum{
        if(msg.value.getConversionRate() >= MINIMUM_USD) revert MinimumNotReached();
        _;
    }

    //receive() and fallback()

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}