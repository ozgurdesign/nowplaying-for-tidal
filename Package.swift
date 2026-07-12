// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "NowPlayingForTidal",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "NowPlayingForTidal",
            path: "Sources/NowPlayingForTidal"
        )
    ]
)
