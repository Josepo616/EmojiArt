//
//  EmojiArtDocumentViewModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

/// Main ViewModel that manages the state of the EmojiArt document,
/// including emojis on the canvas, background, and flags for gesture controls
/// like moving and zooming.

class EmojiArtDocumentViewModel: ObservableObject {
    typealias Emoji = EmojiArtModel.Emoji
    @Published private var emojiArt = EmojiArtModel()
    @Published var selectedEmojiIds: Set<Emoji.ID> = []
    @Published var isMovingCanva = true
    @Published var isZoomCanva = true
    @Published var lastDragPosition: CGPoint?
    @Published var canvasSize: CGSize = .zero
    private var emojiFactory = EmojiFactory()
    var emojis: [Emoji] { emojiArt.emojis }
    var background: URL? { emojiArt.background }

    // MARK: - Intent(s)
    /// Functions that handle updates to the EmojiArt document state,
    /// including background changes, emoji creation, movement, resizing, and deletion.

    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }

    func enableCanvaGestures() {
        isMovingCanva = true
        isZoomCanva = true
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

    func move(_ emoji: Emoji, by offset: CGOffset) {
        let pos = emojiArt[emoji].position
        emojiArt[emoji].position = Emoji.Position(
            x: pos.x + Int(offset.width),
            y: pos.y - Int(offset.height)
        )
    }

    func addEmojis(
        _ emoji: String,
        at position: EmojiArtModel.Emoji.Position,
        size: CGFloat
    ) {
        let newEmoji = emojiFactory.makeEmoji(
            string: emoji,
            position: position,
            size: Int(size)
        )
        emojiArt.addEmoji(newEmoji)
    }

    func deleteEmojis(emoji: Emoji) {
        if let index = emojiArt.emojis.firstIndex(where: { $0.id == emoji.id })
        {
            emojiArt.emojis.remove(at: index)
            selectedEmojiIds.remove(emoji.id)
            if selectedEmojiIds.isEmpty {
                enableCanvaGestures()
            }
        }
    }

    /// Moves a specific emoji by a given translation, adjusting for zoom level and sensitivity,
    /// while constraining its position to remain within the canvas bounds.
    func moveEmoji(
        id: Emoji.ID,
        by translation: CGSize,
        in geometry: CGSize,
        zoomScale: CGFloat
    ) {
        guard let index = emojiArt.emojis.firstIndex(where: { $0.id == id })
        else { return }
        
        let halfWidth = Int(geometry.width / 2)
        let halfHeight = Int(geometry.height / 2)
        let sensitivity: CGFloat = 0.1
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
    func positionEmoji(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

/// Extension of EmojiArtDocumentView that handles drop interactions for URLs and emoji strings,
/// setting the background or adding a new emoji at a calculated position relative to the canvas.
extension EmojiArtDocumentView {
    func drop(
        _ sturldatas: [Sturldata],
        at location: CGPoint,
        in geometry: GeometryProxy
    ) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmojis(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: paletteEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }

    func emojiPosition(at location: CGPoint, in geometry: GeometryProxy)
        -> Emoji.Position
    {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom)
        )
    }
}
