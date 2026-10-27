// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "SupportSDK", platforms: [.iOS(.v17)],
    products: [.library(name: "SupportSDK", targets: ["SupportSDK"])],
    targets: [.binaryTarget(name: "SupportSDK", url: "https://github.com/gabruini/supportsdk-ios-dist/releases/download/0.1.3/SupportSDK.xcframework.zip", checksum: "6c22246944d7f9476ca45028971915c34834dbc43e9f58104480a591c4aaa3ac")])
