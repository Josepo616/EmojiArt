//
//  DocumentView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//
import SwiftUI 

/// Extension of EmojiArtDocumentView that builds the main document UI,
/// including the canvas with background, handling gestures for pan, zoom,
/// as well as tap, selection, and drop actions.
extension EmojiArtDocumentView {

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                canvasContents(in: geometry)
            }
            .gesture(combinedGestures(in: geometry))
            .dropDestination(for: MediaResource.self) { sturldatas, location in
                drop(sturldatas, at: location, in: geometry)
            }
            .onAppear {
                document.canvasSize = geometry.size
            }
        }
    }

    @ViewBuilder
    private func documentContent(in geometry: GeometryProxy) -> some View {
        backgroundView(in: geometry)
        ForEach(document.emojis) { emoji in
            emojiView(emoji, in: geometry)
        }
    }
    
    private func canvasContents(in geometry: GeometryProxy) -> some View {
        documentContent(in: geometry)
            .scaleEffect(document.zoom * gestureZoom)
            .offset(document.pan + gesturePan)
            .onTapGesture {
                document.selectedEmojiIds.removeAll()
                document.enableCanvaGestures()
            }
    }
    
    private func backgroundView(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.positionEmoji(geometry))
    }

    private func combinedGestures(in geometry: GeometryProxy) -> some Gesture {
        panGesture
            .simultaneously(with: zoomGesture)
            .simultaneously(with: dragSelectedEmojisGesture(in: geometry))
            .simultaneously(with: emojiZoomGesture)
    }
}
