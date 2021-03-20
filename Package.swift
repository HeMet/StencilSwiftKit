// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "StencilSwiftKit",
  products: [
    .library(name: "StencilSwiftKit", targets: ["StencilSwiftKit"])
  ],
  dependencies: [
    // .package(url: "https://github.com/shibapm/Komondor.git", from: "1.0.0"),
    .package(url: "https://github.com/HeMet/Stencil.git", .branch("win-support"))
  ],
  targets: [
    .target(name: "StencilSwiftKit", dependencies: [
      "Stencil"
    ]),
    .testTarget(name: "StencilSwiftKitTests", dependencies: [
      "StencilSwiftKit"
    ])
  ],
  swiftLanguageVersions: [.v5]
)

#if canImport(PackageConfig) && !os(Windows)
import PackageConfig

let config = PackageConfiguration([
  "komondor": [
    "pre-commit": [
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:code",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:tests"
    ],
    "pre-push": [
      "PATH=\"~/.rbenv/shims:$PATH\" bundle exec rake spm:test"
    ]
  ],
]).write()
#endif
