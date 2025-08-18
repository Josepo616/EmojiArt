//
//  PaletteStoreViewModel.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import SwiftUI

/// ViewModel for managing a collection of emoji palettes,
/// keeping track of the current palette index with bounds checking,
/// and initializing with built-in palettes or a fallback warning palette.
class PaletteStoreViewModel: ObservableObject {
    @Published var palettes: [PaletteModel]
    @Published var _cursorIndex = 0
    let name: String

    var cursorIndex: Int {
        get { boundsCheckedPaletteIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedPaletteIndex(newValue) }
    }

    init(named name: String) {
        self.name = name
        palettes = PaletteCatalog.builtins
        if palettes.isEmpty {
            palettes = [PaletteModel(name: "Warning", emojis: "⚠️")]
        }
    }

    private func boundsCheckedPaletteIndex(_ index: Int) -> Int {
        if palettes.isEmpty {
            return 0
        } else {
            var index = index % palettes.count
            if index < 0 {
                index += palettes.count
            }
            return index
        }
    }

    // MARK: - ADDING PALETTS
    /// Methods for adding palettes to the collection, either by inserting at a specific index or appending,
    /// with logic to handle duplicates by replacing or moving existing palettes as needed.
    func insert(_ palette: PaletteModel, at insertionIndex: Int? = nil) {
        let insertionIndex = boundsCheckedPaletteIndex(
            insertionIndex ?? cursorIndex
        )
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(
                fromOffsets: IndexSet([index]),
                toOffset: insertionIndex
            )
            palettes.replaceSubrange(
                insertionIndex...insertionIndex,
                with: [palette]
            )
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }

    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(PaletteModel(name: name, emojis: emojis))
    }

    func append(_ palette: PaletteModel) {
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }

    func append(name: String, emojis: String) {
        append(PaletteModel(name: name, emojis: emojis))
    }
}
