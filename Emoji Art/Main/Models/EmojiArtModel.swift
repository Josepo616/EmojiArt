//
//  EmojiArtModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import Foundation

/// Core model representing an EmojiArt document, including an optional background URL,
/// a list of emojis, and a nested Emoji struct with position, size, and unique ID.
struct EmojiArtModel {
    var background: URL?
    var emojis = [Emoji]()
    var uniqueEmojiId = 0

    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: Int
        var id: Int

        struct Position {
            var x: Int
            var y: Int
            static let zero = Self(x: 0, y: 0)
        }
    }
}
