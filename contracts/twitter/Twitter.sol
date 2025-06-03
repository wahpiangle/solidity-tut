// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter {
    uint8 maxTweetLength = 200;
    address public owner;
    mapping(address => Tweet[]) public tweets;

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

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= maxTweetLength, "Tweet is too long");

        Tweet storage newTweet = tweets[msg.sender].push();

        newTweet.id = tweets[msg.sender].length - 1;
        newTweet.author = msg.sender;
        newTweet.content = _tweet;
        newTweet.timestamp = block.timestamp;
        newTweet.likeCount = 0;
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

    function likeTweet(address author, uint256 tweetId) external {
        if(hasLiked(author, tweetId, msg.sender)){
            tweets[author][tweetId].likeCount -= 1;
            tweets[author][tweetId].likedBy[msg.sender] = false;
        }else{
            tweets[author][tweetId].likeCount += 1;
            tweets[author][tweetId].likedBy[msg.sender] = true;
        }
    }
}
