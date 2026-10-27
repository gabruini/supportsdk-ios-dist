# Verifiable setup — F11 / 0.1.2

Call explicitly in a developer-controlled Debug path after configure; it sends a real, fixed test message to the app's support inbox. It never starts from a launch argument in the SDK. Do not run against a customer's production account without their authorization.

```swift
let report = await SupportSDK.verifyIntegration(timeout: 30)
// Encode only this report for the agent. Never print JWTs, device tokens or message contents.
let data = try JSONEncoder().encode(report)
```

The report separates configured, clientMessageId, conversationId, messageAccepted, replyReceived, unreadObserved and readConfirmed. status is completed only after every transport/read step, timed_out when the deadline expires, failed for explicit errors, and cancelled on caller cancellation. configured means the local configure call succeeded, not that the server accepted a message. The timeout must be finite, greater than zero and at most 120 seconds. The report contains no identity, token, secret or message body. The returned errorCode is a sanitized diagnostic; do not log the raw underlying error.

1. Close the chat before testing. Run the check and read its clientMessageId; the attempt is persisted before sending. Retry the same check after timeout or a lost response. It reuses that attempt within the same identity, even across app relaunch. Do not reset/logout to retry a network problem. Identity changes clear the local attempt; they are separate tests.
2. Dashboard → Apps → Integrate with your AI agent shows the last contact for the expected bundle ID. The client declares that bundle ID; this diagnostic is not an attestation or authentication factor. Old 0.1.1 sessions lack it and do not count as detected until updated by 0.1.2. Device metadata is updated on the first authenticated contact of each SDK instance.
3. Copy the report's clientMessageId into the dashboard's test field. Acceptance is independent of first launch. Open the test conversation, reply once, and return to the app with chat closed. Run the same check again if its deadline already expired. Verify unread on the actual entry/menu/tab. It does not mark messages read for you.
4. Open and read the chat. Only the successful read API plus the cleared badge total counts as local readConfirmed. Dashboard read means the server read pointer advanced; it alone cannot prove the reply rendered on this device. Existing messages on other devices can advance that pointer. Report the device's observation separately.

Timeout/network failure is never completed. Preserve partial evidence and the attempt, fix the error, retry. Suspension is explicit, bad app IDs fail, and a mismatched bundle ID fails validation. Do not replace a customer's configuration with a test app silently. A test interrupted by identity change fails and must be restarted for the intended account.

## Local screenshots without server writes

The normal Release XCFramework returns nil from integrationPreview(), including on simulator. The separate **SupportSDKPreview.xcframework** is built Debug, simulator only, using scripts/build-integration-preview.sh. It is a local SPM binary package in .build/integration-preview and a separately distributable ZIP; it must never be used to ship the app. Until that artifact is published, screenshots from a local source/preview build are local evidence only.

Call `try SupportSDK.integrationPreview(configuration: optionalConfigJSON)` before configure. If it returns a view, show it as the root and skip configure/identity/network setup. On UIKit embed it in UIHostingController. In SwiftUI branch the root view. Gate that host path with #if DEBUG. Only the Debug simulator framework responds to these explicit arguments:

```sh
xcrun simctl launch --terminate-running-process SIMULATOR_ID com.example.app --supportsdk-preview welcome
xcrun simctl io SIMULATOR_ID screenshot /tmp/support-welcome.png
xcrun simctl launch --terminate-running-process SIMULATOR_ID com.example.app --supportsdk-preview conversation
xcrun simctl io SIMULATOR_ID screenshot /tmp/support-conversation.png
```

The repository helper `scripts/capture-integration-previews.py` captures the SwiftUI/UIKit examples in both languages and themes and checks that the SDK stores do not change. It requires an explicitly selected simulator and locally built preview clients.

Set SIMCTL_CHILD_SUPPORTSDK_PREVIEW_LANGUAGE=it or en when launching for deterministic copy; set simulator light/dark appearance. Optional configuration JSON uses the existing remote-config schema and may contain only public theme/text data. Fixtures have fixed dates/IDs and no persistent store or network transport. Show the native entry separately in the normal app. Collect visual feedback one screenshot at a time; a headless test cannot supply the developer's approval.
