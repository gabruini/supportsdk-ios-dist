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

Apple has narrowly defined optional-disclosure criteria for some support requests. The SDK's user identification and continued message synchronization do not establish that your app qualifies; do not automatically omit collection from your label. Check the current Apple rules for your actual flow.
