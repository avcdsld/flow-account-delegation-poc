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

## セキュリティ注意事項

⚠️ **重要**: &Account capabilityの移譲は、秘密鍵を共有することと実質的に同等です。本番環境では、より安全な制御を行うためにHybridCustodyコントラクトの使用を検討してください。

## 要件

- Flow CLI v2.0.6以上
- Node.js (package.jsonスクリプト実行用)
