// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "lox",
  products: [
    .library(name: "FrontEnd", targets: ["FrontEnd"]),
    .executable(name: "treeloxc", targets: ["treeloxc"]),
    .executable(name: "loxc", targets: ["loxc"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-collections.git",
      from: "1.0.0"),
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      from: "1.2.0"),
    .package(
      url: "https://github.com/apple/swift-format",
      from: "508.0.1"),
  ],
  targets: [
    .target(
      name: "Utils",
      dependencies: [
        .product(name: "Collections", package: "swift-collections"),
        .product(name: "Algorithms", package: "swift-algorithms"),
      ]
    ),
    .target(
      name: "FrontEnd",
      dependencies: ["Utils"]
    ),
    .testTarget(
      name: "FrontEndTests",
      dependencies: ["FrontEnd"]
    ),
    .executableTarget(
      name: "treeloxc",
      dependencies: ["FrontEnd"]
    ),
    .executableTarget(
      name: "loxc",
      dependencies: ["FrontEnd"]
    ),
  ]
)
