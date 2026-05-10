# base-token-locker

> Token & LP Locker for Base L2

Lock ERC20 tokens and Uniswap v3 / Aerodrome LP positions for a defined period. Verifiable on-chain proof of locked liquidity for investor trust.

## Features
- 🔒 Lock any ERC20 token or LP NFT
- ⏰ Time-locked with configurable unlock date
- 👥 Multi-beneficiary locks
- 📜 Transferable lock ownership
- 📊 Lock explorer dashboard
- 🔔 Unlock notifications

## Usage
```bash
forge script script/LockTokens.s.sol \
  --sig "run(address,uint256,uint256)" \
  "0xTokenAddress" 1000000000000000000000 1735689600 \
  --rpc-url $BASE_RPC_URL --broadcast
```

## License
MIT