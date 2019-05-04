import PackageDescription

let package = Package(
    name: "Element",
	dependencies: [
        .package(url: "https://github.com/ZuopanYao/swift-utils.git", from: "1.0.0")
    ],
	exclude: ["README.md"]
) 
