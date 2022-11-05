// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ProductAnalysis",
  platforms: [
    .macOS(.v12),
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ProductAnalysisCore",
      targets: ["ProductAnalysisCore"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
  ],
  targets: [
    .executableTarget(
      name: "ProductAnalysis",
      dependencies: [
        "ProductAnalysisCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]),
    .target(name: "ProductAnalysisCore", dependencies: ["Csourcekitd"]),
    .target(name: "Csourcekitd", dependencies: []),
    .testTarget(
      name: "ProductAnalysisCoreTests",
      dependencies: ["ProductAnalysisCore"],
      resources: [
        .copy("Resources")
      ])
  ]
)
