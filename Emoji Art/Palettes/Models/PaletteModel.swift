//
//  Palette.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/12/25.
//

import Foundation

/// Model representing an emoji palette with a name, a string of emojis, and a unique identifier.
struct PaletteModel: Identifiable {
    var name: String
    var emojis: String
    let id = UUID()
}
