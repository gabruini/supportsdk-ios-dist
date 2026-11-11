# Offer cards and app-owned paywalls

Requires **SupportSDK 0.3.0** and the N6 backend. Published 0.1.4 apps keep reading the fallback text; they cannot open these cards. Updating the operator app alone does not enable paywalls in customer apps.

Configure a catalog entry in the web dashboard for the same app: title, fallback text, button label, RevenueCat Offering ID, availability and optional expiry. Operators select an existing entry from the web or iOS conversation. They cannot enter a price or destination URL. Configure actual products, prices and offers in your store/provider account.

Register your handler on the main actor **before** `configure`:

```swift
import SupportSDK

try SupportSDK.registerPaywallHandler { request in
    guard request.offeringId == "support_plans" else { return .unavailable }
    // Your app resolves this exact Offering, verifies customer eligibility and
    // presents its own paywall using the active scene's presentation context.
    return await appPaywalls.present(offeringId: request.offeringId)
}
try SupportSDK.configure(appId: "pk_live_YOUR_32_CHARACTER_PUBLIC_APP_ID")
```

`appPaywalls` above is your app's implementation; it returns `SupportPaywallResult`: `.presented`, `.cancelled` or `.unavailable`. Allowlist the Offering IDs you support. Do not silently substitute the current/default Offering when the requested one is missing. Only advertise support in builds with a working handler; registration enables `offers_v1` in device registration/update. Registration after `configure` fails explicitly.

The SDK calls the authenticated activation endpoint before invoking your handler. The server verifies the message belongs to the current app, conversation and customer, then checks the catalog revision, expiry and availability. An old card never silently redirects to a newly edited Offering. Network failure and unavailable/changed/expired entries leave the fallback text readable. Unknown card versions do not prevent reading history.

Your app owns store eligibility, commercial identity and presentation. A card does not grant a discount. Treat unknown eligibility as unavailable for a card promising an introductory offer. Prices, subscription terms and renewal details come from the actual products/paywall. Do not put private provider keys in the app, the catalog or a card.

Activation records that the server resolved a destination. Local results record presentation, cancellation or unavailability. **Neither confirms a purchase**, unlocks an entitlement or attributes a subscription to a card. Those features require a separate authenticated provider webhook and a defined identity/attribution model; this release has neither a client purchase-confirmation endpoint nor a purchase-completed message state.

For a runnable RevenueCat adapter, see `Examples/RevenueCatDemo` in the private SDK source project. It pins RevenueCat 5.25.3, resolves exactly `n6_test`, checks introductory eligibility and uses `PaywallView` with test products. RevenueCat remains a host-app dependency; SupportSDK has no third-party runtime dependency.

Provider references: [displaying paywalls](https://www.revenuecat.com/docs/tools/paywalls/displaying-paywalls), [offer eligibility](https://www.revenuecat.com/docs/subscription-guidance/subscription-offers), [Apple sandbox and StoreKit testing](https://www.revenuecat.com/docs/test-and-launch/sandbox/apple-app-store).

## Coupons and assistant suggestions

This section requires SupportSDK 0.3.0 and the Z4 backend.

The web catalog can also contain a coupon for physical goods or services consumed outside the app. The business creates the codes in its own commerce system and imports either a shared code or a pool of single-use codes. SupportSDK delivers a code; it does not create the commercial discount, redeem it or prove eligibility. Digital content and in-app subscriptions continue through the Offering/paywall path.

Codes are encrypted on the server. The AI sees only a catalog reference, title and usage guidance. A draft reserves no code. Sending atomically assigns one code; another conversation or concurrent send cannot bypass the limit of one offer per customer per app in 90 days. This applies to manual and autonomous sending. An anonymous identity reset is not proof of commercial eligibility: your app and commerce system must still enforce their own rules.

The SDK advertises `offer_code_v1`, checks the authenticated activation endpoint when the customer opens a coupon, and displays the code as selectable text. It needs no paywall callback for coupons. The code stays in memory while the chat model is alive and is not written into the cached message history. On reopening, activation checks the catalog again. Disabling, expiry or a catalog revision makes an old coupon unavailable. Older SDKs keep the fallback text readable; the server requires the appropriate capability before sending a new coupon card.

Owner/admin can supply “when to use” guidance and explicitly opt an offer into autonomous sending. Existing offers default to no autonomous sending. Copilot drafts show the proposed card; sending a draft includes it. Autonomous mode hands the draft to the team when the selected offer has no opt-in. A catalog change invalidates the proposal before sending. Never place actual code values in catalog titles, fallback text, usage guidance or knowledge sources.

Feedback and optional native review requests are documented in [feedback and reviews](feedback-and-reviews.md); an offer is never coupled to a request for a rating.
