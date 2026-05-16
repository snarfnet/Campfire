# Campfire 🔥

焚き火をテーマにした匿名2人マッチングチャットiOSアプリ。SwiftUI + Supabase で実装。

## 概要

- **2人きりのチャット** - ランダムマッチング
- **選択式会話** - 自由入力なし、選択肢のみで荒れない設計
- **焚き火アニメーション** - リアルタイムで炎が揺らぐUI
- **リアルタイム同期** - Supabase Realtime で即座に反映

## セットアップ

### Supabase設定（完了済み）

✅ Project URL: `https://azvgjuxedcdqyeixodur.supabase.co`
✅ Anon Key: `sb_publishable_vCQBY39YfFFf9V-ncMYKzg_U-Fia3Pg`
✅ テーブル作成済み
✅ RLS設定済み
✅ Realtime有効化済み

### Xcode設定

1. Xcode でこのリポジトリをクローン
2. `Campfire.xcodeproj` を開く
3. ターゲット設定：
   - Bundle ID: `com.tokyonasu.Campfire`
   - Minimum iOS Version: 15.0
4. SigningTeam を設定
5. Build & Run

## ファイル構造

```
Campfire/
  Config.swift              ← Supabase認証情報
  SupabaseClientManager.swift ← API通信
  
  Models/
    User.swift
    Room.swift
    Message.swift
    Choice.swift
    WaitingQueueEntry.swift
  
  ViewModels/
    AuthManager.swift
    MatchmakingViewModel.swift
    ChatRoomViewModel.swift
    ReportBlockViewModel.swift
  
  Views/
    App.swift
    HomeView.swift
    WaitingView.swift
    ChatRoomView.swift
    EndView.swift
    ReportView.swift
    BonfireView.swift
```

## 実装済み機能

✅ 匿名ログイン  
✅ マッチングキューシステム  
✅ リアルタイムメッセージング  
✅ 選択式チャット（12種類の会話パターン）  
✅ 焚き火アニメーション  
✅ 通報・ブロック機能  
✅ RLSベースのセキュリティ  

## 次のステップ

- [ ] Xcode プロジェクト作成 (Package.swift から .xcodeproj へ)
- [ ] シミュレーターテスト（2台で同時マッチング確認）
- [ ] App Store Connect 設定
- [ ] TestFlight 配信

## 開発者

snarfnet
