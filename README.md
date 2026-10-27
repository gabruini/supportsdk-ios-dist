# SupportSDK for iOS

Binary Swift package for iOS 17+, Swift 6, SwiftUI and UIKit. No third-party runtime dependencies.

Version 0.1.3. The signed XCFramework, checksum and matching dSYMs are available in [GitHub Releases](https://github.com/gabruini/supportsdk-ios-dist/releases/tag/0.1.3).

Version 0.1.1 remains available for existing integrations.

Add `https://github.com/gabruini/supportsdk-ios-dist` in Xcode → Package Dependencies, then link the `SupportSDK` product.

```swift
import SupportSDK

// MainActor, once at app startup. This value is public and may be shipped in the app.
try SupportSDK.configure(appId: "pk_live_YOUR_32_CHARACTER_PUBLIC_APP_ID")
SupportSDK.open()
SupportSDK.close()
```

The dashboard's **App ID pubblico** is the existing `pk_live_…`/`pk_test_…` value stored as `public_key`. It is different from the internal app UUID. It authorizes configuration and anonymous session creation, never access to another user's conversations. SDK HTTP requests use `x-app-id`.

- [Integration, identity and presentation](integration.md)
- [Messages, offline use, cache and drafts](behavior.md)
- [Data deletion and logout](data-deletion.md)
- [App Store privacy](privacy.md)

The original API guides describe 0.1.1; the F11 guides explicitly label additions for 0.1.2. Internal previews using `configure(appKey:)`, static `userHash` or `x-app-key` must migrate before adopting this release.

## Agent integration (F11 / 0.1.2)

See [agent workflow](agent-integration.md), [setup checks and Debug previews](setup-verification.md), [custom entry/unread](custom-entry.md), and [backend recipes](backend-identity.md). These guides label APIs unavailable in the published 0.1.1.
