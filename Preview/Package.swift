// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.4/SupportSDKPreview.xcframework.zip", checksum: "a198cbdfc34a60662fe28ce24988ffb49ea0222c6770fc0adc760c2d88fadaa4")])
