// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol"; 
import "contracts/twitter/Profile.sol";

interface IProfile{
    struct UserProfile{
        string displayName;
        string bio;
    }
    function getProfile(address user) external view returns (UserProfile memory);
}

contract Twitter is Ownable{
    uint8 maxTweetLength = 200;
    mapping(address => Tweet[]) public tweets;
    IProfile profileContract;

    constructor(address _profileContractAddress) Ownable(msg.sender){
        profileContract = IProfile(_profileContractAddress);
    }

    modifier OnlyRegistered(){
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfileTemp.displayName).length > 0, "User is not registered.");
        _;
    }

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likeCount; // <- stores total likes
        mapping(address => bool) likedBy;
    }

    struct TweetView {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likeCount;
    }

    event TweetCreated(
        uint256 id,
        address indexed author,
        string content,
        uint256 timestamp
    );
    event TweetLiked(address indexed liker, address author, uint256 id);

    function createTweet(string memory _tweet) public OnlyRegistered{
        require(bytes(_tweet).length <= maxTweetLength, "Tweet is too long");

        Tweet storage newTweet = tweets[msg.sender].push();

        newTweet.id = tweets[msg.sender].length - 1;
        newTweet.author = msg.sender;
        newTweet.content = _tweet;
        newTweet.timestamp = block.timestamp;
        newTweet.likeCount = 0;
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function getTweet(address _owner, uint256 _i)
        public
        view
        returns (
            uint256 id,
            address author,
            string memory content,
            uint256 timestamp,
            uint256 likeCount
        )
    {
        Tweet storage t = tweets[_owner][_i];
        return (t.id, t.author, t.content, t.timestamp, t.likeCount);
    }

    function getTweets(address _owner)
        public
        view
        returns (TweetView[] memory)
    {
        uint256 len = tweets[_owner].length;
        TweetView[] memory result = new TweetView[](len);

        for (uint256 i = 0; i < len; i++) {
            Tweet storage t = tweets[_owner][i];
            result[i] = TweetView({
                id: t.id,
                author: t.author,
                content: t.content,
                timestamp: t.timestamp,
                likeCount: t.likeCount
            });
        }

        return result;
    }

    function changeTweetLength(uint8 _newTweetLength) public onlyOwner {
        maxTweetLength = _newTweetLength;
    }

    function hasLiked(
        address _owner,
        uint256 tweetId,
        address liker
    ) public view returns (bool) {
        return tweets[_owner][tweetId].likedBy[liker];
    }

    function likeTweet(address author, uint256 tweetId) external OnlyRegistered {
        if (hasLiked(author, tweetId, msg.sender)) {
            tweets[author][tweetId].likeCount -= 1;
            tweets[author][tweetId].likedBy[msg.sender] = false;
        } else {
            tweets[author][tweetId].likeCount += 1;
            tweets[author][tweetId].likedBy[msg.sender] = true;
        }
        emit TweetLiked(msg.sender, author, tweetId);
    }
}
