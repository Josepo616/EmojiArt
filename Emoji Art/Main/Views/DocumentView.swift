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
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    @ViewBuilder
    func documentContents(in geometry: GeometryProxy) -> some View {
        backgroundView(in: geometry)
        ForEach(document.emojis) { emoji in
            emojiView(emoji, in: geometry)
        }
    }
    
    private func backgroundView(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
    }
    
    private func emojiView(_ emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> some View {
        let isSelected = document.selectedEmojiIds.contains(emoji.id)
        return Text(emoji.string)
            .font(emoji.font)
            .position(emoji.position.in(geometry))
            .onTapGesture {
                if document.selectedEmojiIds.contains(emoji.id) {
                    document.selectedEmojiIds.remove(emoji.id)
                } else {
                    document.selectedEmojiIds.insert(emoji.id)
                }
            }
            .opacity(isSelected ? 0.5 : 1)
    }
}

