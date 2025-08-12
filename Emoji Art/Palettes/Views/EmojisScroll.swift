//
//  EmojisScroll.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

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
