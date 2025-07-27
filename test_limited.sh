#!/bin/bash
set -e

BACKEND_ADDRESS="179b6b1cb6755e31"
USER_ADDRESS="f3fcd2c1a78f5eee"

flow project deploy --network=emulator

flow transactions send ./transactions/backend_publish_limited_capability.cdc \
    --network=emulator --signer backend-account $USER_ADDRESS

flow transactions send ./transactions/user_claim_limited_capability.cdc \
    --network=emulator --signer user-account $BACKEND_ADDRESS