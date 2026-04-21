// swift-tools-version: 5.9
// Local tooling only: Apollo iOS codegen CLI (run from repo root).
import PackageDescription

let package = Package(
    name: "AgileFreaksTestTools",
    platforms: [.macOS(.v13)],
    products: [],
    dependencies: [
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "2.0.0")
    ],
    targets: []
)
