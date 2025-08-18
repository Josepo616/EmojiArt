//
//  GesturesView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

/// Extension of EmojiArtDocumentView that defines gestures for the canvas and emojis,
/// including pinch-to-zoom, pan, dragging selected emojis, and resizing selected emojis,
/// while respecting flags that enable or disable canvas and emoji interactions.
extension EmojiArtDocumentView {
    
    var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                guard document.isZoomCanva else { return }
                gestureZoom = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                guard document.isZoomCanva else { return }
                zoom *= endingPinchScale
            }
    }
    
    var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                guard document.isMovingCanva else { return }
                gesturePan = value.translation
            }
            .onEnded { value in
                guard document.isMovingCanva else { return }
                pan += value.translation
            }
    }
    
    func dragSelectedEmojisGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                setLastDragPosition(value)
                
                let deltaX = value.location.x - document.lastDragPosition!.x
                let deltaY = value.location.y - document.lastDragPosition!.y
        
                for emojiId in document.selectedEmojiIds {
                    document.isMovingCanva = false
                    document.moveEmoji(id: emojiId, by: CGSize(width: deltaX, height: deltaY), in: document.canvasSize, zoomScale: 0.1)
                }
                
                document.lastDragPosition = value.location
            }
            .onEnded { _ in
                document.lastDragPosition = nil
            }
    }
    
    var emojiZoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureEmojiZoom) { currentScale, gestureEmojiZoom, _ in
                for _ in document.selectedEmojiIds {
                    document.isZoomCanva = false
                    gestureEmojiZoom = currentScale
                }
            }
            .onEnded { finalScale in
                for emojiId in document.selectedEmojiIds {
                    document.resize(emojiWithId: emojiId, by: finalScale)
                }
            }
    }
    
    //MARK: - Extra credits
    func individualDragGesture(
        for emoji: EmojiArtModel.Emoji,
        isSelected: Bool,
        in geometry: CGSize,
        emojiDragOffsets: Binding<[Emoji.ID: CGSize]>,
    ) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if !isSelected {
                    setLastDragPosition(value)
                    
                    let deltaX = value.location.x - document.lastDragPosition!.x
                    let deltaY = value.location.y - document.lastDragPosition!.y
                    
                    emojiDragOffsets.wrappedValue[emoji.id] = value.translation
                    document.moveEmoji(
                        id: emoji.id,
                        by: CGSize(width: deltaX, height: deltaY),
                        in: geometry,
                        zoomScale: 0.1
                    )
                    emojiDragOffsets.wrappedValue[emoji.id] = .zero
                }
            }
            .onEnded { value in
                document.lastDragPosition = nil
            }
    }
    
    private func setLastDragPosition(_ value: DragGesture.Value) {
        if document.lastDragPosition == nil {
            document.lastDragPosition = value.location
        }
    }
}
