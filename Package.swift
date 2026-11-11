// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.3.0/SupportSDK.xcframework.zip", checksum: "4cbe09e2563d05544f8f9e95e1da245afa58811bf88fe6a9067fd8ef26240b27")])
