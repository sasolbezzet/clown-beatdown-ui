// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "forge-std/StdCheats.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CheckClownBalance is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant token = 0xb9Fb801A5D1491E70A886800982CB80cdf98A174;
    address constant clown = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;

    function run() external {
        uint256 bal = IERC20(token).balanceOf(clown);
        console2.log("Clown token balance:", bal);
    }
}
