//
//  DocumentView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

extension EmojiArtDocumentView {

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
                    .onTapGesture {
                        document.selectedEmojiIds.removeAll()
                    }
            }
            .gesture(
                panGesture
                    .simultaneously(with: zoomGesture)
                    .simultaneously(
                        with: dragSelectedEmojisGesture(in: geometry)
                    )
                    .simultaneously(with: emojiZoomGesture)
            )
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }

    @ViewBuilder
    func documentContents(in geometry: GeometryProxy) -> some View {
        backgroundView(in: geometry)
        ForEach(document.emojis) { emoji in
            let isSelected = document.selectedEmojiIds.contains(emoji.id)
            if isSelected {
                emojiView(emoji, in: geometry)

            } else {
                emojiView(emoji, in: geometry)
            }
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

        @ViewBuilder
        var emojiText: some View {
            let base = Text(emoji.string)
                .font(emoji.font)
                .fixedSize()
                .opacity(isSelected ? 0.5 : 1)
                .scaleEffect(isSelected ? gestureEmojiZoom : 1)
                .onTapGesture {
                    if isSelected {
                        document.selectedEmojiIds.remove(emoji.id)
                    } else {
                        document.selectedEmojiIds.insert(emoji.id)
                    }
                    if document.selectedEmojiIds.isEmpty {
                        document.enableCanvaGestures()
                    }
                }

            base.contextMenu {
                Button("Delete", systemImage: "minus.circle") {
                    document.deleteEmojis(emoji: emoji)
                }
            }
        }

        return
            emojiText
            .background(Color.clear)
            .position(emoji.position.in(geometry))
    }

}
