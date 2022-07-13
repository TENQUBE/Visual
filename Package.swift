// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Visual",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Visual",
            targets: ["Visual"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "4.9.1")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .branch("master")),
        .package(url: "https://github.com/realm/realm-swift.git",  .exact("3.18.0")),
        .package(url: "https://github.com/TENQUBE/VisualParser.git", .branch("develop"))

        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Visual",
            dependencies: [
                "Alamofire",
                "SwiftyJSON",
                .product(name: "RealmSwift", package: "realm-swift")]
                "VisualParser"
            ]),
        .testTarget(
            name: "VisualTests",
            dependencies: ["Visual"]),
    ]
)
