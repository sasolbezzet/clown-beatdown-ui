// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "../src/ClownBeatdown.sol";
import "forge-std/StdCheats.sol";

contract PlayAndRobEOA is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant clownAddr = 0x8bc25dB1feda8Fc5eB20d0117Ff1f965F2F4E29C;

    function run() external {
        // Add secret (optional, ensure at least one)
        vm.broadcast();
        ClownBeatdown(clownAddr).addSecret("mysecret3");
        // Hit three times
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();
        vm.broadcast();
        ClownBeatdown(clownAddr).hit();
        // Rob and reward
        vm.broadcast();
        bytes memory secret = ClownBeatdown(clownAddr).robAndReward();
        console2.logBytes(secret);
    }
}
