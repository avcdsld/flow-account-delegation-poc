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
├── contracts/
│   └── ExampleNFT.cdc                          # NFTコントラクト
├── scripts/
│   └── check_nft_ownership.cdc                 # NFT所有権確認
├── transactions/
│   ├── backend_publish_capability.cdc          # バックエンド: capability公開
│   ├── backend_publish_limited_capability.cdc  # バックエンド: 制限付きcapability公開
│   ├── create_collection.cdc                   # NFTコレクション作成
│   ├── mint.cdc                                # NFTミント
│   ├── parent_move_nft_from_child.cdc          # 親: 子アカウントからNFT移動
│   ├── parent_move_nft_from_child_limited.cdc  # 親: 制限付きcapabilityでNFT移動
│   ├── user_claim_capability.cdc               # ユーザー: capability取得
│   └── user_claim_limited_capability.cdc       # ユーザー: 制限付きcapability取得
└── README.md
```

## 要件

- Flow CLI v2.0.6以上
- Node.js (package.jsonスクリプト実行用)
