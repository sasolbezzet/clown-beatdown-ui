// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/// @title Minimal Clown Beatdown contract
/// @notice Implements the functions required by the UI (addSecret, hit, rob, robAndReward, reset, stats).
/// The logic here is simplified for demonstration and testing on Seismic Testnet.
contract ClownBeatdown {
    // Store a secret string (only one for simplicity)
    string public secret;
    // Simple counters for actions
    uint256 public hitCount;
    uint256 public robCount;
    uint256 public rewardCount;

    /// @notice Set the secret string.
    function addSecret(string calldata _secret) external {
        secret = _secret;
    }

    /// @notice Register a hit.
    function hit() external {
        hitCount += 1;
    }

    /// @notice Register a rob.
    function rob() external {
        robCount += 1;
    }

    /// @notice Register a rob and reward.
    function robAndReward() external {
        robCount += 1;
        rewardCount += 1;
    }

    /// @notice Reset all counters and secret.
    function reset() external {
        secret = "";
        hitCount = 0;
        robCount = 0;
        rewardCount = 0;
    }

    /// @notice Return a simple statistic (total actions performed).
    function stats() external view returns (uint256) {
        return hitCount + robCount + rewardCount;
    }
}
