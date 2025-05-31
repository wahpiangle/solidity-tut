// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter{
    uint8 constant maxTweetLength = 200;
    struct Tweet{
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= maxTweetLength, "Tweet is too long");
        Tweet memory newTweet = Tweet(
            msg.sender,
            _tweet,
            block.timestamp,
            0
        );
        //msg is information of transaction
        // msg.sender is the senders address
        tweets[msg.sender].push(newTweet);
    }

    function getTweet(address _owner, uint _i) public view returns (Tweet memory){
        return tweets[_owner][_i];
    }

    function getTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];
    }
}