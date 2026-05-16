// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Vm.sol";
import "forge-std/StdCheats.sol";

interface IERC20 { function transfer(address to, uint256 amount) external returns (bool); }

contract SelfTransfer is StdCheats {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant token = 0xb9Fb801A5D1491E70A886800982CB80cdf98A174;
    address constant me = 0xE34FF1D2C925DDafB28C95C2396fC49A6f64569e;
    function run() external {
        vm.broadcast();
        bool ok = IERC20(token).transfer(me, 1e18);
        require(ok, "fail");
    }
}
