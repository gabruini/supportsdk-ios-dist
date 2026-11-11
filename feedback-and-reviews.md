# Feedback and native reviews

Requires SupportSDK 0.3.0 and the Z4 backend. The SDK advertises `feedback_v1` and `offer_code_v1`; it advertises `review_v1` only when the host opts into reviews.

The chat offers Helpful / Not helpful on delivered AI answers and unchanged Copilot answers approved by the team. At a resolved conversation it also offers a separate support feedback question. Submitting a vote never opens a store review. A failed request can be retried; changing a vote replaces the previous vote. A delayed resolution vote cannot rate a later turn. Feedback has no free-text field and is stored only for the authenticated customer's conversation.

## Optional native review requests

Both owner/admin and the host app must enable reviews. The host controls when to attempt the native prompt; the SDK does not render a custom review card or call StoreKit automatically from a chat tap.

Before `configure`, opt in:

```swift
try SupportSDK.enableReviewRequests()
try SupportSDK.configure(appId: "pk_live_YOUR_32_CHARACTER_PUBLIC_APP_ID")
```

In a SwiftUI view, read `@Environment(\.requestReview) private var requestReview`. At an appropriate natural break after meaningful use of your app, run:

```swift
let attempted = try await SupportSDK.requestReviewIfAvailable(using: requestReview)
```

Choose that point in the app's flow; do not wire this API to a “Rate us” button or a custom review pre-prompt. Keep the request separate from offers, rewards and the support satisfaction vote. Do not decide whom to ask from positive/negative feedback.

The server permits one request per customer per app in 120 days and consumes each request once across devices. Pending requests expire for activation after 30 days. A `true` return means the native API was attempted; it does not prove a prompt appeared or a review was written. The SDK never receives a rating or review result. If the network response is lost, retrying does not produce a second native attempt; an opportunity may be skipped.

Apple decides whether to display the prompt. Test on a physical iPhone with a development build; TestFlight does not display review requests. [RequestReviewAction](https://developer.apple.com/documentation/storekit/requestreviewaction), [ratings and reviews](https://developer.apple.com/design/human-interface-guidelines/ratings-and-reviews), [App Review Guidelines §5.6.1](https://developer.apple.com/app-store/review/guidelines/#developer-code-of-conduct).

## Privacy and retention

Feedback is linked to the support conversation and included in the user's data export. Deleting the conversation or customer deletes its votes. Offer and review quota receipts contain IDs and timestamps, not coupon values or store ratings. If a conversation is removed, the receipt remains through its 90/120-day quota window and is then eligible for cleanup; deleting the customer removes it immediately. Coupons already consumed from a single-use pool stay reserved after customer deletion.

The manifest continues to declare Customer Support and the existing identifiers for App Functionality, linked to the support user, with no tracking. StoreKit review presentation adds no required-reason API. Review the complete app's privacy report and disclosure, including the host's own data collection. See [privacy](privacy.md). The legal review required before real-customer use remains outstanding.
