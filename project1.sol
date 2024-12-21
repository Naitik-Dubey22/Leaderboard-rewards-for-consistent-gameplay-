// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LeaderboardRewards {
    address public owner;
    uint256 public totalRewardsPool;

    struct Player {
        uint256 points;
    }

    mapping(address => Player) public players;

    event PointsUpdated(address indexed player, uint256 points);
    event RewardsClaimed(address indexed player, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() payable {
        owner = msg.sender;
        totalRewardsPool = msg.value;
    }

    function addPoints(address player, uint256 points) external onlyOwner {
        players[player].points += points;
        emit PointsUpdated(player, players[player].points);
    }

    function claimRewards(uint256 rewardPerPoint) external {
        Player storage player = players[msg.sender];
        require(player.points > 0, "No points to claim rewards for.");

        uint256 rewards = player.points * rewardPerPoint;
        require(rewards <= totalRewardsPool, "Not enough rewards in the pool.");

        totalRewardsPool -= rewards;
        player.points = 0;

        payable(msg.sender).transfer(rewards);
        emit RewardsClaimed(msg.sender, rewards);
    }
}
