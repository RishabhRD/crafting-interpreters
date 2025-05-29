// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "lox",
  products: [
    .executable(name: "treeloxc", targets: ["TreeLox"]),
    .executable(name: "vmloxc", targets: ["VMLox"]),
  ],
  targets: [
    .target(
      name: "Core"
    ),
    .executableTarget(
      name: "TreeLox",
      dependencies: ["Core"]
    ),
    .executableTarget(
      name: "VMLox",
      dependencies: ["Core"]
    ),
  ]
)
