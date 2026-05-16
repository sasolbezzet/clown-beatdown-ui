// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "forge-std/StdCheats.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract CheckBalance is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant token = 0xb9Fb801A5D1491E70A886800982CB80cdf98A174;
    address constant deployer = 0xE34FF1D2C925DDafB28C95C2396fC49A6f64569e;

    function run() external {
        uint256 bal = IERC20(token).balanceOf(deployer);
        console2.log("Deployer balance:", bal);
    }
}
