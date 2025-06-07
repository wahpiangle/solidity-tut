// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// 2️⃣ Set up a connection to the User Contract throught IUser in constructor
// 3️⃣ Call the createUser function with the correct inputs

interface IUser {
    function createUser(address userAddress, string memory username) external;
}

contract Game {
    uint public gameCount;
    IUser public userContract;

    constructor(address _userContractAddress) {
        userContract = IUser(_userContractAddress);
    }

    function startGame(string memory username) external {
        gameCount++;
        userContract.createUser(msg.sender, username);    
    }
}