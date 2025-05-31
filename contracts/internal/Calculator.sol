// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicCalculator{
    uint256 public res;

    function add(uint256 a, uint256 b) internal{
        res = a + b;
    }

    function subtract(uint256 a, uint256 b) internal{
        res = a - b;
    }
}

// inheritance, internal allows inheriting contracts to be used
contract AdvancedCalculator is BasicCalculator {
    function multiply(uint256 a, uint256 b) public {        
       res = a * b;
    }

    function divide(uint256 a, uint256 b) public{
        res = a / b;
    }

    // External can only be accessed by external contracts or accounts
    //cannot be used internally
    function get() external view returns (uint256){ 
        return res;
    }


}