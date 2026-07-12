import Foundation

struct StreamMessage: Decodable {
    let type: String
    let diff: Bool
    let payload: NowPlaying
}

struct NowPlaying: Decodable {
    let bundleIdentifier: String?
    let playing: Bool?
    let title: String?
    let artist: String?
    let album: String?
    let artworkData: String?
    let artworkMimeType: String?

    var isTidal: Bool { bundleIdentifier == "com.tidal.desktop" }
}
