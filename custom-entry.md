# Custom entry and unread — F11 / 0.1.2

Use the app's existing control style, dimensions, font, accessibility labels and navigation. Keep SupportSettingsRow(), .supportFloatingButton(), makeSettingsCell() and showFloatingButton() available as alternatives. Hide a badge at zero. Mark at most one tab; if a nested menu also contains the entry, update that menu from the same count.

SwiftUI observes the SDK's Observation-backed unreadCount when it is read inside body:

```swift
import SwiftUI
import SupportSDK
struct SupportEntry: View {
    var body: some View {
        Button { SupportSDK.open() } label: {
            HStack {
                Text("Support", comment: "Support entry")
                if SupportSDK.unreadCount > 0 {
                    Text(String(SupportSDK.unreadCount)).monospacedDigit()
                        .accessibilityLabel("Unread messages: \(SupportSDK.unreadCount)")
                }
            }
        }
    }
}
```

UIKit reads the initial value and observes changes on the main thread. The notification is new in 0.1.2; do not use it with 0.1.1.

```swift
@MainActor final class SettingsController: UIViewController {
    let unreadLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnread),
            name: SupportSDK.unreadDidChangeNotification, object: nil)
        updateUnread()
    }
    @objc private func updateUnread() {
        let count = SupportSDK.unreadCount
        unreadLabel.isHidden = count == 0
        unreadLabel.text = String(count)
        // Update the existing intermediate menu and the single chosen tab here.
    }
    @objc private func openSupport() { SupportSDK.open(from: self) }
}
```

Use visibilityDidChangeNotification/isVisible only for presentation coordination. They do not certify delivery or reading. For remote fonts use the exact PostScript name from the app's bundled font; no remote font downloads. Transfer only supported theme fields via the authenticated appearance editor, review contrast warnings, save, and allow about a minute in foreground for propagation. Reapply the app's selected language with setLanguage; nil restores automatic selection. Standard controls are English/Italian; do not promise extra translations.
