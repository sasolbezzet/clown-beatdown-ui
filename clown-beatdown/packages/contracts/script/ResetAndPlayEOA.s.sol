// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "../src/ClownBeatdown.sol";
import "forge-std/StdCheats.sol";

contract ResetAndPlayEOA is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant clownAddr = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;

    function run() external {
        // Reset to new round (must be down)
        vm.broadcast();
        ClownBeatdown(clownAddr).reset();

        // Add secret (optional, already there)
        vm.broadcast();
        ClownBeatdown(clownAddr).addSecret("mysecret2");

        // Hit three times as contributor (EOA)
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();

        // Rob and claim reward
        vm.broadcast();
        bytes memory secret = ClownBeatdown(clownAddr).robAndReward();
        console2.logBytes(secret);
    }
}
