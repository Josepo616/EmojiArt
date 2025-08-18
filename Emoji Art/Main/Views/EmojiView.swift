//
//  EmojiView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/15/25.
//

import SwiftUI

/// Extension of EmojiArtDocumentView that builds the emojis in the canva
/// each emoji can be selected, move individual or in group, and at the same
/// time can be deleted using a context menu
extension EmojiArtDocumentView {
    func emojiView(
        _ emoji: EmojiArtModel.Emoji,
        in geometry: GeometryProxy
    ) -> some View {
        let isSelected = document.selectedEmojiIds.contains(emoji.id)
        let baseScale = emojiZoomScales[emoji.id] ?? 1
        let scale = isSelected ? baseScale * gestureEmojiZoom : baseScale

        return Text(emoji.string)
            .font(emoji.font)
            .fixedSize()
            .opacity(isSelected ? 0.5 : 1)
            .scaleEffect(scale)
            .contentShape(Rectangle())
            .onTapGesture {
                toggleEmojiSelection(emoji.id)
            }
            .contextMenu {
                Button("Delete", systemImage: "minus.circle") {
                    document.deleteEmojis(emoji: emoji)
                }
            }
            .background(Color.clear)
            .offset(isSelected ? .zero : emojiDragOffsets[emoji.id] ?? .zero)
            .gesture(
                !isSelected ?
                individualDragGesture(
                    for: emoji,
                    isSelected: isSelected,
                    in: document.canvasSize,
                    emojiDragOffsets: $emojiDragOffsets,
                ) : nil
            )
            .position(emoji.position.positionEmoji(geometry))
    }
    
    private func toggleEmojiSelection(_ emojiId: EmojiArtModel.Emoji.ID) {
        if document.selectedEmojiIds.contains(emojiId) {
            document.selectedEmojiIds.remove(emojiId)
        } else {
            document.selectedEmojiIds.insert(emojiId)
        }
        if document.selectedEmojiIds.isEmpty {
            document.enableCanvaGestures()
        }
    }
}
