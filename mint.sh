#!/bin/bash
set -e

BACKEND_ADDRESS="179b6b1cb6755e31"
USER_ADDRESS="f3fcd2c1a78f5eee"

# Deploy the project contracts
echo "Deploying project contracts..."
flow project deploy --network=emulator

# Create NFT collections for both accounts if not already created
echo "Creating NFT collections..."
flow transactions send ./transactions/create_collection.cdc \
    --network=emulator --signer backend-account

flow transactions send ./transactions/create_collection.cdc \
    --network=emulator --signer user-account

# Mint an NFT to the backend account for testing
echo "Minting NFT to backend account..."
flow transactions send ./transactions/mint.cdc \
    --network=emulator --signer emulator-account $BACKEND_ADDRESS

# Check NFT ownership before transfer
echo "Checking NFT ownership before transfer..."
flow scripts execute ./scripts/check_nft_ownership.cdc \
    --network=emulator $USER_ADDRESS $BACKEND_ADDRESS