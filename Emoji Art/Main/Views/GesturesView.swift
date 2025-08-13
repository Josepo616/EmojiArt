//
//  GesturesView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

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
                if document.lastDragPosition == nil {
                    document.lastDragPosition = value.location
                }
                let deltaX = value.location.x - document.lastDragPosition!.x
                let deltaY = value.location.y - document.lastDragPosition!.y
                
                for emojiId in document.selectedEmojiIds {
                    document.isMovingCanva = false
                    document.moveEmoji(id: emojiId, by: CGSize(width: deltaX, height: deltaY), in: geometry, zoomScale: 0.1)
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
}
