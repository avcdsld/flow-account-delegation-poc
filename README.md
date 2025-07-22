# Flow Capability Delegation

1. `flow emulator start`
2. `flow accounts create`
    - Enter an account name: `backend-account`
    - Choose a network: `Emulator`
2. `flow accounts create`
    - Enter an account name: `user-account`
    - Choose a network: `Emulator`
3. `./test.sh`

Flowブロックチェーンにおけるカストディウォレットから&Accountのcapabilityを移譲するPOC。

1. `flow transactions send transactions/create_collection.cdc --network=emulator --signer user-account`
2. `flow transactions send transactions/create_collection.cdc --network=emulator --signer backend-account`
3. `flow transactions send transactions/mint.cdc --network=emulator --signer emulator-account <backend-account-address>`
4. `flow scripts execute scripts/check_nft_ownership.cdc --network=emulator <user-account-address> <backend-account-address>`
5. `flow transactions send transactions/parent_move_nft_from_child.cdc --network=emulator --signer user-account <nft-id>`
6. `flow scripts execute scripts/check_nft_ownership.cdc --network=emulator <user-account-address> <backend-account-address>`

## 概要

このプロジェクトは、バックエンドが管理するカストディウォレットから、ユーザーのセルフカストディウォレットに対してアカウント制御権限を移譲する仕組みを実装しています。

## ファイル構成

```
├── package.json              # プロジェクト設定とスクリプト
├── flow.json                 # Flow CLI設定
├── test.sh                   # テスト実行スクリプト
├── transactions/
│   ├── backend_publish_capability.cdc   # バックエンド: capability公開
│   └── user_claim_capability.cdc        # ユーザー: capability取得
└── README.md
```

## 要件

- Flow CLI v2.0.6以上
- Node.js (package.jsonスクリプト実行用)
