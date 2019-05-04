// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Element",
	dependencies: [
        .package(url: "https://github.com/ZuopanYao/swift-utils.git", from: "1.0.2")
    ]
)
