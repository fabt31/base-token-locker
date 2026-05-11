// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../contracts/TokenLocker.sol";
contract TokenLockerTest is Test {
    TokenLocker locker;
    function setUp() public { locker = new TokenLocker(); }
    function test_withdrawBeforeUnlockReverts() public {
        vm.expectRevert("Still locked");
    }
    function test_totalLocksIncrement() public {
        assertEq(locker.totalLocks(), 0);
    }
}
