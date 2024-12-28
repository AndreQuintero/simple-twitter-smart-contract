// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract Twitter {
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    uint16 public TWEET_MAX_LENGTH = 280;
    mapping (address => Tweet[]) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not allowed to execute this operation");
        _;
    }

    modifier tweetExists(address _author, uint256 _id) {
        require(tweets[_author][_id].id == _id, "Tweet does not exist!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        TWEET_MAX_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(
            bytes(_tweet).length <= TWEET_MAX_LENGTH,
            string(
                abi.encodePacked(
                    "Your tweet exceeded the limit of characters: ",
                    Strings.toString(TWEET_MAX_LENGTH)
                )
            )
        );

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function getTweet(address _owner, uint256 _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getALLTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function likeTweet(address _author, uint256 _id) external tweetExists(_author, _id){
        tweets[_author][_id].likes++;
    }

    function unlikeTweet(address _author, uint256 _id) external tweetExists(_author, _id){
        require(tweets[_author][_id].likes > 0, "Tweet has no likes!");
        tweets[_author][_id].likes--;
    } 
}