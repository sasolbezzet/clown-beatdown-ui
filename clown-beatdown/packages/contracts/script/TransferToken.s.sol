// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "../src/ClownBeatdown.sol";

contract TransferToken {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant token = 0xb9Fb801A5D1491E70A886800982CB80cdf98A174;
    address constant clown = 0x9Fd14A94bDbEFf73EDB22853cc77416B65E2A0c0;

    function run() external {
        // send 10 SRC20 (10 * 10^18) to Clown contract
        vm.broadcast();
        bool ok = IERC20(token).transfer(clown, 1e18);
        require(ok, "Token transfer failed");
    }
}
