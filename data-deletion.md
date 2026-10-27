# Logout and deletion — 0.1.1

```swift
try await SupportSDK.logout() // reset() is an alias. Remote history is retained.

// Revoke this device, remove its device record and local data; shared server history stays.
let deviceResult = try await SupportSDK.deleteData(scope: .device)

// Remove the current user's server profile, conversations and messages; revoke every device.
// For an identified user fetch a fresh JWT for the SAME user and app immediately before deletion.
let userResult = try await SupportSDK.deleteData(scope: .user, jwt: freshJWT)
```

Device scope never deletes shared conversation history. User scope affects only the current app's verified user (or current anonymous user). It cannot name an arbitrary other user, app or organization. An anonymous user does not need a JWT. For a verified user, deletion requires a JWT signed by the current identity secret; obtain it from the authenticated backend. Deletion and logout remain available during service suspension and after the device identity's 30-day expiry.

Server deletion commits atomically with an idempotency receipt. Conversation messages and all device records are removed by cascading foreign keys. Anonymous merge aliases are detached; they contain no accepted conversation history. Minimal receipt metadata (request ID, hashed revoked token, scope and deleted entity IDs, no message/JWT/profile content) remains to confirm retries. Server backups and infrastructure logs follow the service's retention policy; this API does not claim to erase them instantly. Another device's **local offline cache** cannot be remotely erased: integrate logout in every host app and honor revoked access; the API removes server access across devices.

The SDK records a local deletion request before networking, without persisting the JWT. If the response is lost, retry the **same scope**; it uses the same request ID and retained device token, including after restart. A fresh JWT may be supplied. If the server has already completed deletion, the receipt confirms the previous result. While confirmation is pending, chat access and logout are blocked to preserve recovery state. A confirmed server response is journaled before local cleanup, so Keychain/disk errors can also be retried.

The returned `status == "completed"` confirms both the server response and local cleanup on this device. An error never claims that an uncertain or partial attempt succeeded. Do not create a new SDK session, delete the app or clear Keychain as a recovery step before retrying.

Logout immediately hides local chat/cache/queue and attempts to revoke the old device token. If the network fails, it reports an error and never reuses that token locally. The server token may remain valid until revocation or expiry; logout does not provide remote deletion or revoke other devices.
