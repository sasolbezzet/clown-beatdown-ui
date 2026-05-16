// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/ClownBeatdown.sol";
import "forge-std/StdCheats.sol";

contract HitScript is StdCheats {
    function run() external {
        vm.broadcast();
        ClownBeatdown cb = ClownBeatdown(payable(address(0xCf4A01c1b70c5C557fe4f42c6eD5825e3258B88a)));

        cb.hit();
    }
}
