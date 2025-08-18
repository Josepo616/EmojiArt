//
//  EmojisScroll.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

/// A horizontal scroll view that displays a unique set of emojis,
/// each of which can be dragged for use in the canvas or other views.
struct EmojisScroll: View {
    let emojis: [String]

    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}
