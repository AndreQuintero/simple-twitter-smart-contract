// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Twitter {
    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    uint16 public TWEEET_MAX_LENGTH = 280;
    mapping (address => Tweet[]) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not allowed to execute this operation");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        TWEEET_MAX_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= TWEEET_MAX_LENGTH, "Your tweet exceeded the limit of characters");

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        return tweets[msg.sender].push(newTweet);
    }

    function getTweet(address _owner, uint256 _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getALLTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

}