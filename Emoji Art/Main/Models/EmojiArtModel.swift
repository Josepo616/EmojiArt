//
//  EmojiArtModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import Foundation

struct EmojiArtModel {
    var background: URL?
    private(set) var emojis = [Emoji]()
    private var uniqueEmojiId: Int = 0

    mutating func addEmoji(
        _ emoji: String,
        at position: Emoji.Position,
        size: Int
    ) {
        uniqueEmojiId += 1
        emojis.append(
            Emoji(
                string: emoji,
                position: position,
                size: size,
                id: uniqueEmojiId
            )
        )
    }

    subscript(_ emojiId: Emoji.ID) -> Emoji? {
        if let index = index(of: emojiId) {
            return emojis[index]
        } else {
            return nil
        }
    }

    subscript(_ emoji: Emoji) -> Emoji {
        get {
            if let index = index(of: emoji.id) {
                return emojis[index]
            } else {
                return emoji
            }
        }
        set {
            if let index = index(of: emoji.id) {
                emojis[index] = newValue
            }
        }
    }

    func index(of emojiId: Emoji.ID) -> Int? {
        emojis.firstIndex(where: { $0.id == emojiId })
    }

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
