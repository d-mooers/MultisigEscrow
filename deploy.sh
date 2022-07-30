echo "Deploying!"
forge script script/Escrow.s.sol --rpc-url $ETH_RPC_URL  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv