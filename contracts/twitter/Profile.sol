// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract Profile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    
    mapping(address => UserProfile) public profiles;

    function setProfile(address user, string memory _displayName, string memory _bio) public {
        profiles[user] = UserProfile(_displayName, _bio);
    }

    function getProfile(address _user) public view returns (UserProfile memory) {
        return profiles[_user];
    }
}