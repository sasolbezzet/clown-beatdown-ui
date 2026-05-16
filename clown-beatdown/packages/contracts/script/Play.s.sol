// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/StdCheats.sol";
import "../src/ClownBeatdown.sol";

contract Play is StdCheats {
    // Update this address after deployment
    address constant clownAddr = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;

    function run() external {
        // broadcast the following transactions
        vm.broadcast();
        ClownBeatdown(cb).addSecret("mysecret");

        // hit three times (initial stamina = 3)
        vm.broadcast();
        ClownBeatdown(cb).hit();
        vm.broadcast();
        ClownBeatdown(cb).hit();
        vm.broadcast();
        ClownBeatdown(cb).hit();

        // rob and claim reward, also print secret
        vm.broadcast();
        bytes memory secret = ClownBeatdown(cb).robAndReward();
        console2.logBytes(secret);
    }

    // helper to get contract instance
    function cb() internal view returns (ClownBeatdown) {
        return ClownBeatdown(payable(clownAddr));
    }
}
