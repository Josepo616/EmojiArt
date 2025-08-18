//
//  StringExtension.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/18/25.
//

import SwiftUI

/// String extension that returns a new string with duplicate characters removed.
extension String {
    var uniqued: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}
