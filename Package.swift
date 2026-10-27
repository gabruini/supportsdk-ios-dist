// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.1/SupportSDK.xcframework.zip", checksum: "8f9d854269ac2e145e40d392fbe3b92424df5b69f166c57cc4083a10386932aa")])
