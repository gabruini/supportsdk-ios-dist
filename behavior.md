# Messages and local data — 0.1.1

A message marked sent has been **accepted by the server**. This does not mean an agent replied or read it. An incoming agent message is a separate event; the unread badge changes after synchronization and a successful read update.

Before an attempted send, the SDK atomically writes the outgoing text and a unique client message ID to disk. Failed requests leave it pending/failed. Retries reuse that ID so a timeout after server acceptance cannot create a duplicate. A 429 respects Retry-After. `try await SupportSDK.retryPendingMessages()` retries the existing queue. A network error is not proof of failure on the server.

Already downloaded history stays available offline. The cache and pending queue share an atomic file, isolated by gateway, public appId and user. They use Application Support with device file protection and are excluded from backups. The device token is stored in device-only Keychain, never UserDefaults or iCloud. The SDK does not send message contents to diagnostic logs.

An **unsent draft** is separate from the outgoing queue. Editing persists text per local conversation; reopening the chat or app restores it. Saving a draft never creates a session or sends it. Tapping send removes that draft as the outgoing message is persisted. An unsent conversation with a draft is retained when server history is refreshed. Draft persistence can fail if local storage is unavailable; do not treat visible text as an external backup.

Changing identity clears local drafts/cache after the queue is empty; reconfirming the same verified user preserves them, including across restart; accepted anonymous history is merged on the server. Drafts are deliberately not transferred to the verified account, even if it has the same history. Logout and successful deletion remove local drafts, cache and queue. Late writes from the old presentation are ignored. Logout therefore discards pending messages: do it for account transitions, not to repair a network error.

A confirmed service suspension disables sending and retries, stops chat polling/reconnects and retains queued messages. Configuration checks continue at a limited rate and reactivate the SDK without an app update. A network error retains the last confirmed service state and configuration.

Common recovery:

| Error | Action |
|---|---|
| Network timeout/offline | Keep cache and queue; reconnect or retry with the same message IDs |
| `pendingMessages` during an identity change | Retry pending sends, then identify; choose logout only if discarding them is intended |
| `http` 401 / `unauthenticated` | Fetch a fresh JWT from your authenticated backend, then identify |
| `identity_verification_failed` | Check server secret, audience and clock; fetch a new JWT |
| `serviceSuspended` | Wait for configuration to confirm availability; do not loop retries |
| `storage` or `keychain` | Surface a recoverable local storage problem; retain deletion recovery state and retry |

`reset()` is an alias of `logout()`. Neither is a troubleshooting shortcut for transient network failures.
