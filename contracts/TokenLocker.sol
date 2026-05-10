// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenLocker is ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Lock {
        address token;
        address owner;
        address beneficiary;
        uint256 amount;
        uint256 unlockTime;
        bool withdrawn;
        string description;
    }

    Lock[] public locks;
    mapping(address => uint256[]) public userLocks;

    event Locked(uint256 indexed lockId, address indexed token, address indexed owner, uint256 amount, uint256 unlockTime);
    event Withdrawn(uint256 indexed lockId, address indexed beneficiary, uint256 amount);

    function lock(address token, address beneficiary, uint256 amount, uint256 unlockTime, string calldata description)
        external nonReentrant returns (uint256 lockId) {
        require(unlockTime > block.timestamp, "Unlock in future");
        require(amount > 0, "Amount > 0");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        lockId = locks.length;
        locks.push(Lock(token, msg.sender, beneficiary, amount, unlockTime, false, description));
        userLocks[msg.sender].push(lockId);
        emit Locked(lockId, token, msg.sender, amount, unlockTime);
    }

    function withdraw(uint256 lockId) external nonReentrant {
        Lock storage l = locks[lockId];
        require(msg.sender == l.beneficiary || msg.sender == l.owner, "Not authorized");
        require(block.timestamp >= l.unlockTime, "Still locked");
        require(!l.withdrawn, "Already withdrawn");
        l.withdrawn = true;
        IERC20(l.token).safeTransfer(l.beneficiary, l.amount);
        emit Withdrawn(lockId, l.beneficiary, l.amount);
    }

    function getUserLocks(address user) external view returns (uint256[] memory) { return userLocks[user]; }
    function getLock(uint256 lockId) external view returns (Lock memory) { return locks[lockId]; }
    function totalLocks() external view returns (uint256) { return locks.length; }
}