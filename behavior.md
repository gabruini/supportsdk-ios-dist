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


## AI assistance — 0.2.0

When enabled and approved by the support team, the chat labels automated replies **AI assistant**. The message still uses the existing `agent` sender and includes a persistent `Assistente AI:` text prefix, so older binaries can display and recover it in the normal sequence. Optional author and handling metadata does not change read receipts or unread counts.

While the assistant prepares a reply, the chat shows a processing status. **Talk to a person** sends a normal textual request through the persistent outbox. It preserves your draft and selected attachments, works during generation, and reuses the message ID on retry. If offline, reconnect or retry the failed message; the team handoff is confirmed after server acceptance and synchronization. Older clients can type “I would like to speak to a person” or “Vorrei parlare con un operatore”. An automated reply never resolves the conversation by itself.

After handoff, the support team handles subsequent messages. The conversation returns to AI when it is resolved, when a person returns it from the dashboard, or after 4 hours without messages if the team spoke last and the customer did not explicitly ask for a person. The SDK has no model selector or access to private knowledge documents, citations, internal proposals, or provider credentials.

Available from 0.2.0. Earlier binaries show AI replies with the text prefix, without the processing status or the operator button.

## AI consent and approved drafts — 0.2.0

When your app uses AI in any mode (evaluation, team drafts or automated replies), the chat asks the end user for consent before their messages are sent to the AI provider. A panel above the composer shows the text and two equally weighted choices, **Allow** and **Team only**. It steps aside while the user types; until a choice is recorded, messages go to the team and no AI work runs. The server enforces the choice for each end user of your app, on all of their devices, and for the current version of the text.

The chat menu (**…**) revokes consent; open requests handled by the assistant then pass to the team. A user who declined can reopen the text from the same menu; consent is never given without showing it again. Logout, `reset()` and data deletion start from a fresh anonymous user, who is asked again; identifying the same verified user again restores the choice recorded on the server. If the server publishes a newer text that this SDK version does not include, the SDK does not ask, and AI stays off for that user until you update the SDK.

A reply that the support team sent from an AI draft without changes shows **Prepared with AI, checked by the support team** inside the message bubble. The sender is still the team; edited or written replies carry no label. Older binaries show these replies as normal team messages.

The SDK exposes no public API to read or change consent: the choice belongs to the end user inside the chat.
