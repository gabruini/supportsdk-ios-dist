// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDKPreview", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.2.0/SupportSDKPreview.xcframework.zip", checksum: "623aa06754ee665a3b757dd67ee6a8e901c91507a1dbfcdf3961e0dd65e47a75")])
