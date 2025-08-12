//
//  EmojisFactory.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import Foundation

extension EmojiArtModel {

    mutating func addEmoji(
        _ emoji: String,
        at position: Emoji.Position,
        size: Int
    ) {
        emojis.append(
            Emoji(
                string: emoji,
                position: position,
                size: size,
                id: nextId()
            )
        )
    }

    subscript(_ emojiId: Emoji.ID) -> Emoji? {
        guard let index = index(of: emojiId) else { return nil }
        return emojis[index]
    }

    subscript(_ emoji: Emoji) -> Emoji {
        get { index(of: emoji.id).map { emojis[$0] } ?? emoji }
        set {
            if let index = index(of: emoji.id) {
                emojis[index] = newValue
            }
        }
    }

    private func index(of emojiId: Emoji.ID) -> Int? {
        emojis.firstIndex(where: { $0.id == emojiId })
    }

    private mutating func nextId() -> Int {
        uniqueEmojiId += 1
        return uniqueEmojiId
    }
}
