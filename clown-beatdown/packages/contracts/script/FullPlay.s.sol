// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "../src/ClownBeatdown.sol";
import "forge-std/StdCheats.sol"; // for console2 logging

contract FullPlay is StdCheats {
    // address of the deployed ClownBeatdown contract (update if it changes)
    address constant clownAddr = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external {
        // 1️⃣ Tambahkan secret
        ClownBeatdown(clownAddr).addSecret("mysecret");
        // 2️⃣ Hit 3 kali (stamina awal = 3)
        ClownBeatdown(clownAddr).hit();
        ClownBeatdown(clownAddr).hit();
        ClownBeatdown(clownAddr).hit();
        // 3️⃣ Rob & reward, dan catat secret ke console
        bytes memory secret = ClownBeatdown(clownAddr).robAndReward();
        console2.logBytes(secret);
    }
}
