// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Script.sol";
import "../contracts/TokenLocker.sol";
contract LockScript is Script {
    function run(address token, address beneficiary, uint256 amount, uint256 unlockTime) external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        TokenLocker locker = new TokenLocker();
        uint256 id = locker.lock(token, beneficiary, amount, unlockTime, "Team tokens - 1 year lock");
        console.log("Lock created with ID:", id);
        vm.stopBroadcast();
    }
}
