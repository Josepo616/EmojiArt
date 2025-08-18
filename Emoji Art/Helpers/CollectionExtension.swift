//
//  CollectionExtension.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/18/25.
//

import CoreTransferable

/// Collection extension that returns the subsequence starting just after the given index.
extension Collection {
    func suffix(after: Self.Index) -> Self.SubSequence {
        suffix(from: index(after: after))
    }
}
