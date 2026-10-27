# Backend identity recipes — 0.1.1 and F11

Deploy these endpoints in **the customer's backend** and connect its existing authentication. The mobile app sends its existing authenticated bearer/session and receives only a temporary SupportSDK JWT. The identity secret belongs in backend secret storage; the public appId belongs in configuration. Never accept a user ID in the request body, decode an unverified JWT to choose a user, or log tokens. Keep your existing rate limits, CORS and cookie/CSRF protection. The bearer-only examples below accept POST and do not enable CORS.

## Shared signer (Node.js or Web Crypto runtime, maintained jose)

```typescript
import { SignJWT } from "jose";
type SupportEnv = { SUPPORT_APP_ID: string; SUPPORT_IDENTITY_SECRET: string };
async function issueSupportIdentity(userId: string, env: SupportEnv): Promise<Response> {
  if (!/^[^\s]{1,255}$/.test(userId) ||
      !/^pk_(live|test)_[A-Za-z0-9]{32}$/.test(env.SUPPORT_APP_ID) ||
      env.SUPPORT_IDENTITY_SECRET.length < 32) throw new Error("Invalid server configuration");
  const iat = Math.floor(Date.now() / 1000);
  const jwt = await new SignJWT({})
    .setProtectedHeader({ alg: "HS256", typ: "JWT" })
    .setSubject(userId).setAudience(env.SUPPORT_APP_ID)
    .setIssuedAt(iat).setExpirationTime(iat + 600)
    .sign(new TextEncoder().encode(env.SUPPORT_IDENTITY_SECRET));
  return Response.json({ jwt }, { headers: { "Cache-Control": "no-store", Pragma: "no-cache" } });
}
function bearer(request: Request): string | null {
  return /^Bearer ([A-Za-z0-9._~-]+)$/.exec(request.headers.get("authorization") ?? "")?.[1] ?? null;
}
function rejected(status: number): Response {
  return new Response(null, { status, headers: { "Cache-Control": "no-store" } });
}
```

Handle unexpected signing/configuration errors with a sanitized 503 response in your backend error handler. Do not expose exception text. Reuse the shared signer in each recipe; do not accept its `userId` argument from an HTTP parameter.

## Firebase

Use an initialized Firebase Admin SDK for the customer's project (Application Default Credentials or that backend's secret setup). Verify the Firebase ID token and check revocation; Firebase custom tokens are not ID tokens.

```typescript
import { getAuth } from "firebase-admin/auth";
async function firebaseSupportIdentity(request: Request, env: SupportEnv): Promise<Response> {
  if (request.method !== "POST") return rejected(405);
  const token = bearer(request);
  if (!token) return rejected(401);
  let uid: string;
  try { uid = (await getAuth().verifyIdToken(token, true)).uid; }
  catch { return rejected(401); }
  return issueSupportIdentity(uid, env);
}
```

Project initialization, route/Function deployment, authentication in the iOS app and environment secrets are required integration work. [Firebase verification documentation](https://firebase.google.com/docs/auth/admin/verify-id-tokens).

## Supabase

Verify the access token with the customer's Supabase Auth server using `getUser(token)`. Do not trust `getSession()` data received from the client as server-side proof of identity.

```typescript
import { createClient } from "@supabase/supabase-js";
type SupabaseEnv = SupportEnv & { SUPABASE_URL: string; SUPABASE_PUBLISHABLE_KEY: string };
async function supabaseSupportIdentity(request: Request, env: SupabaseEnv): Promise<Response> {
  if (request.method !== "POST") return rejected(405);
  const token = bearer(request);
  if (!token) return rejected(401);
  const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_PUBLISHABLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  });
  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user || data.user.is_anonymous) return rejected(401);
  return issueSupportIdentity(data.user.id, env);
}
```

Route/Edge Function deployment and its outer JWT policy must match the customer's auth setup; verify with a real signed-in user before declaring it complete. [Supabase getUser documentation](https://supabase.com/docs/reference/javascript/auth-getuser).

## Existing backend / cookie session

```typescript
async function supportIdentity(request: Request, env: SupportEnv,
  authenticate: (request: Request) => Promise<{ id: string } | null>): Promise<Response> {
  if (request.method !== "POST") return rejected(405);
  const user = await authenticate(request); // Existing server-side session verification + CSRF/origin controls.
  if (!user) return rejected(401);
  return issueSupportIdentity(user.id, env);
}
```

This adapter is intentionally incomplete until it calls your actual authentication and the endpoint is deployed. Do not fill it with a client-supplied ID. [jose SignJWT reference](https://github.com/panva/jose/blob/main/docs/jwt/sign/classes/SignJWT.md).

## Account lifecycle in the app

- At authenticated app launch/session restore and login, obtain a fresh JWT through the endpoint and call `try await SupportSDK.identify(jwt:)` before presenting authenticated history. Reconfirm on app-session renewal. JWT lifetime is at most 15 minutes; the SupportSDK device session lasts 30 days after the last successful identify. See [identity](integration.md).
- Handle `pendingMessages` before changing accounts. Retry the same user's queue with `retryPendingMessages()`, or let the developer/user explicitly choose to discard via logout. Never silently discard or log out to fix a network problem. An uncertain identify must retry with a fresh JWT for the same intended user.
- On actual logout call `try await SupportSDK.logout()` and handle errors. Close support before exposing another app account; do not show previous history while identity is unresolved. Account switching must await the chosen transition and fresh identify.
- Before deleting an identified app account, obtain a **fresh** JWT while the authenticated session still exists and call `try await SupportSDK.deleteData(scope: .user, jwt: jwt)`. Retry the same deletion through this API after an uncertain response; its request journal persists. Do not revoke the app session/remove the backend account before retaining the means to retry. `.device` revokes this device, not the user's shared remote history. See [deletion](data-deletion.md).
- Track backend endpoint, secret installation, deployment and real authenticated checks as separate pending work. An anonymous setup test never completes this branch.
