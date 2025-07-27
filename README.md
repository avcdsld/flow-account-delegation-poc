# Flow Capability Delegation
Flowブロックチェーンにおけるカストディウォレットから&Accountのcapabilityを移譲するPOC。

## 権限の委譲
1. `flow emulator start`
2. `flow accounts create`
    - Enter an account name: `backend-account`
    - Choose a network: `Emulator`
3. `flow accounts create`
    - Enter an account name: `user-account`
    - Choose a network: `Emulator`
4. 全ての権限を委譲する方法と、制限付き権限を委譲する場合がある
    - 全ての権限を委譲する場合: `./test.sh`
    - 制限付きの権限を委譲する場合: `./test_limited.sh`

## NFTを移動させるテスト

1. `flow project deploy --network=emulator`
2. `flow transactions send transactions/create_collection.cdc --network=emulator --signer user-account`
3. `flow transactions send transactions/create_collection.cdc --network=emulator --signer backend-account`
4. `flow transactions send transactions/mint.cdc --network=emulator --signer emulator-account <backend-account-address>`
5. `flow scripts execute scripts/check_nft_ownership.cdc --network=emulator <user-account-address> <backend-account-address>`
6. 全ての権限を委譲したときと、制限付き権限を委譲したときでトランザクションを変える
   - 全ての権限を委譲したとき: `flow transactions send transactions/parent_move_nft_from_child.cdc --network=emulator --signer user-account <nft-id>`
   - 制限付きの権限を委譲したとき: `flow transactions send transactions/parent_move_nft_from_child_limited.cdc --network=emulator --signer user-account <nft-id>`
7. `flow scripts execute scripts/check_nft_ownership.cdc --network=emulator <user-account-address> <backend-account-address>`

## 子アカウントをrevokeするテスト
1. `flow accounts get --network=emulator <backend-account-address>`
2. 全ての権限を委譲したときと、制限付き権限を委譲したときでトランザクションを変える
   - 全ての権限を委譲したとき: `flow transactions send transactions/revoke_child_account.cdc --network=emulator --signer user-account <backend-account-address>`
   - 制限付きの権限を委譲したとき: `flow transactions send transactions/revoke_child_account_limited.cdc --network=emulator --signer user-account <backend-account-address>`
3. `flow accounts get --network=emulator <backend-account-address>`

## 概要

このプロジェクトは、バックエンドが管理するカストディウォレットから、ユーザーのセルフカストディウォレットに対してアカウント制御権限を移譲する仕組みを実装しています。

## ファイル構成

```
├── package.json              # プロジェクト設定とスクリプト
├── flow.json                 # Flow CLI設定
├── test.sh                   # テスト実行スクリプト（全権限委譲）
├── test_limited.sh           # テスト実行スクリプト（制限付き権限委譲）
├── mint.sh                   # NFTミントスクリプト
├── contracts/
│   └── ExampleNFT.cdc                          # NFTコントラクト(https://github.com/onflow/flow-nft/blob/master/contracts/ExampleNFT.cdc)
├── scripts/
│   └── check_nft_ownership.cdc                 # NFT所有権確認
├── transactions/
│   ├── backend_publish_capability.cdc          # バックエンド: capability公開
│   ├── backend_publish_limited_capability.cdc  # バックエンド: 制限付きcapability公開
│   ├── create_collection.cdc                   # NFTコレクション作成
│   ├── mint.cdc                                # NFTミント
│   ├── parent_move_nft_from_child.cdc          # 親: 子アカウントからNFT移動
│   ├── parent_move_nft_from_child_limited.cdc  # 親: 制限付きcapabilityでNFT移動
│   ├── revoke_child_account.cdc                # ユーザー: 子アカウントの全キーをrevoke
│   ├── revoke_child_account_limited.cdc        # ユーザー: 制限付きcapabilityで子アカウントをrevoke
│   ├── user_claim_capability.cdc               # ユーザー: capability取得
│   └── user_claim_limited_capability.cdc       # ユーザー: 制限付きcapability取得
└── README.md
```

## 要件

- Flow CLI v2.0.6以上
- Node.js (package.jsonスクリプト実行用)
