// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWAssistiveTouch",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWAssistiveTouch", targets: ["WWAssistiveTouch"]),
    ],
    targets: [
        .target(name: "WWAssistiveTouch", resources: [.process("Storyboard"), .process("Material"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
