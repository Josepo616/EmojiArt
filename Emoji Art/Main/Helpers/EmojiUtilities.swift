//
//  EmojiUtilities.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/13/25.
//

import Foundation

extension EmojiArtModel {
    private static var emojiFactory = EmojiFactory()

    mutating func addEmoji(_ emoji: Emoji) {
        emojis.append(emoji)
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
}
