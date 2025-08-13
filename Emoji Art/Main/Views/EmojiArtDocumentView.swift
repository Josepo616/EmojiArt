//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocumentViewModel
    @GestureState var gestureZoom: CGFloat = 1
    @GestureState var gesturePan: CGOffset = .zero
    @GestureState var gestureEmojiZoom: CGFloat = 1
    @State var zoom: CGFloat = 1
    @State var pan: CGOffset = .zero
    let paletteEmojiSize: CGFloat = 40
    typealias Emoji = EmojiArtModel.Emoji

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

// MARK: - Extentions
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

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocumentViewModel())
        .environmentObject(PaletteStoreViewModel(named: "Preview"))
}
