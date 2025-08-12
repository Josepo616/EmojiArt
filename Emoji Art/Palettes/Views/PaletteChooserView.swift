//
//  PaletteChooserView.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

struct PaletteChooserView: View {
    @EnvironmentObject var store: PaletteStoreViewModel

    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
}

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
