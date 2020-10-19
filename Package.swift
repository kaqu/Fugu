// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Fugu",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "Fugu",
      targets: ["Fugu"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Fugu",
      dependencies: []
    ),
    .testTarget(
      name: "FuguTests",
      dependencies: ["Fugu"]
    ),
  ]
)
