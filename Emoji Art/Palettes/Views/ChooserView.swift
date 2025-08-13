//
//  ChooserView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/13/25.
//

import SwiftUI

/// Extension of PaletteChooserView that defines the palette selection button with context menu actions
/// for creating or deleting palettes, and a view builder to display a palette's name and its emojis with animations.
extension PaletteChooserView {
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+-*?$")
            }
            AnimatedActionButton(
                "Delete",
                systemImage: "minus.circle",
                role: .destructive
            ) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }

    func view(for palette: PaletteModel) -> some View {
        HStack {
            Text(palette.name)
            EmojisScroll(palette.emojis)
        }
        .id(palette.id)
        .transition(
            .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .top)
            )
        )
    }
}
