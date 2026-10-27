# Integration — 0.1.0

Configure on the MainActor before using the SDK. During this preview the default gateway is SupportSDK staging. Use the explicit `gatewayURL:` argument for local development; HTTP is accepted only on loopback.

## Identity

```swift
// Fetch from your backend using the app's authenticated session.
let jwt = try await backend.fetchSupportIdentityToken()
try await SupportSDK.identify(jwt: jwt)
```

The backend signs HS256 JWTs using the app's identity secret, kept on the backend. Use `sub` for the authenticated user's stable ID, `aud` for the public appId, and integer seconds `iat` and `exp`. Include `typ: JWT` and `alg: HS256`. Lifetime: at most 900 seconds, recommended 600; clock tolerance: 30 seconds. A single exact audience is required. No email or other profile data is necessary in the JWT.

Example using maintained `jose`, with your existing authentication adapter:

```typescript
import { SignJWT } from "jose";

export async function supportIdentity(
  request: Request,
  authenticatedUser: (request: Request) => Promise<{ id: string } | null>,
  env: { SUPPORT_APP_ID: string; SUPPORT_IDENTITY_SECRET: string },
): Promise<Response> {
  if (request.method !== "POST") return new Response(null, { status: 405 });
  const user = await authenticatedUser(request); // Verify your existing session here.
  if (!user) return new Response(null, { status: 401 });
  const iat = Math.floor(Date.now() / 1000);
  const jwt = await new SignJWT({})
    .setProtectedHeader({ alg: "HS256", typ: "JWT" })
    .setSubject(user.id).setAudience(env.SUPPORT_APP_ID)
    .setIssuedAt(iat).setExpirationTime(iat + 600)
    .sign(new TextEncoder().encode(env.SUPPORT_IDENTITY_SECRET));
  return Response.json({ jwt }, { headers: { "Cache-Control": "no-store" } });
}
```

The endpoint ignores client-supplied user IDs. Connect the adapter to your verified Firebase, Supabase or backend session; never decode an unverified client token to determine the user. Apply the same session/CSRF controls as your other authenticated endpoints. Do not embed the secret or log tokens in the mobile app, URLs, analytics or error reports.

JWT expiry prevents new identifications. A successfully identified device session lasts **30 days from the last successful identify**. Obtain a new JWT and call identify at authenticated app launch and whenever the account session is renewed. Re-identifying the same user renews the device session. Expired sessions can only reconfirm identity, log out or request deletion; ordinary chat requests fail with `unauthenticated`. An expired socket is excluded before the next event is delivered and closed at its next channel wake. JWT refresh is owned by the host app.

The same verified sub in the same app shares server history across devices. Accepted anonymous conversations merge into that history. Changing to another verified user moves only the calling device. Other devices and the previous user's conversations remain with that user. Local drafts and cache are cleared when identity changes and are never merged. Reconfirming the same verified user preserves them. Pending messages block a change of identity with `pendingMessages`; retry them first using `retryPendingMessages()` or choose logout to discard them explicitly. A JWT for the same verified user can renew an expired session while retaining its queue; only the server response confirms that identity.

Logout revokes the current session. Full user deletion revokes every device of that user. Secret rotation accepts the previous identity secret for 24 hours for identify; it does not revoke sessions already issued. Repeated rotations immediately remove the older secret. Pre-release HMAC sessions require fresh JWT identification after the backend migration.

## Presentation and components

The SDK owns its sheet. Call `SupportSDK.open(from:)` from UIKit or `SupportSDK.open()` from SwiftUI; `close()` cancels pending opening and dismisses only the SDK sheet. Keep your app's own sheets/navigation under your control. The SDK finds the active scene and can present over an existing modal. Avoid calls during a host transition. Multiple open calls cannot create multiple SDK sheets.

`SupportSDK.isVisible` is observable by SwiftUI. UIKit can observe `SupportSDK.visibilityDidChangeNotification` on the main thread; `userInfo["isVisible"]` is a Bool. Visibility reports presentation state; it does not certify a connection, accepted message or read receipt. Interactive dismissal and logout update visibility. Coordinate account changes with `logout()` before the app starts using the next account.

SwiftUI launchers: `.supportFloatingButton()`, `.supportFloatingButtonHidden()` and `SupportSettingsRow()`. UIKit launchers: `showFloatingButton()` and `makeSettingsCell()`. Insert the components you want in your app; the dashboard can select among those already integrated. Service suspension hides them and prevents `open()`.

## Language

Call `SupportSDK.setLanguage("it")` when the app's selector changes; `setLanguage(nil)` restores system selection. The choice is in memory and must be reapplied at app launch.

Standard controls are translated into English and Italian. Unsupported languages use English controls. Remote text chooses exact locale, base language, English, then the first configured language in alphabetical key order. Remote Arabic text can therefore appear with English controls. Arabic and other RTL locales use RTL layout even when standard controls fall back to English. This is layout support, not a promise of additional translations.
