//SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

contract SafeMathTester {
    

    //The modern way of handling overflows
    uint8 public bigNumber = 255;
    
    //This helps you like telling the compiler
    //Hey, I know what I'm doing. Turn off safety sensors
    //It's like preventing the contract from crushing.
    function add() public {
        unchecked {bigNumber = bigNumber + 1;}
    }
}