//
//  EmojisFactory.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import Foundation

/// Factory struct that creates new Emoji instances with unique IDs, setting their string, position, and size.
struct EmojiFactory {
    private var nextId: Int = 1

    mutating func makeEmoji(
        string: String,
        position: EmojiArtModel.Emoji.Position,
        size: Int
    ) -> EmojiArtModel.Emoji {
        let emoji = EmojiArtModel.Emoji(
            string: string,
            position: position,
            size: size,
            id: nextId
        )
        nextId += 1
        return emoji
    }
}
