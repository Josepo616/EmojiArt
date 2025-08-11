//
//  EmojiArtDocumentViewModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

class EmojiArtDocumentViewModel: ObservableObject {
    typealias Emoji = EmojiArtModel.Emoji
    @Published private var emojiArt = EmojiArtModel()

    init() {
        emojiArt.addEmoji("⛳️", at: .init(x: -200, y: -150), size: 200)
        emojiArt.addEmoji("⚽️", at: .init(x: 250, y: 100), size: 80)

    }
    var emojis: [Emoji] {
        emojiArt.emojis
    }

    var background: URL? {
        emojiArt.background
    }

    // MARK: - INTENT(S)

    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }

    func addEmojis(_ emoji: String, at position: Emoji.Position, size: CGFloat)
    {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
}

extension EmojiArtModel.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArtModel.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y + CGFloat(y))
    }
}
