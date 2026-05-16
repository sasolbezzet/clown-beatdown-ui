// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "forge-std/StdCheats.sol";
import "../src/ClownBeatdown.sol";

contract ReadSrcToken is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant clownAddr = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;
    function run() external {
        address token = ClownBeatdown(clownAddr).src20Token();
        console2.logBytes(abi.encodePacked(token));
    }
}
