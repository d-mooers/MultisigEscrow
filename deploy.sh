echo "Hi"
echo $RINKEBY_RPC_URL
echo $ETH_RPC_URL
forge script script/Escrow.s.sol --rpc-url $RINKEBY_RPC_URL  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv