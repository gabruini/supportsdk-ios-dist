# Changelog

## 0.1.0

Initial binary release for iOS 17 and Swift 6. SwiftUI/UIKit chat and launchers, remote theme, service availability, realtime recovery and idempotent offline sending.

Public configuration uses `configure(appId:)` and identification uses expiring HS256 `identify(jwt:)`. Static user hashes and `x-app-key` are removed. Identified sessions require renewal after 30 days. Logout/reset retains server history; asynchronous deletion has explicit device/user scopes and idempotent recovery. Added close/observable visibility, app language override and persistent unsent drafts.

