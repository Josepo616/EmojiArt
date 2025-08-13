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
    @Published var selectedEmojiIds: Set<EmojiArtModel.Emoji.ID> = []
    @Published var isMovingCanva = true
    @Published var isZoomCanva = true
    @Published var lastDragPosition: CGPoint?

    var emojis: [Emoji] { emojiArt.emojis }
    var background: URL? { emojiArt.background }

    // MARK: - INTENT(S)

    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }

    func addEmojis(_ emoji: String, at position: Emoji.Position, size: CGFloat)
    {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }

    func deleteEmojis(emoji: Emoji) {
        if let index = emojiArt.emojis.firstIndex(where: { $0.id == emoji.id })
        {
            emojiArt.emojis.remove(at: index)
            selectedEmojiIds.remove(emoji.id)
            print(selectedEmojiIds)
            

            if selectedEmojiIds.isEmpty {
                isMovingCanva = true
                isZoomCanva = true
            }
        }
    }

    func move(_ emoji: Emoji, by offset: CGOffset) {
        let pos = emojiArt[emoji].position
        emojiArt[emoji].position = Emoji.Position(
            x: pos.x + Int(offset.width),
            y: pos.y - Int(offset.height)
        )
    }

    func resize(_ emoji: Emoji, by scale: CGFloat) {
        emojiArt[emoji].size = Int(CGFloat(emojiArt[emoji].size) * scale)
    }

    func move(emojiWithId id: Emoji.ID, by offset: CGOffset) {
        withEmoji(id) { move($0, by: offset) }
    }

    func resize(emojiWithId id: Emoji.ID, by scale: CGFloat) {
        withEmoji(id) { resize($0, by: scale) }
    }

    func moveEmoji(
        id: Emoji.ID,
        by translation: CGSize,
        in geometry: GeometryProxy,
        zoomScale: CGFloat
    ) {
        guard let index = emojiArt.emojis.firstIndex(where: { $0.id == id })
        else { return }

        let halfWidth = Int(geometry.size.width / 2)
        let halfHeight = Int(geometry.size.height / 2)

        let sensitivity: CGFloat = 0.1
        // Ajustamos la traslación por sensibilidad y zoom
        let adjustedX = translation.width * sensitivity / zoomScale
        let adjustedY = translation.height * sensitivity / zoomScale

        var newX = emojiArt.emojis[index].position.x + Int(adjustedX)
        var newY = emojiArt.emojis[index].position.y - Int(adjustedY)

        newX = min(max(newX, -halfWidth), halfWidth)
        newY = min(max(newY, -halfHeight), halfHeight)

        emojiArt.emojis[index].position.x = newX
        emojiArt.emojis[index].position.y = newY
    }

    // MARK: - Private Helpers

    private func withEmoji(_ id: Emoji.ID, perform action: (Emoji) -> Void) {
        if let emoji = emojiArt[id] {
            action(emoji)
        }
    }
}

// MARK: - Extentions

extension EmojiArtModel.Emoji {
    var font: Font { .system(size: CGFloat(size)) }
}

extension EmojiArtModel.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
