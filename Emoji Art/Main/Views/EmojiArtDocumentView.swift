//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

/// Main view for the EmojiArt document, holding gesture states, zoom/pan values,
/// and displaying the editable canvas along with the emoji palette for selection.
struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArtModel.Emoji
    @ObservedObject var document: EmojiArtDocumentViewModel
    @GestureState var gestureZoom: CGFloat = 1
    @GestureState var gesturePan: CGOffset = .zero
    @GestureState var gestureEmojiZoom: CGFloat = 1
    let paletteEmojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooserView()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocumentViewModel())
        .environmentObject(PaletteStoreViewModel(named: "Preview"))
}
