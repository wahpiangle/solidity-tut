// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Calculator{
    string public name = "Anis";

    function displayName() public view returns (string memory){
        return name;
    }
    uint256 res = 0;

    function add(uint256 _num1) public {
        res += _num1;
    }
    
    function substract(uint256 _num1) public {
        res -= _num1;
    }

    function multiply(uint256 _num1) public {
        res *= _num1;
    }
    
    function divide(uint256 _num1) public {
        res /= _num1;
    }

    //view = not modifying state
    function getResult() public view returns (uint256){
        return res;
    }
}