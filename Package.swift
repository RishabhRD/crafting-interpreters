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
  targets: [
    .target(
      name: "Utils",
    ),
    .target(
      name: "FrontEnd",
      dependencies: ["Utils"]
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
