// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "../src/ClownBeatdown.sol";
import "forge-std/StdCheats.sol";

contract RobRewardOnly is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant clownAddr = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;

    function run() external {
        bytes memory secret = ClownBeatdown(clownAddr).robAndReward();
        console2.logBytes(secret);
    }
}
