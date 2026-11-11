# Native assistant mascot — Zeus

Requires SupportSDK 0.3.0 and the mascot-capable backend. Installing the SDK does not activate an autonomous pilot.

Choose **Mascotte AI** in the web dashboard's appearance editor. The character is the supplied Zeus cloud-and-speech-bubble artwork, bundled locally with the SDK. Its original colors, proportions, highlights and transparency are retained in both light and dark mode. Native SwiftUI animates the artwork; no animation library or image download is needed. The component uses the existing floating launcher integration, position and bottom offset:

```swift
import SupportSDK

// After configure, on MainActor:
SupportSDK.showFloatingButton()
```

In SwiftUI, use `.supportFloatingButton()` on the host view. Hide the launcher on a sensitive or crowded screen using `.supportFloatingButtonHidden(true)`. The existing per-screen visibility tokens apply equally to the mascot. Keep a support entry in the host app; a remote configuration cannot insert a settings row into an existing screen.

The launcher distinguishes idle, thinking, a new AI reply, handoff to the team, and other unread support messages. State comes from the existing synchronized conversation cache and realtime events; the launcher adds no polling loop. Only an unread AI reply can produce a short preview; tapping it opens that same conversation. Human replies retain their team identity and are not previewed as the assistant's words. The launcher identifies itself as an AI assistant.

Drag horizontally toward an edge to collapse it into a tab. Tap the tab to expand it. Long-press the launcher to collapse it, hide it for the current session, or save a persistent hide preference. VoiceOver exposes the same actions. The preference is local to the current support identity on this device and is cleared by identity changes, logout or data deletion; it is not a remote account preference. Hiding the launcher does not revoke AI consent or change the app's autonomy mode.

Insert `SupportSettingsRow()` into a SwiftUI settings list, or use `SupportSDK.makeSettingsCell()` with UIKit. In mascot mode, a hidden assistant changes that row's action to **Show AI assistant**: the first tap restores it. Alternatively:

```swift
try await SupportSDK.restoreMascot()
```

Restoring the user's preference cannot override the admin's remote visibility switch, a host screen's hide flag, suspension, or an identity transition. Preference updates are tied to the current cache epoch, so a delayed update cannot change the next identity. The launcher stays hidden until its local preference has been loaded.

The launcher avoids the keyboard, uses the current view's safe area, and reduces to its compact control for accessibility text sizes or when there is insufficient height for a preview. It leaves touches outside its controls to the host app and does not become the key window. Status changes do not present a chat or move accessibility focus. Its thinking animation runs only in an active foreground scene with Reduce Motion disabled.

## Inside the chat

With the **Mascotte AI** component selected, the chat uses the same Zeus artwork and configured assistant name. The chat retains its configured theme; the character itself is rendered in its original colors:

- The empty chat can show a larger character above the existing configured welcome. Before the server has routed the conversation, the header keeps the configured chat title; the character does not promise an AI reply or replace the consent choice.
- While the server assigns the conversation to the AI, the header shows the character, the assistant name and an AI label. The first message in each AI group has a small character beside it. The author label remains in the history after a handoff.
- While `waitingForAi` is true, a 40-point character gently pulses beside the waiting status. A newly received AI reply can trigger one 250 ms nod in the header when the reader is following the latest messages. Initial history, older messages, human replies and operator-approved drafts do not trigger the nod.
- Handoff, denied consent and service suspension use the team identity in the header. Human messages, including AI-assisted drafts approved by an operator, keep the team avatar and attribution.

Animation is confined to the character artwork. Reply text and composer layout appear immediately; no typewriter effect, text shortening or extra request is introduced. The pulse stops when the view disappears or its scene becomes inactive. All character motion respects the system's Reduce Motion setting. The floating character also stops animating while the chat is open.

The live character also blinks occasionally and makes small glances. Blinks last 240 ms with a variable 3.8–7.2 second pause, sometimes followed by a second blink. Glances use 200 ms transitions, hold briefly, and return to center; they are separated by variable 5.5–9 second pauses. Only the original eye shapes move. The cloud, highlights and speech bubble retain the supplied artwork. Two small background patches behind the eyes are prepared once from a bundled clean plate, matched to the surrounding original colors; there is no image generation or network call at runtime.

Eye motion uses the same visibility, active-scene and Reduce Motion gates as the other character motion. Historical message avatars stay still. With motion disabled, the SDK draws the unmodified original PNG with its eyes open. The web appearance editor remains a static preview.

At accessibility text sizes, message rows omit the decorative avatar column so the text keeps its full available width. The header announces the full assistant or team identity to VoiceOver. These chat changes apply only to the mascot component; the other launcher appearances retain their existing chat presentation. No additional host-app integration is required.

The updated SDK advertises `mascot_v1` in the configuration request. The backend serves a floating-button representation to older clients, with a separate representation hash and `Vary` header. The stored admin configuration remains unchanged.

Existing `mascotPreset` values (`orb` and `spark`) remain valid for configuration compatibility. Both display the Zeus artwork in SDK 0.3.0. The updated appearance editor shows Zeus rather than the previous character selector; it does not rewrite saved preset values. The image is included in both the Swift package resources and the binary framework's resources.

Replies and routing remain server responsibilities under the existing consent, budget and autonomy controls. The SDK never generates a client-side greeting or changes a conversation's handling because the mascot is visible. The Z7 source candidate's deterministic pure-greeting path remains independent of the mascot's presentation; mixed questions retain the normal answer pipeline.

Local simulator tests do not close Z6/M4. Physical-device VoiceOver/Dynamic Type/Reduce Motion checks, real model regressions, pilot evidence, trademark clearance and the SDK release remain separate requirements.

Zeus occasionally blinks and shifts its gaze subtly. Eye animations pause when hidden, in the background, or when Reduce Motion is enabled. History avatars remain static.
