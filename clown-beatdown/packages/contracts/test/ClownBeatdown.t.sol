// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ClownBeatdown} from "../src/ClownBeatdown.sol";

contract ClownBeatdownTest is Test {
    ClownBeatdown public game;
    address public alice = address(0xA);
    address public bob = address(0xB);

    function setUp() public {
        // Initialize game with stamina = 2 for quick testing
        game = new ClownBeatdown(2);
        // Add two secrets
        game.addSecret("secret1");
        game.addSecret("secret2");
    }

    function testHitAndDown() public {
        // Alice hits once
        vm.prank(alice);
        game.hit();
        assertEq(game.clownStamina(), 1);
        // Bob hits once – clown should be down now
        vm.prank(bob);
        game.hit();
        assertEq(game.clownStamina(), 0);
    }

    function testRobOnlyContributor() public {
        // Alice and Bob each hit once to bring stamina to 0
        vm.prank(alice);
        game.hit();
        vm.prank(bob);
        game.hit();
        // Bob (contributor) can rob
        vm.prank(bob);
        bytes memory secret = game.rob();
        // secret should be either "secret1" or "secret2"
        bool ok = (keccak256(secret) == keccak256(bytes("secret1")) || keccak256(secret) == keccak256(bytes("secret2")));
        assertTrue(ok);
    }

    function testRobRevertsIfNotContributor() public {
        // Only Alice hits
        vm.prank(alice);
        game.hit();
        vm.prank(alice);
        game.hit();
        // Bob (not a contributor) tries to rob – should revert
        vm.prank(bob);
        vm.expectRevert("Not a contributor");
        game.rob();
    }

    function testReset() public {
        // Bring clown down
        vm.prank(alice);
        game.hit();
        vm.prank(bob);
        game.hit();
        // Reset the game
        game.reset();
        assertEq(game.clownStamina(), 2);
        assertEq(game.round(), 2);
    }
}
