// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "forge-std/StdCheats.sol";

interface IERC20 { function transfer(address to, uint256 amount) external returns (bool); }

contract FundClown is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant token = 0xA6EeE6c972825f7d746673D9a1E25Ca58BD11274; // SRC20 address
    address constant clown = 0x8bc25dB1feda8Fc5eB20d0117Ff1f965F2F4E29C; // ClownBeatdown address
    function run() external {
        vm.broadcast();
        bool ok = IERC20(token).transfer(clown, 1e18);
        require(ok, "Funding failed");
    }
}
