// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "itermfocus",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "itermfocus",
            path: "Sources/itermfocus",
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Resources/Info.plist"
                ])
            ]
        )
    ]
)
