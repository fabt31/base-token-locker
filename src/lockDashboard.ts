import { ethers } from "ethers";
const LOCKER_ABI = [
  "function getLock(uint256 lockId) view returns (address,address,address,uint256,uint256,bool,string)",
  "function getUserLocks(address user) view returns (uint256[])",
  "function totalLocks() view returns (uint256)"
];
export async function getUserLockSummary(lockerAddress: string, user: string, provider: ethers.JsonRpcProvider) {
  const locker = new ethers.Contract(lockerAddress, LOCKER_ABI, provider);
  const lockIds = await locker.getUserLocks(user);
  const locks = await Promise.all(lockIds.map((id: bigint) => locker.getLock(id)));
  return locks.map((l: any, i: number) => ({
    lockId: lockIds[i].toString(),
    token: l[0], amount: ethers.formatEther(l[3]),
    unlockDate: new Date(Number(l[4]) * 1000).toLocaleDateString(),
    withdrawn: l[5], description: l[6]
  }));
}
