// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Eatyaylove",
    products: [
        .executable(
            name: "Eatyaylove",
            targets: ["Eatyaylove"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "Eatyaylove",
            dependencies: ["Publish"]
        )
    ]
)
