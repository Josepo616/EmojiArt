//
//  DocumentView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//
import SwiftUI

/// Extension of EmojiArtDocumentView that builds the main document UI,
/// including the canvas with background and emojis, handling gestures for pan, zoom,
/// and emoji interactions, as well as tap, selection, context menu, and drop actions.
extension EmojiArtDocumentView {

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                canvasContents(in: geometry)
            }
            .gesture(combinedGestures(in: geometry))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                drop(sturldatas, at: location, in: geometry)
            }
        }
    }

    @ViewBuilder
    private func canvasContents(in geometry: GeometryProxy) -> some View {
        documentContent(in: geometry)
            .scaleEffect(zoom * gestureZoom)
            .offset(pan + gesturePan)
            .onTapGesture {
                document.selectedEmojiIds.removeAll()
            }
    }

    @ViewBuilder
    private func documentContent(in geometry: GeometryProxy) -> some View {
        backgroundView(in: geometry)
        ForEach(document.emojis) { emoji in
            emojiView(emoji, in: geometry)
        }
    }

    private func backgroundView(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
    }

    private func emojiView(
        _ emoji: EmojiArtModel.Emoji,
        in geometry: GeometryProxy
    ) -> some View {
        let isSelected = document.selectedEmojiIds.contains(emoji.id)

        return Text(emoji.string)
            .font(emoji.font)
            .fixedSize()
            .opacity(isSelected ? 0.5 : 1)
            .scaleEffect(isSelected ? gestureEmojiZoom : 1)

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
                    in: geometry,
                    emojiDragOffsets: $emojiDragOffsets,
                ) : nil
            )
            .position(emoji.position.in(geometry))
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

    private func combinedGestures(in geometry: GeometryProxy) -> some Gesture {
        panGesture
            .simultaneously(with: zoomGesture)
            .simultaneously(with: dragSelectedEmojisGesture(in: geometry))
            .simultaneously(with: emojiZoomGesture)
    }
}
