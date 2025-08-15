//
//  PaletteChooserView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

/// View that displays the palette chooser interface, showing navigation controls
/// and the currently selected emoji palette from the store.
struct PaletteChooserView: View {
    @EnvironmentObject var store: PaletteStoreViewModel
    var body: some View {
        HStack {
            chooser
            if store.cursorIndex >= 0
                && store.cursorIndex < store.palettes.count
            {
                view(for: store.palettes[store.cursorIndex])
            } else {
                Text("Emoji palette empty, please add some!")
                    .font(.headline)
            }
        }
        .clipped()
    }
}
