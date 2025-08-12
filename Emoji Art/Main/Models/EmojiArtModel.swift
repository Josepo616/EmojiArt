//
//  EmojiArtModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import Foundation

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
