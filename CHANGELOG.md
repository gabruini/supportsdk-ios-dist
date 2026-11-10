# Changelog

## 0.2.0

Recognize AI replies without changing message sender values; retain the persistent AI text prefix for older clients. Show processing and human handling status, and add a Talk to a person action using the existing durable text outbox. Optional metadata is cached alongside history and unread counts. This candidate requires the KB6 backend and is not included in the published 0.1.4 binary.

Read the chat identity mode chosen in the dashboard (D36): with an account, an anonymous device makes no chat requests and shows a sign-in invitation until `identify(jwt:)`; in anonymous mode `identify(jwt:)` is a no-op and an identified session returns to a new anonymous chat. `SupportSDK.requiresAccount` exposes the mode.

Ask the end user for AI consent inside the chat when the app uses AI, with the approved text for version 2026-11-01 in English and Italian. The server enforces the choice for each end user; until it is given, messages go to the team. The chat menu revokes it or reopens the text. Replies sent from an unedited AI draft show “Prepared with AI, checked by the support team”. Requires the C1 and C3 backend.

## 0.1.4

Place the timestamp and delivery indicator inside each message bubble, removing the redundant visible sent label while preserving accessible delivery status and retry.

## 0.1.3

Update the chat interface: a centered title capsule, a welcome shown only before the first message, grouped sender labels, stable message alignment when the keyboard appears, and an animated close. Remove the keyboard toolbar button; tapping outside the composer dismisses the keyboard and preserves the draft.

## 0.1.2

F11 integration tooling: verifiable setup with a persisted idempotent test attempt, sanitized timeout/error reports and separate acceptance/reply/unread/read evidence. Added bundle ID reporting and validation, observable UIKit unread notifications, and an isolated Debug simulator preview artifact. Release frameworks never activate previews.

Added version-aware agent guides, custom entry and badge recipes, Firebase/Supabase/backend JWT examples and screenshot workflow. Release 0.1.2 and staging deployment were verified from a Mac without GitHub Actions.

## 0.1.1

Fix ZIP packaging so SwiftPM preserves the Apple Distribution signature: exclude AppleDouble metadata and verify the signature after a literal ZIP extraction.

## 0.1.0 — superseded

The original archive contained AppleDouble sidecars that made Xcode reject its signature after SwiftPM extraction. Use 0.1.1. The original artifacts remain available for traceability.

Initial binary release for iOS 17 and Swift 6. SwiftUI/UIKit chat and launchers, remote theme, service availability, realtime recovery and idempotent offline sending.

Public configuration uses `configure(appId:)` and identification uses expiring HS256 `identify(jwt:)`. Static user hashes and `x-app-key` are removed. Identified sessions require renewal after 30 days. Logout/reset retains server history; asynchronous deletion has explicit device/user scopes and idempotent recovery. Added close/observable visibility, app language override and persistent unsent drafts.
