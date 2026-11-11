# App Store privacy — 0.1.1

Review the SDK's contribution together with your app's own practices when filling App Store Connect. Apple's [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/) cover third-party SDK collection as well as your code.

| SDK data | Suggested Apple category | Purpose / linkage |
|---|---|---|
| Support messages and conversation content | Customer Support | App Functionality; linked to the support user |
| Verified external ID and generated anonymous user ID | User ID | App Functionality; linked |
| Generated support device/session ID | Device ID | App Functionality; linked |
| App/SDK/iOS version, device model, locale and time zone attached to requests | Other Diagnostic Data | App Functionality; linked |

The SDK does not implement advertising tracking, collect IDFA, request location, access contacts, collect photos/audio or run a third-party analytics SDK. It sends only plain-text support messages in this version. Users can place personal information in those messages; design your own support/privacy disclosures accordingly.

The shipped `PrivacyInfo.xcprivacy` declares the categories above, no tracking and no tracking domains. There are no declared required-reason APIs in this version; Keychain, the SDK's own Application Support files and network communication implement storage and chat. Verify the aggregate privacy report in Xcode when adding other dependencies. The manifest does not replace App Store privacy answers, your privacy policy or your own retention/deletion obligations.

**AI processing (0.2.0).** When your app enables AI in the dashboard, the text of chat messages may be sent to OpenAI, possibly outside the EU, only after the end user allows it inside the chat (App Review Guideline 5.1.2(i)). The data categories above do not change. Mention this processing and the consent in your privacy policy; the SDK's consent text does not replace it.

Apple has narrowly defined optional-disclosure criteria for some support requests. The SDK's user identification and continued message synchronization do not establish that your app qualifies; do not automatically omit collection from your label. Check the current Apple rules for your actual flow.

**SDK 0.3.0.** Helpful/not-helpful support votes belong to Customer Support, linked to the existing support identity and used for App Functionality. No free-text feedback or store rating is collected. Offer assignment and native-review attempt receipts contain IDs and dates for frequency limits, with no purchase confirmation. Coupons are fetched on demand for the authenticated recipient and kept out of the cached history. The existing manifest categories and purpose still cover these flows; no tracking or required-reason API is added. See [feedback/reviews and retention](feedback-and-reviews.md) and [coupon delivery](offers.md#coupons-and-assistant-suggestions). Recheck the host app's aggregate privacy report before release.
