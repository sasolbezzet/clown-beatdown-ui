// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/SRC20.sol";

contract SRC20Test is Test {
    SRC20 private token;
    address private alice = address(0xA);
    address private bob   = address(0xB);

    // 1,000 * 10^18 token (shielded)
    uint256 private constant INITIAL_SUPPLY = 1_000 ether;

    function setUp() public {
        token = new SRC20(INITIAL_SUPPLY);
    }

    function testInitialSupply() public {
        assertEq(uint256(token.totalSupply()), 1_000 ether);
        assertEq(uint256(token.balanceOf(address(this))), 1_000 ether);
    }

    function testTransfer() public {
        uint256 amount = 100 ether;
        token.transfer(alice, amount);
        assertEq(uint256(token.balanceOf(alice)), 100 ether);
        assertEq(uint256(token.balanceOf(address(this))), 900 ether);
    }

    function testTransferRevertWhenInsufficient() public {
        uint256 tooMuch = 2_000 ether;
        vm.expectRevert("Insufficient balance");
        token.transfer(bob, tooMuch);
    }
}
