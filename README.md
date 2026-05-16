# Campfire

焚火をテーマにした匿名2人チャットのiOSアプリです。SwiftUIとSupabaseで作っています。

## 機能

- 匿名ログイン
- ランダムな2人マッチング
- 選択式メッセージ
- 焚火アニメーション
- 通報とブロック

## 設定

- Bundle ID: `com.tokyonasu.Campfire`
- Team ID: `8ZMLVT8WBP`
- Minimum iOS Version: 15.0
- Project: `Campfire/Campfire.xcodeproj`

## GitHub Actions

`main` へのpush、または手動実行でTestFlightへアップロードします。必要なSecretsは次の通りです。

- `DIST_CERT_BASE64`
- `DIST_CERT_PASSWORD`
- `PROVISION_PROFILE_BASE64`
- `PROVISION_PROFILE_NAME`
- `APP_STORE_CONNECT_API_KEY_BASE64`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`
